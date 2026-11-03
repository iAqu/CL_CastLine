-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:50
-- Luau version 6, Types version 3
-- Time taken: 0.001601 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
setmetatable_result1_upvr.ClassName = "GamepadRotateModel"
local var1_result1_upvr = any_load_result1("AccelTween")
function setmetatable_result1_upvr.new() -- Line 16
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1._rampVelocityX = var1_result1_upvr.new(25)
	setmetatable_result1._rampVelocityY = var1_result1_upvr.new(25)
	setmetatable_result1.IsRotating = Instance.new("BoolValue")
	setmetatable_result1.IsRotating.Value = false
	setmetatable_result1._maid:GiveTask(setmetatable_result1.IsRotating)
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetThumbstickDeltaAngle(arg1) -- Line 29
	if not arg1._lastInputObject then
		return Vector2.new()
	end
	return Vector2.new(arg1._rampVelocityX.p, arg1._rampVelocityY.p)
end
function setmetatable_result1_upvr.StopRotate(arg1) -- Line 37
	arg1._lastInputObject = nil
	arg1._rampVelocityX.t = 0
	arg1._rampVelocityX.p = arg1._rampVelocityX.t
	arg1._rampVelocityY.t = 0
	arg1._rampVelocityY.p = arg1._rampVelocityY.t
	arg1.IsRotating.Value = false
end
local var1_result1_upvr_2 = any_load_result1("CameraGamepadInputUtils")
function setmetatable_result1_upvr.HandleThumbstickInput(arg1, arg2) -- Line 48
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if var1_result1_upvr_2.outOfDeadZone(arg2) then
		arg1._lastInputObject = arg2
		local Position = arg1._lastInputObject.Position
		local any_gamepadLinearToCurve_result1 = var1_result1_upvr_2.gamepadLinearToCurve(Vector2.new(-Position.x, Position.y))
		arg1._rampVelocityX.t = any_gamepadLinearToCurve_result1.x
		arg1._rampVelocityY.t = any_gamepadLinearToCurve_result1.y
		arg1.IsRotating.Value = true
	else
		arg1:StopRotate()
	end
end
return setmetatable_result1_upvr