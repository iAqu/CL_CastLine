-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copyDeep = require(v1.copyDeep)
local v2 = v1.Parent
local None = require(v2.None)
local table = require(v2.t).table
return function(...) --[[ concatDeep | Line: 10 | Upvalues: table (copy), None (copy), copyDeep (copy) ]]
	local t = {}
	local count = 1
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil then
			assert(table(v1))
			for i2, v in ipairs(v1) do
				if v ~= None then
					if type(v) == "table" then
						t[count] = copyDeep(v)
					else
						t[count] = v
					end
					count = count + 1
				end
			end
		end
	end
	return t
end