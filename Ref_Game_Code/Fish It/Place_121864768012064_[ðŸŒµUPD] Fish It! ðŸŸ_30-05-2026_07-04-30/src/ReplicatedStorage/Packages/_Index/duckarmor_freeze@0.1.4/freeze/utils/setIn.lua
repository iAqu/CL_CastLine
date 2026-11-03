-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local updateIn = require(script.Parent.updateIn)
local None = require(script.Parent.Parent.None)
return function(p1, p2, p3) --[[ Line: 4 | Upvalues: updateIn (copy), None (copy) ]]
	return updateIn(p1, p2, function() --[[ Line: 5 | Upvalues: p3 (copy) ]]
		return p3
	end, None)
end