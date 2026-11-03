-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ pop | Line: 1 ]]
	local v1 = p2 or 1
	if v1 == 1 then
		local v2 = table.clone(p1)
		table.remove(v2)
		return v2
	end
	if v1 == 0 then
		return p1
	end
	local v3 = #p1 - v1
	if v3 <= 0 then
		return {}
	end
	if v1 < v3 then
		local v4 = table.clone(p1)
		for i = 1, v1 do
			table.remove(v4)
		end
		return v4
	else
		local t = {}
		for j = 1, v3 do
			t[j] = p1[j]
		end
		return t
	end
end