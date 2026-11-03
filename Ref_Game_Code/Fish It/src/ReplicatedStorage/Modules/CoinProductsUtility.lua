-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
require(ReplicatedStorage.Packages.Replion)
local CoinProducts = require(ReplicatedStorage.Shared.Products.CoinProducts)
local t = {}
function t.PurchaseBestCoinPack(p1, p2, p3) --[[ PurchaseBestCoinPack | Line: 16 | Upvalues: t (copy), MarketplaceService (copy), LocalPlayer (copy) ]]
	local v1 = t:_getBestCoinPackId(p2, p3)
	return pcall(function() --[[ Line: 19 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v1 (copy) ]]
		return MarketplaceService:PromptProductPurchase(LocalPlayer, v1)
	end)
end
function t._getBestCoinPackId(p1, p2, p3) --[[ _getBestCoinPackId | Line: 26 | Upvalues: CoinProducts (copy) ]]
	local list = {}
	for v1, v2 in CoinProducts do
		table.insert(list, {
			ProductId = v1,
			Value = v2.Value
		})
	end
	table.sort(list, function(p1, p2) --[[ Line: 35 ]]
		return p1.Value < p2.Value
	end)
	for i, v in ipairs(list) do
		if p3 <= p2 + v.Value then
			return v.ProductId
		end
	end
	return list[#list].ProductId
end
return t