-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	GetLevelXP = function(p1) --[[ GetLevelXP | Line: 6 ]]
		if p1 == 0 or p1 == 1 then
			return 15
		else
			return math.sqrt(p1 ^ 3) + 20
		end
	end
}
function t.GetNextLevelXP(p1) --[[ GetNextLevelXP | Line: 14 | Upvalues: t (copy) ]]
	return t.GetLevelXP(p1 + 1)
end
return t