-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
return function(p1, p2) --[[ EncodeItem | Line: 7 | Upvalues: ItemUtility (copy) ]]
	if not p1 then
		return nil
	end
	local v1 = if p2 then ItemUtility.GetItemDataFromItemType(p2, p1.Id) else ItemUtility:GetItemData(p1.Id)
	local t = {}
	t.Type = v1 and v1.Data.Type or p2
	t.Name = if v1 then v1.Data.Name else v1
	t.Data = p1
	return t
end