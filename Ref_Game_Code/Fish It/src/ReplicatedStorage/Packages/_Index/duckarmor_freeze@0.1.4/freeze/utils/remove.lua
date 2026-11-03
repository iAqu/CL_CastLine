-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local isImmutable = require(script.Parent.isImmutable)
local isDataStructure = require(script.Parent.isDataStructure)
local shallowCopy = require(script.Parent.shallowCopy)
return function(p1, p2) --[[ Line: 6 | Upvalues: isDataStructure (copy), isImmutable (copy), shallowCopy (copy) ]]
	if not isDataStructure(p1) then
		error("Cannot update non-data-structure value: " .. tostring(p1))
	end
	if isImmutable(p1) then
		if not p1.remove then
			error("Cannot update immutable value without .remove() method: " .. tostring(p1))
		end
		return p1:remove(p2)
	else
		if not p1[p2] then
			return p1
		end
		local v1 = shallowCopy(p1)
		if #v1 > 0 then
			table.remove(p1, p2)
		else
			p1[p2] = nil
		end
		return v1
	end
end