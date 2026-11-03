-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
return function(...) --[[ intersection | Line: 8 | Upvalues: table (copy) ]]
	local v1 = select("#", ...)
	local v2 = select(1, ...)
	assert(table(v2))
	local t = {}
	for k, v in pairs(v2) do
		local v4 = true
		for i = 2, v1 do
			local v5 = select(i, ...)
			assert(table(v5))
			if v5[k] == nil then
				v4 = false
				break
			end
		end
		if v4 then
			t[k] = true
		end
	end
	return t
end