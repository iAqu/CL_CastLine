local ItemToolUtil = require(script.Parent.ItemToolUtil)

local HeldFishPose = {}
HeldFishPose.__index = HeldFishPose

HeldFishPose.RaiseTime = 0.25
local PALM_OVERLAP = 0.025

type ArmLink = {
	joint: Motor6D | AnimationConstraint,
	before: CFrame?,
	applied: CFrame?,
}

type Arm = {
	links: { ArmLink },
	hand: BasePart,
	rest: { CFrame },
}

local function getPart(character: Model, name: string): BasePart?
	local part = character:FindFirstChild(name)
	return if part and part:IsA("BasePart") then part else nil
end

local function getLink(part0: BasePart, part1: BasePart, name: string): ArmLink?
	local joint = part1:FindFirstChild(name) or part0:FindFirstChild(name)
	if joint and joint:IsA("Motor6D") and joint.Part0 == part0 and joint.Part1 == part1 then
		return { joint = joint }
	end
	if joint and joint:IsA("AnimationConstraint") and joint.IsKinematic then
		local a0, a1 = joint.Attachment0, joint.Attachment1
		if a0 and a1 and a0.Parent == part0 and a1.Parent == part1 then
			return { joint = joint }
		end
	end
	return nil
end

local function getArm(character: Model, torso: BasePart, side: string, r6: boolean): Arm?
	if r6 then
		local arm = getPart(character, side .. " Arm")
		local shoulder = arm and getLink(torso, arm, side .. " Shoulder")
		return if arm and shoulder then { links = { shoulder }, hand = arm, rest = {} } else nil
	end

	local upper = getPart(character, side .. "UpperArm")
	local lower = getPart(character, side .. "LowerArm")
	local hand = getPart(character, side .. "Hand")
	if not upper or not lower or not hand then
		return nil
	end
	local shoulder = getLink(torso, upper, side .. "Shoulder")
	local elbow = getLink(upper, lower, side .. "Elbow")
	local wrist = getLink(lower, hand, side .. "Wrist")
	if not shoulder or not elbow or not wrist then
		return nil
	end
	return { links = { shoulder, elbow, wrist }, hand = hand, rest = {} }
end

local function getBindFrames(link: ArmLink): (CFrame?, CFrame?)
	local joint = link.joint
	if not joint.Parent then
		return nil, nil
	end
	if joint:IsA("Motor6D") then
		if joint.Part0 and joint.Part1 then
			return joint.C0, joint.C1
		end
	elseif joint.IsKinematic then
		local a0, a1 = joint.Attachment0, joint.Attachment1
		if a0 and a1 then
			return a0.CFrame, a1.CFrame
		end
	end
	return nil, nil
end

local function handFrame(arm: Arm, blend: number?): CFrame?
	-- Evaluate in torso space so the grip follows the same pose as the batched joints.
	local frame = CFrame.identity
	for index, link in arm.links do
		local c0, c1 = getBindFrames(link)
		if not c0 or not c1 then
			return nil
		end
		local target = arm.rest[index]
		if blend then
			local before = link.joint.Transform
			target = if blend < 1 then before:Lerp(target, blend) else target
			link.joint.Transform = target
			link.before, link.applied = before, link.joint.Transform
		end
		frame *= c0 * target * c1:Inverse()
	end
	return frame
end

local function palm(frame: CFrame, arm: Arm, r6: boolean): Vector3
	local half = arm.hand.Size * 0.5
	if r6 then
		return frame:PointToWorldSpace(Vector3.new(0, -half.Y, 0))
	end
	local top = math.abs(frame.XVector.Y) * half.X
		+ math.abs(frame.YVector.Y) * half.Y
		+ math.abs(frame.ZVector.Y) * half.Z
	return frame.Position + Vector3.new(0, top, 0)
end

local function setArmRest(arm: Arm, inwardRoll: number, r6: boolean)
	if r6 then
		local c0 = getBindFrames(arm.links[1])
		local axes = if c0 then c0.Rotation else CFrame.identity
		arm.rest[1] = axes:Inverse() * CFrame.Angles(math.rad(155), 0, inwardRoll) * axes
		return
	end
	-- The last frame of the intro catch: lift the arms and counter the lift at the wrists.
	arm.rest[1] = CFrame.Angles(math.rad(161), 0, inwardRoll)
	arm.rest[2] = CFrame.Angles(math.rad(16), 0, 0)
	arm.rest[3] = CFrame.Angles(math.rad(-75), 0, 0)
end

