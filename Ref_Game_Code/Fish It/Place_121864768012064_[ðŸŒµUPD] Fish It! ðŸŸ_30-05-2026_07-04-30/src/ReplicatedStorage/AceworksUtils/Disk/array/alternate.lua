-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local reduce = require(script.Parent:WaitForChild("reduce"))
return function(p1, ...) --[[ alternate | Line: 3 | Upvalues: reduce (copy) ]]
	local t = { ... }
	if #t == 0 then
		return p1
	end
	local v1 = reduce(t, function(p1, p2) --[[ Line: 10 ]]
		return math.min(p1, #p2)
	end, #p1)
	if v1 == 0 then
		return {}
	end
	local t2 = {}
	for i = 1, v1 do
		table.insert(t2, p1[i])
		for v3, v4 in t do
			table.insert(t2, v4[i])
		end
	end
	return t2
end