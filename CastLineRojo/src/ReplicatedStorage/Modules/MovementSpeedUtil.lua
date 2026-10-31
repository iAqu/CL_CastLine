local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Constants = require(script.Parent.Constants)
local EventStateUtil = require(script.Parent.EventStateUtil)
local UpgradeShopConfig = require(script.Parent.UpgradeShopConfig)
local ZonesData = require(ReplicatedFirst.Data.ZonesData)

local MovementSpeedUtil = {}

MovementSpeedUtil.DEFAULT_WALK_SPEED = UpgradeShopConfig.BASE_WALK_SPEED
MovementSpeedUtil.MIN_WALK_SPEED = 8
MovementSpeedUtil.ZONE_BASE_WALK_SPEED = 15
MovementSpeedUtil.FREE_WALK_SPEED_BONUS_EXPONENT = 0.8
MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE = "ZoneWalkSpeedPercent"
MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE = "IsInDigZone"
MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE = "CurrentDigZone"

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

function MovementSpeedUtil.GetSpeedAttribute(playerData): number
	local speedAttribute = UpgradeShopConfig.GetWalkSpeed(playerData)
	if playerData.GamePasses[Constants.GAMEPASS.FAST_MOVE] then
		speedAttribute += MovementSpeedUtil.DEFAULT_WALK_SPEED * 0.5
	end
	return speedAttribute
end

function MovementSpeedUtil.GetFreeWalkSpeed(playerData): number
	local speedAttribute = MovementSpeedUtil.GetSpeedAttribute(playerData)
	local speedBonus = speedAttribute - MovementSpeedUtil.DEFAULT_WALK_SPEED
	return MovementSpeedUtil.DEFAULT_WALK_SPEED
		+ speedBonus ^ MovementSpeedUtil.FREE_WALK_SPEED_BONUS_EXPONENT
end

function MovementSpeedUtil.GetZoneWalkSpeedPercent(playerData, zoneId: string?): number
	if typeof(zoneId) ~= "string" then
		return 1
	end

	local zoneData = ZonesData[zoneId]
	if typeof(zoneData) ~= "table" then
		return 1
	end

	local requiredWalkSpeed = zoneData.RequiredWalkSpeed
	local zoneWalkSpeedPercent = zoneData.WalkSpeedPercent
	if not isFiniteNumber(requiredWalkSpeed) or not isFiniteNumber(zoneWalkSpeedPercent) then
		return 1
	end
	zoneWalkSpeedPercent = math.clamp(zoneWalkSpeedPercent, 0, 1)

	local speedAttribute = MovementSpeedUtil.GetSpeedAttribute(playerData)
	local freeWalkSpeed = MovementSpeedUtil.GetFreeWalkSpeed(playerData)
	if freeWalkSpeed <= 0 then
		return 1
	end

	local zoneWalkSpeed = math.clamp(
		MovementSpeedUtil.ZONE_BASE_WALK_SPEED
			+ (speedAttribute - requiredWalkSpeed) * zoneWalkSpeedPercent,
		MovementSpeedUtil.MIN_WALK_SPEED,
		freeWalkSpeed
	)

	return normalizeZoneWalkSpeedPercent(zoneWalkSpeed / freeWalkSpeed)
end

function MovementSpeedUtil.CalculateWalkSpeed(playerData, zoneWalkSpeedPercent: unknown): number
	local eventMultiplier = EventStateUtil.GetMoveSpeedMultiplier(EventStateUtil.GetStateFolder())
	return MovementSpeedUtil.GetFreeWalkSpeed(playerData) * normalizeZoneWalkSpeedPercent(zoneWalkSpeedPercent)
		* eventMultiplier
end

return MovementSpeedUtil
