-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ joinAsString | Line: 15 ]]
	local t = {}
	for v1, v2 in p1 do
		local format = string.format
		local v3 = tostring(v1)
		table.insert(t, format("%s=%s", v3, (tostring(v2))))
	end
	return table.concat(t, p2 or ",")
end