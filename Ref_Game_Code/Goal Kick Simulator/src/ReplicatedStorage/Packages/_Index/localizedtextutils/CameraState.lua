-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:25
-- Luau version 6, Types version 3
-- Time taken: 0.002722 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "CameraState";
}
function module_upvr.isCameraState(arg1) -- Line 19
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if getmetatable(arg1) ~= module_upvr then
		var3 = false
	else
		var3 = true
	end
	return var3
end
local any_load_result1_result1_upvr = any_load_result1("CameraFrame")
local any_load_result1_result1_upvr_2 = any_load_result1("QFrame")
function module_upvr.new(arg1, arg2) -- Line 29
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var7
	if typeof(arg1) == "Instance" then
		assert(var7:IsA("Camera"))
		var7 = any_load_result1_result1_upvr.new(any_load_result1_result1_upvr_2.fromCFrameClosestTo(var7.CFrame, any_load_result1_result1_upvr_2.new()), var7.FieldOfView)
	end
	if not any_load_result1_result1_upvr.isCameraFrame(var7) then
		if type(var7) ~= "nil" then
		else
		end
	end
	assert(true, "Bad cameraFrame")
	if not any_load_result1_result1_upvr.isCameraFrame(arg2) then
		if type(arg2) ~= "nil" then
		else
		end
	end
	assert(true, "Bad cameraFrameDerivative")
	local var8 = var7
	if not var8 then
		var8 = any_load_result1_result1_upvr.new()
	end
	setmetatable_result1.CameraFrame = var8
	var8 = arg2
	local var9 = var8
	if not var9 then
		var9 = any_load_result1_result1_upvr.new()
	end
	setmetatable_result1.CameraFrameDerivative = var9
	return setmetatable_result1
end
function module_upvr.__index(arg1, arg2) -- Line 52
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		return arg1.CameraFrame.CFrame
	end
	if arg2 == "Position" then
		return arg1.CameraFrame.Position
	end
	if arg2 == "Velocity" then
		return arg1.CameraFrameDerivative.Position
	end
	if arg2 == "FieldOfView" then
		return arg1.CameraFrame.FieldOfView
	end
	return module_upvr[arg2]
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 66
	if arg2 == "CFrame" then
		arg1.CameraFrame.CFrame = arg3
	else
		if arg2 == "Position" then
			arg1.CameraFrame.Position = arg3
			return
		end
		if arg2 == "Velocity" then
			arg1.CameraFrameDerivative.Position = arg3
			return
		end
		if arg2 == "FieldOfView" then
			arg1.CameraFrame.FieldOfView = arg3
			return
		end
		if arg2 == "CameraFrame" or arg2 == "CameraFrameDerivative" then
			rawset(arg1, arg2, arg3)
			return
		end
		error("'%s' is not a valid index of CameraState":format(tostring(arg2)))
	end
end
function module_upvr.Set(arg1, arg2) -- Line 86
	arg2.FieldOfView = arg1.FieldOfView
	arg2.CFrame = arg1.CFrame
end
return module_upvr