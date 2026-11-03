-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isImmutable = require(script.Parent.isImmutable)
local isDataStructure = require(script.Parent.isDataStructure)
return function(p1, p2) --[[ Line: 5 | Upvalues: isImmutable (copy), isDataStructure (copy) ]]
	if isImmutable(p1) then
		return p1:has(p2)
	end
	return isDataStructure(p1) and p1[p2] ~= nil
end