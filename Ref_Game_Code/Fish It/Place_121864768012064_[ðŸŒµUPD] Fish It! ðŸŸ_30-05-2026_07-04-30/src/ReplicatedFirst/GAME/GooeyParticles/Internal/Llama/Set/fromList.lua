-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1) --[[ fromList | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local t = {}
	for i = 1, #p1 do
		t[p1[i]] = true
	end
	return t
end