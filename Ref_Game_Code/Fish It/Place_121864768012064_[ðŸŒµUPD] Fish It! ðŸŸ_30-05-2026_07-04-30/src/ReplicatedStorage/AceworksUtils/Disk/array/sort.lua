-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ sort | Line: 1 ]]
	if #p1 <= 1 then
		return p1
	else
		local v1 = table.clone(p1)
		table.sort(v1, p2)
		return v1
	end
end