-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1) --[[ last | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	return p1[#p1]
end