-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Symbol).named("Nil")
local t = {}
return function(p1, p2) --[[ getDefaultInstanceProperty | Line: 16 | Upvalues: t (copy), v1 (copy) ]]
	local v12 = t[p1]
	if v12 then
		local v2 = v12[p2]
		if v2 == v1 then
			return true, nil
		end
		if v2 ~= nil then
			return true, v2
		end
	else
		v12 = {}
		t[p1] = v12
	end
	local v3 = Instance.new(p1)
	local v4, v5 = pcall(function() --[[ Line: 37 | Upvalues: v3 (copy), p2 (copy) ]]
		return v3[p2]
	end)
	v3:Destroy()
	if v4 then
		if v5 == nil then
			v12[p2] = v1
			return v4, v5
		end
		v12[p2] = v5
	end
	return v4, v5
end