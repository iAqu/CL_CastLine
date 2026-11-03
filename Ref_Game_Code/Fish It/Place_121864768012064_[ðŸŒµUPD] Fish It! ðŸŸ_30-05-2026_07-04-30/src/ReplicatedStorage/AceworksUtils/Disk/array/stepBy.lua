-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ stepBy | Line: 1 ]]
	local v1 = #p1
	if p2 == 1 then
		return p1
	end
	if p2 == -1 then
		local v2 = table.clone(p1)
		for i = 1, math.floor(v1 / 2) do
			local v3 = v1 - i + 1
			local v5 = v2[i]
			v2[i] = v2[v3]
			v2[v3] = v5
		end
		return v2
	elseif p2 > 1 then
		local t = {}
		for j = 1, v1, p2 do
			table.insert(t, p1[j])
		end
		return t
	else
		if not (p2 < -1) then
			error((("invalid step value \'%*\' passed to Array.stepBy"):format(p2)))
		end
		local t = {}
		for k = v1, 1, p2 do
			table.insert(t, p1[k])
		end
		return t
	end
end