-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, ...) --[[ unshift | Line: 14 | Upvalues: maybeFreeze (copy) ]]
	local v1 = select("#", ...)
	local v2 = table.clone(p1)
	for i = v1, 1, -1 do
		table.insert(v2, 1, (select(i, ...)))
	end
	return maybeFreeze(v2)
end