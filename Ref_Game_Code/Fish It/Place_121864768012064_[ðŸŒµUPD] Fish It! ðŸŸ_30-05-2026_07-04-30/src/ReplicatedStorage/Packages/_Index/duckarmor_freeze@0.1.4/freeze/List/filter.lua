-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ filter | Line: 16 | Upvalues: maybeFreeze (copy) ]]
	local v1 = table.create(#p1)
	for v2, v3 in p1 do
		if p2(v3, v2) then
			table.insert(v1, v3)
		end
	end
	return maybeFreeze(v1)
end