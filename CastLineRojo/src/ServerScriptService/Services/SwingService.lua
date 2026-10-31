local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Ragdoll = require(ReplicatedStorage.Libs.Ragdoll)
local ShovelToolUtil = require(ReplicatedStorage.Modules.ShovelToolUtil)
local DigItemService = require(script.Parent.DigItemService)
local MovementSpeedService = require(script.Parent.MovementSpeedService)

local ATTACK_COOLDOWN = 0.65
local HIT_WINDOW_DURATION = 0.4
local TARGET_HIT_COOLDOWN = 0.5
local HIT_RANGE = 12
local MIN_FORWARD_DOT = 0.3
local HORIZONTAL_KNOCKBACK_SPEED = 45
local UPWARD_KNOCKBACK_SPEED = 18
local RAGDOLL_DURATION = 1.5
local DROWNING_RECHECK_DELAY = 0.1
local DROWNING_ATTRIBUTE = "WaterDrowning"
local HIT_HIGHLIGHT_NAME = "SwingHitHighlight"
local HIT_HIGHLIGHT_DURATION = 0.5
local HIT_HIGHLIGHT_TWEEN_INFO = TweenInfo.new(HIT_HIGHLIGHT_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

type SwingState = {
	expiresAt: number,
	hitTargets: { [Player]: boolean },
}

type RagdollState = {
	token: {},
	character: Model,
	humanoid: Humanoid,
	root: BasePart,
	head: BasePart?,
	joints: { Instance },
	walkSpeed: number,
	autoRotate: boolean,
	platformStand: boolean,
	rootCanCollide: boolean,
	headCanCollide: boolean?,
	networkParts: { BasePart },
}

local SwingService = Knit.CreateService({
	Name = "SwingService",
	Client = {
		BeginSwing = Knit.CreateSignal(),
		HitPlayer = Knit.CreateSignal(),
		DigInterrupted = Knit.CreateSignal(),
	},
	_LastSwingAt = {} :: { [Player]: number },
	_ActiveSwings = {} :: { [Player]: SwingState },
	_LastHitAt = {} :: { [Player]: { [Player]: number } },
	_RagdollStates = {} :: { [Player]: RagdollState },
})

local function getLivingCharacterParts(player: Player): (Model?, Humanoid?, BasePart?)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root or not root:IsA("BasePart") then
		return nil, nil, nil
	end
	return character, humanoid, root
end

local function hasEquippedShovel(character: Model): boolean
	return ShovelToolUtil.FindShovelTool(character) ~= nil
end

local function getUnanchoredCharacterParts(character: Model): { BasePart }
	local parts = {}
	for _, descendant in character:GetDescendants() do
		if descendant:IsA("BasePart") and not descendant.Anchored then
			parts[#parts + 1] = descendant
		end
	end
	return parts
end

local function setServerNetworkOwners(parts: { BasePart })
	for _, part in parts do
		if part.Parent and part:CanSetNetworkOwnership() then
			part:SetNetworkOwner(nil)
		end
	end
end

local function restoreAutomaticNetworkOwnership(parts: { BasePart })
	for _, part in parts do
		if part.Parent and part:CanSetNetworkOwnership() then
			part:SetNetworkOwnershipAuto()
		end
	end
end

local function showHitHighlight(character: Model)
	local existing = character:FindFirstChild(HIT_HIGHLIGHT_NAME)
	if existing then
		existing:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = HIT_HIGHLIGHT_NAME
	highlight.Adornee = character
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = character

	local tween = TweenService:Create(highlight, HIT_HIGHLIGHT_TWEEN_INFO, {
		FillTransparency = 1,
	})
	tween:Play()
	Debris:AddItem(highlight, HIT_HIGHLIGHT_DURATION)
end

function SwingService:_beginSwing(player: Player)
	local now = os.clock()
	local lastSwingAt = self._LastSwingAt[player]
	if lastSwingAt and now - lastSwingAt < ATTACK_COOLDOWN then
		return
	end

	local character, _, root = getLivingCharacterParts(player)
	if not character or not root or not hasEquippedShovel(character) then
		return
	end

	self._LastSwingAt[player] = now
	self._ActiveSwings[player] = {
		expiresAt = now + HIT_WINDOW_DURATION,
		hitTargets = {},
	}
end

function SwingService:_restoreRagdoll(player: Player, state: RagdollState)
	if self._RagdollStates[player] ~= state or self._RagdollStates[player].token ~= state.token then
		return
	end

	local character = state.character
	local humanoid = state.humanoid
	local root = state.root
	if
		player.Character ~= character
		or not character.Parent
		or not humanoid.Parent
		or not root.Parent
		or humanoid.Health <= 0
	then
		self._RagdollStates[player] = nil
		return
	end
	if character:GetAttribute(DROWNING_ATTRIBUTE) == true then
		task.delay(DROWNING_RECHECK_DELAY, function()
			self:_restoreRagdoll(player, state)
		end)
		return
	end
	self._RagdollStates[player] = nil

	Ragdoll.SetMotorsEnabled(state.joints, true)
	Ragdoll.DestroyJoints(character)
	humanoid.PlatformStand = state.platformStand
	humanoid.AutoRotate = state.autoRotate
	humanoid.WalkSpeed = state.walkSpeed
	root.CanCollide = state.rootCanCollide
	if state.head and state.head.Parent and state.headCanCollide ~= nil then
		state.head.CanCollide = state.headCanCollide
	end
	restoreAutomaticNetworkOwnership(state.networkParts)
	if humanoid:GetState() ~= Enum.HumanoidStateType.GettingUp then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
	MovementSpeedService:RefreshPlayer(player)
end

function SwingService:_applyRagdollKnockback(
	player: Player,
	character: Model,
	humanoid: Humanoid,
	root: BasePart,
	horizontalDirection: Vector3
): boolean
	if self._RagdollStates[player] or character:GetAttribute(DROWNING_ATTRIBUTE) == true then
		return false
	end

	-- Avatar Joint Upgrade characters form one kinematic assembly until their
	-- AnimationConstraints are released. Preserve that whole-character mass so
	-- the impulse remains correct after the ragdoll splits into many assemblies.
	local characterAssemblyMass = root.AssemblyMass
	local joints = Ragdoll.CreateJoints(character)
	if not joints then
		return false
	end

	local head = character:FindFirstChild("Head")
	local networkParts = getUnanchoredCharacterParts(character)
	local state: RagdollState = {
		token = {},
		character = character,
		humanoid = humanoid,
		root = root,
		head = if head and head:IsA("BasePart") then head else nil,
		joints = joints,
		walkSpeed = humanoid.WalkSpeed,
		autoRotate = humanoid.AutoRotate,
		platformStand = humanoid.PlatformStand,
		rootCanCollide = root.CanCollide,
		headCanCollide = if head and head:IsA("BasePart") then head.CanCollide else nil,
		networkParts = networkParts,
	}
	self._RagdollStates[player] = state

	humanoid.PlatformStand = true
	Ragdoll.SetMotorsEnabled(joints, false)
	Ragdoll.Ragdoll(character)
	-- Releasing AnimationConstraints changes the assembly topology. Ownership
	-- must be assigned afterwards and for every resulting ragdoll assembly;
	-- setting only HumanoidRootPart is immediately undone by client ownership.
	setServerNetworkOwners(networkParts)

	local velocityChange = horizontalDirection * HORIZONTAL_KNOCKBACK_SPEED + Vector3.new(0, UPWARD_KNOCKBACK_SPEED, 0)
	root:ApplyImpulse(velocityChange * characterAssemblyMass)

	humanoid.Died:Once(function()
		if self._RagdollStates[player] == state then
			self._RagdollStates[player] = nil
		end
	end)
	task.delay(RAGDOLL_DURATION, function()
		self:_restoreRagdoll(player, state)
	end)
	return true
end

function SwingService:_hitPlayer(player: Player, targetUserId: number)
	if typeof(targetUserId) ~= "number" or targetUserId == math.huge or targetUserId % 1 ~= 0 then
		return
	end

	local now = os.clock()
	local swingState = self._ActiveSwings[player]
	if not swingState or now > swingState.expiresAt then
		self._ActiveSwings[player] = nil
		return
	end

	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer or targetPlayer == player or swingState.hitTargets[targetPlayer] then
		return
	end

	local attackerCharacter, _, attackerRoot = getLivingCharacterParts(player)
	local targetCharacter, targetHumanoid, targetRoot = getLivingCharacterParts(targetPlayer)
	if not attackerCharacter or not attackerRoot or not hasEquippedShovel(attackerCharacter) then
		return
	end
	if not targetCharacter or not targetHumanoid or not targetRoot or self._RagdollStates[targetPlayer] then
		return
	end

	local offset = targetRoot.Position - attackerRoot.Position
	local distance = offset.Magnitude
	if distance <= 0 or distance > HIT_RANGE or attackerRoot.CFrame.LookVector:Dot(offset.Unit) < MIN_FORWARD_DOT then
		return
	end

	local targetHitTimes = self._LastHitAt[player]
	if not targetHitTimes then
		targetHitTimes = {}
		self._LastHitAt[player] = targetHitTimes
	end
	local lastHitAt = targetHitTimes[targetPlayer]
	if lastHitAt and now - lastHitAt < TARGET_HIT_COOLDOWN then
		return
	end

	local horizontalOffset = Vector3.new(offset.X, 0, offset.Z)
	local horizontalDirection = if horizontalOffset.Magnitude > 0
		then horizontalOffset.Unit
		else Vector3.new(attackerRoot.CFrame.LookVector.X, 0, attackerRoot.CFrame.LookVector.Z).Unit
	if
		not self:_applyRagdollKnockback(targetPlayer, targetCharacter, targetHumanoid, targetRoot, horizontalDirection)
	then
		return
	end

	swingState.hitTargets[targetPlayer] = true
	targetHitTimes[targetPlayer] = now

	showHitHighlight(targetCharacter)
	DigItemService:InterruptPlayer(targetPlayer)
	self.Client.DigInterrupted:Fire(targetPlayer)
end

function SwingService:_clearPlayer(player: Player)
	self._LastSwingAt[player] = nil
	self._ActiveSwings[player] = nil
	self._LastHitAt[player] = nil
	self._RagdollStates[player] = nil
	for _, hitTimes in pairs(self._LastHitAt) do
		hitTimes[player] = nil
	end
end

function SwingService:_registerPlayer(player: Player)
	player.CharacterAdded:Connect(function()
		self._ActiveSwings[player] = nil
		self._RagdollStates[player] = nil
	end)
end

function SwingService:KnitInit()
	self.Client.BeginSwing:Connect(function(player: Player)
		self:_beginSwing(player)
	end)
	self.Client.HitPlayer:Connect(function(player: Player, targetUserId: number)
		self:_hitPlayer(player, targetUserId)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		self:_registerPlayer(player)
	end
	Players.PlayerAdded:Connect(function(player: Player)
		self:_registerPlayer(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:_clearPlayer(player)
	end)
end

return SwingService
