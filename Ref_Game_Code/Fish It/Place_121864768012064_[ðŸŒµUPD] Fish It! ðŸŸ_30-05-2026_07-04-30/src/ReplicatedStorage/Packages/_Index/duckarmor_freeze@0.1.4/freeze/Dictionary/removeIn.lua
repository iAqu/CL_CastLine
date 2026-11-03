-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local removeIn = require(script.Parent.Parent.utils.removeIn)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ removeIn | Line: 16 | Upvalues: maybeFreeze (copy), removeIn (copy) ]]
	return maybeFreeze(removeIn(p1, p2))
end