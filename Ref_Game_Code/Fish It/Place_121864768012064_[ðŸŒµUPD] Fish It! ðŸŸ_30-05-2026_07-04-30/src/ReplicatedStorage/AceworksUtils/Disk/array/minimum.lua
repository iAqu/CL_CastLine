-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ minimum | Line: 1 ]]
	if p2 == nil then
		if #p1 == 0 then
			error("initial value must be provided to Array.minimum when the array is empty")
		end
		p2 = p1[1]
	end
	local v1 = p2
	for v2, v3 in p1 do
		v1 = math.min(v1, v3)
	end
	return v1
end