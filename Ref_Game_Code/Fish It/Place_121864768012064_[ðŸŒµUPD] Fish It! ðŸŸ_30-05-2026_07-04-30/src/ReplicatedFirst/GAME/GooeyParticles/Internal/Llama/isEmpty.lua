-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.t).table
return function(p1) --[[ isEmpty | Line: 6 | Upvalues: table (copy) ]]
	assert(table(p1))
	return next(p1) == nil
end