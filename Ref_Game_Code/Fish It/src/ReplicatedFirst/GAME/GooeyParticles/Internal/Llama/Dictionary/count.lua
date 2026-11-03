-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local function alwaysTrue() --[[ alwaysTrue | Line: 6 ]]
	return true
end
local v2 = t.tuple(t.table, t.optional(t.callback))
return function(p1, p2) --[[ count | Line: 12 | Upvalues: v2 (copy), alwaysTrue (copy) ]]
	assert(v2(p1, p2))
	local v3, count = if p2 then p2 else alwaysTrue, 0
	for k, v in pairs(p1) do
		if v3(v, k) then
			count = count + 1
		end
	end
	return count
end