-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1, ...) --[[ push | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local v2 = #p1
	local t = {}
	for i = 1, v2 do
		t[i] = p1[i]
	end
	for j = 1, select("#", ...) do
		t[v2 + j] = select(j, ...)
	end
	return t
end