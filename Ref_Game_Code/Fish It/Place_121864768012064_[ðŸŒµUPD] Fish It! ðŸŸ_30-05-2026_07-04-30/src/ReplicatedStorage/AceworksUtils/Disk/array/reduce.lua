-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ reduce | Line: 1 ]]
	if p3 == nil then
		for v1, v2 in p1 do
			if v1 == 1 then
				p3 = v2
				continue
			end
			p3 = p2(p3, v2, v1)
		end
	else
		for v4, v5 in p1 do
			p3 = p2(p3, v5, v4)
		end
	end
	return p3
end