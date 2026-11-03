-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ minimumBy | Line: 1 ]]
	if p3 == nil then
		if #p1 == 0 then
			error("initial value must be provided to Array.minimumBy when the array is empty")
		end
		p3 = p2(p1[1])
	end
	local v2 = p3
	for v3, v4 in p1 do
		v2 = math.min(v2, p2(v4))
	end
	return v2
end