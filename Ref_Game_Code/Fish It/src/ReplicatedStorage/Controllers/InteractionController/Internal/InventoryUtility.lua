-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local t = {
	GetEquippedInventoryItem = function(p1, p2, p3) --[[ GetEquippedInventoryItem | Line: 11 | Upvalues: PlayerStatsUtility (copy) ]]
		if p3 then
			return PlayerStatsUtility:GetItemFromInventory(p2, function(p1) --[[ Line: 16 | Upvalues: p3 (copy) ]]
				return p1.UUID == p3
			end)
		end
	end
}
function t.GetItemDataFromEquippedItem(p1, p2, p3) --[[ GetItemDataFromEquippedItem | Line: 21 | Upvalues: t (copy), ItemUtility (copy) ]]
	local v1 = t:GetEquippedInventoryItem(p2, p3)
	if v1 then
		return ItemUtility:GetItemData(v1.Id)
	end
end
function t.FishingRodEquipped(p1, p2, p3) --[[ FishingRodEquipped | Line: 30 | Upvalues: t (copy) ]]
	local v1 = t:GetItemDataFromEquippedItem(p2, p3)
	if not v1 then
		return
	end
	return v1.Data.Type == "Fishing Rods"
end
return t