-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, ...) --[[ push | Line: 14 | Upvalues: maybeFreeze (copy) ]]
	if #{ ... } == 0 then
		return p1
	end
	local v1 = table.clone(p1)
	for v2, v3 in { ... } do
		table.insert(v1, v3)
	end
	return maybeFreeze(v1)
end