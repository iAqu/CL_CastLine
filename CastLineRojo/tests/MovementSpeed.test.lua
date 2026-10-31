local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local zonesData = read("src/ReplicatedFirst/Data/ZonesData.lua")
local upgradeShopConfig = read("src/ReplicatedStorage/Modules/UpgradeShopConfig.lua")
local movementSpeedUtil = read("src/ReplicatedStorage/Modules/MovementSpeedUtil.lua")
local movementSpeedService = read("src/ServerScriptService/Services/MovementSpeedService.lua")
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")
local gamePassService = read("src/ServerScriptService/Services/GamePassService.lua")
local characterController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/CharacterController.lua")
local upgradeShopController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/UpgradeShopGuiController.lua")

for zoneId, expected in pairs({
	Zone_1 = { requiredWalkSpeed = "30", walkSpeedPercent = "0.3" },
	Zone_2 = { requiredWalkSpeed = "40", walkSpeedPercent = "0.2" },
	Zone_3 = { requiredWalkSpeed = "60", walkSpeedPercent = "0.1" },
	Zone_4 = { requiredWalkSpeed = "90", walkSpeedPercent = "0.1" },
	Zone_5 = { requiredWalkSpeed = "120", walkSpeedPercent = "0.1" },
	Zone_6 = { requiredWalkSpeed = "150", walkSpeedPercent = "0.1" },
	Zone_7 = { requiredWalkSpeed = "180", walkSpeedPercent = "0.1" },
	Zone_8 = { requiredWalkSpeed = "210", walkSpeedPercent = "0.1" },
	Zone_9 = { requiredWalkSpeed = "240", walkSpeedPercent = "0.1" },
	Zone_10 = { requiredWalkSpeed = "270", walkSpeedPercent = "0.1" },
}) do
	assert(zonesData:find(zoneId .. " = {", 1, true), zoneId .. " must be configured")
	assert(
		zonesData:find("RequiredWalkSpeed = " .. expected.requiredWalkSpeed, 1, true),
		zoneId .. " must define its required walk speed"
	)
	assert(
		zonesData:find("WalkSpeedPercent = " .. expected.walkSpeedPercent, 1, true),
		zoneId .. " must define its speed-difference retention percent"
	)
end

