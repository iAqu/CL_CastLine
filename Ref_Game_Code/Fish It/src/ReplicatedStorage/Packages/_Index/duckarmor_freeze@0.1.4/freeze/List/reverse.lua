-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1) --[[ reverse | Line: 14 | Upvalues: maybeFreeze (copy) ]]
	local v1 = #p1
	local v2 = table.create(v1)
	local v3 = v1 + 1
	for v4, v5 in p1 do
		v2[v4] = p1[v3 - v4]
	end
	return maybeFreeze(v2)
end