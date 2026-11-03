-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.optional(t.integer)
local v3 = t.tuple(t.table, v2, v2)
return function(p1, p2, p3, ...) --[[ splice | Line: 9 | Upvalues: v3 (copy) ]]
	assert(v3(p1, p2, p3))
	local v2 = #p1
	local sum = p2 or 1
	local v32 = if p3 then p3 else v2 + 1
	if sum < 1 then
		sum = v2 + sum
	end
	local v4 = if v32 < 1 then v2 + v32 else v32
	assert(if sum > 0 then if sum <= v2 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", sum, v2))
	assert(if v4 > 0 then if v4 <= v2 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", v4, v2))
	assert(if sum <= v4 then true else false, string.format("start index %d cannot be greater than end index %d", sum, v4))
	local t = {}
	local count = 1
	for i = 1, sum - 1 do
		t[count] = p1[i]
		count = count + 1
	end
	for j = 1, select("#", ...) do
		t[count] = select(j, ...)
		count = count + 1
	end
	for k = v4 + 1, v2 do
		t[count] = p1[k]
		count = count + 1
	end
	return t
end