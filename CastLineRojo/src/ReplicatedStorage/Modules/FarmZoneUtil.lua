local FarmBoundsUtil = require(script.Parent.FarmBoundsUtil)

local STARTER_ZONE_NAME = "Zone_1"

local FarmZoneUtil = {}

export type ZonePresenceAabb = {
	minX: number,
	maxX: number,
	minZ: number,
	maxZ: number,
}

local zonePresenceAabbCache: { [Instance]: ZonePresenceAabb? } = {}
local zonePresenceAabbComputed: { [Instance]: boolean } = {}

FarmZoneUtil.ZONE_UNLOCKED_ATTRIBUTE = "ZoneUnlocked"

function FarmZoneUtil.isConfiguredZone(zone: Instance): boolean
	return zone:IsA("Folder") and string.match(zone.Name, "^Zone_%d+$") ~= nil
end

function FarmZoneUtil.resolveZonesFolder(farm: Instance): Folder?
	for _, child in ipairs(farm:GetChildren()) do
		if child.Name == "Zones" and child:IsA("Folder") and child:FindFirstChild(STARTER_ZONE_NAME) then
			return child
		end
	end

	return nil
end

function FarmZoneUtil.isZoneUnlocked(zone: Instance): boolean
	if not FarmZoneUtil.isConfiguredZone(zone) then
		return false
	end

	local attribute = zone:GetAttribute(FarmZoneUtil.ZONE_UNLOCKED_ATTRIBUTE)
	if attribute == nil then
		return true
	end

	return attribute == true
end

function FarmZoneUtil.resolveZoneBoundsPart(farm: Instance, zoneName: string): BasePart?
	local zonesFolder = FarmZoneUtil.resolveZonesFolder(farm)
	if not zonesFolder then
		return nil
	end

	local zone = zonesFolder:FindFirstChild(zoneName)
	if not zone or not FarmZoneUtil.isConfiguredZone(zone) then
		return nil
	end

	local boundsPart = zone:FindFirstChild("BoundsPart")
	if boundsPart and boundsPart:IsA("BasePart") then
		return boundsPart
	end

	return nil
end

function FarmZoneUtil.resolveUnlockedZoneBounds(farm: Instance): BasePart?
	return FarmZoneUtil.resolveZoneBoundsPart(farm, STARTER_ZONE_NAME)
end

function FarmZoneUtil.getUnlockedZones(farm: Instance): { Instance }
	local zonesFolder = FarmZoneUtil.resolveZonesFolder(farm)
	if not zonesFolder then
		return {}
	end

	local unlockedZones: { Instance } = {}
	for _, child in ipairs(zonesFolder:GetChildren()) do
		if FarmZoneUtil.isConfiguredZone(child) and FarmZoneUtil.isZoneUnlocked(child) then
			table.insert(unlockedZones, child)
		end
	end

	return unlockedZones
end

function FarmZoneUtil.getUnlockedZonesForPlayer(farm: Instance, _playerData): { Instance }
	return FarmZoneUtil.getUnlockedZones(farm)
end

function FarmZoneUtil.findUnlockedZoneAtPoint(farm: Instance, position: Vector3): BasePart?
	local _, boundsPart = FarmZoneUtil.findUnlockedZoneNameAtPoint(farm, position)
	return boundsPart
end

function FarmZoneUtil.findUnlockedZoneNameAtPoint(farm: Instance, position: Vector3): (string?, BasePart?)
	for _, zone in ipairs(FarmZoneUtil.getUnlockedZones(farm)) do
		local boundsPart = zone:FindFirstChild("BoundsPart")
		if boundsPart and boundsPart:IsA("BasePart") then
			if FarmZoneUtil.isPointInBoundsPart(boundsPart, position) then
				return zone.Name, boundsPart
			end
		end
	end

	return nil, nil
end

function FarmZoneUtil.findUnlockedZoneNameAtPointForPlayer(
	farm: Instance,
	position: Vector3,
	playerData
): (string?, BasePart?)
	return FarmZoneUtil.findUnlockedZoneNameAtPoint(farm, position)
end

function FarmZoneUtil.findUnlockedZoneNameAtPointForPlayerExact(
	farm: Instance,
	position: Vector3,
	playerData
): (string?, BasePart?)
	for _, zone in ipairs(FarmZoneUtil.getUnlockedZonesForPlayer(farm, playerData)) do
		local boundsPart = zone:FindFirstChild("BoundsPart")
		if boundsPart and boundsPart:IsA("BasePart") then
			if FarmZoneUtil.isPointInBoundsPartExact(boundsPart, position) then
				return zone.Name, boundsPart
			end
		end
	end

	return nil, nil
