-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent.Parent
local None = require(v1.None)
local table = require(v1.t).table
return function(...) --[[ merge | Line: 9 | Upvalues: table (copy), None (copy) ]]
	local t = {}
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil then
			assert(table(v1))
			for k, v in pairs(v1) do
				if v == None then
					t[k] = nil
					continue
				end
				t[k] = v
			end
		end
	end
	return t
end