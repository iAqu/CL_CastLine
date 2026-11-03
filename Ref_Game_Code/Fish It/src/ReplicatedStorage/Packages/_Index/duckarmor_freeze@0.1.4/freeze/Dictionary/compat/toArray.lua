-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local values = require(script.Parent.Parent.values)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1) --[[ toArray | Line: 10 | Upvalues: deprecationWarning (copy), values (copy) ]]
	deprecationWarning("Dictionary." .. script.Name, "Dictionary.values")
	return values(p1)
end