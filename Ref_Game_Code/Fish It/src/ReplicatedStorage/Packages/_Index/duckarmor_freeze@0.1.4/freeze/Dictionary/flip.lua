-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1) --[[ flip | Line: 14 | Upvalues: maybeFreeze (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		t[v2] = v1
	end
	return maybeFreeze(t)
end