local function fitArms(left: Arm, right: Arm, fishSpan: number, r6: boolean)
	local function setRoll(degrees: number): number
		setArmRest(left, math.rad(degrees), r6)
		setArmRest(right, math.rad(-degrees), r6)
		local l = handFrame(left)
		local r = handFrame(right)
		return if l and r then palm(r, right, r6).X - palm(l, left, r6).X else 0
	end

	local wide = 8
	local narrow = 36
	local minimumGap = (left.hand.Size.X + right.hand.Size.X) * 0.5
	local desiredGap = math.max(minimumGap, fishSpan * 0.7)
	if setRoll(wide) <= desiredGap then
		return
	end

	for _ = 1, 6 do
		local roll = (wide + narrow) * 0.5
		if setRoll(roll) > desiredGap then
			wide = roll
		else
			narrow = roll
		end
	end
	setRoll(wide)
end

local function findRightGrip(hand: BasePart, handle: BasePart): JointInstance?
	for _, joint in hand:GetChildren() do
		if joint.Name == "RightGrip" and joint:IsA("JointInstance") and joint.Part0 == hand and joint.Part1 == handle then
			return joint
		end
	end
	return nil
end

function HeldFishPose.new(character: Model, tool: Tool)
	local carryGrip = tool:GetAttribute(ItemToolUtil.FISH_CARRY_GRIP_ATTRIBUTE)
	local fishSpan = tool:GetAttribute(ItemToolUtil.FISH_CARRY_SPAN_ATTRIBUTE)
	local handle = tool:FindFirstChild("Handle")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if typeof(carryGrip) ~= "CFrame" or typeof(fishSpan) ~= "number"
		or not handle or not handle:IsA("BasePart") or not humanoid or humanoid.Health <= 0
	then
		return nil
	end

	local r6 = humanoid.RigType == Enum.HumanoidRigType.R6
	local torso = getPart(character, if r6 then "Torso" else "UpperTorso")
	if not torso then
		return nil
	end
	local left = getArm(character, torso, "Left", r6)
	local right = getArm(character, torso, "Right", r6)
	local grip = right and findRightGrip(right.hand, handle)
	if not left or not right or not grip then
		return nil
	end
	fitArms(left, right, fishSpan, r6)

	return setmetatable({
		character = character,
		tool = tool,
		humanoid = humanoid,
		handle = handle,
		left = left,
		right = right,
		grip = grip,
		gripC0 = grip.C0,
		gripC1 = grip.C1,
		carryGrip = carryGrip,
		elapsed = 0,
		r6 = r6,
	}, HeldFishPose)
end

export type State = typeof(setmetatable({} :: {
	character: Model,
	tool: Tool,
	humanoid: Humanoid,
	handle: BasePart,
	left: Arm,
	right: Arm,
	grip: JointInstance,
	gripC0: CFrame,
	gripC1: CFrame,
	carryGrip: CFrame,
	elapsed: number,
	r6: boolean,
}, HeldFishPose))

function HeldFishPose.RestoreArms(self: State)
	for _, arm in { self.left, self.right } do
		for _, link in arm.links do
			if link.before and link.joint.Parent and link.joint.Transform == link.applied then
				link.joint.Transform = link.before
			end
			link.before, link.applied = nil, nil
		end
	end
end

function HeldFishPose.Step(self: State, deltaTime: number): boolean
	local grip = self.grip
	if not self.character.Parent or self.tool.Parent ~= self.character or self.humanoid.Health <= 0
		or not grip.Parent or grip.Part0 ~= self.right.hand or grip.Part1 ~= self.handle
	then
		return false
	end

	self.elapsed = math.min(self.elapsed + deltaTime, HeldFishPose.RaiseTime)
	local progress = self.elapsed / HeldFishPose.RaiseTime
	local blend = progress * progress * (3 - 2 * progress)
	local left = handFrame(self.left, blend)
	local right = handFrame(self.right, blend)
	if not left or not right then
		return false
	end

	local center = (palm(left, self.left, self.r6) + palm(right, self.right, self.r6)) * 0.5
	local carryC0 = right:ToObjectSpace(CFrame.new(center - Vector3.yAxis * PALM_OVERLAP))
	local c0 = self.gripC0:Lerp(carryC0, blend)
	local c1 = if blend < 1 then self.gripC1:Lerp(self.carryGrip, blend) else self.carryGrip
	if grip.C0 ~= c0 then
		grip.C0 = c0
	end
	if grip.C1 ~= c1 then
		grip.C1 = c1
	end
	return true
end

function HeldFishPose.Destroy(self: State)
	self:RestoreArms()
	local grip = self.grip
	if grip.Parent and grip.Part0 == self.right.hand and grip.Part1 == self.handle then
		grip.C0, grip.C1 = self.gripC0, self.gripC1
	end
end

return HeldFishPose
