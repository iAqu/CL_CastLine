-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1, p2) --[[ includes | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	for k, v in pairs(p1) do
		if v == p2 then
			return true
		end
	end
	return false
end