-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2) --[[ some | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	for i = 1, #p1 do
		if p2(p1[i], i) then
			return true
		end
	end
	return false
end