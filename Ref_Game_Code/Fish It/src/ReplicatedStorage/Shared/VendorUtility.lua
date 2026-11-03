-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Types.Fishing)
return {
	GetSellPrice = function(p1, p2, p3) --[[ GetSellPrice | Line: 16 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility.GetItemDataFromItemType(p3 or "Items", p2.Id)
		if not v1 then
			return
		end
		local Type = v1.Data.Type
		if Type == "Fishing Rods" or Type == "Potions" then
			return
		end
		if Type == "Pets" or Type == "Pet Eggs" then
			return v1.SellPrice
		end
		local sum = 1
		local Metadata = p2.Metadata
		local v2 = if v1.SellPrice then v1.SellPrice else nil
		if not v2 then
			return
		end
		if Metadata then
			local Weight = v1.Weight
			local Weight_2 = Metadata.Weight
			if Weight_2 and (Weight and Weight.Default.Max < Weight_2) then
				sum = sum + math.clamp((Weight_2 - Weight.Default.Max) / (Weight.Big.Max - Weight.Default.Max), 0, 3)
			end
			local VariantId = Metadata.VariantId
			local v4 = if VariantId then ItemUtility:GetVariantData(VariantId) else nil
			if v4 then
				sum = sum + v4.SellMultiplier
			end
			if Metadata.Shiny then
				sum = sum + 1.5
			end
		end
		return math.ceil(v2 * sum)
	end
}