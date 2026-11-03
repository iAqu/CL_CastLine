-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ sort | Line: 16 | Upvalues: maybeFreeze (copy) ]]
	local v1 = table.clone(p1)
	table.sort(v1, p2)
	return maybeFreeze(v1)
end