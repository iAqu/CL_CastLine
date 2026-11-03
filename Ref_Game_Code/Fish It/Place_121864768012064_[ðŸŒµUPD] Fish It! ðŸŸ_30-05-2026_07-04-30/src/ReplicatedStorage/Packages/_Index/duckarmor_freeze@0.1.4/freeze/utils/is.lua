-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isValueObject = require(script.Parent.isValueObject)
return function(p1, p2) --[[ Line: 4 | Upvalues: isValueObject (copy) ]]
	if p1 == p2 or p1 ~= p1 and p2 ~= p2 then
		return true
	end
	if not (p1 and p2) then
		return false
	end
	if typeof(p1) == "function" and typeof(p2) == "function" then
		local v1 = p1()
		local v2 = p2()
		if v1 == v2 or v1 ~= v1 and v2 ~= v2 then
			return true
		end
		p2 = v2
		if not (v1 and v2) then
			return false
		end
		p1 = v1
	end
	return isValueObject(p1) and (isValueObject(p2) and p1.equals(p2)) and true or false
end