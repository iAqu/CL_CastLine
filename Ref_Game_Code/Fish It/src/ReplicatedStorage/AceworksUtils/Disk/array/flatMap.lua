-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isArray = require(script.Parent:WaitForChild("isArray"))
return function(p1, p2) --[[ flatMap | Line: 3 | Upvalues: isArray (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		local v3 = p2(v2, v1)
		if v3 ~= nil then
			if isArray(v3) then
				for v4, v5 in v3 do
					table.insert(t, v5)
				end
				continue
			end
			table.insert(t, v3)
		end
	end
	return t
end