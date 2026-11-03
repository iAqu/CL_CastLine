-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1, ...) --[[ add | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local t = {}
	for k, v in pairs(p1) do
		t[k] = true
	end
	for i = 1, select("#", ...) do
		t[select(i, ...)] = true
	end
	return t
end