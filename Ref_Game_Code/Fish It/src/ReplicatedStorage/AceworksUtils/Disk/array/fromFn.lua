-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ fromFn | Line: 1 ]]
	local count = 1
	local t = {}
	while true do
		local v1 = p1(count)
		if v1 == nil then
			break
		end
		table.insert(t, v1)
		count = count + 1
	end
	return t
end