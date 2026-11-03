-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ entries | Line: 1 ]]
	local v1 = if p2 == nil then 1 else p2
	local v2 = if p3 == nil then v1 + 1 else p3
	local t = {}
	for v3, v4 in p1 do
		table.insert(t, {
			[v1] = v3,
			[v2] = v4
		})
	end
	return t
end