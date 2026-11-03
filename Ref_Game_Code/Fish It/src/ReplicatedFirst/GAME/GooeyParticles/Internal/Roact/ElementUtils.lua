-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Type = require(script.Parent.Type)
local Symbol = require(script.Parent.Symbol)
local function noop() --[[ noop | Line: 4 ]]
	return nil
end
local t = {
	UseParentKey = Symbol.named("UseParentKey")
}
function t.iterateElements(p1) --[[ iterateElements | Line: 40 | Upvalues: Type (copy), t (copy), noop (copy) ]]
	if Type.of(p1) == Type.Element then
		local v1 = false
		return function() --[[ Line: 47 | Upvalues: v1 (ref), t (ref), p1 (copy) ]]
			if v1 then
				return nil
			else
				v1 = true
				return t.UseParentKey, p1
			end
		end
	end
	local v2 = typeof(p1)
	if p1 == nil or v2 == "boolean" then
		return noop
	end
	if v2 == "table" then
		return pairs(p1)
	else
		error("Invalid elements")
	end
end
function t.getElementByKey(p1, p2) --[[ getElementByKey | Line: 79 | Upvalues: Type (copy), t (copy) ]]
	if p1 == nil or typeof(p1) == "boolean" then
		return nil
	end
	if Type.of(p1) == Type.Element then
		if p2 == t.UseParentKey then
			return p1
		else
			return nil
		end
	elseif typeof(p1) == "table" then
		return p1[p2]
	else
		error("Invalid elements")
	end
end
return t