-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent.None)
local isDataStructure = require(script.Parent.Parent.utils.isDataStructure)
local slice = require(script.Parent.slice)
local get = require(script.Parent.get)
local remove = require(script.Parent:FindFirstChild("remove"))
local set = require(script.Parent.set)
local function toString(p1) --[[ toString | Line: 12 ]]
	return table.concat(p1, ", ")
end
local function v2(p1, p2, p3, p4, p5) --[[ updateInDeeply | Line: 16 | Upvalues: None (copy), isDataStructure (copy), slice (copy), get (copy), v2 (copy), remove (copy), set (copy) ]]
	local v1 = if p1 == None then true else false
	if p3 == #p2 + 1 then
		local v22 = if v1 then p5 else p1
		local v3 = p4(v22)
		if v3 == v22 then
			return p1
		else
			return v3
		end
	else
		if not (v1 or isDataStructure(p1)) then
			local v4 = error
			local v5 = slice(p2, 1, p3 - 1)
			v4("Cannot update within non-data-structure value in path [" .. table.concat(v5, ", ") .. "]: " .. tostring(p1))
		end
		local v6 = p2[p3]
		local v7 = if v1 then None else get(p1, v6, None)
		local v8 = v2(v7, p2, p3 + 1, p4, p5)
		if v8 == v7 then
			return p1
		end
		if v8 == None then
			return remove(p1, v6)
		end
		return set(if v1 then {} else p1, v6, v8)
	end
end
return function(p1, p2, p3, p4) --[[ Line: 49 | Upvalues: v2 (copy), None (copy) ]]
	local v1 = v2(p1, p2, 1, p3, p4)
	if v1 == None then
		return p4
	else
		return v1
	end
end