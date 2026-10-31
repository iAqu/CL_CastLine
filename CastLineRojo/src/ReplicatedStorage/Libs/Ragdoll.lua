-- Ragdoll Module
-- Made by Dev1n @ADRENALXNE

local RPS = game:GetService("ReplicatedStorage")

local stateType = Enum.HumanoidStateType

local RIG_TYPE_CONFIG_FOLDER = RPS.Config.RagdollConfig

local RAGDOLL_NAME = "RagdollConstraint"
local NOCOLLIDE_NAME = "RagdollNoCollide"
local COLLIDER_NAME = "RagdollCollider"
local COLLIDER_SCALE = 0.75
local PLAYER_COLLISION_GROUP = "Player"
local MIN_BALL_SOCKET_ANGLE = 60
local MIN_TWIST_ANGLE = 45

local ORIGINAL_LIMITS_ENABLED_ATTRIBUTE = "SeaDigRagdollOriginalLimitsEnabled"
local ORIGINAL_UPPER_ANGLE_ATTRIBUTE = "SeaDigRagdollOriginalUpperAngle"
local ORIGINAL_TWIST_LIMITS_ENABLED_ATTRIBUTE = "SeaDigRagdollOriginalTwistLimitsEnabled"
local ORIGINAL_TWIST_LOWER_ANGLE_ATTRIBUTE = "SeaDigRagdollOriginalTwistLowerAngle"
local ORIGINAL_TWIST_UPPER_ANGLE_ATTRIBUTE = "SeaDigRagdollOriginalTwistUpperAngle"

local noCollisionMap = {
	R15 = {
		Head = { "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightUpperArm", "RightUpperLeg" },
		LeftFoot = { "LowerTorso", "UpperTorso" },
		LeftHand = { "LowerTorso", "UpperTorso" },
		RightFoot = { "LowerTorso", "UpperTorso" },
		RightHand = { "LowerTorso", "UpperTorso" },
		LeftLowerArm = { "LowerTorso", "UpperTorso" },
		LeftLowerLeg = { "LowerTorso", "UpperTorso" },
		LeftUpperArm = { "LeftUpperLeg", "LowerTorso", "UpperTorso", "RightUpperArm", "RightUpperLeg" },
		LeftUpperLeg = { "LowerTorso", "UpperTorso", "RightUpperLeg" },
		RightLowerArm = { "LowerTorso", "UpperTorso" },
		RightLowerLeg = { "LowerTorso", "UpperTorso" },
		RightUpperArm = { "RightUpperLeg", "LowerTorso", "UpperTorso", "LeftUpperLeg" },
		RightUpperLeg = { "LowerTorso", "UpperTorso" },
	},

	R6 = {
		Head = { "Left Arm", "Left Leg", "Torso", "Right Arm", "Right Leg" },
	},
}

