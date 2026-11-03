-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent.None)
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(...) --[[ concat | Line: 16 | Upvalues: None (copy), maybeFreeze (copy) ]]
	local t = {}
	local count = 1
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil and (type(v1) == "table" and #v1 > 0) then
			for i2, v in ipairs(v1) do
				if v ~= None then
					t[count] = v
					count = count + 1
				end
			end
		end
	end
	return maybeFreeze(t)
end