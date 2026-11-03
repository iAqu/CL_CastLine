-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isImmutable = require(script.Parent.isImmutable)
return function(p1) --[[ Line: 4 | Upvalues: isImmutable (copy) ]]
	if isImmutable(p1) then
		return p1:clone()
	else
		return table.clone(p1)
	end
end