-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 3 ]]
	local t = {}
	for v1, v2 in p1 do
		local v3, v4 = p2(v2, v1)
		local v5 = if v4 == nil then v1 else v4
		if v3 ~= nil then
			t[v5] = v3
		end
	end
	return t
end