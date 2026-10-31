local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local moveCommand = read("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevel.lua")
local moveCommandServer = read("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevelServer.lua")
local backpackCommand = read("src/ServerScriptService/Cmdr/Commands/SetBackpackLevel.lua")
local backpackCommandServer = read("src/ServerScriptService/Cmdr/Commands/SetBackpackLevelServer.lua")
local permissions = read("src/ServerScriptService/Cmdr/Hooks/Permission.lua")
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")

assert(moveCommand:find('Name = "setMoveSpeedLevel"', 1, true), "Move speed level command must exist")
assert(moveCommand:find('"sMSL"', 1, true), "Move speed level command must expose its alias")
assert(moveCommand:find('Type = "player"', 1, true), "Move speed level command must target a player")
assert(moveCommand:find('Type = "integer"', 1, true), "Move speed level command must require an integer level")
assert(moveCommandServer:find("Constants.UPGRADE_ID.MOVE_SPEED", 1, true), "Move speed command must set the move speed upgrade")
assert(moveCommandServer:find('GetService("UpgradeService"):SetUpgradeLevel', 1, true), "Move speed command must use the shared setter")
assert(moveCommandServer:find("MovementSpeedUtil.CalculateWalkSpeed", 1, true), "Move speed command must report the applied WalkSpeed")

assert(backpackCommand:find('Name = "setBackpackLevel"', 1, true), "Backpack level command must exist")
assert(backpackCommand:find('"sBL"', 1, true), "Backpack level command must expose its alias")
assert(backpackCommand:find('Type = "player"', 1, true), "Backpack level command must target a player")
assert(backpackCommand:find('Type = "integer"', 1, true), "Backpack level command must require an integer level")
assert(backpackCommandServer:find("Constants.UPGRADE_ID.CARRY_WEIGHT", 1, true), "Backpack command must set the carry weight upgrade")
assert(backpackCommandServer:find('GetService("UpgradeService"):SetUpgradeLevel', 1, true), "Backpack command must use the shared setter")
assert(backpackCommandServer:find("CarryCapacityUtil.CAPACITY_ATTRIBUTE", 1, true), "Backpack command must report the refreshed capacity")

assert(permissions:find('"setMoveSpeedLevel"', 1, true), "GM permission must include setMoveSpeedLevel")
assert(permissions:find('"setBackpackLevel"', 1, true), "GM permission must include setBackpackLevel")
assert(upgradeService:find("function UpgradeService:SetUpgradeLevel", 1, true), "UpgradeService must expose the shared level setter")
assert(upgradeService:find("level >= 0", 1, true), "The setter must accept level zero and reject negative levels")
assert(upgradeService:find("level % 1 == 0", 1, true), "The setter must reject decimal levels")
assert(upgradeService:find("UpgradeShopConfig.IsValidUpgradeId(upgradeId)", 1, true), "The setter must reject unknown upgrade IDs")
assert(upgradeService:find('"Player data is unavailable"', 1, true), "The setter must reject unavailable profiles")
assert(upgradeService:find("profile.Data.Upgrades[upgradeId] = newLevel", 1, true), "The shared apply path must persist the exact level")
assert(upgradeService:find('GetService("MovementSpeedService"):RefreshPlayer(player)', 1, true), "Move speed changes must refresh immediately")
assert(upgradeService:find('GetService("CarryCapacityService"):RefreshPlayer(player)', 1, true), "Backpack changes must refresh immediately")
assert(upgradeService:find("self.Client.Upgrade:Fire(player, upgradeId, true, message, newLevel)", 1, true), "Changes must sync the final level to the client")

print("CmdrUpgradeLevel.test.lua passed")
