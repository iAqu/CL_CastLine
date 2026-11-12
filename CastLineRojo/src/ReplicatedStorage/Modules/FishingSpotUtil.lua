local FishingSpotUtil = {}

function FishingSpotUtil.GetStartPart(plot: Instance?): BasePart?
	local part = plot and plot:FindFirstChild("FishingStartPart")
	return if part and part:IsA("BasePart") then part else nil
end

function FishingSpotUtil.GetFootHeight(root: BasePart, humanoid: Humanoid): number
	local height = humanoid.HipHeight + root.Size.Y / 2
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leg = root.Parent and root.Parent:FindFirstChild("Left Leg")
		if leg and leg:IsA("BasePart") then
			height += leg.Size.Y
		end
	end
	return height
end

function FishingSpotUtil.Contains(part: BasePart, root: BasePart, humanoid: Humanoid, horizontalTolerance: number?): boolean
	-- The marker is a thin floor, so check the feet rather than the root.
	local feet = root.Position - Vector3.yAxis * FishingSpotUtil.GetFootHeight(root, humanoid)
	local point = part.CFrame:PointToObjectSpace(feet)
	local tolerance = horizontalTolerance or 0
	return math.abs(point.X) <= part.Size.X / 2 + tolerance
		and math.abs(point.Z) <= part.Size.Z / 2 + tolerance
		and math.abs(point.Y - part.Size.Y / 2) <= 2.5
end

return FishingSpotUtil
