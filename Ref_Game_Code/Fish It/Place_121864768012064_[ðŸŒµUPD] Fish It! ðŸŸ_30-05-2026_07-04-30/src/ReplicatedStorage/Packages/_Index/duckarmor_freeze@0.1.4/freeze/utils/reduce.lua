-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3, p4) --[[ reduce | Line: 3 ]]
	local v1 = #p1 + 1
	for v2, v3 in p1 do
		if p4 then
			v3 = p1[v1 - v2]
		end
		p3 = p2(p3, v3, v2)
	end
	return p3
end