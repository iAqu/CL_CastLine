-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ takeWhile | Line: 1 ]]
	local v1 = #p1
	if v1 == 0 then
		return p1
	end
	local v2 = v1 + 1
	local v3 = if p3 == nil then 1 else p3
	if v3 == 1 then
		for v4, v5 in p1 do
			if not p2(v5, v4) then
				v2 = v4
				break
			end
		end
	else
		for i = v3, #p1 do
			if not p2(p1[i], i) then
				v2 = i
				break
			end
		end
	end
	if v3 == v2 then
		return {}
	end
	if v3 == 1 and v1 < v2 then
		return p1
	end
	if v3 == 1 and v2 - v3 < v1 / 2 then
		local v6 = table.clone(p1)
		for j = 1, v1 - v2 do
			table.remove(v6)
		end
		return v6
	else
		local t = {}
		for k = v3, v2 - 1 do
			table.insert(t, p1[k])
		end
		return t
	end
end