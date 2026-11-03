-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ pop | Line: 20 | Upvalues: maybeFreeze (copy) ]]
	local v1 = math.max(1, p2 or 1)
	local v2 = #p1
	local v3 = table.create(v2)
	for i = 1, v2 - v1 do
		v3[i] = p1[i]
	end
	return maybeFreeze(v3)
end