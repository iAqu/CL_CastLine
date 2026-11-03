-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local toSet = require(v1.toSet)
local table = require(v1.Parent.t).table
return function(p1, ...) --[[ removeValue | Line: 9 | Upvalues: table (copy), toSet (copy) ]]
	assert(table(p1))
	local v2 = toSet({ ... })
	local t = {}
	local count = 1
	for i, v in ipairs(p1) do
		if not v2[v] then
			t[count] = v
			count = count + 1
		end
	end
	return t
end