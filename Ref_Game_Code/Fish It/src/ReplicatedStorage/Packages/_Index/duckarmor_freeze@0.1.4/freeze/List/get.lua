-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ get | Line: 21 ]]
	if type(p2) == "number" and p2 < 0 then
		p2 = #p1 + (p2 + 1)
	end
	return p1[p2] or p3
end