-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local set = require(script.Parent.Parent.utils.set)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, ...) --[[ remove | Line: 18 | Upvalues: set (copy), maybeFreeze (copy) ]]
	local v1 = table.clone(p1)
	for v2, v3 in { ... } do
		v1 = set(v1, v3, nil)
	end
	return maybeFreeze(v1)
end