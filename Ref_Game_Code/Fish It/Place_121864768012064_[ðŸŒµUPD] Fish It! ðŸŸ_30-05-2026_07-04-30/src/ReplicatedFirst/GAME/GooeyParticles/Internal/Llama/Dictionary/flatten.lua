-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))
local function v3(p1, p2) --[[ flatten | Line: 8 | Upvalues: v2 (copy), v3 (copy) ]]
	assert(v2(p1, p2))
	local tbl = {}
	for k, v in pairs(p1) do
		if type(v) == "table" and (not p2 or p2 > 0) then
			local v4 = v3(v, if p2 then p2 - 1 else p2)
			for k2, v5 in pairs(tbl) do
				v4[k2] = v5
			end
			tbl = v4
			continue
		end
		tbl[k] = v
	end
	return tbl
end
return v3