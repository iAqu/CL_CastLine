-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, ...) --[[ concat | Line: 1 ]]
	local v1 = nil
	for i = 1, select("#", ...) do
		local v2 = select(i, ...)
		if v2 ~= nil and #v2 > 0 then
			v1 = if v1 then v1 else table.clone(p1)
			for v4, v5 in v2 do
				table.insert(v1, v5)
			end
		end
	end
	return v1 or p1
end