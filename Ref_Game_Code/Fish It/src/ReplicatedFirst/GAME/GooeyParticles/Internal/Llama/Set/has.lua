-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.any)
return function(p1, p2) --[[ has | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	return p1[p2] == true
end