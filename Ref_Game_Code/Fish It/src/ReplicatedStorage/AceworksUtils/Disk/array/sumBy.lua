-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ sumBy | Line: 1 ]]
	local sum = if p3 == nil then 0 else p3
	for v1, v2 in p1 do
		sum = sum + p2(v2)
	end
	return sum
end