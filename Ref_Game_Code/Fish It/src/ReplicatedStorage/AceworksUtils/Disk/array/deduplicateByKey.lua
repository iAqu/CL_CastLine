-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ deduplicateByKey | Line: 1 ]]
	local t = {}
	local t2 = {}
	for v1, v2 in p1 do
		local v3 = p2(v2)
		if t[v3] == nil then
			t[v3] = true
			continue
		end
		table.insert(t2, v1)
	end
	local v4 = #t2
	if v4 == 0 then
		return p1
	end
	local v5 = table.clone(p1)
	for i = v4, 1, -1 do
		table.remove(v5, t2[i])
	end
	return v5
end