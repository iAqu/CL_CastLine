-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:21
-- Luau version 6, Types version 3
-- Time taken: 0.009934 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("InputObjectUtils")
local function rk4Integrator_upvr(arg1, arg2, arg3) -- Line 19, Named "rk4Integrator"
	local var5_upvr
	if arg2 < 0 then
		var5_upvr = -1
	else
		var5_upvr = 1
	end
	local function _(arg1_2, arg2_2) -- Line 21, Named "acceleration"
		--[[ Upvalues[1]:
			[1]: var5_upvr (readonly)
		]]
		return var5_upvr * math.max(1, arg1_2 / 3.3 + 0.5)
	end
	local var6 = var5_upvr * math.max(1, arg1 / 3.3 + 0.5)
	local var7 = arg2 + (var6) * (arg3 / 2)
	local var8 = var5_upvr * math.max(1, (arg1 + (arg2) * (arg3 / 2)) / 3.3 + 0.5)
	local var9 = arg2 + (var8) * (arg3 / 2)
	local var10 = var5_upvr * math.max(1, (arg1 + (var7) * (arg3 / 2)) / 3.3 + 0.5)
	return arg1 + ((arg2 + 2 * var7 + 2 * var9) + (arg2 + var10 * arg3)) * (arg3 / 6), arg2 + (var6 + 2 * var8 + 2 * var10 + var5_upvr * math.max(1, (arg1 + var9 * arg3) / 3.3 + 0.5)) * (arg3 / 6)
end
local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "CameraControls"
module_upvr.MOUSE_SENSITIVITY = Vector2.new(12.566370614359172, 5.969026041820607)
module_upvr._dragBeginTypes = {Enum.UserInputType.MouseButton2, Enum.UserInputType.Touch}
local any_load_result1_result1_upvr = any_load_result1("GamepadRotateModel")
function module_upvr.new(arg1, arg2) -- Line 50
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._enabled = false
	setmetatable_result1._key = tostring(setmetatable_result1).."CameraControls"
	setmetatable_result1._gamepadRotateModel = any_load_result1_result1_upvr.new()
	if arg1 then
		setmetatable_result1:SetZoomedCamera(arg1)
	end
	if arg2 then
		setmetatable_result1:SetRotatedCamera(arg2)
	end
	return setmetatable_result1
end
function module_upvr.GetKey(arg1) -- Line 69
	return arg1._key
end
function module_upvr.IsEnabled(arg1) -- Line 73
	return arg1._enabled
