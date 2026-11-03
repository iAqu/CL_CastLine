-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local updateIn = require(script.Parent.updateIn)
local merge = require(script.Parent.merge)
return function(p1, p2, ...) --[[ Line: 5 | Upvalues: updateIn (copy), merge (copy) ]]
	local t = { ... }
	return updateIn(p1, p2, function(p1) --[[ Line: 7 | Upvalues: merge (ref), t (copy) ]]
		return merge(p1, table.unpack(t))
	end, {})
end