-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ removeSortedIndexes | Line: 1 ]]
	local v1 = #p2
	local v2 = #p1
	if v1 == 0 or v2 == 0 then
		return p1
	end
	local v3 = nil
	for i = v1, 1, -1 do
		local v4 = p2[i]
		if v4 <= v2 then
			v3 = v4
			break
		end
	end
	if v3 == nil then
		return p1
	end
	local v5 = table.clone(p1)
	local v6, v7 = nil, v2
	for j = v3, 1, -1 do
		local v8 = p2[j]
		if v8 ~= v6 and v8 <= v7 then
			table.remove(v5, v8)
			v6, v7 = v8, v7 - 1
		end
	end
	return v5
end