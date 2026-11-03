-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, ...) --[[ removeValues | Line: 1 ]]
	local v1 = select("#", ...)
	local v2 = #p1
	if v1 == 0 or v2 == 0 then
		return p1
	end
	local t = {}
	for v3, v4 in p1 do
		for i = 1, v1 do
			local v5 = select(i, ...)
			if v5 ~= nil and v4 == v5 then
				table.insert(t, v3)
			end
		end
	end
	local v6 = #t
	if v6 == 0 then
		return p1
	end
	if v6 == v2 then
		return {}
	end
	local v7 = table.clone(p1)
	for j = v6, 1, -1 do
		table.remove(v7, t[j])
	end
	return v7
end