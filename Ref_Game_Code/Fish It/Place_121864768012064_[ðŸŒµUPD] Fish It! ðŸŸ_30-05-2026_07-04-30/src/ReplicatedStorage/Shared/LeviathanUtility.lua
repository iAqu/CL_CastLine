-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local t = {
	{
		Type = "Gears",
		Identifier = "Sunken Eye Relic",
		Color = Color3.fromRGB(34, 188, 70)
	},
	{
		Type = "Gears",
		Identifier = "Blacktide Relic",
		Color = Color3.fromRGB(203, 45, 48)
	},
	{
		Type = "Gears",
		Identifier = "Burntflame Relic",
		Color = Color3.fromRGB(207, 132, 47)
	}
}
return {
	TOME_POSITIONS = t,
	START_COUNT = 2,
	GetTomeDataFromName = function(p1, p2) --[[ GetTomeDataFromName | Line: 36 | Upvalues: t (copy) ]]
		for k, v in pairs(t) do
			if v.Identifier == p2 then
				return v
			end
		end
	end,
	Validate = function(p1, p2, p3, p4) --[[ Validate | Line: 44 | Upvalues: t (copy), PlayerStatsUtility (copy), ItemUtility (copy) ]]
		local v1 = t[p3]
		if not v1 then
			return
		end
		local v2 = PlayerStatsUtility:GetItemFromInventory(p2, function(p1) --[[ Line: 48 | Upvalues: p4 (copy) ]]
			return p1.UUID == p4
		end, "Items")
		if not v2 then
			return
		end
		local v3 = ItemUtility.GetItemDataFromItemType("Gears", v2.Id)
		if not v3 then
			return
		end
		return if v3.Data.Name == v1.Identifier then v3.Data.Type == v1.Type else false
	end
}