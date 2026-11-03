local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

-- Removing the feature must also remove its bootstrap dependencies.
for _, path in ipairs({
	"src/ReplicatedStorage/Modules/TideConfig.lua",
	"src/ServerScriptService/Services/TideService.lua",
	"src/ServerScriptService/TideDebug.server.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/TideController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/PositionBarController.lua",
	"src/StarterPlayer/StarterPlayerScripts/TideDebugPanel.client.lua",
}) do
	assert(io.open(path, "r") == nil, path .. " must be removed")
end

for _, path in ipairs({
	"src/ServerScriptService/KnitServer.server.lua",
	"src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/MusicController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/FootprintController.lua",
	"src/ServerScriptService/Services/DrownDropService.lua",
	"src/StarterPlayer/StarterPlayerScripts/TestDebugPanel.client.lua",
}) do
	local source = read(path)
	assert(not source:find("Tide", 1, true), path .. " must not depend on the removed system")
	assert(not source:find("WaterSurfacePosition", 1, true), path .. " must not depend on the removed high-water marker")
	assert(not source:find("PositionBarController", 1, true), path .. " must not bootstrap the removed position bar")
end

local debugPanel = read("src/StarterPlayer/StarterPlayerScripts/TestDebugPanel.client.lua")
assert(debugPanel:find("CharacterUtil.TeleportTo(character, spawnLocation.CFrame * HOME_SPAWN_OFFSET)", 1, true), "The home button must keep using the character teleport utility")
assert(debugPanel:find("setPanelCollapsed(frame.Visible)", 1, true), "The remaining test panel must still collapse")
local footprintController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FootprintController.lua")
assert(footprintController:find('zone.Name:match("^Zone_%d+$")', 1, true), "Footprints must discover authored zones without a tide configuration")

local movementUtil = read("src/ReplicatedStorage/Modules/MovementSpeedUtil.lua")
local movementService = read("src/ServerScriptService/Services/MovementSpeedService.lua")
assert(
	movementUtil:find('IS_IN_DIG_ZONE_ATTRIBUTE = "IsInDigZone"', 1, true),
	"The shared dig-zone attribute must be defined"
)
assert(
	movementUtil:find('CURRENT_DIG_ZONE_ATTRIBUTE = "CurrentDigZone"', 1, true),
	"The shared current dig-zone attribute must be defined"
)
assert(
	movementService:find("activeZones ~= nil and next(activeZones) ~= nil", 1, true),
	"The player must remain inside while any overlapping dig zone is active"
)
assert(
	movementService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, zoneId", 1, true)
		and movementService:find("getFallbackActiveZoneId(activeZones)", 1, true),
	"The server must publish the last-entered zone and fall back to an overlapping zone on exit"
)
assert(
	movementService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil", 1, true),
	"The current dig zone must clear outside dig zones and across respawns"
)

print("StaticWaterLifecycle.test.lua passed")