end
local ContextActionService_upvr = game:GetService("ContextActionService")
function module_upvr.Enable(arg1) -- Line 77
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: ContextActionService_upvr (readonly)
		[3]: UserInputService_upvr (readonly)
	]]
	if arg1._enabled then
	else
		assert(not arg1._maid, "Maid already defined")
		arg1._enabled = true
		arg1._maid = var1_result1_upvr_2.new()
		arg1._maid:GiveTask(arg1._gamepadRotateModel.IsRotating.Changed:Connect(function() -- Line 87
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1._gamepadRotateModel.IsRotating.Value then
				arg1:_handleGamepadRotateStart()
			else
				arg1:_handleGamepadRotateStop()
			end
		end))
		ContextActionService_upvr:BindAction(arg1._key, function(arg1_3, arg2, arg3) -- Line 95
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg3.UserInputType == Enum.UserInputType.MouseWheel then
				arg1:_handleMouseWheel(arg3)
			end
		end, false, Enum.UserInputType.MouseWheel)
		ContextActionService_upvr:BindAction(arg1._key.."Drag", function(arg1_4, arg2, arg3) -- Line 101
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg2 == Enum.UserInputState.Begin then
				arg1:BeginDrag(arg3)
			end
		end, false, unpack(arg1._dragBeginTypes))
		ContextActionService_upvr:BindAction(arg1._key.."Rotate", function(arg1_5, arg2, arg3) -- Line 107
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_handleThumbstickInput(arg3)
		end, false, Enum.KeyCode.Thumbstick2)
		arg1._maid:GiveTask(UserInputService_upvr.TouchPinch:Connect(function(arg1_6, arg2, arg3, arg4) -- Line 111
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_handleTouchPinch(arg2, arg3, arg4)
		end))
		arg1._maid:GiveTask(function() -- Line 115
			--[[ Upvalues[2]:
				[1]: ContextActionService_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			ContextActionService_upvr:UnbindAction(arg1._key)
			ContextActionService_upvr:UnbindAction(arg1._key.."Drag")
			ContextActionService_upvr:UnbindAction(arg1._key.."Rotate")
		end)
	end
end
function module_upvr.Disable(arg1) -- Line 122
	if not arg1._enabled then
	else
		arg1._enabled = false
		arg1._maid:DoCleaning()
		arg1._maid = nil
		arg1._lastMousePosition = nil
	end
end
function module_upvr.BeginDrag(arg1, arg2) -- Line 135
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: UserInputService_upvr (readonly)
	]]
	if not arg1._rotatedCamera then
		arg1._maid._dragMaid = nil
	else
		local any_new_result1_2 = var1_result1_upvr_2.new()
		arg1._lastMousePosition = arg2.Position
		if var1_result1_upvr.isMouseUserInputType(arg2.UserInputType) then
			UserInputService_upvr.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		end
		any_new_result1_2:GiveTask(UserInputService_upvr.InputEnded:Connect(function(arg1_7, arg2_3) -- Line 149
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			if arg1_7 == arg2 then
				arg1:_endDrag()
			end
		end))
		any_new_result1_2:GiveTask(UserInputService_upvr.InputChanged:Connect(function(arg1_8) -- Line 155
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: arg1 (readonly)
			]]
			if var1_result1_upvr.isMouseUserInputType(arg1_8.UserInputType) or arg1_8 == arg2 then
				arg1:_handleMouseMovement(arg1_8)
			end
		end))
		if arg1._rotatedCamera.ClassName == "SmoothRotatedCamera" then
			arg1._rotVelocityTracker = arg1:_getVelocityTracker(0.05, Vector2.new())
		end
		arg1._maid._dragMaid = any_new_result1_2
	end
end
function module_upvr.SetZoomedCamera(arg1, arg2) -- Line 168
	arg1._zoomedCamera = assert(arg2, "Bad zoomedCamera")
	arg1._startZoomScale = arg1._zoomedCamera.Zoom
	return arg1
end
function module_upvr.SetRotatedCamera(arg1, arg2) -- Line 175
	arg1._rotatedCamera = assert(arg2, "Bad rotatedCamera")
	return arg1
end
function module_upvr._handleMouseWheel(arg1, arg2) -- Line 181
	--[[ Upvalues[1]:
		[1]: rk4Integrator_upvr (readonly)
	]]
	if arg1._zoomedCamera then
		arg1._zoomedCamera.TargetZoom = rk4Integrator_upvr(arg1._zoomedCamera.TargetZoom, math.clamp(-arg2.Position.Z, -1, 1) * 1.4, 1)
	end
	if arg1._rotatedCamera and arg1._rotatedCamera.ClassName == "PushCamera" then
		arg1._rotatedCamera:StopRotateBack()
	end
end
function module_upvr._handleTouchPinch(arg1, arg2, arg3, arg4) -- Line 196
	if arg1._zoomedCamera then
		if arg4 == Enum.UserInputState.Begin then
			arg1._startZoomScale = arg1._zoomedCamera.Zoom
			arg1._zoomedCamera.Zoom = arg1._startZoomScale * 1 / arg2
			return
		end
		if arg4 == Enum.UserInputState.End then
			arg1._zoomedCamera.Zoom = arg1._startZoomScale * 1 / arg2
			arg1._zoomedCamera.TargetZoom = arg1._zoomedCamera.Zoom + -arg3 / 5
			return
		end
		if arg4 == Enum.UserInputState.Change then
			if arg1._startZoomScale then
				arg1._zoomedCamera.TargetZoom = arg1._startZoomScale * 1 / arg2
				arg1._zoomedCamera.Zoom = arg1._zoomedCamera.TargetZoom
				return
			end
			warn("[CameraControls._handleTouchPinch] - No self._startZoomScale")
		end
	end
end
function module_upvr._mouseTranslationToAngle(arg1, arg2) -- Line 216
	return Vector2.new(arg2.x / 1920, arg2.y / 1200)
