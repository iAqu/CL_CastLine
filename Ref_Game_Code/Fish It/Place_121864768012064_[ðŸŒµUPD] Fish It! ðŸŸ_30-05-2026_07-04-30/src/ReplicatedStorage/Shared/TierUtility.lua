-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tiers = require(ReplicatedStorage.Tiers)
local t = {}
for v1, v2 in Tiers do
	table.insert(t, v2.Tier)
end
table.sort(t, function(p1, p2) --[[ Line: 14 ]]
	return p1 < p2
end)
return {
	GetTier = function(p1, p2) --[[ GetTier | Line: 21 | Upvalues: Tiers (copy) ]]
		if typeof(p2) == "number" then
			return Tiers[p2]
		end
		for v1, v2 in Tiers do
			if v2.Name == p2 then
				return v2
			end
		end
		return Tiers[1]
	end,
	GetTierFromRarity = function(p1, p2) --[[ GetTierFromRarity | Line: 35 | Upvalues: t (copy), Tiers (copy) ]]
		for i = #t, 1, -1 do
			local v1 = Tiers[t[i]]
			if p2 <= v1.Rarity then
				return v1
			end
		end
		return Tiers[1]
	end
}