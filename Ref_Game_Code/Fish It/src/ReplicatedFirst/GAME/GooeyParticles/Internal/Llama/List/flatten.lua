-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = require(script.Parent.Parent.t)
local v2 = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))
local function v3(p1, p2) --[[ flatten | Line: 8 | Upvalues: v2 (copy), v3 (copy) ]]
	assert(v2(p1))
	local t = {}
	local count = 1
	for i, v in ipairs(p1) do
		if type(v) == "table" and (not p2 or p2 > 0) then
			local v4 = v3(v, if p2 then p2 - 1 else p2)
			for i2 = 1, #v4 do
				t[count] = v4[i2]
				count = count + 1
			end
			continue
		end
		t[count] = v
		count = count + 1
	end
	return t
end
return v3