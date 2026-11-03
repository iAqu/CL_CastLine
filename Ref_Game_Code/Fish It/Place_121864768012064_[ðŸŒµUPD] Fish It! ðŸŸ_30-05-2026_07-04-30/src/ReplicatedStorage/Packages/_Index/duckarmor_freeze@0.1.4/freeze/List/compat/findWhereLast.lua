-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local reverse = require(script.Parent.Parent.reverse)
local find = require(script.Parent.Parent.find)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, p2, p3) --[[ findWhereLast | Line: 11 | Upvalues: deprecationWarning (copy), reverse (copy), find (copy) ]]
	assert(if p3 == nil then true else false, "[Freeze] findWhereLast\'s `from` argument is not supported.")
	deprecationWarning("List." .. script.Name, "List.reverse and then List.find")
	return find(reverse(p1), p2)
end