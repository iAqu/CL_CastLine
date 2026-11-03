-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, ...) --[[ push | Line: 1 ]]
	local v1 = table.clone(p1)
	for i = 1, select("#", ...) do
		local v2 = select(i, ...)
		if v2 ~= nil then
			table.insert(v1, v2)
		end
	end
	return v1
end