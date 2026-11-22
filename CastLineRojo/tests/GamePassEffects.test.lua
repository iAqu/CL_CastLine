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
local cashPack = assert(loadstring(read("src/ReplicatedStorage/Modules/CashPack.lua")))()

assert(not constants:find("DOUBLE_CARRY", 1, true), "Removed carry pass must not have a constant")
assert(not purchaseData:find("DoubleCarry", 1, true), "Removed carry pass must not be configured")
assert(not purchaseHelper:find("DoubleCarry", 1, true), "Removed carry pass must not retain compatibility logic")
assert(not read("src/ServerScriptService/Services/PlayerDataService.lua"):find("DoubleCarry", 1, true),
	"Removed carry pass must not retain a profile migration")

assert(effects:find("function GamePassEffectUtil.GetSaleMultiplier", 1, true), "Sale bonuses need a shared effect")
assert(effects:find("bonus += 0.2", 1, true), "VIP must add 20% sale cash")
assert(effects:find("function GamePassEffectUtil.GetItemLuckMultiplier", 1, true), "Item-roll Luck bonuses need a shared effect")
assert(effects:find("bonus += 0.5", 1, true), "SuperLuck must add 50% luck")
assert(effects:find("bonus += 2", 1, true), "MegaLuck must add 200% luck")

assert(sell:find("GamePassEffectUtil.GetSaleMultiplier(profile.Data)", 1, true), "Sale rewards and quotes must use the shared sale multiplier")

