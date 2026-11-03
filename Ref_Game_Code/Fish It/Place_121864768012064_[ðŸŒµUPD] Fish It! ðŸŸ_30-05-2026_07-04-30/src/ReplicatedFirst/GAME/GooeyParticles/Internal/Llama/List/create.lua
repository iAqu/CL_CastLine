-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.intersection(t.integer, t.numberMin(0)), t.any)
return function(p1, p2) --[[ recur | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local t = {}
	for i = 1, p1 do
		t[i] = p2
	end
	return t
end