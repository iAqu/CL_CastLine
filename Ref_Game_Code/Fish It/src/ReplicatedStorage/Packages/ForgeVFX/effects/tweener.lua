-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("../mod/attributes")
local v2 = require("../mod/lerp")
local v3 = require("../mod/tween")
require("../types")
local v4 = require("../mod/utility")
local v5 = Random.new()
return {
	emit = function(p1, p2, p3) --[[ emit | Line: 11 | Upvalues: v4 (copy), v1 (copy), v5 (copy), v3 (copy), v2 (copy) ]]
		local v12 = v4.getTarget(p1)
		if not v12 then
			return
		end
		local v22 = p1.Name
		local v32 = v1.get(p1, "EmitDelay", 0)
		local v42 = v1.get(p1, "ResetOnFinish", true)
		local v52 = v1.getRange(p1, "Duration", NumberRange.new(1, 1), NumberRange.new(0, (1 / 0)))
		if v32 > 0 then
			task.wait(v32)
		end
		local v6 = v1.get(p1, "_END_VALUE", nil)
		local v7 = v1.get(p1, "_START_VALUE", nil)
		local v8
		if p3 then
			v8 = v1.get(v12, v22, nil)
		else
			local v9, v10 = pcall(function() --[[ Line: 37 | Upvalues: v12 (copy), v22 (copy) ]]
				return v12[v22]
			end)
			if not v9 then
				return
			end
			v8 = v10
		end
		if v7 then
			v8 = v7
		end
		local v11 = typeof(v8)
		if v11 ~= typeof(v6) then
			return
		end
		local v122 = v5:NextNumber(v52.Min, v52.Max)
		local v13 = v1.get(p1, "Speed_Start", 1)
		local v14 = v1.get(p1, "Speed_End", 1)
		local v15 = v13
		local v16
		if v13 == v14 then
			v16 = nil
		else
			v16 = v3.fromParams(v1.get(p1, "Speed_Curve", v4.default_bezier), v1.get(p1, "Speed_Duration", 0.1), function(p1, p2) --[[ Line: 71 | Upvalues: v15 (ref), v4 (ref), v13 (copy), v14 (copy) ]]
				v15 = v4.lerp(v13, v14, p1)
				return p2
			end)
			table.insert(p2, v16)
		end
		local v17 = v2[v11] or v2.Other
		local v18 = if p3 then function(p1, p2) --[[ Line: 83 | Upvalues: v1 (ref), v12 (copy), v22 (copy), v17 (copy), v8 (ref), v6 (copy), v15 (ref) ]]
	v1.set(v12, v22, v17(v8, v6, p1))
	return p2 * v15
end else function(p1, p2) --[[ Line: 87 | Upvalues: v12 (copy), v22 (copy), v17 (copy), v8 (ref), v6 (copy), v15 (ref) ]]
	v12[v22] = v17(v8, v6, p1)
	return p2 * v15
end
		local v19 = v1.get(p1, "Easing_Curve", v4.linear_bezier)
		local v20 = v4.RENDER_PRIORITY + p2.depth
		table.insert(p2, v3.fromParams(v19, v122, v18, v16, nil, nil, v20))
		if v42 then
			local function f21() --[[ Line: 106 | Upvalues: p3 (copy), v1 (ref), v12 (copy), v22 (copy), v8 (ref) ]]
				if p3 then
					v1.set(v12, v22, v8)
				else
					v12[v22] = v8
				end
			end
			table.insert(p2, f21)
		end
		v3.timer(v122, function(p1, p2) --[[ Line: 115 | Upvalues: v15 (ref), v16 (ref) ]]
			if v15 > 0 or p2 > 0 and (v16 and v16.Connected) then
				return p1 * v15
			else
				return nil
			end
		end, v16, p2)
	end
}