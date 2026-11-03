-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:52
-- Luau version 6, Types version 3
-- Time taken: 0.004560 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("CubicSplineUtils")
local any_load_result1_result1_upvr = any_load_result1("CameraState")
local var1_result1_upvr = any_load_result1("SpringUtils")
local module_upvr = {
	ClassName = "FadeBetweenCamera4";
}
module_upvr.__index = module_upvr
local any_load_result1_result1_upvr_3 = any_load_result1("Spring")
function module_upvr.new(arg1, arg2) -- Line 21
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	local tbl = {}
	local var8 = arg1
	if not var8 then
		var8 = error("No cameraA")
	end
	tbl.CameraA = var8
	var8 = arg2
	local var9 = var8
	if not var9 then
		var9 = error("No cameraB")
	end
	tbl.CameraB = var9
	tbl._spring = any_load_result1_result1_upvr_3.new()
	tbl._position0 = 0
	tbl._state0 = arg1.CameraState
	local setmetatable_result1 = setmetatable(tbl, module_upvr)
	setmetatable_result1._spring.s = 15
	return setmetatable_result1
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 35
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg2 == "Value" then
		if type(arg3) ~= "number" then
		else
		end
		assert(true, "Bad value")
		local _, any_animating_result2_5 = var1_result1_upvr.animating(arg1._spring)
		local any__computeCameraState_result1_2, any__computeCameraState_result2_2 = arg1:_computeCameraState(any_animating_result2_5)
		arg1._state0 = any__computeCameraState_result1_2
		arg1._position0 = any__computeCameraState_result2_2
		arg1._spring.p = arg3
		do
			return
		end
		local var15
	end
	if arg2 == "Target" then
		if type(arg3) ~= "number" then
			var15 = false
		else
			var15 = true
		end
		assert(var15, "Bad value")
		var15 = var1_result1_upvr
		var15 = arg1._spring
		local _, any_animating_result2_4 = var15.animating(var15)
		local any__computeCameraState_result1_5, any__computeCameraState_result2_4 = arg1:_computeCameraState(any_animating_result2_4)
		arg1._state0 = any__computeCameraState_result1_5
		arg1._position0 = any__computeCameraState_result2_4
		arg1._spring.t = arg3
	else
		if arg2 == "Speed" then
			if type(arg3) ~= "number" then
				any_animating_result2_4 = false
			else
				any_animating_result2_4 = true
			end
			assert(any_animating_result2_4, "Bad value")
			any_animating_result2_4 = var1_result1_upvr
			any_animating_result2_4 = arg1._spring
			local _, any_animating_result2_6 = any_animating_result2_4.animating(any_animating_result2_4)
			local any__computeCameraState_result1, any__computeCameraState_result2_3 = arg1:_computeCameraState(any_animating_result2_6)
			arg1._state0 = any__computeCameraState_result1
			arg1._position0 = any__computeCameraState_result2_3
			arg1._spring.s = arg3
			return
		end
		if arg2 == "CameraA" or arg2 == "CameraB" then
			if type(arg3) == "nil" then
				any_animating_result2_6 = false
			else
				any_animating_result2_6 = true
			end
			assert(any_animating_result2_6, "Bad value")
			any_animating_result2_6 = var1_result1_upvr
			any_animating_result2_6 = arg1._spring
			local _, any_animating_result2_3 = any_animating_result2_6.animating(any_animating_result2_6)
			local any__computeCameraState_result1_4, any__computeCameraState_result2 = arg1:_computeCameraState(any_animating_result2_3)
			arg1._state0 = any__computeCameraState_result1_4
			arg1._position0 = any__computeCameraState_result2
			rawset(arg1, arg2, arg3)
			return
		end
		error("%q is not a valid member of FadeBetweenCamera4":format(tostring(arg2)))
	end
end
function module_upvr.__index(arg1, arg2) -- Line 71
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local _, any_animating_result2 = var1_result1_upvr.animating(arg1._spring)
		local any__computeCameraState_result1_3, _ = arg1:_computeCameraState(any_animating_result2)
		return any__computeCameraState_result1_3
	end
	if arg2 == "Value" then
		local any_animating_result1_2, any_animating_result2_2 = var1_result1_upvr.animating(arg1._spring)
		return any_animating_result2_2
	end
	if arg2 == "Target" then
		return arg1._spring.t
	end
	if arg2 == "HasReachedTarget" then
		local any_animating_result1, _ = var1_result1_upvr.animating(arg1._spring)
		return any_animating_result1
	end
	if arg2 == "Speed" then
		return arg1._spring.s
	end
	if arg2 == "Velocity" then
		return arg1._spring.v
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q is not a valid member of FadeBetweenCamera4":format(tostring(arg2)))
end
function module_upvr._computeTargetState(arg1, arg2) -- Line 95
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2 <= 0 then
		return arg1.CameraA.CameraState
	end
	if 1 <= arg2 then
		return arg1.CameraB.CameraState
	end
	local CameraState = arg1.CameraA.CameraState
	local CameraState_2 = arg1.CameraB.CameraState
	local any_tweenSplineNodes_result1_2 = any_load_result1_result1_upvr_2.tweenSplineNodes(any_load_result1_result1_upvr_2.newSplineNode(0, CameraState.CameraFrame, CameraState.CameraFrameDerivative), any_load_result1_result1_upvr_2.newSplineNode(1, CameraState_2.CameraFrame, CameraState_2.CameraFrameDerivative), arg1._spring.t)
	return any_load_result1_result1_upvr.new(any_tweenSplineNodes_result1_2.p, any_tweenSplineNodes_result1_2.v)
end
function module_upvr._computeCameraState(arg1, arg2) -- Line 113
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2 <= 0 then
		return arg1:_computeTargetState(0), 0
	end
	if 1 <= arg2 then
		return arg1:_computeTargetState(1), 1
	end
	local var39
	local var40
	if arg2 < arg1._position0 then
		local any__computeTargetState_result1_2 = arg1:_computeTargetState(0)
		var39 = any_load_result1_result1_upvr_2.newSplineNode(0, any__computeTargetState_result1_2.CameraFrame, any__computeTargetState_result1_2.CameraFrameDerivative)
		var40 = any_load_result1_result1_upvr_2.newSplineNode(arg1._position0, arg1._state0.CameraFrame, arg1._state0.CameraFrameDerivative)
	else
		local any__computeTargetState_result1 = arg1:_computeTargetState(1)
		var39 = any_load_result1_result1_upvr_2.newSplineNode(arg1._position0, arg1._state0.CameraFrame, arg1._state0.CameraFrameDerivative)
		var40 = any_load_result1_result1_upvr_2.newSplineNode(1, any__computeTargetState_result1.CameraFrame, any__computeTargetState_result1.CameraFrameDerivative)
	end
	local any_tweenSplineNodes_result1 = any_load_result1_result1_upvr_2.tweenSplineNodes(var39, var40, arg2)
	return any_load_result1_result1_upvr.new(any_tweenSplineNodes_result1.p, any_tweenSplineNodes_result1.v), arg2
end
return module_upvr