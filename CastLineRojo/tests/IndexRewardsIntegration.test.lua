local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/IndexGuiController.lua")
local home = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")
local animation = read("src/ReplicatedStorage/Modules/GuiAnimation.lua")
local index = read("src/ServerScriptService/Services/IndexService.lua")
local grant = read("src/ServerScriptService/Services/ItemGrantUtil.lua")
local luck = read("src/ServerScriptService/Services/PlayerLuckService.lua")
for _, source in ipairs({ controller, home }) do
	assert(source:find('WaitForChild("IndexGui_New")', 1, true), "Index consumers must bind the new GUI")
end
assert(animation:find('"IndexGui_New",', 1, true) and not animation:find('"IndexGui",', 1, true),
	"Popup exclusivity and navigation must register the new GUI")
assert(not controller:find("IndexItemViewport", 1, true), "Index must use table icons instead of models")
for _, source in ipairs({ index, grant, luck }) do
	assert(not source:find("GetDiscoveryLuck", 1, true), "Index luck must be absent from all consumers")
end
assert(not index:find("IndexRewardsData", 1, true), "Retired milestone tables must no longer affect Index")
print("IndexRewardsIntegration.test.lua passed")
