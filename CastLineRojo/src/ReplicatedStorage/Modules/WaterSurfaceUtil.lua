local Workspace = game:GetService("Workspace")

local WaterSurfaceUtil = {}

function WaterSurfaceUtil.GetWaterTop(): BasePart?
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	local top = water and water:FindFirstChild("Top")
	return if top and top:IsA("BasePart") then top else nil
end

function WaterSurfaceUtil.GetWaterSurfaceY(waterTop: BasePart?): number?
	local top = waterTop or WaterSurfaceUtil.GetWaterTop()
	if not top then
		return nil
	end

	return top.CFrame:PointToWorldSpace(Vector3.new(0, top.Size.Y * 0.5, 0)).Y
end

function WaterSurfaceUtil.IsPointSubmerged(worldPosition: Vector3, waterTop: BasePart?): boolean
	local top = waterTop or WaterSurfaceUtil.GetWaterTop()
	if not top then
		return false
	end

	local localPoint = top.CFrame:PointToObjectSpace(worldPosition)
	local halfSize = top.Size * 0.5
	return math.abs(localPoint.X) <= halfSize.X
		and math.abs(localPoint.Z) <= halfSize.Z
		and localPoint.Y <= halfSize.Y
end

return WaterSurfaceUtil
