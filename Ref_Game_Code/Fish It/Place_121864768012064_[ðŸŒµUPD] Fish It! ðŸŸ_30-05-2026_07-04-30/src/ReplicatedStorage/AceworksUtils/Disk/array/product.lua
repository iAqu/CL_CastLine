-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ product | Line: 1 ]]
	local v1 = if p2 == nil then 1 else p2
	for v2, v3 in p1 do
		v1 = v1 * v3
	end
	return v1
end