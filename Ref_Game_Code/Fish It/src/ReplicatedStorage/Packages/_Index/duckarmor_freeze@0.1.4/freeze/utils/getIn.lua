-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent.None)
local get = require(script.Parent.get)
return function(p1, p2, p3) --[[ Line: 5 | Upvalues: get (copy), None (copy) ]]
	local count, v1 = 0, p1
	while count ~= #p2 do
		count = count + 1
		local v2 = get(v1, p2[count], None)
		if v2 == None then
			return p3
		end
		v1 = v2
	end
	return v1
end