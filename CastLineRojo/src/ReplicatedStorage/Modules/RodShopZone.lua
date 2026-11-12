local RodShopZone = {}

RodShopZone.ExitMargin = 2

function RodShopZone.GetAnchor(plot: Instance?): BasePart?
	local anchor = plot and plot:FindFirstChild("RodShopAnchor")
	return if anchor and anchor:IsA("BasePart") then anchor else nil
end

function RodShopZone.Contains(anchor: BasePart, character: Model?, margin: number): boolean
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not (root and root:IsA("BasePart") and humanoid and humanoid.Health > 0) then
		return false
	end
	local height = humanoid.HipHeight + root.Size.Y / 2
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leg = character:FindFirstChild("Left Leg")
		if leg and leg:IsA("BasePart") then
			height += leg.Size.Y
		end
	end
	local foot = anchor.CFrame:PointToObjectSpace(root.Position - Vector3.yAxis * height)
	-- The anchor inherits the circle's local X axis, which is normal to the ground.
	local y = foot.Y / (anchor.Size.Y / 2 + margin)
	local z = foot.Z / (anchor.Size.Z / 2 + margin)
	return math.abs(foot.X) <= 3.5 and y * y + z * z <= 1
end

return RodShopZone
