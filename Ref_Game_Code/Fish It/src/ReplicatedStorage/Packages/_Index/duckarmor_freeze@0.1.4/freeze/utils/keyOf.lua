-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local findKey = require(script.Parent.findKey)
local is = require(script.Parent.is)
return function(p1, p2) --[[ Line: 4 | Upvalues: findKey (copy), is (copy) ]]
	return findKey(p1, function(p1) --[[ Line: 5 | Upvalues: is (ref), p2 (copy) ]]
		return is(p1, p2)
	end)
end