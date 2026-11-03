-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local getIn = require(script.Parent.Parent.utils.getIn)
local None = require(script.Parent.Parent.None)
return function(p1, p2) --[[ hasIn | Line: 16 | Upvalues: getIn (copy), None (copy) ]]
	return getIn(p1, p2, None) ~= None
end