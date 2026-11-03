-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isEmpty = require(script.Parent:WaitForChild("isEmpty"))
return function(p1, ...) --[[ remove | Line: 3 | Upvalues: isEmpty (copy) ]]
	local v1 = select("#", ...)
	if v1 == 0 or isEmpty(p1) then
		return p1
	else
		local v2 = nil
		for i = 1, v1 do
			local v3 = select(i, ...)
			if v3 ~= nil and p1[v3] ~= nil then
				local v4 = if v2 then v2 else table.clone(p1)
				v4[v3] = nil
				v2 = v4
			end
		end
		return v2 or p1
	end
end