local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local knitClient = read("src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua")
local playerDataController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlayerDataController.lua")

assert(knitClient:find("LoadingAttributes.CLIENT_CONTROLLERS_READY", 1, true))
assert(knitClient:find("Knit.Start():andThen", 1, true))
assert(knitClient:find("task.wait()", 1, true))
assert(playerDataController:find("LoadingAttributes.PLAYER_DATA_LOADED", 1, true))
assert(playerDataController:find("function PlayerDataController:LoadData", 1, true))

print("LoadingScreenClientReadiness.test.lua passed")
