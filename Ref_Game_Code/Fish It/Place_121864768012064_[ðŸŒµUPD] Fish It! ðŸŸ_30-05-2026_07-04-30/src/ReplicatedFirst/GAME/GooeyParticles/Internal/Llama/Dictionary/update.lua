-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local copy = require(v1.copy)
local t = require(v1.Parent.t)
local function noUpdate(p1) --[[ noUpdate | Line: 7 ]]
	return p1
end
local function call(p1, ...) --[[ call | Line: 11 ]]
	if type(p1) == "function" then
		return p1(...)
	end
end
local v3 = t.optional(t.callback)
local v4 = t.tuple(t.table, t.any, v3, v3)
return function(p1, p2, p3, p4) --[[ update | Line: 20 | Upvalues: v4 (copy), noUpdate (copy), copy (copy), call (copy) ]]
	assert(v4(p1, p2, p3, p4))
	local v2 = if p3 then p3 else noUpdate
	local v3 = copy(p1)
	if v3[p2] == nil then
		v3[p2] = call(p4, p2)
	else
		v3[p2] = v2(v3[p2], p2)
	end
	return v3
end