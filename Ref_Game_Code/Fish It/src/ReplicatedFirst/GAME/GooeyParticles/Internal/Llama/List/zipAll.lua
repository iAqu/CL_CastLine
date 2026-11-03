-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent.Parent
local None = require(v1.None)
local table = require(v1.t).table
return function(...) --[[ zipAll | Line: 9 | Upvalues: table (copy), None (copy) ]]
	local v1 = select("#", ...)
	local v2 = 0
	local t = {}
	for i = 1, v1 do
		local v3 = select(i, ...)
		assert(table(v3))
		local v5 = #v3
		if v2 < v5 then
			v2 = v5
		end
	end
	for j = 1, v2 do
		t[j] = {}
		for k = 1, v1 do
			if select(k, ...)[j] == nil then
				t[j][k] = None
				continue
			end
			t[j][k] = select(k, ...)[j]
		end
	end
	return t
end