-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1) --[[ reverse | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local v2 = #p1 + 1
	local t = {}
	for i, v in ipairs(p1) do
		t[i] = p1[v2 - i]
	end
	return t
end