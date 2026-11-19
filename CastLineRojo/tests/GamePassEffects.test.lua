local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local constants = read("src/ReplicatedStorage/Modules/Constants.lua")
local effects = read("src/ReplicatedStorage/Modules/GamePassEffectUtil.lua")
local sell = read("src/ServerScriptService/Services/SellService.lua")
local grants = read("src/ServerScriptService/Services/ItemGrantUtil.lua")
local purchaseData = read("src/ReplicatedFirst/Data/PurchaseData.lua")
local purchaseHelper = read("src/ReplicatedFirst/DataHelpers/PurchaseDataHelper.lua")
local store = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/StoreGuiController.lua")

assert(not constants:find("DOUBLE_CARRY", 1, true), "Removed carry pass must not have a constant")
assert(not purchaseData:find("DoubleCarry", 1, true), "Removed carry pass must not be configured")
assert(not purchaseHelper:find("DoubleCarry", 1, true), "Removed carry pass must not retain compatibility logic")
assert(not read("src/ServerScriptService/Services/PlayerDataService.lua"):find("DoubleCarry", 1, true),
	"Removed carry pass must not retain a profile migration")

assert(effects:find("function GamePassEffectUtil.GetSaleMultiplier", 1, true), "Sale bonuses need a shared effect")
assert(effects:find("bonus += 0.2", 1, true), "VIP must add 20% sale cash")
assert(effects:find("bonus += 1", 1, true), "DoubleWins must add 100% sale cash")
assert(effects:find("function GamePassEffectUtil.GetItemLuckMultiplier", 1, true), "Item-roll Luck bonuses need a shared effect")
assert(effects:find("bonus += 0.5", 1, true), "SuperLuck must add 50% luck")
assert(effects:find("bonus += 2", 1, true), "MegaLuck must add 200% luck")

assert(sell:find("GamePassEffectUtil.GetSaleMultiplier(profile.Data)", 1, true), "Sale rewards and quotes must use the shared sale multiplier")

local purchaseConfigs = assert(loadstring(purchaseData))()
local function loadHelper(configs)
	return assert(load(purchaseHelper, "PurchaseDataHelper", "t", setmetatable({
		game = { GetService = function()
			return { Data = { PurchaseData = configs } }
		end },
		require = function(config)
			return config
		end,
	}, { __index = getfenv() })))()
end
local helper = loadHelper(purchaseConfigs)
local gamePasses = helper.GetGamePassesData()
assert(gamePasses.DoubleCarry == nil and gamePasses.FastMove == nil,
	"Active offers must exclude removed or retired passes")
for purchaseId, config in pairs(purchaseConfigs) do
	local expected = config.Type == "GamePass" and not helper.IsRetired(purchaseId)
	assert((gamePasses[purchaseId] ~= nil) == expected, "Offers must follow the current config: " .. purchaseId)
end

-- Test the remaining retirement policy independently of the live product catalog.
local testConfigs = table.clone(purchaseConfigs)
local fastMoveProductId, fastMoveGiftId = -101, -102
testConfigs.FastMove = { Type = "GamePass", ProductId = fastMoveProductId, GiftProductId = fastMoveGiftId }
helper = loadHelper(testConfigs)
assert(helper.GetGamePassesData().FastMove == nil, "Configured retired offers must stay hidden")
assert(helper.GetPurchaseId(fastMoveProductId) == "FastMove" and helper.GetPurchaseId(fastMoveGiftId) == "FastMove",
	"Configured retired products must resolve before purchase rejection")
assert(store:find("PurchaseDataHelper.IsRetired(card.Name)", 1, true), "Existing retired cards must be hidden")
local purchaseBoard = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PurchaseBoardController.lua")
assert(purchaseBoard:find("PurchaseDataHelper.IsRetired(purchaseId)", 1, true), "Purchase boards must hide retired products")
assert(store:find("PurchaseDataHelper.GetGamePassesData", 1, true), "GamePass cards must be sourced from PurchaseData")
assert(store:find("PurchaseDataHelper.GetWinsData", 1, true), "Wins cards must be sourced from PurchaseData")
assert(store:find("GeneratedStoreWinsCard", 1, true), "Wins cards must be regenerated without duplicates")
assert(store:find('"StarterPackFrame", "PotionFrame"', 1, true), "Non-store sections must remain hidden")
assert(not store:find("LimitedTabButton", 1, true), "Hidden Limited UI must not be bound")
assert(store:find("code redemption failed", 1, true), "Code redemption failures must be handled")

