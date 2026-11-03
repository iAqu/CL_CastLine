-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local map = require(script.Parent:WaitForChild("map"))
return function(p1, p2) --[[ sortByKey | Line: 5 | Upvalues: map (copy) ]]
	if #p1 <= 1 then
		return p1
	end
	local v1 = map(p1, function(p1) --[[ Line: 9 | Upvalues: p2 (copy) ]]
		return {
			key = p2(p1),
			element = p1
		}
	end)
	table.sort(v1, function(p1, p2) --[[ Line: 16 ]]
		return p1.key < p2.key
	end)
	for v2, v3 in v1 do
		v1[v2] = v3.element
	end
	return v1
end