end

function FarmZoneUtil.computeZoneFolderPresenceAabb(zone: Instance): ZonePresenceAabb?
	local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
	local foundPart = false

	for _, desc in zone:GetDescendants() do
		if desc:IsA("BasePart") then
			foundPart = true
			local cf = desc.CFrame
			local halfSize = desc.Size * 0.5
			for sx = -1, 1, 2 do
				for sy = -1, 1, 2 do
					for sz = -1, 1, 2 do
						local worldCorner = cf:PointToWorldSpace(
							Vector3.new(halfSize.X * sx, halfSize.Y * sy, halfSize.Z * sz)
						)
						minX = math.min(minX, worldCorner.X)
						maxX = math.max(maxX, worldCorner.X)
						minZ = math.min(minZ, worldCorner.Z)
						maxZ = math.max(maxZ, worldCorner.Z)
					end
				end
			end
		end
	end

	if not foundPart then
		return nil
	end

	return {
		minX = minX,
		maxX = maxX,
		minZ = minZ,
		maxZ = maxZ,
	}
end

function FarmZoneUtil.getZoneFolderPresenceAabb(zone: Instance): ZonePresenceAabb?
	if zonePresenceAabbComputed[zone] then
		return zonePresenceAabbCache[zone]
	end

	zonePresenceAabbComputed[zone] = true
	local aabb = FarmZoneUtil.computeZoneFolderPresenceAabb(zone)
	zonePresenceAabbCache[zone] = aabb
	return aabb
end

function FarmZoneUtil.isPointInZonePresenceAabb(presenceAabb: ZonePresenceAabb, position: Vector3): boolean
	return position.X >= presenceAabb.minX
		and position.X <= presenceAabb.maxX
		and position.Z >= presenceAabb.minZ
		and position.Z <= presenceAabb.maxZ
end

function FarmZoneUtil.isPointInZoneFolderPresence(zone: Instance, position: Vector3): boolean
	local presenceAabb = FarmZoneUtil.getZoneFolderPresenceAabb(zone)
	if not presenceAabb then
		return false
	end

	return FarmZoneUtil.isPointInZonePresenceAabb(presenceAabb, position)
end

function FarmZoneUtil.findUnlockedZoneNameAtPointForPlayerPresence(
	farm: Instance,
	position: Vector3,
	playerData
): (string?, BasePart?)
	for _, zone in ipairs(FarmZoneUtil.getUnlockedZonesForPlayer(farm, playerData)) do
		if FarmZoneUtil.isPointInZoneFolderPresence(zone, position) then
			local boundsPart = zone:FindFirstChild("BoundsPart")
			if boundsPart and boundsPart:IsA("BasePart") then
				return zone.Name, boundsPart
			end
		end
	end

	return nil, nil
end

local function boundsFromPart(boundsPart: BasePart)
	return {
		part = boundsPart,
		cframe = boundsPart.CFrame,
		size = boundsPart.Size,
		fallbackY = boundsPart.Position.Y,
	}
end

function FarmZoneUtil.isPointInBoundsPart(boundsPart: BasePart, position: Vector3): boolean
	return FarmBoundsUtil.IsPointInBounds(boundsFromPart(boundsPart), position)
end

function FarmZoneUtil.isPointInBoundsPartExact(boundsPart: BasePart, position: Vector3): boolean
	return FarmBoundsUtil.IsPointInBoundsExact(boundsFromPart(boundsPart), position)
end

function FarmZoneUtil.clearAllZoneUnlockAttributes(farm: Instance)
	local zonesFolder = FarmZoneUtil.resolveZonesFolder(farm)
	if not zonesFolder then
		return
	end

	for _, child in ipairs(zonesFolder:GetChildren()) do
		if FarmZoneUtil.isConfiguredZone(child) then
			child:SetAttribute(FarmZoneUtil.ZONE_UNLOCKED_ATTRIBUTE, true)
		end
	end
end

function FarmZoneUtil.applyUnlockedZoneAttributes(farm: Instance, _unlockedZoneIds: { [string]: boolean })
	FarmZoneUtil.clearAllZoneUnlockAttributes(farm)
end

return FarmZoneUtil
