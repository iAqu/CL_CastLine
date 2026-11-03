-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ shift | Line: 17 | Upvalues: maybeFreeze (copy) ]]
	local v1 = #p1
	local v2 = math.min(v1, p2 or 1)
	local v3 = table.create(v1 - v2)
	for i = v2 + 1, v1 do
		v3[i - v2] = p1[i]
	end
	return maybeFreeze(v3)
end