-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent.Parent
local None = require(v1.None)
local table = require(v1.t).table
return function(...) --[[ concat | Line: 9 | Upvalues: table (copy), None (copy) ]]
	local t = {}
	local count = 1
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil then
			assert(table(v1))
			for i2, v in ipairs(v1) do
				if v ~= None then
					t[count] = v
					count = count + 1
				end
			end
		end
	end
	return t
end