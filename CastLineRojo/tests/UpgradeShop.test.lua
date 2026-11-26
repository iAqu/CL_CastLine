local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")

assert(not io.open("src/ServerScriptService/Services/UpgradeService.lua", "r"),
    "The retired shop must not expose purchase or grant endpoints")
assert(not io.open("src/ReplicatedStorage/Modules/UpgradeShopConfig.lua", "r"),
    "The retired shop catalog must not load")

assert(not io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/UpgradeShopGuiController.lua", "r"),
	"The retired shop must not install a purchase prompt or bind buttons")

local migrationSource = assert(playerDataService:match("(local REMOVED_PROFILE_FIELDS = .-)\nlocal function migratePlotHome"))
local migrate = assert(loadstring(migrationSource .. "\nreturn migrateRemovedLegacyFields"))()
local legacy = {
	Upgrades = { Upgrade_MoveSpeed = 3, Upgrade_WinsBoost = 2 },
	GamePasses = { FastMove = true, SuperLuck = true },
	DailyRewards = { { IsClaimed = true } },
	OnlineRewardsClaimLog = { true },
	SpinningWheelBonusSpins = 2,
	SeasonXp = 10,
	GiftBoxClaimLog = { GiftBox_1 = true },
}
migrate(legacy)
migrate(legacy)
assert(legacy.Upgrades.Upgrade_MoveSpeed == nil and legacy.GamePasses.FastMove == nil, "Migration must remove retired speed fields")
assert(legacy.Upgrades.Upgrade_WinsBoost == 2 and legacy.GamePasses.SuperLuck, "Migration must preserve active upgrades and passes")
assert(legacy.DailyRewards[1].IsClaimed and legacy.OnlineRewardsClaimLog[1])
assert(legacy.SpinningWheelBonusSpins == 2 and legacy.SeasonXp == 10 and legacy.GiftBoxClaimLog.GiftBox_1,
	"Retired business history must survive profile migration")
assert(playerDataService:find("migrateRemovedLegacyFields(profile.Data)", 1, true), "Profile loading must run the migration")

print("UpgradeShop.test.lua passed")
