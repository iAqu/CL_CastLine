-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local push = require(script.Parent.Parent.push)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, ...) --[[ append | Line: 10 | Upvalues: deprecationWarning (copy), push (copy) ]]
	deprecationWarning("List." .. script.Name, "List.push")
	return push(p1, ...)
end