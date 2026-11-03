-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2, p3) --[[ reduce | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local v22, v3
	if p3 == nil then
		v22 = p1[1]
		v3 = 2
	else
		v3 = 1
		v22 = p3
	end
	for i = v3, #p1 do
		v22 = p2(v22, p1[i], i)
	end
	return v22
end