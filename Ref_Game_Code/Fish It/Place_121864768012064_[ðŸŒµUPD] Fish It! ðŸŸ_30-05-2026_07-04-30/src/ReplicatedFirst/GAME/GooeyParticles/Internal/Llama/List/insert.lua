-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.optional(t.integer))
return function(p1, p2, ...) --[[ insert | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local v22 = #p1
	if p2 < 1 then
		p2 = v22 + p2
	end
	assert(if p2 > 0 then if p2 <= v22 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", p2, v22))
	local t = {}
	local count = 1
	for i = 1, v22 do
		if i == p2 then
			for j = 1, select("#", ...) do
				t[count] = select(j, ...)
				count = count + 1
			end
		end
		t[count] = p1[i]
		count = count + 1
	end
	return t
end