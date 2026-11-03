-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local removeValue = require(script.Parent.Parent.removeValue)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, ...) --[[ removeValues | Line: 10 | Upvalues: deprecationWarning (copy), removeValue (copy) ]]
	deprecationWarning("List." .. script.Name, "List.removeValue")
	return removeValue(p1, ...)
end