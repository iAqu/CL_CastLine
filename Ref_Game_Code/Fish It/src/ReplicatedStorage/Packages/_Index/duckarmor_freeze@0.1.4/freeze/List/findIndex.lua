-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local findPair = require(script.Parent.Parent.utils.findPair)
return function(p1, p2) --[[ findIndex | Line: 17 | Upvalues: findPair (copy) ]]
	local v1, _ = findPair(p1, p2)
	return v1
end