-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(...) --[[ equalObjects | Line: 2 ]]
	local v1 = select(1, ...)
	for i = 2, select("#", ...) do
		if v1 ~= select(i, ...) then
			return false
		end
	end
	return true
end