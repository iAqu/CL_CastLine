local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Ragdoll = require(ReplicatedStorage.Libs.Ragdoll)

local DROWN_DURATION = 1
local DROWNING_ATTRIBUTE = "WaterDrowning"
local DROWN_STARTED_AT_ATTRIBUTE = "WaterDrownStartedAt"
local FLOAT_ATTACHMENT_NAME = "WaterDrownFloatAttachment"
local FLOAT_FORCE_NAME = "WaterDrownFloatForce"
local FLOAT_ORIENTATION_ATTACHMENT_NAME = "WaterDrownOrientationAttachment"
local FLOAT_ORIENTATION_NAME = "WaterDrownAlignOrientation"
local FLOAT_BODY_SUBMERGENCE_RATIO = 0.35
local FLOAT_SPRING_STRENGTH = 5
local FLOAT_DAMPING = 7
local FLOAT_MAX_ACCELERATION = 18
local FLOAT_ORIENTATION_RESPONSIVENESS = 8
local FLOAT_ORIENTATION_MAX_ANGULAR_VELOCITY = math.rad(180)
local FLOAT_ORIENTATION_TORQUE_LEVER = 20
local HORIZONTAL_DIRECTION_EPSILON = 0.001

type FloatForce = {
	part: BasePart,
	attachment: Attachment,
	force: VectorForce,
}
type FloatState = {
	character: Model,
	anchor: BasePart,
	forces: { FloatForce },
	orientationAttachment: Attachment,
	orientation: AlignOrientation,
	totalMass: number,
	floatPartMass: number,
	submergenceDepth: number,
}

local WaterDrownService = Knit.CreateService {
	Name = "WaterDrownService",
	Client = {
		Drowned = Knit.CreateSignal(),
		DrownedItemsDropped = Knit.CreateSignal(),
	},
	_States = {},
	_FloatStates = {},
	_WarnedMissingWater = false,
	_Random = Random.new(),
}

local function getWaterTop(): BasePart?
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	local top = water and water:FindFirstChild("Top")
	if top and top:IsA("BasePart") then
		return top
	end
	return nil
end

local function isPointBelowWaterSurface(part: BasePart, point: Vector3): boolean
	local localPoint = part.CFrame:PointToObjectSpace(point)
	local halfSize = part.Size * 0.5
	return math.abs(localPoint.X) <= halfSize.X
		and math.abs(localPoint.Z) <= halfSize.Z
		and localPoint.Y <= halfSize.Y
end

local function isPartTouchingWater(waterTop: BasePart, part: BasePart): boolean
	local halfSize = part.Size * 0.5
	for _, x in ipairs({ -halfSize.X, halfSize.X }) do
		for _, y in ipairs({ -halfSize.Y, halfSize.Y }) do
			for _, z in ipairs({ -halfSize.Z, halfSize.Z }) do
				local corner = part.CFrame:PointToWorldSpace(Vector3.new(x, y, z))
				if isPointBelowWaterSurface(waterTop, corner) then
					return true
				end
			end
		end
	end
	return false
end

local function ragdollCharacterForDrowning(character: Model, humanoid: Humanoid): BasePart?
	local root = character.PrimaryPart
	if not root or not root:IsA("BasePart") then
		warn("WaterDrownService: character has no valid PrimaryPart for ragdoll", character:GetFullName())
		return
	end

	local joints = Ragdoll.CreateJoints(character)
	if not joints or #joints == 0 then
		warn("WaterDrownService: could not create ragdoll joints", character:GetFullName())
		return
	end

	humanoid.BreakJointsOnDeath = false
	humanoid.RequiresNeck = false
	if root:CanSetNetworkOwnership() then
		root:SetNetworkOwner(nil)
	end
	Ragdoll.SetMotorsEnabled(joints, false)
	Ragdoll.Ragdoll(character)
	return root
end

function WaterDrownService:_stopFloat(player: Player)
	local state = self._FloatStates[player] :: FloatState?
	if not state then
		return
	end
	self._FloatStates[player] = nil
	if state.orientation.Parent then
		state.orientation:Destroy()
	end
	if state.orientationAttachment.Parent then
		state.orientationAttachment:Destroy()
	end
	for _, floatForce in ipairs(state.forces) do
		if floatForce.force.Parent then
			floatForce.force:Destroy()
		end
		if floatForce.attachment.Parent then
			floatForce.attachment:Destroy()
		end
	end
