-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(p1, p2) --[[ removeValue | Line: 8 | Upvalues: table (copy) ]]
	assert(table(p1))
	local t = {}
	local count = 1
	for i, v in ipairs(p1) do
		if v ~= p2 then
			t[count] = v
			count = count + 1
		end
	end
	return t
end