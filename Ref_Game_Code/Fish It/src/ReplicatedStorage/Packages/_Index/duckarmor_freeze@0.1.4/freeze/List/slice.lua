-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local slice = require(script.Parent.Parent.utils.slice)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3) --[[ slice | Line: 29 | Upvalues: maybeFreeze (copy), slice (copy) ]]
	return maybeFreeze(slice(p1, p2, p3))
end