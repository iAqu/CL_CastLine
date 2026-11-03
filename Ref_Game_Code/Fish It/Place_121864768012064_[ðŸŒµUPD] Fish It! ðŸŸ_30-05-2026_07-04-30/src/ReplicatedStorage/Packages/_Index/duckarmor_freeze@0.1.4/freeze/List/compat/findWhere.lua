-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local find = require(script.Parent.Parent.find)
local deprecationWarning = require(script.Parent.Parent.Parent.utils.deprecationWarning)
return function(p1, p2, p3) --[[ findWhere | Line: 10 | Upvalues: deprecationWarning (copy), find (copy) ]]
	assert(if p3 == nil then true else false, "[Freeze] findWhere\'s `from` argument is not supported.")
	deprecationWarning("List." .. script.Name, "List.find")
	return find(p1, p2)
end