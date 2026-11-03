-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ averageBy | Line: 1 ]]
	local v1 = #p1
	if v1 == 0 then
		return nil
	end
	local sum = 0
	for v2, v3 in p1 do
		sum = sum + p2(v3)
	end
	return sum / v1
end