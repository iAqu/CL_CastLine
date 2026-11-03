-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
return function(p1, p2, ...) --[[ insert | Line: 16 | Upvalues: maybeFreeze (copy) ]]
	local v1 = #p1
	if p2 < 1 then
		p2 = v1 + p2
	end
	local v3, v4, count = math.clamp(p2, 1, v1 + 1), {}, 1
	for i = 1, v1 + 1 do
		if i == v3 then
			for j = 1, select("#", ...) do
				v4[count] = select(j, ...)
				count = count + 1
			end
		end
		v4[count] = p1[i]
		count = count + 1
	end
	return maybeFreeze(v4)
end