-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local equalObjects = require(script.Parent.equalObjects)
local function v1(p1, p2) --[[ compareDeep | Line: 4 | Upvalues: v1 (copy) ]]
	if type(p1) == "table" and type(p2) == "table" then
		for k, v in pairs(p1) do
			if not v1(p2[k], v) then
				return false
			end
		end
		for k, v in pairs(p2) do
			if not v1(p1[k], v) then
				return false
			end
		end
		return true
	else
		return p1 == p2
	end
end
return function(...) --[[ equalsDeep | Line: 24 | Upvalues: equalObjects (copy), v1 (copy) ]]
	if equalObjects(...) then
		return true
	end
	local v12 = select("#", ...)
	local v2 = select(1, ...)
	for i = 2, v12 do
		if not v1(v2, (select(i, ...))) then
			return false
		end
	end
	return true
end