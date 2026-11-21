local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

for _, retired in {
	"ReplicatedFirst/Data/EventsData.lua",
	"ReplicatedStorage/Modules/EventConfig.lua",
	"ReplicatedStorage/Modules/EventStateUtil.lua",
	"ServerScriptService/Services/EventService.lua",
	"ServerScriptService/EventDebug.server.lua",
	"StarterPlayer/StarterPlayerScripts/Controllers/EventController.lua",
} do
	assert(not io.open("src/" .. retired), "Retired sea event script still exists: " .. retired)
end

local server = read("src/ServerScriptService/KnitServer.server.lua")
local client = read("src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua")
local debugPanel = read("src/StarterPlayer/StarterPlayerScripts/TestDebugPanel.client.lua")
assert(not server:find("Services.EventService", 1, true))
assert(not client:find('"EventController"', 1, true))
assert(not debugPanel:find("EventDebugRemote", 1, true))
assert(debugPanel:find("homeButton.Activated", 1, true), "The Studio navigation utility remains available")
