local ReplicatedFirst = game:GetService("ReplicatedFirst")

local EventStateUtil = require(script.Parent.EventStateUtil)
local ZonesData = require(ReplicatedFirst.Data.ZonesData)

local MovementSpeedUtil = {}

MovementSpeedUtil.DEFAULT_WALK_SPEED = 16
MovementSpeedUtil.MIN_WALK_SPEED = 8
MovementSpeedUtil.ZONE_BASE_WALK_SPEED = 15
MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE = "ZoneWalkSpeedPercent"
MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE = "IsInDigZone"
MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE = "CurrentDigZone"

-- Studio owns ZonesData, and older places omit the walk-speed fields.
local DEFAULT_ZONE_SPEED_RULES = {
	Zone_1 = { RequiredWalkSpeed = 20, WalkSpeedPercent = 0.5 },
	Zone_2 = { RequiredWalkSpeed = 35, WalkSpeedPercent = 0.4 },
	Zone_3 = { RequiredWalkSpeed = 60, WalkSpeedPercent = 0.3 },
	Zone_4 = { RequiredWalkSpeed = 90, WalkSpeedPercent = 0.2 },
	Zone_5 = { RequiredWalkSpeed = 120, WalkSpeedPercent = 0.1 },
	Zone_6 = { RequiredWalkSpeed = 150, WalkSpeedPercent = 0.1 },
	Zone_7 = { RequiredWalkSpeed = 180, WalkSpeedPercent = 0.1 },
	Zone_8 = { RequiredWalkSpeed = 210, WalkSpeedPercent = 0.1 },
	Zone_9 = { RequiredWalkSpeed = 240, WalkSpeedPercent = 0.1 },
	Zone_10 = { RequiredWalkSpeed = 270, WalkSpeedPercent = 0.1 },
}

local function isFiniteNumber(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
end

local function normalizeZoneWalkSpeedPercent(percent: unknown): number
	if not isFiniteNumber(percent) then
		return 1
	end

	return math.clamp(percent, 0, 1)
end

function MovementSpeedUtil.HasZoneConfig(zoneId: string): boolean
	return typeof(ZonesData[zoneId]) == "table"
end

function MovementSpeedUtil.GetZoneWalkSpeedPercent(zoneId: string?): number
	if typeof(zoneId) ~= "string" then
		return 1
	end

	local zoneData = ZonesData[zoneId]
	if typeof(zoneData) ~= "table" then
		return 1
	end
	if zoneData.RequiredWalkSpeed == nil and zoneData.WalkSpeedPercent == nil then
		zoneData = DEFAULT_ZONE_SPEED_RULES[zoneId]
		if not zoneData then
			return 1
		end
	end

	local requiredWalkSpeed = zoneData.RequiredWalkSpeed
	local zoneWalkSpeedPercent = zoneData.WalkSpeedPercent
	if not isFiniteNumber(requiredWalkSpeed) or not isFiniteNumber(zoneWalkSpeedPercent) then
		return 1
	end
	zoneWalkSpeedPercent = math.clamp(zoneWalkSpeedPercent, 0, 1)

	local baseWalkSpeed = MovementSpeedUtil.DEFAULT_WALK_SPEED
	local zoneWalkSpeed = math.clamp(
		MovementSpeedUtil.ZONE_BASE_WALK_SPEED
			+ (baseWalkSpeed - requiredWalkSpeed) * zoneWalkSpeedPercent,
		MovementSpeedUtil.MIN_WALK_SPEED,
		baseWalkSpeed
	)

	return zoneWalkSpeed / baseWalkSpeed
end

function MovementSpeedUtil.CalculateWalkSpeed(zoneWalkSpeedPercent: unknown): number
	local eventMultiplier = EventStateUtil.GetMoveSpeedMultiplier(EventStateUtil.GetStateFolder())
	return MovementSpeedUtil.DEFAULT_WALK_SPEED * normalizeZoneWalkSpeedPercent(zoneWalkSpeedPercent)
		* eventMultiplier
end

return MovementSpeedUtil
