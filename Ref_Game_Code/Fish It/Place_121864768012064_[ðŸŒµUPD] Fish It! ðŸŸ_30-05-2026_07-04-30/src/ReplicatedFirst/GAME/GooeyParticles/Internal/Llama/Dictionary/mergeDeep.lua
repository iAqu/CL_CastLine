-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copyDeep = require(v1.copyDeep)
local None = require(script.Parent.Parent.None)
local table = require(v1.Parent.t).table
local function v3(...) --[[ mergeDeep | Line: 10 | Upvalues: table (copy), None (copy), copyDeep (copy), v3 (copy) ]]
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
				if type(v) == "table" then
					if t[k] ~= nil and type(t[k]) == "table" then
						t[k] = v3(t[k], v)
						continue
					end
					t[k] = copyDeep(v)
					continue
				end
				t[k] = v
			end
		end
	end
	return t
end
return v3