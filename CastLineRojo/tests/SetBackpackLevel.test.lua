local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local command = read("src/ServerScriptService/Cmdr/Commands/SetBackpackLevelServer.lua")
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")
local capacityService = read("src/ServerScriptService/Services/CarryCapacityService.lua")
local visualService = read("src/ServerScriptService/Services/BackpackVisualService.lua")

assert(command:find('SetUpgradeLevel(player, Constants.UPGRADE_ID.CARRY_WEIGHT, level)', 1, true), "Cmdr must update the carry-weight upgrade")
assert(not command:find('GetService("BackpackVisualService"):RefreshPlayer', 1, true), "Cmdr must rely on the shared capacity refresh path")
assert(upgradeService:find('GetService("CarryCapacityService"):RefreshPlayer(player)', 1, true), "Carry-weight level changes must refresh capacity immediately")
assert(capacityService:find('player:SetAttribute(CarryCapacityUtil.CAPACITY_ATTRIBUTE, snapshot.capacity)', 1, true), "Capacity refresh must update the replicated kg attribute")
assert(capacityService:find('GetService("BackpackVisualService"):RefreshPlayer(player)', 1, true), "Capacity refresh must update the backpack visual")
assert(visualService:find("function BackpackVisualService:RefreshPlayer", 1, true), "The backpack visual service must expose a refresh entry point")

print("SetBackpackLevel.test.lua passed")
