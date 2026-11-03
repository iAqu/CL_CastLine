-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local reduce = require(script.Parent:WaitForChild("reduce"))
return function(p1, ...) --[[ zip | Line: 3 | Upvalues: reduce (copy) ]]
	local t = { ... }
	local v1 = reduce(t, function(p1, p2) --[[ Line: 6 ]]
		return math.min(p1, #p2)
	end, #p1)
	if v1 == 0 then
		return {}
	end
	local t2 = {}
	for i = 1, v1 do
		local t3 = { p1[i] }
		for v2, v3 in t do
			table.insert(t3, v3[i])
		end
		table.insert(t2, t3)
	end
	return t2
end