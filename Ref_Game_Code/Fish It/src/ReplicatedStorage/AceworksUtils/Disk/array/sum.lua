-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ sum | Line: 1 ]]
	local sum = if p2 == nil then 0 else p2
	for v1, v2 in p1 do
		sum = sum + v2
	end
	return sum
end