-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2, p3) --[[ reduceRight | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local v22 = #p1
	local v3, v4
	if p3 == nil then
		v3 = p1[v22]
		v4 = v22 - 1
	else
		v4 = v22
		v3 = p3
	end
	for i = v4, 1, -1 do
		v3 = p2(v3, p1[i], i)
	end
	return v3
end