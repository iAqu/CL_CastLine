-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2) --[[ removeValue | Line: 14 | Upvalues: maybeFreeze (copy) ]]
	local t = {}
	local v1 = false
	for v2, v3 in p1 do
		if v3 == p2 then
			v1 = true
			continue
		end
		t[v2] = v3
	end
	if v1 then
		return maybeFreeze(t)
	else
		return p1
	end
end