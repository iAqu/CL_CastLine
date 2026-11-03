-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ filter | Line: 1 ]]
	local t = {}
	for v1, v2 in p1 do
		if p2(v2, v1) then
			table.insert(t, v2)
		end
	end
	return t
end