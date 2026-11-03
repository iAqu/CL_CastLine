-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3) --[[ slice | Line: 2 ]]
	local v1 = #p1
	local v2 = if p2 and p2 < 0 then v1 + (p2 + 1) else p2 or 1
	local v3 = if p3 and p3 < 0 then v1 + p3 else p3 or v1
	if v2 == 1 and v3 == #p1 then
		return p1
	end
	local t = {}
	local count = 1
	for i = v2, v3 do
		t[count] = p1[i]
		count = count + 1
	end
	return t
end