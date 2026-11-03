-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(...) --[[ zip | Line: 8 | Upvalues: table (copy) ]]
	local t = {}
	local v1 = select("#", ...)
	if v1 <= 0 then
		return t
	end
	local v2 = select(1, ...)
	assert(table(v2))
	local v4 = #v2
	for i = 2, v1 do
		local v5 = select(i, ...)
		assert(table(v5))
		local v7 = #v5
		if v7 < v4 then
			v4 = v7
		end
	end
	for j = 1, v4 do
		t[j] = {}
		for k = 1, v1 do
			t[j][k] = select(k, ...)[j]
		end
	end
	return t
end