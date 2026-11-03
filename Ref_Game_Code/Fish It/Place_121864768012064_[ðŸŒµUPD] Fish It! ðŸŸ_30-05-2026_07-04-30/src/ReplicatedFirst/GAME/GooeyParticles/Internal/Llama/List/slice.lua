-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.optional(t.integer)
local v3 = t.tuple(t.table, v2, v2)
return function(p1, p2, p3) --[[ slice | Line: 9 | Upvalues: v3 (copy) ]]
	assert(v3(p1, p2, p3))
	local v2 = #p1
	local sum = p2 or 1
	local sum_2 = p3 or v2
	if sum < 1 then
		sum = v2 + sum
	end
	if sum_2 < 1 then
		sum_2 = v2 + sum_2
	end
	assert(if sum > 0 then if sum <= v2 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", sum, v2))
	assert(if sum_2 > 0 then if sum_2 <= v2 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", sum_2, v2))
	assert(if sum <= sum_2 then true else false, string.format("start index %d cannot be greater than end index %d", sum, sum_2))
	local t = {}
	local count = 1
	for i = sum, sum_2 do
		t[count] = p1[i]
		count = count + 1
	end
	return t
end