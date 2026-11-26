local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local home = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")
local playerData = read("src/ServerScriptService/Services/PlayerDataService.lua")

assert(not io.open("src/ServerScriptService/Services/CarryCapacityService.lua", "r"), "Retired capacity service must be removed")
assert(not io.open("src/ReplicatedStorage/Modules/CarryCapacityUtil.lua", "r"), "Retired capacity module must be removed")
assert(not io.open("src/ServerScriptService/Services/UpgradeService.lua", "r"), "Old capacity upgrades must have no purchase service")
assert(not home:find("BackpackPanel", 1, true), "Home must not bind the retired capacity panel")
assert(playerData:find("TotalItemWeightTenths", 1, true), "Cumulative catch weight must remain available")

print("CarryCapacity.test.lua passed")
