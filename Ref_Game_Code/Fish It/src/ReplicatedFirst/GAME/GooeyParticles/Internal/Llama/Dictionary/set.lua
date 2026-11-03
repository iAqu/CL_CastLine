-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copy = require(v1.copy)
local t = require(v1.Parent.t)
local v3 = t.tuple(t.table, t.any)
return function(p1, p2, p3) --[[ set | Line: 9 | Upvalues: v3 (copy), copy (copy) ]]
	assert(v3(p1, p2))
	local v2 = copy(p1)
	v2[p2] = p3
	return v2
end