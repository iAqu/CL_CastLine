-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local table = t.table
local integer = t.integer
return function(p1, ...) --[[ removeIndices | Line: 9 | Upvalues: table (copy), integer (copy) ]]
	assert(table(p1))
	local v2 = #p1
	local t = {}
	for i = 1, select("#", ...) do
		local sum = select(i, ...)
		assert(integer(sum))
		if sum < 1 then
			sum = v2 + sum
		end
		assert(if sum > 0 then if sum <= v2 then true else false else false, string.format("index %d out of bounds of list of length %d", sum, v2))
		t[sum] = true
	end
	local t2 = {}
	local count = 1
	for j = 1, v2 do
		if not t[j] then
			t2[count] = p1[j]
			count = count + 1
		end
	end
	return t2
end