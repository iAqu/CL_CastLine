-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 3 ]]
	for v1, v2 in p1 do
		if p2(v2, v1) == true then
			return v1, v2
		end
	end
	return nil
end