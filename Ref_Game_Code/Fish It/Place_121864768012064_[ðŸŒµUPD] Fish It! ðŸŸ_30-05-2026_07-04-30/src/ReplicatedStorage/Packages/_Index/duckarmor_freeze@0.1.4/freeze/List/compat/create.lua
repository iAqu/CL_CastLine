-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, p2) --[[ create | Line: 9 | Upvalues: deprecationWarning (copy) ]]
	deprecationWarning("List." .. script.Name, "table.create")
	return table.create(p1, p2)
end