-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local set = require(script.Parent.Parent.utils.set)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3) --[[ set | Line: 16 | Upvalues: maybeFreeze (copy), set (copy) ]]
	if p2 == nil then
		return p1
	else
		return maybeFreeze(set(p1, p2, p3))
	end
end