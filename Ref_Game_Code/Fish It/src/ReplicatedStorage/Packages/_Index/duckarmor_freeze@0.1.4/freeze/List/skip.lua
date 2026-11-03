-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local slice = require(script.Parent.slice)
return function(p1, p2) --[[ skip | Line: 15 | Upvalues: slice (copy) ]]
	return slice(p1, (math.max(1, p2 + 1)))
end