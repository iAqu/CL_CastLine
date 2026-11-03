-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ deduplicate | Line: 1 ]]
	if #p1 == 0 then
		return p1
	end
	local t = {}
	local t2 = {}
	for v1, v2 in p1 do
		if t[v2] == nil then
			t[v2] = true
			continue
		end
		table.insert(t2, v1)
	end
	local v3 = #t2
	if v3 == 0 then
		return p1
	end
	local v4 = table.clone(p1)
	for i = v3, 1, -1 do
		table.remove(v4, t2[i])
	end
	return v4
end