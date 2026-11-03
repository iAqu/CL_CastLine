-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 10 ]]
	local t = {}
	for v1, v2 in p1 do
		t[v2] = true
	end
	return t
end