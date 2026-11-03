-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1) --[[ keys | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local t = {}
	local count = 1
	for k, v in pairs(p1) do
		t[count] = k
		count = count + 1
	end
	return t
end