-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local update = require(script.Parent.Parent.utils.update)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3, p4) --[[ update | Line: 24 | Upvalues: maybeFreeze (copy), update (copy) ]]
	return maybeFreeze(update(p1, p2, p3, p4))
end