end

local function isRagdollBodyPart(part: BasePart, character: Model): boolean
	return not part.Anchored
		and not part:FindFirstAncestorOfClass("Accessory")
		and not part:FindFirstAncestorOfClass("Tool")
		and part:IsDescendantOf(character)
end

function WaterDrownService:_applyFloatForces(state: FloatState, waterTop: BasePart)
	local anchor = state.anchor
	local waterSurfaceY = waterTop.Position.Y + waterTop.Size.Y * 0.5
	local targetAnchorY = waterSurfaceY - state.submergenceDepth
	local heightError = targetAnchorY - anchor.Position.Y
	local desiredAcceleration = math.clamp(
		heightError * FLOAT_SPRING_STRENGTH - anchor.AssemblyLinearVelocity.Y * FLOAT_DAMPING,
		-FLOAT_MAX_ACCELERATION,
		FLOAT_MAX_ACCELERATION
	)
	local totalLift = state.totalMass * (Workspace.Gravity + desiredAcceleration)
	for _, floatForce in ipairs(state.forces) do
		local massShare = floatForce.part:GetMass() / state.floatPartMass
		local lift = totalLift * massShare
		floatForce.force.Force = Vector3.new(0, lift, 0)
	end
end

local function getHorizontalFacing(root: BasePart): Vector3
	local lookVector = root.CFrame.LookVector
	local horizontalFacing = Vector3.new(lookVector.X, 0, lookVector.Z)
	if horizontalFacing.Magnitude < HORIZONTAL_DIRECTION_EPSILON then
		return Vector3.zAxis
	end
	return horizontalFacing.Unit
end

function WaterDrownService:_startFloat(player: Player, character: Model, waterTop: BasePart)
	self:_stopFloat(player)

	local upperTorso = character:FindFirstChild("UpperTorso")
	local lowerTorso = character:FindFirstChild("LowerTorso")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not upperTorso
		or not upperTorso:IsA("BasePart")
		or not lowerTorso
		or not lowerTorso:IsA("BasePart")
		or not root
		or not root:IsA("BasePart")
	then
		return
	end

	local forces: { FloatForce } = {}
	local totalMass = 0
	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") and isRagdollBodyPart(descendant, character) then
			totalMass += descendant:GetMass()
		end
	end
	local floatPartMass = upperTorso:GetMass() + lowerTorso:GetMass() + root:GetMass()
	for _, floatPart in ipairs({ upperTorso, lowerTorso, root }) do
		local attachment = Instance.new("Attachment")
		attachment.Name = FLOAT_ATTACHMENT_NAME
		attachment.Parent = floatPart

		local force = Instance.new("VectorForce")
		force.Name = FLOAT_FORCE_NAME
		force.Attachment0 = attachment
		force.RelativeTo = Enum.ActuatorRelativeTo.World
		force.ApplyAtCenterOfMass = true
		force.Parent = floatPart

		table.insert(forces, {
			part = floatPart,
			attachment = attachment,
			force = force,
		})
	end
	if #forces ~= 3 or totalMass <= 0 or floatPartMass <= 0 then
		for _, floatForce in ipairs(forces) do
			floatForce.force:Destroy()
			floatForce.attachment:Destroy()
		end
		return
	end

	local horizontalFacing = getHorizontalFacing(root)
	local faceUp = self._Random:NextNumber() < 0.5
	local faceNormal = if faceUp then Vector3.yAxis else -Vector3.yAxis
	local headDirection = if faceUp then -horizontalFacing else horizontalFacing
	local targetOrientation = CFrame.lookAt(Vector3.zero, faceNormal, headDirection)

	local velocity = lowerTorso.AssemblyLinearVelocity
	lowerTorso.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
	local rootVelocity = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(rootVelocity.X, 0, rootVelocity.Z)

	local orientationAttachment = Instance.new("Attachment")
	orientationAttachment.Name = FLOAT_ORIENTATION_ATTACHMENT_NAME
	orientationAttachment.Parent = lowerTorso

	local orientation = Instance.new("AlignOrientation")
	orientation.Name = FLOAT_ORIENTATION_NAME
	orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	orientation.AlignType = Enum.AlignType.AllAxes
	orientation.Attachment0 = orientationAttachment
	orientation.CFrame = targetOrientation
	orientation.RigidityEnabled = false
	orientation.Responsiveness = FLOAT_ORIENTATION_RESPONSIVENESS
	orientation.MaxAngularVelocity = FLOAT_ORIENTATION_MAX_ANGULAR_VELOCITY
	orientation.MaxTorque = totalMass * Workspace.Gravity * FLOAT_ORIENTATION_TORQUE_LEVER
	orientation.ReactionTorqueEnabled = false
	orientation.Parent = lowerTorso

	local state: FloatState = {
		character = character,
		anchor = lowerTorso,
		forces = forces,
		orientationAttachment = orientationAttachment,
		orientation = orientation,
		totalMass = totalMass,
		floatPartMass = floatPartMass,
		submergenceDepth = lowerTorso.Size.Z * FLOAT_BODY_SUBMERGENCE_RATIO,
	}
	self._FloatStates[player] = state
	self:_applyFloatForces(state, waterTop)
