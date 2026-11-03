-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ contains | Line: 1 ]]
	for v1, v2 in p1 do
		if v2 == p2 then
			return true
		end
	end
	return false
end