end
function module_upvr._getVelocityTracker(arg1, arg2, arg3) -- Line 222
	local var25_upvw = arg3
	local module = {}
	local tick_result1_upvw = tick()
	local var28_upvw = arg2 or 1
	function module.Update(arg1_9, arg2_4) -- Line 229
		--[[ Upvalues[3]:
			[1]: tick_result1_upvw (read and write)
			[2]: var25_upvw (read and write)
			[3]: var28_upvw (read and write)
		]]
		local var29 = tick() - tick_result1_upvw
		tick_result1_upvw = tick()
		var25_upvw = var25_upvw / 2 ^ (var29 / var28_upvw) + arg2_4 / (0.0001 + var29) * var28_upvw
	end
	function module.GetVelocity(arg1_10) -- Line 234
		--[[ Upvalues[2]:
			[1]: arg3 (readonly)
			[2]: var25_upvw (read and write)
		]]
		arg1_10:Update(arg3 * 0)
		return var25_upvw
	end
	return module
end
function module_upvr._handleMouseMovement(arg1, arg2) -- Line 241
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg1._lastMousePosition then
		if arg1._rotatedCamera then
			local var30
			if var1_result1_upvr.isMouseUserInputType(arg2.UserInputType) then
				var30 = -arg2.Delta + arg1._lastMousePosition - arg2.Position
			else
				var30 = -arg2.Delta
			end
			local var31 = arg1:_mouseTranslationToAngle(var30) * arg1.MOUSE_SENSITIVITY
			arg1._rotatedCamera:RotateXY(var31)
			if arg1._rotVelocityTracker then
				arg1._rotVelocityTracker:Update(var31)
			end
		end
		arg1._lastMousePosition = arg2.Position
	end
end
function module_upvr._handleThumbstickInput(arg1, arg2) -- Line 264
	arg1._gamepadRotateModel:HandleThumbstickInput(arg2)
end
function module_upvr._applyRotVelocityTracker(arg1, arg2) -- Line 268
	if arg1._rotatedCamera then
		local AngleXZ = arg1._rotatedCamera.AngleXZ
		local var33 = AngleXZ + arg2:GetVelocity().X
		if math.abs(arg1._rotatedCamera.TargetAngleXZ - AngleXZ) < math.abs(var33 - AngleXZ) then
			arg1._rotatedCamera.TargetAngleXZ = var33
		end
		arg1._rotatedCamera:SnapIntoBounds()
	end
end
function module_upvr._endDrag(arg1) -- Line 283
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	if arg1._rotVelocityTracker then
		arg1:_applyRotVelocityTracker(arg1._rotVelocityTracker)
		arg1._rotVelocityTracker = nil
	end
	arg1._lastMousePosition = nil
	UserInputService_upvr.MouseBehavior = Enum.MouseBehavior.Default
	arg1._maid._dragMaid = nil
end
function module_upvr._handleGamepadRotateStop(arg1) -- Line 295
	if arg1._rotVelocityTracker then
		arg1:_applyRotVelocityTracker(arg1._rotVelocityTracker)
		arg1._rotVelocityTracker = nil
	end
	arg1._maid._dragMaid = nil
end
local RunService_upvr = game:GetService("RunService")
function module_upvr._handleGamepadRotateStart(arg1) -- Line 304
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: RunService_upvr (readonly)
	]]
	if not arg1._rotatedCamera then
		arg1._maid._dragMaid = nil
	else
		local any_new_result1 = var1_result1_upvr_2.new()
		if arg1._rotatedCamera.ClassName == "SmoothRotatedCamera" then
			arg1._rotVelocityTracker = arg1:_getVelocityTracker(0.05, Vector2.new())
		end
		any_new_result1:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 316
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			local var37 = 0.1 * arg1._gamepadRotateModel:GetThumbstickDeltaAngle()
			if arg1._rotatedCamera then
				arg1._rotatedCamera:RotateXY(var37)
			end
			if arg1._rotVelocityTracker then
				arg1._rotVelocityTracker:Update(var37)
			end
		end))
		arg1._maid._dragMaid = any_new_result1
	end
end
function module_upvr.Destroy(arg1) -- Line 331
	arg1._gamepadRotateModel:Destroy()
	arg1:Disable()
	setmetatable(arg1, nil)
end
return module_upvr