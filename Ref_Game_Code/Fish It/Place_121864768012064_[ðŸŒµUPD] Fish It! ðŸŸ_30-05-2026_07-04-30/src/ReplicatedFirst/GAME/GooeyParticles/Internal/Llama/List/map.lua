-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2) --[[ map | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local t = {}
	local count = 1
	for i, v in ipairs(p1) do
		local v22 = p2(v, i)
		if v22 ~= nil then
			t[count] = v22
			count = count + 1
		end
	end
	return t
end