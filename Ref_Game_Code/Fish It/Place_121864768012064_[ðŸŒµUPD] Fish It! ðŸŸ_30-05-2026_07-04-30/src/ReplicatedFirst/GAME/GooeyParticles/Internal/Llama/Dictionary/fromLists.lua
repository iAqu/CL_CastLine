-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.table)
return function(p1, p2) --[[ fromLists | Line: 9 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local v22 = #p1
	assert(v22 == #p2, "lists must be same size")
	local t = {}
	for i = 1, v22 do
		t[p1[i]] = p2[i]
	end
	return t
end