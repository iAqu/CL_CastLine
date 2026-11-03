-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local filter = require(script.Parent.filter)
return function(p1, p2) --[[ filterNot | Line: 17 | Upvalues: filter (copy) ]]
	return filter(p1, function(p1, p22) --[[ Line: 18 | Upvalues: p2 (copy) ]]
		return not p2(p1, p22)
	end)
end