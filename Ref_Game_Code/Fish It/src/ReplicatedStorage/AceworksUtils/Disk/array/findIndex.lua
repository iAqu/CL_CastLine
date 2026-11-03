-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ findIndex | Line: 1 ]]
	if p3 == nil or p3 == 1 then
		for v1, v2 in p1 do
			if p2(v2, v1) then
				return v1
			end
		end
	else
		for i = p3, #p1 do
			if p2(p1[i], i) then
				return i
			end
		end
	end
	return nil
end