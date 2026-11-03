-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ filter | Line: 16 | Upvalues: maybeFreeze (copy) ]]
	local t = {}
	for v1, v2 in p1 do
		if p2(v2, v1) == true then
			t[v1] = v2
		end
	end
	return maybeFreeze(t)
end