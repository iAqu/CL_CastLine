-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Replion)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local t = {
	["Diamond Rod"] = {
		ItemType = "Fishing Rods",
		RequiredIdentifier = "Diamond Key",
		RequiredItemType = "Gears"
	},
	["Overlord\'s Trident"] = {
		ItemType = "Fishing Rods",
		RequiredIdentifier = "Ruin Key",
		RequiredItemType = "Gears"
	}
}
return {
	GetAllItems = function(p1) --[[ GetAllItems | Line: 31 | Upvalues: t (copy) ]]
		return t
	end,
	Get = function(p1, p2) --[[ Get | Line: 35 | Upvalues: t (copy) ]]
		return t[p2]
	end,
	Check = function(p1, p2, p3) --[[ Check | Line: 39 | Upvalues: t (copy), ItemUtility (copy), InventoryMapping (copy), PlayerStatsUtility (copy) ]]
		local v1 = t[p3]
		if not v1 then
			return false, "No_Item"
		end
		if v1.RequiredQuest and p2:Find("CompletedQuests", v1.RequiredQuest) == nil then
			return false, ("You have not completed quest: %*"):format(v1.RequiredQuest)
		end
		local v2 = ItemUtility.GetItemDataFromItemType(v1.RequiredItemType, v1.RequiredIdentifier)
		if not v2 then
			return false, "No_Claim_Data"
		end
		local v3 = InventoryMapping[v1.RequiredItemType]
		if not v3 then
			return false, "No_Claim_Category"
		end
		if not PlayerStatsUtility:GetItemFromInventory(p2, function(p1) --[[ Line: 62 | Upvalues: v2 (copy) ]]
			return p1.Id == v2.Data.Id
		end, v3) then
			return false, ("You do not own %*"):format(v2.Data.Name)
		end
		local v4 = ItemUtility.GetItemDataFromItemType(v1.ItemType, p3)
		if not v4 then
			return false, "No_Item_Data"
		end
		local v5 = InventoryMapping[v1.ItemType]
		if not v5 then
			return false, "No_Item_Category"
		end
		if PlayerStatsUtility:GetItemFromInventory(p2, function(p1) --[[ Line: 81 | Upvalues: v4 (copy) ]]
			return p1.Id == v4.Data.Id
		end, v5) then
			return false, "You already own this item!"
		else
			return true
		end
	end
}