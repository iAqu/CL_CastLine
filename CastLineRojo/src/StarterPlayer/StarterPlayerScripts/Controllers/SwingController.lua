local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ShovelToolUtil = require(ReplicatedStorage.Modules.ShovelToolUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local ATTACK_COOLDOWN = 0.65
local HIT_WINDOW_DURATION = 0.4
local HITBOX_PADDING = Vector3.new(4, 4, 4)
local TOUCH_TAP_MAX_DURATION = 0.5
local TOUCH_TAP_MAX_DISTANCE = 10
local DEFAULT_JUMP_SOUND_ID = "rbxasset://sounds/action_jump.mp3"

local LOCAL_PLAYER = Players.LocalPlayer

local SwingController = Knit.CreateController({
	Name = "SwingController",
})

local lastSwingAt = 0
local activeTouch: InputObject? = nil
local touchStartedAt = 0
local touchStartPosition: Vector2? = nil
local touchMoved = false
local warnedMissingAnimation = false

local function getPlayerFromTouchedPart(part: BasePart): Player?
	local ancestor = part.Parent
	while ancestor do
		if ancestor:IsA("Model") then
			local player = Players:GetPlayerFromCharacter(ancestor)
			if player then
				return player
			end
		end
		ancestor = ancestor.Parent
	end
	return nil
end

local function beginHitWindow(tool: Tool)
	local swingService = Knit.GetService("SwingService")
	local originalCanTouch = {} :: { [BasePart]: boolean }
	local connections = {} :: { RBXScriptConnection }
	local reportedPlayers = {} :: { [Player]: boolean }
	local cleanedUp = false

	local function reportTouchedPart(otherPart: BasePart)
		local targetPlayer = getPlayerFromTouchedPart(otherPart)
		if not targetPlayer or targetPlayer == LOCAL_PLAYER or reportedPlayers[targetPlayer] then
			return
		end

		reportedPlayers[targetPlayer] = true
		swingService.HitPlayer:Fire(targetPlayer.UserId)
	end

	local function cleanup()
		if cleanedUp then
			return
		end
		cleanedUp = true

		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		for part, canTouch in pairs(originalCanTouch) do
			if part.Parent then
				part.CanTouch = canTouch
			end
		end
	end

	for _, descendant in ipairs(tool:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local part = descendant
			originalCanTouch[part] = part.CanTouch
			connections[#connections + 1] = part.Touched:Connect(reportTouchedPart)
			part.CanTouch = true
		end
	end

	local shovelHeadCandidate = tool:FindFirstChild("ShovelHead", true)
	local shovelHead = if shovelHeadCandidate and shovelHeadCandidate:IsA("BasePart") then shovelHeadCandidate else nil
	if shovelHead then
		local targetCharacters = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LOCAL_PLAYER and player.Character then
				targetCharacters[#targetCharacters + 1] = player.Character
			end
		end

		if #targetCharacters > 0 then
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Include
			overlapParams.FilterDescendantsInstances = targetCharacters
			connections[#connections + 1] = RunService.Heartbeat:Connect(function()
				if not shovelHead.Parent then
					cleanup()
					return
				end
				for _, part in
					ipairs(
						Workspace:GetPartBoundsInBox(shovelHead.CFrame, shovelHead.Size + HITBOX_PADDING, overlapParams)
					)
				do
					reportTouchedPart(part)
				end
			end)
		end
	end

	task.delay(HIT_WINDOW_DURATION, cleanup)
end

local function getCharacterParts(): (Model?, Humanoid?)
	local character = LOCAL_PLAYER.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not humanoid or humanoid.Health <= 0 then
		return nil, nil
	end
	return character, humanoid
end

local function getSwingAnimation(): Animation?
	local animationFolder = ReplicatedStorage:FindFirstChild("Animation")
	local characterFolder = animationFolder and animationFolder:FindFirstChild("Character")
	local swing = characterFolder and characterFolder:FindFirstChild("Swing")
	if swing and swing:IsA("Animation") then
		return swing
	end
	if not warnedMissingAnimation then
		warnedMissingAnimation = true
		warn("SwingController: ReplicatedStorage.Animation.Character.Swing is missing or not an Animation")
	end
	return nil
end

local function playSwingAnimation(humanoid: Humanoid)
	local animation = getSwingAnimation()
	if not animation then
		return
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local ok, track = pcall(function()
		return animator:LoadAnimation(animation)
	end)
	if ok and track then
		track.Priority = Enum.AnimationPriority.Action
		track:Play(0.05)
	end
end

local function playSwingSound(character: Model)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root or not root:IsA("BasePart") then
		return
	end

	local jumpSound = root:FindFirstChild("Jumping")
	local fallbackSound = Instance.new("Sound")
	fallbackSound.Name = "Jumping"
	if jumpSound and jumpSound:IsA("Sound") and jumpSound.SoundId ~= "" then
		-- Roblox's default character sounds are not necessarily Archivable, so clone only their playback settings.
		fallbackSound.SoundId = jumpSound.SoundId
		fallbackSound.Volume = jumpSound.Volume
		fallbackSound.PlaybackSpeed = jumpSound.PlaybackSpeed
	else
		fallbackSound.SoundId = DEFAULT_JUMP_SOUND_ID
	end
	SoundHelper.PlaySound(fallbackSound, root)
	fallbackSound:Destroy()
end

function SwingController:_trySwing()
	if os.clock() - lastSwingAt < ATTACK_COOLDOWN then
		return
	end

	local character, humanoid = getCharacterParts()
	local shovel = character and ShovelToolUtil.FindShovelTool(character)
	if not character or not humanoid or not shovel then
		return
	end

	local digController = Knit.GetController("DigController")
	if digController:IsDigging() then
		return
	end

	lastSwingAt = os.clock()
	playSwingAnimation(humanoid)
	playSwingSound(character)
	Knit.GetService("SwingService").BeginSwing:Fire()
	beginHitWindow(shovel)
end

function SwingController:KnitInit()
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
			self:_trySwing()
		elseif input.UserInputType == Enum.UserInputType.Touch then
			activeTouch = input
			touchStartedAt = os.clock()
			touchStartPosition = Vector2.new(input.Position.X, input.Position.Y)
			touchMoved = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input: InputObject)
		if input ~= activeTouch or input.UserInputType ~= Enum.UserInputType.Touch or not touchStartPosition then
			return
		end
		if
			(Vector2.new(input.Position.X, input.Position.Y) - touchStartPosition).Magnitude > TOUCH_TAP_MAX_DISTANCE
		then
			touchMoved = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input: InputObject)
		if input ~= activeTouch then
			return
		end

		activeTouch = nil
		local wasTap = not touchMoved and os.clock() - touchStartedAt <= TOUCH_TAP_MAX_DURATION
		touchStartPosition = nil
		if wasTap then
			self:_trySwing()
		end
	end)
end

function SwingController:KnitStart()
	Knit.GetService("SwingService").DigInterrupted:Connect(function()
		Knit.GetController("DigController"):InterruptDigging()
	end)
end

return SwingController
