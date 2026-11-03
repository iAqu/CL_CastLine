-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent:WaitForChild("None"))
return function(p1, p2) --[[ mapValues | Line: 3 | Upvalues: None (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		local v3 = p2(v2, v1)
		if v3 ~= nil and v3 ~= None then
			t[v1] = v3
		end
	end
	return t
end