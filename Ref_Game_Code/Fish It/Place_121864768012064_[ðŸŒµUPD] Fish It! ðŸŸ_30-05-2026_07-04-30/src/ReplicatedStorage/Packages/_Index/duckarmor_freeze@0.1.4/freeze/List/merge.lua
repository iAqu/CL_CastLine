-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local merge = require(script.Parent.Parent.utils.merge)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(...) --[[ merge | Line: 21 | Upvalues: maybeFreeze (copy), merge (copy) ]]
	return maybeFreeze(merge(...))
end