local constantsModule = assert(load(constants, "Constants", "t", setmetatable({
	game = { GetService = function()
		return { WaitForChild = function() return { Value = "test", Attack = {}, Gui = {} } end }
	end },
	script = { Parent = { RarityPresentation = { GetColor = function(name) return name end } } },
	Color3 = { fromRGB = function() return {} end },
	require = function(module) return assert(module) end,
}, { __index = getfenv() })))()
local profile = { Data = { GamePasses = {} } }
local denied = 0
local previouslyGranted = false
local services = {
	ReplicatedFirst = {
		Data = { AreasData = {} },
		DataHelpers = {
			PurchaseDataHelper = helper,
			UpgradesDataHelper = { GetAllData = function() return { Upgrade_MoveSpeed = {}, Upgrade_WinsBoost = {} } end },
			GiftBoxesDataHelper = { GetAllData = function() return {} end },
		},
	},
	ReplicatedStorage = {
		Packages = {
			Knit = {
				GetService = function(name) assert(name == "PaidEggService"); return { IsProduct = function() return false end } end,
				CreateService = function(service) return service end,
				CreateSignal = function() return { Fire = function() denied += 1 end } end,
			},
			Signal = { new = function() return {} end },
		},
		Modules = {
			Constants = constantsModule,
			FishingConfig = { DefaultRodId = "Default" },
			PaidEggConfig = { Purchases = {} },
			GameAnalyticsHelper = {}, LogHelper = {}, PotionFeatureHelper = {},
		},
	},
	ServerScriptService = { Services = {
		PlayerDataService = { GetAllData = function() return profile.Data end, GetProfile = function() return profile end },
		HGAnalyticsService = {},
	} },
	DataStoreService = { GetDataStore = function()
		return {
			GetAsync = function() return previouslyGranted end,
			UpdateAsync = function() error("Retired receipts must never write order records") end,
		}
	end },
}
local decisions = { PurchaseGranted = "PurchaseGranted", NotProcessedYet = "NotProcessedYet" }
local function loadModule(path)
	return assert(load(read(path), path, "t", setmetatable({
		game = { GetService = function(_, name) return services[name] or {} end },
		require = function(module) return assert(module) end,
		script = {Parent={FishingBaitPurchases={GetRod=function() return nil end}}},
		Enum = { ProductPurchaseDecision = decisions },
	}, { __index = getfenv() })))()
end

local template = loadModule("src/ReplicatedStorage/PlayerData/Template.lua")
assert(template.GamePasses.DoubleCarry == nil, "New profiles must omit the removed carry entitlement")
assert(template.Upgrades.Upgrade_MoveSpeed == nil and template.GamePasses.FastMove == nil, "New profiles must omit retired speed fields")
assert(template.Upgrades.Upgrade_WinsBoost == 0, "Active upgrade defaults must remain")
for purchaseId in pairs(gamePasses) do
	assert(template.GamePasses[purchaseId] == false, "Configured passes must default to unowned: " .. purchaseId)
end

local purchaseService = loadModule("src/ServerScriptService/Services/PurchaseService.lua")
local gamePassService = loadModule("src/ServerScriptService/Services/GamePassService.lua")
local buyer = { UserId = 42 }
purchaseService:PromptPurchase(buyer, "FastMove")
purchaseService._PlayerGifted[buyer.UserId] = 43
purchaseService:PromptPurchase(buyer, "FastMove")
assert(denied == 2, "Fast Move must reject both purchase and gift prompts")
assert(not purchaseService:HandlePurchase(buyer, fastMoveProductId), "Fast Move purchases must not grant")
assert(not purchaseService:HandlePurchase(buyer, fastMoveGiftId), "Fast Move gifts must not grant")
gamePassService:GiveGamePass(buyer, "FastMove")
assert(profile.Data.GamePasses.FastMove == nil and denied == 2, "Direct grants must not recreate retired entitlement")

local receipt = { PlayerId = buyer.UserId, PurchaseId = "old-gift-order", ProductId = fastMoveGiftId }
assert(purchaseService:processReceipt(receipt) == decisions.NotProcessedYet, "An ungranted retired receipt must not be acknowledged")
previouslyGranted = true
assert(purchaseService:processReceipt(receipt) == decisions.PurchaseGranted, "Previously granted receipts must remain acknowledged")

local signalsBefore = denied
for _, purchaseId in ipairs({ "DoubleCarry", "MissingPass", "WinsTier1" }) do
	gamePassService:GiveGamePass(buyer, purchaseId)
	assert(profile.Data.GamePasses[purchaseId] == nil, "Only configured GamePasses may grant: " .. purchaseId)
end
assert(denied == signalsBefore, "Rejected grants must not emit an entitlement event")
gamePassService:GiveGamePass(buyer, "DoubleTrain")
assert(profile.Data.GamePasses.DoubleTrain == true and denied == signalsBefore + 1,
	"Configured training passes must still grant and emit an entitlement event")

print("GamePassEffects.test.lua passed")
