-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ StableExp10 | Line: 25 ]]
	assert(if type(p1) == "number" then true else false)
	assert(if type(p2) == "number" then true else false)
	if p2 == 0 then
		return p1
	end
	local v4 = tonumber((("%*e%*"):format(string.format("%f", p1), p2)))
	if v4 then
		return v4
	else
		return p1 * 10 ^ p2
	end
end