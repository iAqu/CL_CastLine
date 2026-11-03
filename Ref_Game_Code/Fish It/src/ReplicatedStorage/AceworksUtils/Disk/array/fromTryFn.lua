-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ fromTryFn | Line: 1 ]]
	local count = 1
	local t = {}
	while true do
		local v1, v2 = pcall(p1, count)
		if v1 == false then
			break
		end
		if v2 == nil then
			break
		end
		table.insert(t, v2)
		count = count + 1
	end
	return t
end