-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 1 ]]
	while #p2 > 1 do
		local t = {}
		for i = 1, #p2 - 1 do
			t[i] = p2[i]:Lerp(p2[i + 1], p1)
		end
		p2 = t
	end
	return p2[1]
end