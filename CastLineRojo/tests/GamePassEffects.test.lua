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

for _, gamePassId in ipairs({ "DoubleCarry", "FastMove", "SuperLuck", "MegaLuck" }) do
	assert(constants:find(gamePassId, 1, true), gamePassId .. " must have a Constants.GAMEPASS entry")
	assert(purchaseData:find(gamePassId .. " = {", 1, true), gamePassId .. " must be configured in PurchaseData")
end

assert(effects:find("function GamePassEffectUtil.GetSaleMultiplier", 1, true), "Sale bonuses need a shared effect")
assert(effects:find("bonus += 0.2", 1, true), "VIP must add 20% sale cash")
assert(effects:find("bonus += 1", 1, true), "DoubleWins must add 100% sale cash")
assert(effects:find("function GamePassEffectUtil.GetItemLuckMultiplier", 1, true), "Item-roll Luck bonuses need a shared effect")
assert(effects:find("bonus += 0.5", 1, true), "SuperLuck must add 50% luck")
assert(effects:find("bonus += 2", 1, true), "MegaLuck must add 200% luck")

assert(sell:find("GamePassEffectUtil.GetSaleMultiplier(profile.Data)", 1, true), "Sale rewards and quotes must use the shared sale multiplier")
assert(grants:find("GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)", 1, true), "Condition rolls must apply shared GamePass Luck")

local purchaseConfigs = assert(loadstring(purchaseData))()
local helper = assert(load(purchaseHelper, "PurchaseDataHelper", "t", setmetatable({
	game = { GetService = function()
		return { Data = { PurchaseData = purchaseConfigs } }
	end },
	require = function(config)
		return config
	end,
}, { __index = getfenv() })))()
local gamePasses = helper.GetGamePassesData()
assert(gamePasses.DoubleCarry == nil and gamePasses.FastMove == nil and gamePasses.SuperLuck,
	"Active offers must exclude retired passes")
assert(helper.IsRetired(helper.GetPurchaseId(1969188551)) and helper.IsRetired(helper.GetPurchaseId(3711210335)),
	"Both retired product IDs must still resolve for purchase rejection")
local fastMoveProductId = purchaseConfigs.FastMove.ProductId
local fastMoveGiftId = purchaseConfigs.FastMove.GiftProductId
assert(helper.GetPurchaseId(fastMoveProductId) == "FastMove" and helper.GetPurchaseId(fastMoveGiftId) == "FastMove",
	"Retiring Fast Move must retain its pass and gift ID mapping")
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
	script = { Parent = { RarityConfig = { List = {} } } },
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
				CreateService = function(service) return service end,
				CreateSignal = function() return { Fire = function() denied += 1 end } end,
			},
			Signal = { new = function() return {} end },
		},
		Modules = {
			Constants = constantsModule,
			FishingConfig = { DefaultRodId = "Default" },
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
		Enum = { ProductPurchaseDecision = decisions },
	}, { __index = getfenv() })))()
end

local template = loadModule("src/ReplicatedStorage/PlayerData/Template.lua")
assert(template.Upgrades.Upgrade_MoveSpeed == nil and template.GamePasses.FastMove == nil, "New profiles must omit retired speed fields")
assert(template.Upgrades.Upgrade_WinsBoost == 0 and template.GamePasses.SuperLuck == false, "Active defaults must remain")

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

print("GamePassEffects.test.lua passed")
