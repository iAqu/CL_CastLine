-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1, ...) --[[ unshift | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local v2 = select("#", ...)
	local t = {}
	for i = 1, v2 do
		t[i] = select(i, ...)
	end
	for i, v in ipairs(p1) do
		t[v2 + i] = v
	end
	return t
end