-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent.Parent
local t = require(v1.t)
local toSet = require(v1.List.toSet)
local table = t.table
return function(p1, ...) --[[ removeValues | Line: 11 | Upvalues: table (copy), toSet (copy) ]]
	assert(table(p1))
	local v2 = toSet({ ... })
	local t = {}
	for k, v in pairs(p1) do
		if not v2[v] then
			t[k] = v
		end
	end
	return t
end