-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, p3) --[[ set | Line: 17 | Upvalues: maybeFreeze (copy) ]]
	if p1[p2] == p3 then
		return p1
	else
		local v1 = table.clone(p1)
		v1[p2] = p3
		return maybeFreeze(v1)
	end
end