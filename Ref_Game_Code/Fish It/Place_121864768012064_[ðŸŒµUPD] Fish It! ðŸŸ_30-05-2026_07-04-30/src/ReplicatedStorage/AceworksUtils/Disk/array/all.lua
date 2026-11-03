-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ all | Line: 1 ]]
	for v1, v2 in p1 do
		if not p2(v2, v1) then
			return false
		end
	end
	return true
end