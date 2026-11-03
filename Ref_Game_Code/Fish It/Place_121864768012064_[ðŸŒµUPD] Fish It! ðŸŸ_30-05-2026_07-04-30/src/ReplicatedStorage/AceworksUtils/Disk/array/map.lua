-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ map | Line: 1 ]]
	local t = {}
	for v1, v2 in p1 do
		local v3 = p2(v2, v1)
		if v3 ~= nil then
			table.insert(t, v3)
		end
	end
	return t
end