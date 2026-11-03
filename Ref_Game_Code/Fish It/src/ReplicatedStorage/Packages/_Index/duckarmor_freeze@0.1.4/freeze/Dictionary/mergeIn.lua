-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local mergeIn = require(script.Parent.Parent.utils.mergeIn)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, ...) --[[ mergeIn | Line: 25 | Upvalues: maybeFreeze (copy), mergeIn (copy) ]]
	return maybeFreeze(mergeIn(p1, p2, ...))
end