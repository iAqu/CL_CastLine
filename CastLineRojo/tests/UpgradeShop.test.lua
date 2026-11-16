local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = assert(loadstring(read("src/ReplicatedStorage/Modules/UpgradeShopConfig.lua")))()
local upgradeService = read("src/ServerScriptService/Services/UpgradeService.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")

local profile = { Data = { Wins = 10000, Upgrades = { Upgrade_MoveSpeed = 3, Upgrade_WinsBoost = 2 } } }
local services = {
	ReplicatedStorage = {
		Packages = { Knit = { CreateService = function(service) return service end, CreateSignal = function() return {} end } },
		Modules = { Constants = {}, UpgradeShopConfig = config },
	},
	ServerScriptService = { Services = { PlayerDataService = {
		GetProfile = function() return profile end,
		AdjustWins = function() error("Retired upgrades must never charge the player") end,
	} } },
}
local service = assert(load(upgradeService, "UpgradeService", "t", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(module) return assert(module) end,
}, { __index = getfenv() })))()
service.Client.Server = service
assert(not config.IsValidUpgradeId("Upgrade_MoveSpeed"), "The retired speed upgrade must be invalid")
local result = service.Client:PurchaseUpgrade({}, "Upgrade_MoveSpeed", 1)
assert(not result.ok and result.message == "Invalid upgrade", "A stale speed purchase must be rejected")
assert(not service:SetUpgradeLevel({}, "Upgrade_MoveSpeed", 4).ok, "The level setter must reject the retired speed upgrade")
assert(profile.Data.Wins == 10000 and profile.Data.Upgrades.Upgrade_MoveSpeed == 3, "Rejecting an upgrade must leave the profile intact")

assert(not io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/UpgradeShopGuiController.lua", "r"),
	"The retired shop must not install a purchase prompt or bind buttons")

local migrationSource = assert(playerDataService:match("(local REMOVED_PROFILE_FIELDS = .-)\nlocal function migratePlotHome"))
local migrate = assert(loadstring(migrationSource .. "\nreturn migrateRemovedLegacyFields"))()
local legacy = {
	Upgrades = { Upgrade_MoveSpeed = 3, Upgrade_WinsBoost = 2 },
	GamePasses = { FastMove = true, SuperLuck = true },
}
migrate(legacy)
migrate(legacy)
assert(legacy.Upgrades.Upgrade_MoveSpeed == nil and legacy.GamePasses.FastMove == nil, "Migration must remove retired speed fields")
assert(legacy.Upgrades.Upgrade_WinsBoost == 2 and legacy.GamePasses.SuperLuck, "Migration must preserve active upgrades and passes")
assert(playerDataService:find("migrateRemovedLegacyFields(profile.Data)", 1, true), "Profile loading must run the migration")

print("UpgradeShop.test.lua passed")
