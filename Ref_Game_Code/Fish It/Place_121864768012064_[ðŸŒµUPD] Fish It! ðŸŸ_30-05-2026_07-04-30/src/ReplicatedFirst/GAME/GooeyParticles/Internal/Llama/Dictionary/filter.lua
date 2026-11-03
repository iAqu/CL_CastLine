-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2) --[[ filter | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local t = {}
	for k, v in pairs(p1) do
		if p2(v, k) then
			t[k] = v
		end
	end
	return t
end