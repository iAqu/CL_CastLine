-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copy = require(v1.copy)
local table = require(v1.Parent.t).table
return function(p1, p2) --[[ removeKey | Line: 9 | Upvalues: table (copy), copy (copy) ]]
	assert(table(p1))
	local v2 = copy(p1)
	v2[p2] = nil
	return v2
end