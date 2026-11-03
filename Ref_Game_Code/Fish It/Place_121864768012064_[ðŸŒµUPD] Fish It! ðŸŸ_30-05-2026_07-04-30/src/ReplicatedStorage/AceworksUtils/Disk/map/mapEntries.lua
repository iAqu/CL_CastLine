-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ mapEntries | Line: 1 ]]
	local t = {}
	for v1, v2 in p1 do
		local v3, v4 = p2(v1, v2)
		if v3 ~= nil and v4 ~= nil then
			t[v3] = v4
		end
	end
	return t
end