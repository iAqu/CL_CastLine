-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local remove = require(script.Parent.Parent:FindFirstChild("remove"))
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, p2) --[[ removeIndex | Line: 10 | Upvalues: deprecationWarning (copy), remove (copy) ]]
	deprecationWarning("List." .. script.Name, "List.remove")
	return remove(p1, p2)
end