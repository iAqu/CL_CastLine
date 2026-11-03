-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local isSubset = require(v1.isSubset)
local t = require(v1.Parent.t)
local v3 = t.tuple(t.table, t.table)
return function(p1, p2) --[[ isSuperset | Line: 10 | Upvalues: v3 (copy), isSubset (copy) ]]
	assert(v3(p1, p2))
	return isSubset(p2, p1)
end