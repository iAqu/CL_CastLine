-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local updateIn = require(script.Parent.Parent.utils.updateIn)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3, p4) --[[ updateIn | Line: 31 | Upvalues: maybeFreeze (copy), updateIn (copy) ]]
	return maybeFreeze(updateIn(p1, p2, p3, p4))
end