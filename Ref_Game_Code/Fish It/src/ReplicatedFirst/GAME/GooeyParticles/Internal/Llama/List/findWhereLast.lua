-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback, t.optional(t.integer))
return function(p1, p2, p3) --[[ findWhereLast | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2, p3))
	local v22 = #p1
	if v22 <= 0 then
		return nil
	end
	local sum = p3 or v22
	if sum < 1 then
		sum = v22 + sum
	end
	assert(if sum > 0 then if sum <= v22 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", sum, v22))
	for i = sum, 1, -1 do
		if p2(p1[i], i) then
			return i
		end
	end
	return nil
end