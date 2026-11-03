-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Types.Modifiers)
local Constants = require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Shared.ItemUtility)
local t = {
	MaxSaleListingPrice = 1000000000,
	SaleListingTaxPercentage = 1,
	TradeOfferExpiration = 10,
	ConfirmCountdownTime = 5,
	ChangeCountdownTime = 5,
	MaxItemsInTrade = 20,
	IsEnabled = function() --[[ IsEnabled | Line: 109 | Upvalues: RunService (copy), Replion (copy) ]]
		local v1 = nil
		if RunService:IsServer() then
			v1 = Replion.Server:WaitReplion("RemoteConfigs")
		elseif RunService:IsClient() then
			v1 = Replion.Client:WaitReplion("RemoteConfigs")
		end
		if not v1 then
			return false
		end
		return workspace:GetAttribute("TradingDisabled") == false
	end,
	GetDefaultTradeLock = function() --[[ GetDefaultTradeLock | Line: 125 ]]
		return 604800
	end,
	TradableItemTypes = {
		"Fish",
		"Fishing Rods",
		"Boats",
		"Baits",
		"Charms",
		"Emotes",
		"Halos",
		"Lanterns",
		"Enchant Stones",
		"Pets",
		"Pet Eggs"
	},
	TradableItemsSkinOnly = {
		Baits = true,
		["Fishing Rods"] = true
	},
	ExcludeCoinsItems = {
		["Fishing Rods"] = true,
		Charms = true,
		Boats = true,
		Baits = true,
		Lanterns = true,
		Emotes = true
	},
	SaleContainers = {
		Sign = {
			MaxItems = 3
		},
		Booth = {
			MaxItems = 10
		}
	}
}
t.DefaultTradeLockDuration = if game.GameId == 6078904844 then 120 else 900
t.MaxInventoryItems = Constants.MaxInventorySize
t.RAPCacheLifetime = if game.GameId == 6078904844 then 10 else 60
t.TokensTiers = {
	["1"] = {
		ProductId = 3562441655,
		Tokens = 50
	},
	["2"] = {
		ProductId = 3563709131,
		Tokens = 250
	},
	["3"] = {
		ProductId = 3563709333,
		Tokens = 1000
	},
	["4"] = {
		ProductId = 3563709580,
		Tokens = 2500
	},
	["5"] = {
		ProductId = 3563711098,
		Tokens = 5000
	}
}
function t.GetItemId(p1, p2) --[[ GetItemId | Line: 207 ]]
	assert(p2, (("no item for %*!"):format(p1)))
	return ("%*/%*"):format(p1, p2.Data.Id)
end
t.Remotes = {
	SendTradeOffer = Net:RemoteFunction("Trading/SendTradeOffer"),
	AcceptTradeOffer = Net:RemoteFunction("Trading/AcceptTradeOffer"),
	TradeOfferReceived = Net:RemoteEvent("Trading/TradeOfferReceived"),
	DeclineTradeOffer = Net:RemoteFunction("Trading/DeclineTradeOffer"),
	AddItem = Net:RemoteFunction("Trading/AddItem"),
	RemoveItem = Net:RemoteFunction("Trading/RemoveItem"),
	SetTokens = Net:RemoteFunction("Trading/SetTokens"),
	SetReady = Net:RemoteFunction("Trading/SetReady"),
	ConfirmTrade = Net:RemoteFunction("Trading/ConfirmTrade"),
	CancelTrade = Net:RemoteFunction("Trading/CancelTrade"),
	TradeStarted = Net:RemoteEvent("Trading/TradeStarted"),
	TradeEnded = Net:RemoteEvent("Trading/TradeEnded"),
	TradeCompleted = Net:RemoteEvent("Trading/TradeCompleted"),
	CreateSaleListing = Net:RemoteFunction("Trading/CreateSaleListing"),
	DeleteSaleListing = Net:RemoteFunction("Trading/DeleteSaleListing"),
	PurchaseSaleListing = Net:RemoteFunction("Trading/PurchaseSaleListing"),
	SaleListingSold = Net:RemoteEvent("Trading/SaleListingSold"),
	GetItemRAP = Net:RemoteFunction("Trading/GetItemRAP"),
	LoadPlayerInventory = Net:RemoteFunction("Trading/LoadPlayerInventory"),
	UnloadPlayerInventory = Net:RemoteEvent("Trading/UnloadPlayerInventory"),
	FindSellers = Net:RemoteFunction("Trading/FindSellers"),
	TeleportToListing = Net:RemoteFunction("Trading/TeleportToListing")
}
function t.FollowTradeRules(p1, p2) --[[ Line: 365 | Upvalues: t (copy) ]]
	local Type = p1.Data.Type
	if not table.find(t.TradableItemTypes, Type) then
		return false
	end
	if t.TradableItemsSkinOnly[Type] and not p1.IsSkin then
		return false
	end
	if t.ExcludeCoinsItems[Type] and p1.Price then
		return false
	end
	if p2 and (p2.Metadata and p2.Metadata.TradeLock or p1.TradeLocked) then
		return false
	end
	return (Type == "Charms" or (Type == "Potions" or (Type == "Pets" or not p1.Modifiers))) and true or false
end
function t.CalculatePostTaxPrice(p1) --[[ Line: 396 | Upvalues: t (copy) ]]
	return math.floor(p1 - p1 * (t.SaleListingTaxPercentage / 100))
end
return t