local Workspace = game:GetService("Workspace")

local WaterSurfaceUtil = {}

local function getWater()
	local areas = Workspace:FindFirstChild("Areas")
	return areas and areas:FindFirstChild("Water")
end

function WaterSurfaceUtil.GetWaterTop(): BasePart?
	local water = getWater()
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

local function isBelowTop(top: BasePart, worldPosition: Vector3): boolean
	local localPoint = top.CFrame:PointToObjectSpace(worldPosition)
	local halfSize = top.Size * 0.5
	return math.abs(localPoint.X) <= halfSize.X
		and math.abs(localPoint.Z) <= halfSize.Z
		and localPoint.Y <= halfSize.Y
end

function WaterSurfaceUtil.IsPointSubmerged(worldPosition: Vector3, waterTop: BasePart?): boolean
	if waterTop then
		return isBelowTop(waterTop, worldPosition)
	end
	local water = getWater()
	if water then
		for _, child in water:GetChildren() do
			if child.Name == "Top" and child:IsA("BasePart") and isBelowTop(child, worldPosition) then
				return true
			end
		end
	end
	return false
end

return WaterSurfaceUtil
