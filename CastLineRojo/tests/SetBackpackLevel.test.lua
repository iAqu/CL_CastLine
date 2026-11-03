local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local command = read("src/ServerScriptService/Cmdr/Commands/SetBackpackLevelServer.lua")
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")
local capacityService = read("src/ServerScriptService/Services/CarryCapacityService.lua")

assert(command:find('SetUpgradeLevel(player, Constants.UPGRADE_ID.CARRY_WEIGHT, level)', 1, true), "Cmdr must update the carry-weight upgrade")
assert(upgradeService:find('GetService("CarryCapacityService"):RefreshPlayer(player)', 1, true), "Carry-weight level changes must refresh capacity immediately")
assert(capacityService:find('player:SetAttribute(CarryCapacityUtil.CAPACITY_ATTRIBUTE, snapshot.capacity)', 1, true), "Capacity refresh must update the replicated kg attribute")
assert(capacityService:find('player:SetAttribute(CarryCapacityUtil.WEIGHT_ATTRIBUTE, snapshot.weight)', 1, true), "Capacity refresh must preserve the carried-weight attribute")
assert(capacityService:find('player:SetAttribute(CarryCapacityUtil.VALUE_ATTRIBUTE, snapshot.value)', 1, true), "Capacity refresh must preserve the carried-value attribute")
assert(capacityService:find('self.Client.CapacityChanged:Fire(player, snapshot)', 1, true), "Capacity refresh must still notify the HUD")

print("SetBackpackLevel.test.lua passed")
