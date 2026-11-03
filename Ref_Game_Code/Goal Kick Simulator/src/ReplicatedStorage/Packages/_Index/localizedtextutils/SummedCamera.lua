-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:24
-- Luau version 6, Types version 3
-- Time taken: 0.002574 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "SummedCamera";
}
function module_upvr.new(arg1, arg2) -- Line 22
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._mode = "World"
	local var4 = arg1
	if not var4 then
		var4 = error("No cameraA")
	end
	setmetatable_result1._cameraA = var4
	var4 = arg2
	local var5 = var4
	if not var5 then
		var5 = error("No cameraB")
	end
	setmetatable_result1._cameraB = var5
	return setmetatable_result1
end
function module_upvr.SetMode(arg1, arg2) -- Line 39
	local var6 = true
	if arg2 ~= "World" then
		if arg2 ~= "Relative" then
			var6 = false
		else
			var6 = true
		end
	end
	assert(var6, "Bad mode")
	arg1._mode = arg2
	return arg1
end
function module_upvr.__addClass(arg1, arg2) -- Line 46
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.new(arg1, arg2)
end
function module_upvr.__add(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.new(arg1, arg2):SetMode(arg1._mode)
end
function module_upvr.__sub(arg1, arg2) -- Line 54
	if arg1._cameraA == arg2 then
		return arg1._cameraA
	end
	if arg1._cameraB == arg2 then
		return arg1._cameraB
	end
	error("Unable to subtract successfully")
end
local any_load_result1_result1_upvr_2 = any_load_result1("QFrame")
local any_load_result1_result1_upvr = any_load_result1("CameraFrame")
local any_load_result1_result1_upvr_3 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 64
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		if arg1._mode == "World" then
			error("not implemented")
		else
			local CameraAState = arg1.CameraAState
			local CameraBState = arg1.CameraBState
			return any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr.new(any_load_result1_result1_upvr_2.fromCFrameClosestTo(CameraAState.CFrame * CameraBState.CFrame, CameraAState.CameraFrame.QFrame), CameraAState.FieldOfView + CameraBState.FieldOfView), any_load_result1_result1_upvr.new(any_load_result1_result1_upvr_2.fromCFrameClosestTo(CameraAState.CameraFrameDerivative.CFrame * CameraBState.CameraFrameDerivative.CFrame, CameraAState.CameraFrameDerivative.QFrame), CameraAState.CameraFrameDerivative.FieldOfView + CameraBState.CameraFrameDerivative.FieldOfView))
		end
	end
	if arg2 == "CameraAState" then
		CameraAState = arg1._cameraA.CameraState
		local var12 = CameraAState
		if not var12 then
			var12 = arg1._cameraA
		end
		return var12
	end
	if arg2 == "CameraBState" then
		var12 = arg1._cameraB.CameraState
		local var13 = var12
		if not var13 then
			var13 = arg1._cameraB
		end
		return var13
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("[SummedCamera] - '%s' is not a valid member":format(tostring(arg2)))
end
return module_upvr