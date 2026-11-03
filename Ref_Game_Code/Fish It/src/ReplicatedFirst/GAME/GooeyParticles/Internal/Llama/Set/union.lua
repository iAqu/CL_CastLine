-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(...) --[[ union | Line: 8 | Upvalues: table (copy) ]]
	local t = {}
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		assert(table(v1))
		for k, v in pairs(v1) do
			t[k] = true
		end
	end
	return t
end