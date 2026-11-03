-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
return {
	["Blob Hunter"] = function(p1, p2, p3) --[[ Line: 6 ]]
		if p3.Name == "Blob Fish" then
			return p2.BlobMultiplier or 0
		end
	end,
	["Shark Hunter"] = function(p1, p2, p3) --[[ Line: 12 | Upvalues: ItemUtility (copy) ]]
		local v1 = nil
		if p3.Name:lower():find("shark") then
			v1 = false
		else
			local v2 = ItemUtility:GetItemData(p3.Name)
			if v2 and (v2.Variants and table.find(v2.Variants, "Color Burn")) then
				v1 = true
			end
		end
		if v1 then
			return p2.SharkMultiplier
		end
	end,
	FORGOTTENMultiplier = function(p1, p2, p3) --[[ FORGOTTENMultiplier | Line: 28 ]]
		if p3.Tier == 8 then
			return p2.FORGOTTENMultiplier
		end
	end,
	SECRETMultiplier = function(p1, p2, p3) --[[ SECRETMultiplier | Line: 34 ]]
		if p3.Tier == 7 then
			return p2.SECRETMultiplier
		end
	end,
	HeartLuck = function(p1, p2, p3) --[[ HeartLuck | Line: 40 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "VAL26" then
			return p2.HeartLuck
		end
	end,
	ClassicLuck = function(p1, p2, p3) --[[ ClassicLuck | Line: 47 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "CLASSIC26" then
			return p2.ClassicLuck
		end
	end,
	EasterLuck = function(p1, p2, p3) --[[ EasterLuck | Line: 54 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "EA26" then
			return p2.EasterLuck
		end
	end,
	["Easter Secret Boost"] = function(p1, p2, p3) --[[ Line: 61 ]]
		if p3.Tier == 7 then
			return 1.4
		end
	end,
	["Easter Forgotten Boost"] = function(p1, p2, p3) --[[ Line: 67 ]]
		if p3.Tier == 8 then
			return 1.4
		end
	end
}