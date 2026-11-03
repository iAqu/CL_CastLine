-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.callback)
return function(p1, p2) --[[ map | Line: 8 | Upvalues: v2 (copy) ]]
	assert(v2(p1, p2))
	local t = {}
	for k, v in pairs(p1) do
		local v22 = p2(k)
		if v22 ~= nil then
			t[v22] = true
		end
	end
	return t
end