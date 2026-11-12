local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local zonesData = assert(loadstring(read("src/ReplicatedFirst/Data/ZonesData.lua")))()
local movementSpeedSource = read("src/ReplicatedStorage/Modules/MovementSpeedUtil.lua")
local movementSpeedService = read("src/ServerScriptService/Services/MovementSpeedService.lua")
local characterController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/CharacterController.lua")

local eventMultiplier = 1
local speed = assert(load(movementSpeedSource, "MovementSpeedUtil", "t", setmetatable({
	game = { GetService = function()
		return { Data = { ZonesData = zonesData } }
	end },
	script = { Parent = { EventStateUtil = {
		GetStateFolder = function() return nil end,
		GetMoveSpeedMultiplier = function() return eventMultiplier end,
	} } },
	require = function(module) return assert(module) end,
}, { __index = getfenv() })))()

local zoneOne = speed.GetZoneWalkSpeedPercent("Zone_1")
assert(speed.CalculateWalkSpeed(nil) == 16, "Free walking must use Roblox's default speed")
assert(speed.CalculateWalkSpeed(zoneOne) == 13, "Zone_1 must reduce the base speed using its configuration")
assert(speed.CalculateWalkSpeed(speed.GetZoneWalkSpeedPercent("Zone_10")) == 8, "Zone slowdown must respect the minimum")
assert(speed.CalculateWalkSpeed(speed.GetZoneWalkSpeedPercent("Unknown")) == 16, "Unknown zones must use the base speed")
for zoneId, zoneData in zonesData do
	local configuredPercent = speed.GetZoneWalkSpeedPercent(zoneId)
	zonesData[zoneId] = {}
	assert(speed.GetZoneWalkSpeedPercent(zoneId) == configuredPercent, "Studio data without speed fields must use the zone defaults")
	zonesData[zoneId] = zoneData
end
eventMultiplier = 2
assert(speed.CalculateWalkSpeed(1) == 32, "The move speed event must multiply the base speed")
assert(speed.CalculateWalkSpeed(zoneOne) == 26, "The move speed event must stack with zone slowdown")

assert(movementSpeedService:find("zone.playerEntered", 1, true), "Server must detect zone entry")
assert(movementSpeedService:find("zone.playerExited", 1, true), "Server must detect zone exit")
assert(movementSpeedService:find("percent = math.min", 1, true), "Overlapping zones must apply the slowest speed")
assert(movementSpeedService:find("local ZONE_DETECTION_HEIGHT = 30", 1, true), "Zone detection must cover movement above the ground")
assert(movementSpeedService:find("Zone.fromRegion", 1, true), "Server must detect an elevated region")
assert(movementSpeedService:find('zone:setDetection("Centre")', 1, true), "Zone detection must track the HumanoidRootPart")
assert(
	movementSpeedService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, zoneId", 1, true)
		and movementSpeedService:find("getFallbackActiveZoneId(activeZones)", 1, true)
		and movementSpeedService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil", 1, true),
	"CurrentDigZone must track entry, overlap, and exit"
)
assert(movementSpeedService:find("CalculateWalkSpeed(percent)", 1, true), "Server must apply the shared speed")
assert(characterController:find("CalculateWalkSpeed(zoneWalkSpeedPercent)", 1, true), "Client must apply the shared speed")
assert(not characterController:find("Constants.GAMEPASS.FAST_MOVE", 1, true), "Fast Move must not trigger a speed update")

print("MovementSpeed.test.lua passed")
