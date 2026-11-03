-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))
return function(p1, p2) --[[ shift | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local v22 = #p1
	local v3 = p2 or 1
	assert(if v3 > 0 then if v3 <= v22 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", v3, v22))
	local t = {}
	for i = 1 + v3, v22 do
		t[i - v3] = p1[i]
	end
	return t
end