-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ invert | Line: 1 ]]
	if next(p1) == nil then
		return p1
	end
	local t = {}
	for v1, v2 in p1 do
		t[v2] = v1
	end
	return t
end