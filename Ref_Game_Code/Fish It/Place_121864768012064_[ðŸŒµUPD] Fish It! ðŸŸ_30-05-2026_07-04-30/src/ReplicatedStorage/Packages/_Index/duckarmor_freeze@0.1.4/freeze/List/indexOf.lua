-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local keyOf = require(script.Parent.Parent.utils.keyOf)
return function(p1, p2) --[[ indexOf | Line: 15 | Upvalues: keyOf (copy) ]]
	local v1 = keyOf(p1, p2)
	if v1 == nil then
		return nil
	else
		return v1
	end
end