local function getJoints(character: Model): { Instance }
	local animationConstraints: { Instance } = {}
	local motors: { Instance } = {}

	for _, descendant in character:GetDescendants() do
		if descendant:IsA("AnimationConstraint") then
			animationConstraints[#animationConstraints + 1] = descendant
		elseif descendant:IsA("Motor6D") then
			motors[#motors + 1] = descendant
		end
	end

	-- Avatar Joint Upgrade R15 characters already contain physical BallSocket/Hinge
	-- constraints. Their AnimationConstraints replace Motor6Ds and become ragdolls
	-- when switched out of kinematic mode.
	if #animationConstraints > 0 then
		return animationConstraints
	end
	return motors
end

local function createModernRootConstraint(character: Model, rigTypeName: string)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local lowerTorso = character:FindFirstChild("LowerTorso")
	if not rootPart or not rootPart:IsA("BasePart") or not lowerTorso or not lowerTorso:IsA("BasePart") then
		return
	end
	if lowerTorso:FindFirstChild(RAGDOLL_NAME) then
		return
	end

	local rootAttachment = rootPart:FindFirstChild("RootRigAttachment")
	local torsoAttachment = lowerTorso:FindFirstChild("RootRigAttachment")
	local rigConfig = RIG_TYPE_CONFIG_FOLDER:FindFirstChild(rigTypeName)
	local rootTemplate = rigConfig and rigConfig:FindFirstChild("Root")
	if
		not rootAttachment
		or not rootAttachment:IsA("Attachment")
		or not torsoAttachment
		or not torsoAttachment:IsA("Attachment")
	then
		return
	end
	if not rootTemplate or not rootTemplate:IsA("RigidConstraint") then
		return
	end

	local rootConstraint = rootTemplate:Clone()
	rootConstraint.Name = RAGDOLL_NAME
	rootConstraint.Attachment0 = rootAttachment
	rootConstraint.Attachment1 = torsoAttachment
	rootConstraint.Parent = lowerTorso
end

-- create NoCollisionConstraints so the character doesn't fling
local function createNoCollisionConstraints(character, rigTypeName)
	for i, subMap in noCollisionMap[rigTypeName] do
		for _, x in subMap do
			local noCollision = Instance.new("NoCollisionConstraint")
			noCollision.Name = NOCOLLIDE_NAME
			noCollision.Part0 = character[i]
			noCollision.Part1 = character[x]
			noCollision.Parent = character
		end
	end
end

local function createCollisionProxies(character: Model)
	for _, part in character:GetChildren() do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not part:FindFirstChild(COLLIDER_NAME) then
			local collider = Instance.new("Part")
			collider.Name = COLLIDER_NAME
			collider.Size = part.Size * COLLIDER_SCALE
			collider.CFrame = part.CFrame
			collider.Transparency = 1
			collider.CanCollide = true
			collider.CanQuery = false
			collider.CanTouch = false
			collider.CastShadow = false
			collider.Massless = true
			collider.CollisionGroup = PLAYER_COLLISION_GROUP
			collider.Parent = part

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = part
			weld.Part1 = collider
			weld.Parent = collider
		end
	end
end

local function loosenBallSocketConstraints(character: Model)
	for _, descendant in character:GetDescendants() do
		if not descendant:IsA("BallSocketConstraint") then
			continue
		end

		if descendant:GetAttribute(ORIGINAL_LIMITS_ENABLED_ATTRIBUTE) == nil then
			descendant:SetAttribute(ORIGINAL_LIMITS_ENABLED_ATTRIBUTE, descendant.LimitsEnabled)
			descendant:SetAttribute(ORIGINAL_UPPER_ANGLE_ATTRIBUTE, descendant.UpperAngle)
			descendant:SetAttribute(ORIGINAL_TWIST_LIMITS_ENABLED_ATTRIBUTE, descendant.TwistLimitsEnabled)
			descendant:SetAttribute(ORIGINAL_TWIST_LOWER_ANGLE_ATTRIBUTE, descendant.TwistLowerAngle)
			descendant:SetAttribute(ORIGINAL_TWIST_UPPER_ANGLE_ATTRIBUTE, descendant.TwistUpperAngle)
		end

		descendant.LimitsEnabled = true
		descendant.UpperAngle = math.max(descendant.UpperAngle, MIN_BALL_SOCKET_ANGLE)
		descendant.TwistLimitsEnabled = true
		descendant.TwistLowerAngle = math.min(descendant.TwistLowerAngle, -MIN_TWIST_ANGLE)
		descendant.TwistUpperAngle = math.max(descendant.TwistUpperAngle, MIN_TWIST_ANGLE)
	end
end

local function restoreBallSocketConstraints(character: Model)
	for _, descendant in character:GetDescendants() do
		if not descendant:IsA("BallSocketConstraint") then
			continue
		end

		local limitsEnabled = descendant:GetAttribute(ORIGINAL_LIMITS_ENABLED_ATTRIBUTE)
		local upperAngle = descendant:GetAttribute(ORIGINAL_UPPER_ANGLE_ATTRIBUTE)
		local twistLimitsEnabled = descendant:GetAttribute(ORIGINAL_TWIST_LIMITS_ENABLED_ATTRIBUTE)
		local twistLowerAngle = descendant:GetAttribute(ORIGINAL_TWIST_LOWER_ANGLE_ATTRIBUTE)
		local twistUpperAngle = descendant:GetAttribute(ORIGINAL_TWIST_UPPER_ANGLE_ATTRIBUTE)
		if typeof(limitsEnabled) == "boolean" then
			descendant.LimitsEnabled = limitsEnabled
		end
		if typeof(upperAngle) == "number" then
			descendant.UpperAngle = upperAngle
		end
		if typeof(twistLimitsEnabled) == "boolean" then
			descendant.TwistLimitsEnabled = twistLimitsEnabled
		end
		if typeof(twistLowerAngle) == "number" then
			descendant.TwistLowerAngle = twistLowerAngle
		end
		if typeof(twistUpperAngle) == "number" then
			descendant.TwistUpperAngle = twistUpperAngle
		end

		descendant:SetAttribute(ORIGINAL_LIMITS_ENABLED_ATTRIBUTE, nil)
		descendant:SetAttribute(ORIGINAL_UPPER_ANGLE_ATTRIBUTE, nil)
		descendant:SetAttribute(ORIGINAL_TWIST_LIMITS_ENABLED_ATTRIBUTE, nil)
		descendant:SetAttribute(ORIGINAL_TWIST_LOWER_ANGLE_ATTRIBUTE, nil)
		descendant:SetAttribute(ORIGINAL_TWIST_UPPER_ANGLE_ATTRIBUTE, nil)
	end
end

-- Ragdoll Module
local Ragdoll = {}

local function hasCreatedJoints(character: Model): boolean
	for _, descendant in character:GetDescendants() do
		if descendant.Name == RAGDOLL_NAME and (descendant:IsA("Constraint") or descendant:IsA("WeldConstraint")) then
			return true
		end
	end
	return false
end

-- Create joints for ragdoll
function Ragdoll.CreateJoints(character: Model): { Instance }?
	if not character:IsA("Model") or not character:FindFirstChildOfClass("Humanoid") then
		return
	end

	local rigType = character.Humanoid.RigType
	local joints = getJoints(character)
	if #joints == 0 then
		return
	end
	if not hasCreatedJoints(character) then
		if joints[1]:IsA("AnimationConstraint") then
			createModernRootConstraint(character, rigType.Name)
		else
			local motors = joints
			createNoCollisionConstraints(character, rigType.Name)

			for _, motor in motors do
				local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
				a0.Name, a1.Name = RAGDOLL_NAME, RAGDOLL_NAME
				a0.CFrame = motor.C0
				a1.CFrame = motor.C1
				a0.Parent = motor.Part0
				a1.Parent = motor.Part1

				local name = motor.Name:gsub("Right", "")
				name = name:gsub("Left", "")
				name = name:gsub("Joint", "")
				name = name:gsub(" ", "")

				local b = (
					RIG_TYPE_CONFIG_FOLDER[rigType.Name]:FindFirstChild(name)
					or RIG_TYPE_CONFIG_FOLDER[rigType.Name].Default
				):Clone()
				b.Name = RAGDOLL_NAME

				b.Attachment0 = a0
				b.Attachment1 = a1
				b.Parent = motor.Part1
			end
		end
	end

	createCollisionProxies(character)
	loosenBallSocketConstraints(character)
	return joints
end

-- Remove joints for ragdoll
function Ragdoll.DestroyJoints(character: Model)
	restoreBallSocketConstraints(character)
	for _, descendant: Instance in character:GetDescendants() do
		-- Remove BallSockets and NoCollides, leave the additional Attachments
		if
			(descendant:IsA("Constraint") or descendant:IsA("WeldConstraint") or descendant:IsA("Attachment"))
				and descendant.Name == RAGDOLL_NAME
			or descendant:IsA("NoCollisionConstraint") and descendant.Name == NOCOLLIDE_NAME
			or descendant:IsA("BasePart") and descendant.Name == COLLIDER_NAME
		then
			descendant:Destroy()
		end
	end
end

-- Setup properties for Ragdoll
function Ragdoll.Ragdoll(character: Model)
	local rootPart: BasePart? = character.PrimaryPart
	local humanoid: Humanoid = character.Humanoid

	humanoid.WalkSpeed = 0
	humanoid.AutoRotate = false
	rootPart.CanCollide = false
	character.Head.CanCollide = true

	if not character.PrimaryPart:GetNetworkOwner() then
		if humanoid.Health > 0 and humanoid:GetState() ~= stateType.Physics then
			humanoid:ChangeState(stateType.Physics)
		end
	end
end

-- Reset properties for ragdoll
function Ragdoll.UnRagdoll(character: Model)
	local humanoid: Humanoid = character.Humanoid

	if humanoid.Health > 0 then
		humanoid.WalkSpeed = 30
		humanoid.AutoRotate = true
		character.PrimaryPart.CanCollide = true
		character.Head.CanCollide = false

		if not character.PrimaryPart:GetNetworkOwner() then
			if humanoid:GetState() ~= stateType.GettingUp then
				humanoid:ChangeState(stateType.GettingUp)
			end
		end
	end
end

-- Set motor-set enabled
function Ragdoll.SetMotorsEnabled(joints: { Instance }, enabled: boolean)
	for _, joint in joints do
		if joint:IsA("Motor6D") then
			joint.Enabled = enabled
		elseif joint:IsA("AnimationConstraint") then
			joint.IsKinematic = enabled
		end
	end
end

-- Check whether a humanoid is ragdolled or not
function Ragdoll.IsRagdolled(humanoid: Humanoid): boolean
	return humanoid:GetState() == stateType.Physics
end

return Ragdoll
