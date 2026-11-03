-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.Passives.PassivesTypes)
require(ReplicatedStorage.Types.Modifiers)
local t = {
	GetEquippedInventoryItem = function(p1, p2, p3) --[[ GetEquippedInventoryItem | Line: 17 ]]
		if string.len(p3) == 0 then
			return
		end
		for v1, v2 in p2:GetExpect("Inventory") do
			for i, v in ipairs(v2) do
				if v.UUID == p3 then
					return v, i, v1
				end
			end
		end
	end
}
function t.GetItemDataFromEquippedItem(p1, p2, p3) --[[ GetItemDataFromEquippedItem | Line: 36 | Upvalues: t (copy), ItemUtility (copy) ]]
	local v1, _, v2 = t:GetEquippedInventoryItem(p2, p3)
	if v1 then
		return ItemUtility.GetItemDataFromItemType(v2 or "Items", v1.Id)
	end
end
return t