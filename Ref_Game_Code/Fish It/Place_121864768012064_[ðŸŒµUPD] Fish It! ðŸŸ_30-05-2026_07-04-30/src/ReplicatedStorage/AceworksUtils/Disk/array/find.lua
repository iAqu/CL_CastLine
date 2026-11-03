-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ find | Line: 1 ]]
	if p3 == nil or p3 == 1 then
		for v1, v2 in p1 do
			if p2(v2, v1) then
				return v2
			end
		end
	else
		for i = p3, #p1 do
			local v3 = p1[i]
			if p2(v3, i) then
				return v3
			end
		end
	end
	return nil
end