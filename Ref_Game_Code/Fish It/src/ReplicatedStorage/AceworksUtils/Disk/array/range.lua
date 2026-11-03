-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ range | Line: 1 ]]
	local v1 = #p1
	if v1 == 0 then
		return p1
	end
	local v2 = if p3 == nil then v1 else p3
	local v3 = if p2 < 0 then p2 + v1 + 1 else p2
	local v4 = if v2 < 0 then 1 + (v2 + v1) else v2
	local t = {}
	if v3 <= v4 then
		for i = math.max(v3, 1), math.min(v4, v1) do
			table.insert(t, p1[i])
		end
	else
		for j = math.min(v3, v1), math.max(v4, 1), -1 do
			table.insert(t, p1[j])
		end
	end
	return t
end