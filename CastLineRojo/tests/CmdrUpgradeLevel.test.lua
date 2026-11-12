local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local permissions = read("src/ServerScriptService/Cmdr/Hooks/Permission.lua")
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")

assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevel.lua", "r"), "Do not register the retired speed command")
assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevelServer.lua", "r"), "Remove the retired speed command handler")
assert(not permissions:find('"setMoveSpeedLevel"', 1, true), "Remove the retired command permission")
assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetBackpackLevel.lua", "r"), "Do not register the retired backpack command")
assert(upgradeService:find("function UpgradeService:SetUpgradeLevel", 1, true), "UpgradeService must expose the shared level setter")
assert(upgradeService:find("level >= 0", 1, true), "The setter must accept level zero and reject negative levels")
assert(upgradeService:find("level % 1 == 0", 1, true), "The setter must reject decimal levels")
assert(upgradeService:find("UpgradeShopConfig.IsValidUpgradeId(upgradeId)", 1, true), "The setter must reject unknown upgrade IDs")
assert(upgradeService:find('"Player data is unavailable"', 1, true), "The setter must reject unavailable profiles")
assert(upgradeService:find("profile.Data.Upgrades[upgradeId] = newLevel", 1, true), "The shared apply path must persist the exact level")
assert(upgradeService:find("self.Client.Upgrade:Fire(player, upgradeId, true, message, newLevel)", 1, true), "Changes must sync the final level to the client")

print("CmdrUpgradeLevel.test.lua passed")
