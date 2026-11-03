-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ findMap | Line: 1 ]]
	if p3 == nil or p3 == 1 then
		for v1, v2 in p1 do
			local v3 = p2(v2, v1)
			if v3 ~= nil then
				return v3
			end
		end
	else
		for i = p3, #p1 do
			local v4 = p2(p1[i], i)
			if v4 ~= nil then
				return v4
			end
		end
	end
	return nil
end