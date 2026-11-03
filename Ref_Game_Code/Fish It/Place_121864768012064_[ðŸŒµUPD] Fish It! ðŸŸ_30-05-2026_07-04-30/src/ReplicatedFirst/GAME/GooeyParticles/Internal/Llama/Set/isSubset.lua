-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.table)
return function(p1, p2) --[[ isSubset | Line: 9 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	for k, v in pairs(p1) do
		if p2[k] ~= v then
			return false
		end
	end
	return true
end