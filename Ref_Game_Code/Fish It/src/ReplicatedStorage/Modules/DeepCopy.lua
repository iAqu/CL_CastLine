-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function v1(p1) --[[ deepCopy | Line: 2 | Upvalues: v1 (copy) ]]
	local v12 = table.clone(p1)
	for v2, v3 in v12 do
		if type(v3) == "table" then
			v12[v2] = v1(v3)
		end
	end
	return v12
end
return v1