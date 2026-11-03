-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:45
-- Luau version 6, Types version 3
-- Time taken: 0.003256 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("CubicSplineUtils")
local any_load_result1_result1_upvr = any_load_result1("CameraState")
local module_upvr = {
	ClassName = "FadeBetweenCamera2";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2) -- Line 19
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local module = {}
	local var6 = arg1
	if not var6 then
		var6 = error("No cameraA")
	end
	module.CameraA = var6
	var6 = arg2
	local var7 = var6
	if not var7 then
		var7 = error("No cameraB")
	end
	module.CameraB = var7
	module._state0 = arg1.CameraState
	module._time0 = os.clock()
	module._target = 0
	module._position0 = 0
	module._speed = 15
	return setmetatable(module, module_upvr)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 33
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 2. Error Block 37 start (CF ANALYSIS FAILED)
	if type(arg3) ~= "number" then
	else
	end
	assert(true, "Bad value")
	-- KONSTANTERROR: [2] 2. Error Block 37 end (CF ANALYSIS FAILED)
end
function module_upvr.__index(arg1, arg2) -- Line 75
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any__computeCameraState_result1, any__computeCameraState_result2 = arg1:_computeCameraState(arg1:_computeDoneProportion(os.clock()))
		return any__computeCameraState_result1
	end
	if arg2 == "Value" then
		return arg1:_computeDoneProportion(os.clock())
	end
	if arg2 == "Target" then
		do
			return arg1._target
		end
		local var10
	end
	if arg2 == "HasReachedTarget" then
		if 1 > arg1:_computeDoneProportion(os.clock()) then
			var10 = false
		else
			var10 = true
		end
		return var10
	end
	if arg2 == "Speed" then
		var10 = arg1._speed
		return var10
	end
	if arg2 == "Velocity" then
		var10 = arg1._speed
		return var10
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q is not a valid member of FadeBetweenCamera2":format(tostring(arg2)))
end
function module_upvr._computeTargetState(arg1) -- Line 96
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	if arg1._target == 0 then
		return arg1.CameraA.CameraState
	end
	if arg1._target == 1 then
		return arg1.CameraB.CameraState
	end
	local CameraState = arg1.CameraA.CameraState
	local CameraState_2 = arg1.CameraB.CameraState
	local any_tweenSplineNodes_result1 = var1_result1_upvr.tweenSplineNodes(var1_result1_upvr.newSplineNode(0, CameraState.CameraFrame, CameraState.CameraFrameDerivative), var1_result1_upvr.newSplineNode(1, CameraState_2.CameraFrame, CameraState_2.CameraFrameDerivative), arg1._target)
	return any_load_result1_result1_upvr.new(any_tweenSplineNodes_result1.p, any_tweenSplineNodes_result1.v)
end
function module_upvr._computeCameraState(arg1, arg2) -- Line 114
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2 <= 0 then
		return arg1._state0, 0
	end
	if 1 <= arg2 then
		return arg1:_computeTargetState(), 1
	end
	local _state0 = arg1._state0
	local any__computeTargetState_result1 = arg1:_computeTargetState()
	local any_tweenSplineNodes_result1_2 = var1_result1_upvr.tweenSplineNodes(var1_result1_upvr.newSplineNode(0, _state0.CameraFrame, _state0.CameraFrameDerivative), var1_result1_upvr.newSplineNode(1, any__computeTargetState_result1.CameraFrame, any__computeTargetState_result1.CameraFrameDerivative), arg2)
	return any_load_result1_result1_upvr.new(any_tweenSplineNodes_result1_2.p, any_tweenSplineNodes_result1_2.v), arg2
end
function module_upvr._computeDoneProportion(arg1, arg2) -- Line 135
	local absolute = math.abs(arg1._position0 - arg1._target)
	if absolute == 0 then
		return 1
	end
	return math.clamp(arg1._speed * (arg2 - arg1._time0) * 0.03333333333333333 / absolute, 0, 1)
end
return module_upvr