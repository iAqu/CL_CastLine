-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1) --[[ toSet | Line: 9 | Upvalues: table (copy) ]]
	assert(table(p1))
	local t = {}
	for i, v in ipairs(p1) do
		t[v] = true
	end
	return t
end