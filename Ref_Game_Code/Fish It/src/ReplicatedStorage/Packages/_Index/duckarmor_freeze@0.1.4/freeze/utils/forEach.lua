-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 3 ]]
	local count = 0
	for v1, v2 in p1 do
		count = count + 1
		if p2(v2, v1) == false then
			break
		end
	end
	return count
end