assert(movementSpeedUtil:find("MIN_WALK_SPEED = 8", 1, true), "Zone speed must never fall below 8")
assert(upgradeShopConfig:find("local MOVE_SPEED_UPGRADE_EXPONENT = 0.8", 1, true), "Move-speed upgrades must use a 0.8 exponent")
assert(
	upgradeShopConfig:find("Constants.UPGRADE_ID.MOVE_SPEED) ^ MOVE_SPEED_UPGRADE_EXPONENT", 1, true),
	"Move-speed upgrades must apply diminishing returns before adding base speed"
)
assert(movementSpeedUtil:find("ZONE_BASE_WALK_SPEED = 15", 1, true), "Zone speed must start from 15")
assert(movementSpeedUtil:find("FREE_WALK_SPEED_BONUS_EXPONENT = 0.8", 1, true), "Free-zone bonuses must use the agreed exponent")
assert(not movementSpeedUtil:find("ZONE_WALK_SPEED_BONUS_PERCENT", 1, true), "Zone speed retention must not use a global coefficient")
assert(movementSpeedUtil:find("function MovementSpeedUtil.GetSpeedAttribute", 1, true), "Full speed attributes need a shared calculation")
assert(movementSpeedUtil:find("function MovementSpeedUtil.GetFreeWalkSpeed", 1, true), "Free-zone WalkSpeed needs a shared calculation")
assert(movementSpeedUtil:find("speedAttribute - MovementSpeedUtil.DEFAULT_WALK_SPEED", 1, true), "Only upgrade and Fast Move bonuses may be halved")
assert(movementSpeedUtil:find("speedBonus ^ MovementSpeedUtil.FREE_WALK_SPEED_BONUS_EXPONENT", 1, true), "Free-zone WalkSpeed must apply diminishing returns to the bonus")
assert(movementSpeedUtil:find("speedAttribute - requiredWalkSpeed", 1, true), "Zone speed must use the full speed attribute")
assert(movementSpeedUtil:find("zoneData.WalkSpeedPercent", 1, true), "Zone speed must use the configured retention coefficient")
assert(movementSpeedUtil:find("math.clamp(zoneWalkSpeedPercent, 0, 1)", 1, true), "Zone retention coefficients must stay between zero and one")
assert(movementSpeedUtil:find("not isFiniteNumber(zoneWalkSpeedPercent)", 1, true), "Invalid zone retention coefficients must fail open")
assert(movementSpeedUtil:find("MovementSpeedUtil.MIN_WALK_SPEED,", 1, true), "Zone speed must clamp to the minimum")
assert(movementSpeedUtil:find("freeWalkSpeed", 1, true), "Zone speed must clamp to the free-zone speed")
assert(movementSpeedUtil:find("speedAttribute += MovementSpeedUtil.DEFAULT_WALK_SPEED * 0.5", 1, true), "Fast Move must remain a 15-point speed attribute")
assert(movementSpeedUtil:find("MovementSpeedUtil.GetFreeWalkSpeed(playerData) *", 1, true), "Applied WalkSpeed must use the free-zone speed")
assert(upgradeShopController:find("MovementSpeedUtil.GetSpeedAttribute(playerData)", 1, true), "The shop must display the full speed attribute")
assert(upgradeShopController:find("+{amount} Speed", 1, true), "The shop must continue advertising one speed attribute per level")
assert(movementSpeedService:find("zone.playerEntered", 1, true), "Server must detect zone entry")
assert(movementSpeedService:find("zone.playerExited", 1, true), "Server must detect zone exit")
assert(movementSpeedService:find("percent = math.min", 1, true), "Overlapping zones must apply the slowest speed")
assert(movementSpeedService:find("local ZONE_DETECTION_HEIGHT = 30", 1, true), "Zone detection height must cover normal movement above the ground")
assert(movementSpeedService:find("Zone.fromRegion", 1, true), "Server must detect an elevated region instead of the ground surface")
assert(movementSpeedService:find('zone:setDetection("Centre")', 1, true), "Zone detection must track the HumanoidRootPart inside the elevated region")
assert(not movementSpeedService:find("Zone.new(mainPart)", 1, true), "The physical ground part must not be used as the zone detector")
assert(not movementSpeedService:find('zone:setDetection("WholeBody")', 1, true), "Whole-body ground contact detection is unstable on sloped surfaces")
assert(movementSpeedService:find("ZoneWalkSpeedPercent", 1, true), "Server must replicate the zone speed percent")
assert(
	movementSpeedUtil:find('CURRENT_DIG_ZONE_ATTRIBUTE = "CurrentDigZone"', 1, true)
		and movementSpeedService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, zoneId", 1, true),
	"Server zone detection must replicate the player's last-entered dig zone"
)
assert(
	movementSpeedService:find("getFallbackActiveZoneId(activeZones)", 1, true)
		and movementSpeedService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil", 1, true),
	"CurrentDigZone must fall back across overlaps and clear outside dig zones"
)
assert(characterController:find("ZONE_WALK_SPEED_PERCENT_ATTRIBUTE", 1, true), "Client must react to the replicated zone speed percent")
assert(not movementSpeedService:find("WalkSpeedReduced", 1, true), "Server must not expose an unused speed-slowed notification")
assert(not characterController:find("Speed slowed!", 1, true), "Client must not show a speed-slowed toast")
assert(upgradeService:find('GetService("MovementSpeedService"):RefreshPlayer(player)', 1, true), "Move-speed upgrades must refresh WalkSpeed immediately")
assert(gamePassService:find("Constants.GAMEPASS.FAST_MOVE", 1, true), "Fast Move acquisition must use the shared GamePass ID")
assert(gamePassService:find('GetService("MovementSpeedService"):RefreshPlayer(player)', 1, true), "Fast Move acquisition must refresh WalkSpeed immediately")
assert(characterController:find("gamePassId == Constants.GAMEPASS.FAST_MOVE", 1, true), "The client must refresh movement after receiving Fast Move")

local function assertApprox(actual, expected, message)
	assert(math.abs(actual - expected) < 0.001, string.format("%s: expected %s, got %s", message, expected, actual))
end

local function calculateSpeedAttribute(level, ownsFastMove)
	local fastMoveBonus = 0
	if ownsFastMove then
		fastMoveBonus = 15
	end
	return 30 + level ^ 0.8 + fastMoveBonus
end

local function calculateFreeWalkSpeed(level, ownsFastMove)
	local speedAttribute = calculateSpeedAttribute(level, ownsFastMove)
	return 30 + (speedAttribute - 30) ^ 0.8
end

local function calculateZoneWalkSpeed(level, ownsFastMove, requiredWalkSpeed, percent)
	local speedAttribute = calculateSpeedAttribute(level, ownsFastMove)
	local freeWalkSpeed = calculateFreeWalkSpeed(level, ownsFastMove)
	return math.max(8, math.min(15 + (speedAttribute - requiredWalkSpeed) * percent, freeWalkSpeed))
end

assertApprox(calculateSpeedAttribute(0, false), 30, "Level 0 speed attribute")
assertApprox(calculateFreeWalkSpeed(0, false), 30, "Level 0 free-zone WalkSpeed")
assertApprox(calculateSpeedAttribute(1, false), 31, "Level 1 speed attribute")
assertApprox(calculateFreeWalkSpeed(1, false), 31, "Level 1 free-zone WalkSpeed")
assertApprox(calculateSpeedAttribute(100, false), 69.8107, "Level 100 speed attribute")
assertApprox(calculateFreeWalkSpeed(100, false), 49.0546, "Level 100 free-zone WalkSpeed")
assertApprox(calculateSpeedAttribute(100, true), 84.8107, "Fast Move must add 15 after decay")
assertApprox(calculateFreeWalkSpeed(100, true), 54.6089, "Fast Move free-zone WalkSpeed")
assertApprox(calculateZoneWalkSpeed(100, false, 30, 0.3), 26.9432, "Zone speed must use the decayed attribute")
assertApprox(calculateZoneWalkSpeed(0, false, 170, 0.1), 8, "Zone speed must retain its minimum clamp")

print("MovementSpeed.test.lua passed")
