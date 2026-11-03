-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
local toSet = require(script.Parent.toSet)
local function removeValues(p1, ...) --[[ removeValues | Line: 5 | Upvalues: toSet (copy), maybeFreeze (copy) ]]
	local v1 = toSet({ ... })
	local t = {}
	local count = 1
	local v2 = false
	for i, v in ipairs(p1) do
		if not v1[v] then
			t[count] = v
			count = count + 1
			v2 = true
		end
	end
	if v2 then
		return maybeFreeze(t)
	else
		return p1
	end
end
return function(p1, ...) --[[ removeValue | Line: 35 | Upvalues: maybeFreeze (copy), removeValues (copy) ]]
	local t = { ... }
	if #t ~= 1 then
		return removeValues(p1, ...)
	end
	local v1 = t[1]
	local v2 = table.create(#p1)
	local v3 = false
	for v4, v5 in p1 do
		if v5 == v1 then
			v3 = true
			continue
		end
		table.insert(v2, v5)
	end
	if v3 then
		return maybeFreeze(v2)
	else
		return p1
	end
end