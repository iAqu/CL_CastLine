-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:27
-- Luau version 6, Types version 3
-- Time taken: 0.002301 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "SmoothPositionCamera";
}
local any_load_result1_result1_upvr_2 = any_load_result1("Spring")
function module_upvr.new(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.Spring = any_load_result1_result1_upvr_2.new(Vector3.new())
	local var5 = arg1
	if not var5 then
		var5 = error("Must have BaseCamera")
	end
	setmetatable_result1.BaseCamera = var5
	setmetatable_result1.Speed = 10
	return setmetatable_result1
end
local any_load_result1_result1_upvr_3 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 27
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 31
	if arg2 == "BaseCamera" then
		rawset(arg1, '_'..arg2, arg3)
		arg1.Spring.Target = arg1.BaseCamera.CameraState.Position
		arg1.Spring.Position = arg1.Spring.Target
		arg1.Spring.Velocity = Vector3.new(0, 0, 0)
	else
		if arg2 == "_lastUpdateTime" or arg2 == "Spring" then
			rawset(arg1, arg2, arg3)
			return
		end
		if arg2 == "Speed" or arg2 == "Damper" or arg2 == "Velocity" or arg2 == "Position" then
			arg1:_internalUpdate()
			arg1.Spring[arg2] = arg3
			return
		end
		error(arg2.." is not a valid member of SmoothPositionCamera")
	end
end
local any_load_result1_result1_upvr_4 = any_load_result1("CameraFrame")
local any_load_result1_result1_upvr = any_load_result1("QFrame")
local any_load_result1_result1_upvr_5 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 47
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_5 (readonly)
		[4]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local CameraState = arg1.BaseCamera.CameraState
		local CameraFrame = CameraState.CameraFrame
		local CameraFrameDerivative = CameraState.CameraFrameDerivative
		return any_load_result1_result1_upvr_5.new(any_load_result1_result1_upvr_4.new(any_load_result1_result1_upvr.fromVector3(arg1.Position, CameraFrame.QFrame), CameraFrame.FieldOfView), any_load_result1_result1_upvr_4.new(any_load_result1_result1_upvr.fromVector3(arg1.Velocity, CameraFrameDerivative.QFrame), CameraFrameDerivative.FieldOfView))
	end
	if arg2 == "Position" then
		arg1:_internalUpdate()
		return arg1.Spring.Position
	end
	if arg2 == "Speed" or arg2 == "Damper" or arg2 == "Velocity" then
		return arg1.Spring[arg2]
	end
	if arg2 == "Target" then
		return arg1.BaseCamera.CameraState.Position
	end
	if arg2 == "BaseCamera" then
		local rawget_result1 = rawget(arg1, '_'..arg2)
		if not rawget_result1 then
			rawget_result1 = error("Internal error: index does not exist")
		end
		return rawget_result1
	end
	return module_upvr[arg2]
end
function module_upvr._internalUpdate(arg1) -- Line 75
	local var14
	if arg1._lastUpdateTime then
		var14 = tick() - arg1._lastUpdateTime
	end
	arg1._lastUpdateTime = tick()
	arg1.Spring.Target = arg1.BaseCamera.CameraState.Position
	if var14 then
		arg1.Spring:TimeSkip(var14)
	end
end
return module_upvr