-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copy = require(v1.copy)
local t = require(v1.Parent.t)
local v3 = t.tuple(t.table, t.optional(t.callback))
return function(p1, p2) --[[ sort | Line: 9 | Upvalues: v3 (copy), copy (copy) ]]
	assert(v3(p1, p2))
	local v2 = copy(p1)
	table.sort(v2, p2)
	return v2
end