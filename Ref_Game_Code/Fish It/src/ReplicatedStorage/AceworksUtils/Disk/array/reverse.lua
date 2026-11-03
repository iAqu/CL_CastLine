-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ reverse | Line: 1 ]]
	local v1 = #p1
	if v1 < 2 then
		return p1
	end
	local v2 = table.clone(p1)
	for i = 1, math.floor(v1 / 2) do
		local v3 = v1 - i + 1
		local v5 = v2[i]
		v2[i] = v2[v3]
		v2[v3] = v5
	end
	return v2
end