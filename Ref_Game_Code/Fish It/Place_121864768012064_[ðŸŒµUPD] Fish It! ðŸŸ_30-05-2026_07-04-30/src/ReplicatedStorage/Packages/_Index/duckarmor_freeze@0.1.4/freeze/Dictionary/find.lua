-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local findPair = require(script.Parent.Parent.utils.findPair)
return function(p1, p2, p3) --[[ find | Line: 16 | Upvalues: findPair (copy) ]]
	local _, v1 = findPair(p1, p2)
	if v1 == nil then
		return p3
	else
		return v1
	end
end