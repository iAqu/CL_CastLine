-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local merge = require(script.Parent.Parent.merge)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(...) --[[ join | Line: 10 | Upvalues: deprecationWarning (copy), merge (copy) ]]
	deprecationWarning("Dictionary." .. script.Name, "Dictionary.merge")
	return merge(...)
end