-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	MAX_REBIRTH = 10,
	StairsPerLevel = 2000,
	MultiplierIncrement = 1,
	BASE_MULTIPLIER = 1,
	CachedRequirement = {},
	CachedMultipliers = {},
	GetDamageRequirement = function(p1, p2) --[[ GetDamageRequirement | Line: 10 ]]
		if not p1.CachedRequirement[p2] then
			p1.CachedRequirement[p2] = p1.StairsPerLevel * p2
		end
		return p1.CachedRequirement[p2]
	end,
	GetMultiplierFromLevel = function(p1, p2) --[[ GetMultiplierFromLevel | Line: 18 ]]
		if not p1.CachedMultipliers[p2] then
			p1.CachedMultipliers[p2] = p1.BASE_MULTIPLIER + p1.MultiplierIncrement * p2
		end
		return p1.CachedMultipliers[p2]
	end,
	GetKickRequirement = function(p1, p2) --[[ GetKickRequirement | Line: 26 ]]
		return 10 ^ (p2 + 2)
	end
}