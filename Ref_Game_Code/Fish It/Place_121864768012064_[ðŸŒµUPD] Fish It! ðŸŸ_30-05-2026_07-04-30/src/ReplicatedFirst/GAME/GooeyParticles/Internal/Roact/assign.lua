-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.None)
return function(p1, ...) --[[ assign | Line: 9 | Upvalues: None (copy) ]]
	for i = 1, select("#", ...) do
		local v1 = select(i, ...)
		if v1 ~= nil then
			for k, v in pairs(v1) do
				if v == None then
					p1[k] = nil
					continue
				end
				p1[k] = v
			end
		end
	end
	return p1
end