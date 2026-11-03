-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local reduce = require(script.Parent.Parent.utils.reduce)
return function(p1, p2, p3) --[[ reduceRight | Line: 18 | Upvalues: reduce (copy) ]]
	return reduce(p1, p2, p3, true)
end