local purchaseConfigs = assert(loadstring(purchaseData))()
assert(purchaseConfigs.DoubleWins.Description == "Earn double cash from fish in your slots.")
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
local profile = { Data = { GamePasses = {}, ProductPurchases = {Receipts = {}, Review = {}} } }
function profile:IsActive() return true end
local denied = 0
local previouslyGranted = false
local buyer = { UserId = 42 }
local recipient = { UserId = 43, DisplayName = "Friend" }
local allowed, selfPrompts, giftPrompts = true, 0, 0
local purchaseDataByPlayer = {
	[buyer] = profile.Data,
	[recipient] = { GamePasses = {}, BaseRate = 1000 },
}
local services = {
	Players = {GetPlayerByUserId = function(_, id) return if id == 43 then recipient else buyer end},
	MarketplaceService = { PromptGamePassPurchase = function(_, player, sku)
		assert(player == buyer and sku == purchaseConfigs.MegaLuck.ProductId)
		selfPrompts += 1
	end },
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
				GetService = function(name)
					if name == "FishingService" then
						return { GetUltraLuckOdds = function() return { ok = true, grades = {} } end }
					end
					assert(name == "PaidEggService")
					return { IsProduct = function() return false end }
				end,
				CreateService = function(service) return service end,
				CreateSignal = function() return { Fire = function() denied += 1 end } end,
			},
			Signal = { new = function() return {} end },
		},
		Modules = {
			CashPack = cashPack, PlotFishIncome = { GetBaseRate = function(data) return data.BaseRate or 0 end },
			Constants = constantsModule,
			FishingConfig = { DefaultRodId = "Default" },
			PaidEggConfig = { Purchases = {} },
			GameAnalyticsHelper = {}, LogHelper = {},
			PotionFeatureHelper = { IsAcquisitionEnabled = function() return true end },
		},
	},
	ServerScriptService = { Services = {
		PlayerDataService = {
			GetAllData = function(_, player) return purchaseDataByPlayer[player] end,
			GetProfile = function() return profile end,
			IsUsingMockProfiles = function() return false end,
		},
        PurchasePersistence = {},
		PurchaseCheckout = {},
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
local function loadModule(path, products)
	return assert(load(read(path), path, "t", setmetatable({
		game = { GetService = function(_, name) return services[name] or {} end },
		require = function(module) return assert(module) end,
		script = {Parent={PurchaseCheckout={},ProductPurchases=products,PaidItemPolicy={
			CanPurchase = function() return allowed, if allowed then nil else "Restricted" end,
		},FishingBaitPurchases={IsProduct=function() return false end, IsPurchaseId=function() return false end}}},
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

local productPurchases = loadModule("src/ServerScriptService/Services/ProductPurchases.lua")
local purchaseService = loadModule("src/ServerScriptService/Services/PurchaseService.lua", productPurchases)
local gamePassService = loadModule("src/ServerScriptService/Services/GamePassService.lua")
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

purchaseService.Client.Server = purchaseService
purchaseService:PromptPurchase(buyer, "MegaLuck", true, 42)
assert(selfPrompts == 0, "The purchase needs an odds preview for the same recipient")
assert(purchaseService.Client:GetUltraLuckOdds(buyer, true).canBuy)
allowed = false
purchaseService:PromptPurchase(buyer, "MegaLuck", true, 42)
assert(selfPrompts == 0 and not purchaseService.Client:GetUltraLuckOdds(buyer, true).canBuy,
	"Eligibility is rechecked before opening the purchase")
allowed = true
assert(purchaseService.Client:GetUltraLuckOdds(buyer, true).canBuy)
purchaseService:PromptPurchase(buyer, "MegaLuck", true, 42)
purchaseService:PromptPurchase(buyer, "MegaLuck", true, 42)
assert(selfPrompts == 1, "A preview permits one eligible purchase prompt")
productPurchases.Prompt = function(_, id, _, sku, target)
	assert(id == "MegaLuck" and sku == purchaseConfigs.MegaLuck.GiftProductId and target == recipient)
	giftPrompts += 1
	return true
end
assert(purchaseService.Client:GetUltraLuckOdds(buyer, false).recipientId == 43)
purchaseService._PlayerGifted[buyer.UserId] = nil
purchaseService:PromptPurchase(buyer, "MegaLuck", false, 43)
assert(giftPrompts == 0 and selfPrompts == 1, "The gift cannot become a self purchase")
purchaseService._PlayerGifted[buyer.UserId] = 43
assert(purchaseService.Client:GetUltraLuckOdds(buyer, false).canBuy)
purchaseService:PromptPurchase(buyer, "MegaLuck", false, 43)
assert(giftPrompts == 1)

local cashOrders = {}
productPurchases.Prompt = function(_, id, row, sku, target, amount)
	assert(id == "WinsTier1" and row == purchaseConfigs.WinsTier1 and sku == row.ProductId)
	table.insert(cashOrders, { target = target, amount = amount })
	return true
end
purchaseService:PromptPurchase(buyer, "WinsTier1", true, 42, 100_000)
purchaseService:PromptPurchase(buyer, "WinsTier1", false, 43, 2_500_000)
assert(#cashOrders == 2 and cashOrders[1].target == buyer and cashOrders[1].amount == 100_000)
assert(cashOrders[2].target == recipient and cashOrders[2].amount == 2_500_000)
purchaseDataByPlayer[recipient].BaseRate = 2000
purchaseService:PromptPurchase(buyer, "WinsTier1", false, 43, 2_500_000)
purchaseService:PromptPurchase(buyer, "WinsTier1", false, 42, 5_000_000)
purchaseService:PromptPurchase(buyer, "WinsTier1", false, 43)
assert(#cashOrders == 2, "Block stale amount, mismatched recipient, and missing disclosure")
purchaseService:PromptPurchase(buyer, "WinsTier1", false, 43, 5_000_000)
assert(cashOrders[3].amount == 5_000_000)

print("GamePassEffects.test.lua passed")

-- Exercise the real shop button callback with local and gifting states.
local purchaseId, productId = "DoubleTrain", 210
local activate
local passButton = {
	IsA = function(_, class) return class == "GuiButton" end,
	NameLabel = {}, GamePassImage = {}, DescriptionLabel = {},
	Frame = { BuyButton = { PriceLabel = {}, RobuxImage = {}, OwnedLabel = {} } },
	Activated = { Connect = function(_, callback) activate = callback end },
}
local passCard = {
	Name = purchaseId,
	IsA = function(_, class) return class == "Frame" end,
	FindFirstChild = function(_, name) return if name == "GamePassButton" then passButton else nil end,
	GamePassButton = passButton,
}
local container = {
	GetChildren = function() return { passCard } end,
	FindFirstChild = function(_, name) return if name == purchaseId then passCard else nil end,
}
local scroll = {
	GamePassFrame = { Container = container }, CodeFrame = {},
	WinsFrame = { Container = {} },
}
local storeGui = { Frame = {
	MainFrame = { ScrollingFrame = scroll },
	TopFrame = { GamePass = {}, Wins = {}, Code = {} },
	GiftFrame = { GiftButton = { Gift = {}, Cancel = {} }, GiftedPlayerLabel = {} },
} }
local function waitFor(instance)
	return { WaitForChild = function() return instance end }
end
local shopper = waitFor(waitFor(storeGui))
local opened, gifted, alreadyOwned, unavailable = 0, 0, 0, 0
local owned = {}
local cashPrompt
local storeApi = {
	Players = { LocalPlayer = shopper },
	MarketplaceService = { PromptGamePassPurchase = function(_, player, sku)
		assert(player == shopper and sku == productId)
		opened += 1
	end },
	ReplicatedStorage = {
		Packages = { Knit = {
			CreateController = function(controller) return controller end,
			GetService = function(name)
				assert(name == "PurchaseService")
				return { CancelGift = { Fire = function() end }, PromptPurchase = { Fire = function(_, id, ...)
					if id == "WinsTier1" then
						cashPrompt = { id, ... }
						return
					end
					assert(id == purchaseId)
					gifted += 1
				end } }
			end,
		} },
		Modules = {
			Constants = { NOTIFICATION = { ALREADY_OWN_GAME_PASS = "Owned" } }, GuiAnimation = {},
			CashPack = cashPack,
			PlotFishIncome = { BASE_RATE_ATTRIBUTE = "PlotFishBaseCashPerSecond" },
			NumberUtil = { FormatWinsAmount = function(amount) return tostring(amount) .. "$" end },
			UltraLuckDetails = { PurchaseId = "MegaLuck" },
			ButtonAnimation = { SetUp = function() end },
			NotificationClient = {
				Notify = function(message)
					assert(message == "Owned")
					alreadyOwned += 1
				end,
				RedNotify = function() unavailable += 1 end,
			},
		},
	},
	StarterPlayer = { StarterPlayerScripts = { Controllers = {
		PlayerDataController = { GetData = function() return { GamePasses = owned } end },
	} } },
	ReplicatedFirst = { DataHelpers = { PurchaseDataHelper = {
		IsRetired = function() return false end,
		GetWinsData = function() return { WinsTier1 = purchaseConfigs.WinsTier1 } end,
		GetGamePassesData = function()
			return { [purchaseId] = {
				Name = "Double Train", IconId = "1", Price = 19, Description = "", Index = 1, ProductId = productId,
			} }
		end,
	} } },
}
local activateCash
local cashButton = {
	WinsImage = {}, Frame = { BuyButton = { PriceLabel = {} } },
	PackLabel = {}, BuyNumLabel = {},
	Activated = { Connect = function(_, callback) activateCash = callback end },
}
scroll.WinsFrame.Container.WinsTemplate = {
	Clone = function() return { WinsButton = cashButton, SetAttribute = function() end } end,
	Parent = scroll.WinsFrame.Container,
}
local function initCashRecipient(player, userId)
	player.Parent, player.UserId = storeApi.Players, userId
	function player:GetAttribute() return self.baseRate end
	function player:GetAttributeChangedSignal()
		return { Connect = function(_, callback)
			self.refresh = callback
			return { Disconnect = function() self.refresh = nil end }
		end }
	end
end
local storeController = assert(load(store, "StoreGuiController", "t", setmetatable({
	game = { GetService = function(_, name) return storeApi[name] or {} end },
	require = function(module) return module end,
}, { __index = getfenv() })))()
storeController:GenerateGamePassList()
activate()
assert(opened == 1 and gifted == 0, "A self purchase calls Roblox in the activation callback")
owned[purchaseId] = true
activate()
assert(opened == 1 and alreadyOwned == 1)
storeController:SetGiftingState(true, { DisplayName = "Friend" })
activate()
assert(opened == 1 and gifted == 1 and unavailable == 0, "Gifting still uses server validation")

initCashRecipient(shopper, 42)
initCashRecipient(recipient, 43)
storeController:GenerateWinsList()
storeController:SetGiftingState(false)
assert(cashButton.BuyNumLabel.Text == "Loading..." and not cashButton.Interactable)
activateCash()
assert(cashPrompt == nil)
shopper.baseRate = 0
shopper.refresh()
assert(cashButton.BuyNumLabel.Text == "+100000$" and cashButton.Interactable)
recipient.baseRate = 1000
storeController:SetGiftingState(true, recipient)
assert(cashButton.BuyNumLabel.Text == "+2500000$" and shopper.refresh == nil)
recipient.baseRate = 0
activateCash()
assert(cashPrompt[2] == false and cashPrompt[3] == 43 and cashPrompt[4] == 2_500_000,
	"Activation sends the displayed amount even before replication refreshes the label")
recipient.refresh()
assert(cashButton.BuyNumLabel.Text == "+100000$")
storeController:SetCashPackRecipient(nil)
assert(cashButton.BuyNumLabel.Text == "Unavailable" and not cashButton.Interactable)
storeController:SetGiftingState(false)
activateCash()
assert(cashPrompt[2] == true and cashPrompt[3] == 42 and cashPrompt[4] == 100_000)
