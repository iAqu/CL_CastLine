-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Keys | Line: 20 ]]
	local t = {}
	for k, v in pairs(p1) do
		table.insert(t, k)
	end
	return t
end