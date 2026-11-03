-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local utils = script.Parent.Parent.utils
local updateIn = require(utils.updateIn)
local maybeFreeze = require(utils.maybeFreeze)
return function(p1, p2, p3, p4) --[[ Line: 29 | Upvalues: maybeFreeze (copy), updateIn (copy) ]]
	return maybeFreeze(updateIn(p1, p2, p3, p4))
end