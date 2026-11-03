-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(...) --[[ zip | Line: 19 | Upvalues: maybeFreeze (copy) ]]
	local v1 = select(1, ...)
	local t = {}
	local v2 = select("#", ...)
	if v2 <= 0 then
		return t
	end
	local v3 = #v1
	for i = 2, v2 do
		local v4 = #select(i, ...)
		if v4 < v3 then
			v3 = v4
		end
	end
	for j = 1, v3 do
		t[j] = {}
		for k = 1, v2 do
			t[j][k] = select(k, ...)[j]
		end
	end
	return maybeFreeze(t)
end