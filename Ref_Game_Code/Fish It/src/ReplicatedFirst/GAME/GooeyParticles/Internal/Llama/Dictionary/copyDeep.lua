-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local table = require(script.Parent.Parent.t).table
local function v2(p1) --[[ copyDeep | Line: 8 | Upvalues: table (copy), v2 (copy) ]]
	assert(table(p1))
	local t = {}
	for k, v in pairs(p1) do
		if type(v) == "table" then
			t[k] = v2(v)
			continue
		end
		t[k] = v
	end
	return t
end
return v2