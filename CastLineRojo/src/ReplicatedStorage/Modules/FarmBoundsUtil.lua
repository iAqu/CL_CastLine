local FarmBoundsUtil = {}

local INNER_BOUND_MARGIN = 5
local ANIMAL_Y_OFFSET = 0.2

export type FarmBounds = {
	part: BasePart?,
	cframe: CFrame,
	size: Vector3,
	fallbackY: number,
}

local function boundsFromPart(boundsPart: BasePart): FarmBounds
	return {
		part = boundsPart,
		cframe = boundsPart.CFrame,
		size = boundsPart.Size,
		fallbackY = boundsPart.Position.Y + ANIMAL_Y_OFFSET,
	}
end

local function getHalfExtents(size: Vector3, margin: number): (number, number)
	local halfX = math.max(size.X * 0.5 - margin, 2)
	local halfZ = math.max(size.Z * 0.5 - margin, 2)
	return halfX, halfZ
end

local function isPointInBoundsWithMargin(bounds: FarmBounds, position: Vector3, margin: number): boolean
	local localPosition = bounds.cframe:PointToObjectSpace(position)
	local halfX, halfZ = getHalfExtents(bounds.size, margin)
	return math.abs(localPosition.X) <= halfX and math.abs(localPosition.Z) <= halfZ
end

local function resolveZoneBoundsPart(farm: Instance): BasePart?
	local zone = farm:FindFirstChild("Zone_1", true)
	if not zone then
		return nil
	end

	local boundsPart = zone:FindFirstChild("BoundsPart")
	if boundsPart and boundsPart:IsA("BasePart") then
		return boundsPart
	end

	return nil
end

function FarmBoundsUtil.ResolveBoundsFromPart(boundsPart: BasePart): FarmBounds
	return boundsFromPart(boundsPart)
end

function FarmBoundsUtil.ResolveBounds(farm: Instance): FarmBounds?
	local zoneBoundsPart = resolveZoneBoundsPart(farm)
	if zoneBoundsPart then
		return boundsFromPart(zoneBoundsPart)
	end

	return nil
end

function FarmBoundsUtil.ResolveBoundsForZone(farm: Instance, zoneName: string): FarmBounds?
	local FarmZoneUtil = require(script.Parent.FarmZoneUtil)
	local boundsPart = FarmZoneUtil.resolveZoneBoundsPart(farm, zoneName)
	if boundsPart then
		return boundsFromPart(boundsPart)
	end

	return nil
end

function FarmBoundsUtil.FindUnlockedBoundsAtPoint(farm: Instance, position: Vector3): FarmBounds?
	local FarmZoneUtil = require(script.Parent.FarmZoneUtil)
	local boundsPart = FarmZoneUtil.findUnlockedZoneAtPoint(farm, position)
	if boundsPart then
		return boundsFromPart(boundsPart)
	end

	return nil
end

function FarmBoundsUtil.IsPointInBounds(bounds: FarmBounds, position: Vector3): boolean
	return isPointInBoundsWithMargin(bounds, position, INNER_BOUND_MARGIN)
end

function FarmBoundsUtil.IsPointInBoundsExact(bounds: FarmBounds, position: Vector3): boolean
	return isPointInBoundsWithMargin(bounds, position, 0)
end

function FarmBoundsUtil.ClampPointToBounds(bounds: FarmBounds, position: Vector3): Vector3
	local localPosition = bounds.cframe:PointToObjectSpace(position)
	local halfX, halfZ = getHalfExtents(bounds.size, INNER_BOUND_MARGIN)
	local clampedLocal = Vector3.new(
		math.clamp(localPosition.X, -halfX, halfX),
		localPosition.Y,
		math.clamp(localPosition.Z, -halfZ, halfZ)
	)
	local worldPosition = bounds.cframe:PointToWorldSpace(clampedLocal)
	return Vector3.new(worldPosition.X, position.Y, worldPosition.Z)
end

function FarmBoundsUtil.GetRaycastParams(folder: Folder, localPlayer: Player?): RaycastParams
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local exclude = { folder }
	local character = localPlayer and localPlayer.Character
	if character then
		table.insert(exclude, character)
	end

	params.FilterDescendantsInstances = exclude
	return params
end

local function buildZoneIncludeList(zoneRoot: Instance): { Instance }
	local includeList = { zoneRoot }
	for _, desc in ipairs(zoneRoot:GetDescendants()) do
		if desc:IsA("BasePart") then
			table.insert(includeList, desc)
		end
	end
	return includeList
end

local function raycastGroundInZone(bounds: FarmBounds, position: Vector3): Vector3?
	local boundsPart = bounds.part
	if not boundsPart or not boundsPart.Parent then
		return nil
	end

	local Workspace = game:GetService("Workspace")
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = buildZoneIncludeList(boundsPart.Parent)

	local origin = Vector3.new(position.X, bounds.fallbackY + 60, position.Z)
	local result = Workspace:Raycast(origin, Vector3.new(0, -160, 0), params)
	if result then
		return Vector3.new(position.X, result.Position.Y + ANIMAL_Y_OFFSET, position.Z)
	end

	return nil
end

function FarmBoundsUtil.GetGroundedPosition(bounds: FarmBounds, position: Vector3, folder: Folder, localPlayer: Player?): Vector3
	local zoneGrounded = raycastGroundInZone(bounds, position)
	if zoneGrounded then
		return zoneGrounded
	end

	local Workspace = game:GetService("Workspace")
	local origin = Vector3.new(position.X, bounds.fallbackY + 60, position.Z)
	local result = Workspace:Raycast(origin, Vector3.new(0, -160, 0), FarmBoundsUtil.GetRaycastParams(folder, localPlayer))
	if result then
		return Vector3.new(position.X, result.Position.Y + ANIMAL_Y_OFFSET, position.Z)
	end

	return Vector3.new(position.X, bounds.fallbackY, position.Z)
end

function FarmBoundsUtil.RandomPointInBounds(rng: Random, bounds: FarmBounds, folder: Folder, localPlayer: Player?): Vector3
	local halfX, halfZ = getHalfExtents(bounds.size, INNER_BOUND_MARGIN)
	local localPoint = Vector3.new(rng:NextNumber(-halfX, halfX), 0, rng:NextNumber(-halfZ, halfZ))
	local worldPoint = bounds.cframe:PointToWorldSpace(localPoint)
	return FarmBoundsUtil.GetGroundedPosition(bounds, worldPoint, folder, localPlayer)
end

return FarmBoundsUtil
