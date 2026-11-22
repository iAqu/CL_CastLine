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
	"src/StarterPlayer/StarterPlayerScripts/Controllers/FootprintController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/PositionBarController.lua",
	"src/StarterPlayer/StarterPlayerScripts/TideDebugPanel.client.lua",
}) do
	assert(io.open(path, "r") == nil, path .. " must be removed")
end

for _, path in ipairs({
	"src/ServerScriptService/KnitServer.server.lua",
	"src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/MusicController.lua",
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

print("StaticWaterLifecycle.test.lua passed")
