-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ Line: 5 ]]
	if p1[p2] == nil then
		return p3
	else
		return p1[p2]
	end
end