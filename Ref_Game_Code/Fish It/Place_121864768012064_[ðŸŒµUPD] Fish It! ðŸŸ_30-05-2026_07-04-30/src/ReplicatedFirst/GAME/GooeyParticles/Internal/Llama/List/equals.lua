-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local equalObjects = require(script.Parent.Parent.equalObjects)
local function compare(p1, p2) --[[ compare | Line: 6 ]]
	if type(p1) == "table" and type(p2) == "table" then
		if #p1 ~= #p2 then
			return false
		end
		for i = 1, #p1 do
			if p1[i] ~= p2[i] then
				return false
			end
		end
		return true
	else
		return p1 == p2
	end
end
return function(...) --[[ equals | Line: 26 | Upvalues: equalObjects (copy), compare (copy) ]]
	if equalObjects(...) then
		return true
	end
	local v1 = select("#", ...)
	local v2 = select(1, ...)
	for i = 2, v1 do
		if not compare(v2, (select(i, ...))) then
			return false
		end
	end
	return true
end