-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:14
-- Luau version 6, Types version 3
-- Time taken: 0.003548 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "FadeBetweenCamera3";
}
local var1_result1_upvr_2 = any_load_result1("Spring")
function module_upvr.new(arg1, arg2) -- Line 25
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	local tbl = {
		_spring = var1_result1_upvr_2.new(0);
	}
	local var5 = arg1
	if not var5 then
		var5 = error("No cameraA")
	end
	tbl.CameraA = var5
	var5 = arg2
	local var6 = var5
	if not var6 then
		var6 = error("No cameraB")
	end
	tbl.CameraB = var6
	local setmetatable_result1 = setmetatable(tbl, module_upvr)
	setmetatable_result1.Damper = 1
	setmetatable_result1.Speed = 15
	return setmetatable_result1
end
local var1_result1_upvr_7 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_7 (readonly)
	]]
	return var1_result1_upvr_7.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 42
	if arg2 == "Damper" then
		arg1._spring.Damper = arg3
	else
		if arg2 == "Value" then
			arg1._spring.Value = arg3
			return
		end
		if arg2 == "Speed" then
			arg1._spring.Speed = arg3
			return
		end
		if arg2 == "Target" then
			arg1._spring.Target = arg3
			return
		end
		if arg2 == "Velocity" then
			arg1._spring.Velocity = arg3
			return
		end
		if arg2 == "CameraA" or arg2 == "CameraB" then
			rawset(arg1, arg2, arg3)
			return
		end
		error("%q is not a valid member of FadeBetweenCamera3":format(tostring(arg2)))
	end
end
local var1_result1_upvr_3 = any_load_result1("SpringUtils")
local var1_result1_upvr = any_load_result1("CubicSplineUtils")
local any_load_result1_result1_upvr = any_load_result1("QFrame")
local var1_result1_upvr_5 = any_load_result1("FieldOfViewUtils")
local var1_result1_upvr_6 = any_load_result1("CameraState")
local var1_result1_upvr_4 = any_load_result1("CameraFrame")
function module_upvr.__index(arg1, arg2) -- Line 66
	--[[ Upvalues[7]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_5 (readonly)
		[5]: var1_result1_upvr_6 (readonly)
		[6]: var1_result1_upvr_4 (readonly)
		[7]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_animating_result1, any_animating_result2_2 = var1_result1_upvr_3.animating(arg1._spring)
		if any_animating_result2_2 == 0 then
			return arg1.CameraStateA
		end
		if any_animating_result2_2 == 1 then
			return arg1.CameraStateB
		end
		local CameraStateA = arg1.CameraStateA
		local CameraStateB = arg1.CameraStateB
		local CameraFrame = CameraStateA.CameraFrame
		local CameraFrame_2 = CameraStateB.CameraFrame
		local magnitude = (CameraFrame.Position - CameraFrame_2.Position).magnitude
		local any_tweenSplineNodes_result1 = var1_result1_upvr.tweenSplineNodes(var1_result1_upvr.newSplineNode(0, CameraFrame.Position, CameraStateA.CameraFrameDerivative.Position + CameraFrame.CFrame.lookVector * magnitude * 0.3), var1_result1_upvr.newSplineNode(1, CameraFrame_2.Position, CameraStateB.CameraFrameDerivative.Position + CameraFrame_2.CFrame.lookVector * magnitude * 0.3), any_animating_result2_2)
		local var23 = CameraFrame_2 * CameraFrame ^ -1
		local QFrame = var23.QFrame
		if QFrame.W < 0 then
			var23.QFrame = any_load_result1_result1_upvr.new(QFrame.x, QFrame.y, QFrame.z, -QFrame.W, -QFrame.X, -QFrame.Y, -QFrame.Z)
		end
		local var25 = var23 ^ any_animating_result2_2 * CameraFrame
		var25.FieldOfView = var1_result1_upvr_5.lerpInHeightSpace(CameraFrame.FieldOfView, CameraFrame_2.FieldOfView, any_animating_result2_2)
		var25.Position = any_tweenSplineNodes_result1.p
		return var1_result1_upvr_6.new(var25, var1_result1_upvr_4.new(any_load_result1_result1_upvr.fromVector3(any_tweenSplineNodes_result1.v, any_load_result1_result1_upvr.new())))
	end
	if arg2 == "CameraStateA" then
		any_animating_result1 = arg1.CameraA.CameraState
		local var26 = any_animating_result1
		if not var26 then
			var26 = arg1.CameraA
		end
		return var26
	end
	if arg2 == "CameraStateB" then
		var26 = arg1.CameraB.CameraState
		local var27 = var26
		if not var27 then
			var27 = arg1.CameraB
		end
		return var27
	end
	if arg2 == "Damper" then
		return arg1._spring.Damper
	end
	if arg2 == "Value" then
		local any_animating_result1_2, any_animating_result2 = var1_result1_upvr_3.animating(arg1._spring)
		return any_animating_result2
	end
	if arg2 == "Speed" then
		return arg1._spring.Speed
	end
	if arg2 == "Target" then
		return arg1._spring.Target
	end
	if arg2 == "Velocity" then
		if var1_result1_upvr_3.animating(arg1._spring) then
			return arg1._spring.Velocity
		end
		return Vector3.new(0, 0, 0)
	end
	if arg2 == "HasReachedTarget" then
		return not var1_result1_upvr_3.animating(arg1._spring)
	end
	if arg2 == "Spring" then
		return arg1._spring
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q is not a valid member of FadeBetweenCamera3":format(tostring(arg2)))
end
return module_upvr