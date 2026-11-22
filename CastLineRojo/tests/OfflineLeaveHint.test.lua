local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/OfflineLeaveHintController.lua")
local knitClient = read("src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua")

assert(
	controller:find('local GuiService = game:GetService("GuiService")', 1, true),
	"Offline leave hint must use GuiService"
)
assert(
	controller:find('local CommonResultClient = require(ReplicatedStorage.Modules.CommonResultClient)', 1, true),
	"Offline leave hint must reuse CommonResultGui"
)
assert(
	controller:find('local OFFLINE_HINT_TEXT = "Fish on your plot earn Cash while you\'re away!"', 1, true),
	"Offline leave hint text is incorrect"
)
assert(
	controller:find("GuiService.MenuOpened:Connect", 1, true),
	"Offline leave hint must trigger when the Roblox system menu opens"
)
assert(
	controller:find("CommonResultClient.OpenResultGui(OFFLINE_HINT_TEXT)", 1, true),
	"Offline leave hint must open the shared result modal"
)
assert(
	knitClient:find("controllersFolder:GetDescendants()", 1, true)
		and knitClient:find('v.Name:match("Controller$")', 1, true),
	"KnitClient must automatically load OfflineLeaveHintController"
)

print("OfflineLeaveHint.test.lua passed")
