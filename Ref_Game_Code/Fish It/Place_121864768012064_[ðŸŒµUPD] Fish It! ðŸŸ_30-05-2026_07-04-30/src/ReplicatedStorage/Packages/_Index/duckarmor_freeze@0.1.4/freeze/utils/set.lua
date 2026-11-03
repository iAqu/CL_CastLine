-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ Line: 2 ]]
	if p1[p2] == p3 then
		return p1
	else
		local v1 = table.clone(p1)
		v1[p2] = p3
		return v1
	end
end