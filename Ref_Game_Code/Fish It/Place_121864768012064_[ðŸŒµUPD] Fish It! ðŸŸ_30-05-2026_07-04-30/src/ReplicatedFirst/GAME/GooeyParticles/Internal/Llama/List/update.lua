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
local v4 = t.tuple(t.table, t.integer, v3, v3)
return function(p1, p2, p3, p4) --[[ update | Line: 20 | Upvalues: v4 (copy), noUpdate (copy), copy (copy), call (copy) ]]
	assert(v4(p1, p2, p3, p4))
	local v2 = #p1
	if p2 < 0 then
		p2 = v2 + p2
	end
	assert(if p2 > 0 then if p2 <= v2 + 1 then true else false else false, string.format("index %d out of bounds of list of length %d", p2, v2))
	local v42 = if p3 then p3 else noUpdate
	local v5 = copy(p1)
	if v5[p2] == nil then
		v5[p2] = call(p4, p2)
	else
		v5[p2] = v42(v5[p2], p2)
	end
	return v5
end