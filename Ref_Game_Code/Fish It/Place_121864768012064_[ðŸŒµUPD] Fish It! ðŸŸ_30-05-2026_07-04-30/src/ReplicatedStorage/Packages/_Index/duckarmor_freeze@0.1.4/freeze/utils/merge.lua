-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent.None)
return function(...) --[[ Line: 4 | Upvalues: None (copy) ]]
	local t = {}
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil then
			assert(if type(v1) == "table" then true else false, "Expected table")
			for v3, v4 in v1 do
				if v4 == None then
					t[v3] = nil
					continue
				end
				t[v3] = v4
			end
		end
	end
	return t
end