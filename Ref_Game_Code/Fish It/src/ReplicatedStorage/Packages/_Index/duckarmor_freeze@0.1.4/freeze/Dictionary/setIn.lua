-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local setIn = require(script.Parent.Parent.utils.setIn)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3) --[[ setIn | Line: 24 | Upvalues: maybeFreeze (copy), setIn (copy) ]]
	return maybeFreeze(setIn(p1, p2, p3))
end