-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ count | Line: 3 ]]
	local count = 0
	for v1, v2 in p1 do
		if p2 == nil or p2(v2, v1) then
			count = count + 1
		end
	end
	return count
end