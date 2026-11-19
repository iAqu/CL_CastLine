-- The resource Handle is the centre of the bar, not a right-hand grip.
local Grip = {}

function Grip.GetC0(character)
	local right = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
	local left = character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not right or not left or not root then
		return nil
	end
	local rightAttachment = right:FindFirstChild("RightGripAttachment")
	local leftAttachment = left:FindFirstChild("LeftGripAttachment")
	local a = if leftAttachment then leftAttachment.WorldPosition else left.Position
	local b = if rightAttachment then rightAttachment.WorldPosition else right.Position
	local axis = b - a
	if axis.Magnitude < 0.01 then
		return nil
	end
	local x = axis.Unit
	local z = x:Cross(root.CFrame.UpVector)
	if z.Magnitude < 0.01 then
		return nil
	end
	z = z.Unit
	local target = CFrame.fromMatrix((a + b) * 0.5, x, z:Cross(x), z)
	return right.CFrame:ToObjectSpace(target)
end

function Grip.Update(character)
	local barbell = character and character:FindFirstChild("TrainingBarbell")
	local handle = barbell and barbell:FindFirstChild("Handle")
	local joint = handle and handle:FindFirstChild("TrainingGrip")
	if joint then
		local c0 = Grip.GetC0(character)
		if c0 then
			joint.C0 = c0
		end
	end
end

return Grip
