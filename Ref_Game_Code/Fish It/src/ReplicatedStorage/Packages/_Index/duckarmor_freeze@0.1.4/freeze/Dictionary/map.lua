-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local map = require(script.Parent.Parent.utils.map)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ map | Line: 19 | Upvalues: maybeFreeze (copy), map (copy) ]]
	return maybeFreeze(map(p1, p2))
end