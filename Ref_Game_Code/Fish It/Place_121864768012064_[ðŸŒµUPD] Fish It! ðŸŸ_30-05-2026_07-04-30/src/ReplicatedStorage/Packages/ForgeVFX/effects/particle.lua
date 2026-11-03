-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
return {
	emit = function(p1, p2, p3) --[[ emit | Line: 8 | Upvalues: v1 (copy), v2 (copy), v3 (copy) ]]
		if p1.Enabled then
			p1.Enabled = false
		end
		local v12 = v1.get(p1, "EmitDelay", 0)
		local v22 = v1.get(p1, "EmitCount", 1)
		local v32 = v1.get(p1, "EmitDuration", 0)
		local v4 = if v32 > 0 then true else false
		task.wait(v12)
		if v4 then
			p2.Enabled = true
		end
		local v5 = v1.get(p1, "TimeScale_Duration", 0.1)
		local v6 = v1.get(p1, "TimeScale_Start", p2.TimeScale, true)
		local v7 = v1.get(p1, "TimeScale_End", p2.TimeScale, true)
		local v8 = nil
		if v6 == v7 then
			if v6 ~= p2.TimeScale then
				p2.TimeScale = v6
			end
		else
			v8 = v2.fromParams(v1.get(p1, "TimeScale_Curve", v3.default_bezier), v5, function(p1, p22) --[[ Line: 36 | Upvalues: v3 (ref), v6 (copy), v7 (copy), p2 (copy) ]]
				p2.TimeScale = v3.lerp(v6, v7, (math.clamp(p1, 0, 1)))
				return p22
			end)
			table.insert(p3, v8)
		end
		v3.onCancel(p3, function() --[[ Line: 50 | Upvalues: v4 (copy), p2 (copy) ]]
			if v4 then
				p2.Enabled = false
			end
			p2:Clear()
		end)
		p2:Emit(v22)
		if not v4 then
			v2.timer(p1.Lifetime.Max, function(p12_2, p2_2) --[[ Line: 65 | Upvalues: p1 (copy), v8 (ref) ]]
				if p1.TimeScale > 0 or p2_2 > 0 and (v8 and v8.Connected) then
					return p12_2 * p1.TimeScale
				else
					return nil
				end
			end, v8, p3)
			return
		end
		task.wait(v32)
		p2.Enabled = false
		v2.timer(p1.Lifetime.Max, function(p12_2, p2_2) --[[ Line: 65 | Upvalues: p1 (copy), v8 (ref) ]]
			if p1.TimeScale > 0 or p2_2 > 0 and (v8 and v8.Connected) then
				return p12_2 * p1.TimeScale
			else
				return nil
			end
		end, v8, p3)
	end
}