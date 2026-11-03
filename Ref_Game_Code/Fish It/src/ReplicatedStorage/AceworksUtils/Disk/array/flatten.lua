-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isArray = require(script.Parent:WaitForChild("isArray"))
local function v1(p1, p2) --[[ flatten | Line: 3 | Upvalues: isArray (copy), v1 (copy) ]]
	local v12 = if p2 == nil then (1 / 0) else p2
	if v12 == 0 then
		return p1
	end
	local t = {}
	for v2, v3 in p1 do
		if isArray(v3) then
			for v5, v6 in if v12 > 1 then v1(v3) else v3 do
				table.insert(t, v6)
			end
			continue
		end
		table.insert(t, v3)
	end
	return t
end
return v1