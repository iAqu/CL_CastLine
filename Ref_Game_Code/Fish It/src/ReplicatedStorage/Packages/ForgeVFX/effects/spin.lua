-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")
require("../types")
local v3 = require("../mod/utility")
return {
	emit = function(p1, p2) --[[ emit | Line: 8 | Upvalues: v3 (copy), v1 (copy), v2 (copy) ]]
		if v3.isSpinModelStatic(p1) then
			return
		end
		local v12 = v1.get(p1, "SpinRotation", Vector3.new(0, 0, 0)) * v3.DEG_TO_RAD
		local v22 = v1.get(p1, "Scale_Start", 1)
		local v32 = v1.get(p1, "Scale_End", 1)
		local v4 = v1.get(p1, "EmitDelay", 0)
		local v5 = v1.get(p1, "ResetDelay", 0)
		local v6 = v1.get(p1, "ResetOnFinish", true)
		local v7 = v1.get(p1, "SyncPosition", false)
		local v8 = v1.get(p1, "SpinDuration", 0.5)
		local v9 = v1.get(p1, "SpinSpeed_Duration", 0.1)
		local v10 = v1.get(p1, "SpinSpeed_Start", 0)
		local v11 = v1.get(p1, "SpinSpeed_End", 1)
		local v122 = v10
		task.wait(v4)
		local v13
		if v10 == v11 then
			v13 = nil
		else
			v13 = v2.fromParams(v1.get(p1, "SpinSpeed_Curve", v3.default_bezier), v9, function(p1, p2) --[[ Line: 40 | Upvalues: v122 (ref), v3 (ref), v10 (copy), v11 (copy) ]]
				v122 = v3.lerp(v10, v11, p1)
				return p2
			end)
			table.insert(p2, v13)
		end
		local v14 = p1:GetPivot()
		local v15 = p1:GetScale()
		if v22 == v32 then
			p1:ScaleTo(v22)
		else
			local v16 = v1.get(p1, "Scale_Curve", v3.default_bezier)
			local function f17(p12, p2) --[[ Line: 55 | Upvalues: p1 (copy), v3 (ref), v22 (copy), v32 (copy) ]]
				p1:ScaleTo(v3.lerp(v22, v32, p12))
				return p2
			end
			table.insert(p2, v2.fromParams(v16, v8, f17))
		end
		local v18 = p1:FindFirstAncestorOfClass("Attachment") or p1:FindFirstAncestorWhichIsA("BasePart")
		if v6 then
			local function f19() --[[ Line: 67 | Upvalues: p1 (copy), v18 (copy), v3 (ref), v14 (copy), v15 (copy) ]]
				p1:PivotTo(v18 and v3.getTransformedOriginExtents(v18) or v14)
				p1:ScaleTo(v15)
			end
			table.insert(p2, f19)
		end
		local v20 = v12 * v8
		v2.timer(v8 + v5, function(p12, p2) --[[ Line: 75 | Upvalues: v8 (copy), v20 (ref), v18 (copy), v7 (copy), v3 (ref), v14 (copy), p1 (copy), v122 (ref), v13 (ref) ]]
			local v2 = v20 * math.clamp(p2 / v8, 0, 1)
			local v32 = if v18 and v7 then v3.getTransformedOriginExtents(v18) else v14
			p1:PivotTo(v32 * CFrame.fromOrientation(v2.x, v2.y, v2.z))
			if v122 > 0 or p2 > 0 and v13.Connected then
				return p12 * v122
			else
				return nil
			end
		end, v13, p2, v3.RENDER_PRIORITY + p2.depth)
	end
}