-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function f1(p1, p2) --[[ Line: 2 ]]
	return p2 < p1
end
return function(p1, p2) --[[ Line: 6 | Upvalues: f1 (copy) ]]
	local v1 = if p2 == nil then f1 else p2
	local v2 = nil
	local v3 = nil
	for v4, v5 in p1 do
		if v2 == nil or v1(v2, v5) == false then
			v2 = v5
			v3 = v4
		end
	end
	return v2, v3
end