end

function WaterDrownService:_updateFloats(waterTop: BasePart?)
	for player, state in pairs(self._FloatStates) do
		local anchor = state.anchor
		if player.Character ~= state.character or anchor.Parent == nil or not waterTop then
			self:_stopFloat(player)
			continue
		end
		local isValid = state.orientation.Parent == anchor
			and state.orientationAttachment.Parent == anchor
			and state.orientation.Attachment0 == state.orientationAttachment
		for _, floatForce in ipairs(state.forces) do
			if floatForce.part.Parent == nil or floatForce.force.Parent ~= floatForce.part then
				isValid = false
				break
			end
		end
		if not isValid then
			self:_stopFloat(player)
			continue
		end
		self:_applyFloatForces(state, waterTop)
	end
end

function WaterDrownService:_clearState(player: Player, character: Model?)
	self._States[player] = nil
	if character then
		character:SetAttribute(DROWNING_ATTRIBUTE, false)
		character:SetAttribute(DROWN_STARTED_AT_ATTRIBUTE, nil)
	end
end

function WaterDrownService:_updatePlayer(player: Player, deltaTime: number, waterTop: BasePart?)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local head = character and character:FindFirstChild("Head")
	if not character or not humanoid or not head or not head:IsA("BasePart") or humanoid.Health <= 0 or not waterTop then
		self:_clearState(player, character)
		return
	end
	if not isPartTouchingWater(waterTop, head) then
		self:_clearState(player, character)
		return
	end

	local state = self._States[player]
	if not state or state.character ~= character then
		state = {
			character = character,
			elapsed = 0,
		}
		self._States[player] = state
		character:SetAttribute(DROWNING_ATTRIBUTE, true)
		character:SetAttribute(DROWN_STARTED_AT_ATTRIBUTE, Workspace:GetServerTimeNow())
	end

	state.elapsed += deltaTime
	if state.elapsed >= DROWN_DURATION then
		local root = character:FindFirstChild("HumanoidRootPart")
		local deathPosition = if root and root:IsA("BasePart") then root.Position else head.Position
		local drownDropService = Knit.GetService("DrownDropService")
		local droppedCount = drownDropService:DropCarriedItems(player, deathPosition)
		if droppedCount > 0 then
			self.Client.DrownedItemsDropped:Fire(player, droppedCount)
		end
		local ragdollRoot = ragdollCharacterForDrowning(character, humanoid)
		if ragdollRoot then
			self:_startFloat(player, character, waterTop)
		end
		self.Client.Drowned:Fire(player, character)
		humanoid.Health = 0
		self:_clearState(player, character)
	end
end

function WaterDrownService:KnitInit()
	Players.PlayerRemoving:Connect(function(player: Player)
		self._States[player] = nil
		self:_stopFloat(player)
	end)
end

function WaterDrownService:KnitStart()
	RunService.Heartbeat:Connect(function(deltaTime: number)
		local waterTop = getWaterTop()
		if not waterTop and not self._WarnedMissingWater then
			self._WarnedMissingWater = true
			warn("WaterDrownService: Workspace.Areas.Water.Top is missing")
		elseif waterTop then
			self._WarnedMissingWater = false
		end
		self:_updateFloats(waterTop)

		for _, player in ipairs(Players:GetPlayers()) do
			self:_updatePlayer(player, deltaTime, waterTop)
		end
	end)
end

return WaterDrownService
