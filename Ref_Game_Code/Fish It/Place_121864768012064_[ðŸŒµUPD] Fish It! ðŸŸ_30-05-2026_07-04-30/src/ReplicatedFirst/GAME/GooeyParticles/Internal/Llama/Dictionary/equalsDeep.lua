-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local equalObjects = require(script.Parent.Parent.equalObjects)
local function v2(p1, p2) --[[ compareDeep | Line: 6 | Upvalues: v2 (copy) ]]
	if type(p1) == "table" and type(p2) == "table" then
		for k, v in pairs(p1) do
			if not v2(p2[k], v) then
				return false
			end
		end
		for k, v in pairs(p2) do
			if not v2(p1[k], v) then
				return false
			end
		end
		return true
	else
		return p1 == p2
	end
end
return function(...) --[[ equalsDeep | Line: 26 | Upvalues: equalObjects (copy), v2 (copy) ]]
	if equalObjects(...) then
		return true
	end
	local v1 = select("#", ...)
	local v22 = select(1, ...)
	for i = 2, v1 do
		if not v2(v22, (select(i, ...))) then
			return false
		end
	end
	return true
end