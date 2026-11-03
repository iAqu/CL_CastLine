-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:17
-- Luau version 6, Types version 3
-- Time taken: 0.005853 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local var1_result1_upvr = any_load_result1("Maid")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "ColorPickerInput"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new() -- Line 17
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._isMouseDown = Instance.new("BoolValue")
	setmetatable_result1_upvr._isMouseDown.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseDown)
	setmetatable_result1_upvr._numFingerDown = Instance.new("IntValue")
	setmetatable_result1_upvr._numFingerDown.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._numFingerDown)
	setmetatable_result1_upvr._currentPosition = Instance.new("Vector3Value")
	setmetatable_result1_upvr._currentPosition.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._currentPosition)
	setmetatable_result1_upvr._activePositions = {}
	setmetatable_result1_upvr._isPressed = Instance.new("BoolValue")
	setmetatable_result1_upvr._isPressed.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isPressed)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseDown.Changed:Connect(function() -- Line 38
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateIsPressed()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._numFingerDown.Changed:Connect(function() -- Line 41
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateIsPressed()
	end))
	setmetatable_result1_upvr.PositionChanged = setmetatable_result1_upvr._currentPosition.Changed
	setmetatable_result1_upvr.IsPressedChanged = setmetatable_result1_upvr._isPressed.Changed
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetIsPressedValue(arg1) -- Line 51
	return arg1._isPressed
end
function setmetatable_result1_upvr_2.GetPosition(arg1) -- Line 55
	return arg1._currentPosition.Value
end
function setmetatable_result1_upvr_2.GetIsPressed(arg1) -- Line 59
	return arg1._isPressed.Value
end
function setmetatable_result1_upvr_2.SetButton(arg1, arg2) -- Line 63
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
	]]
	if not arg2 then
		arg1._maid._button = nil
	else
		local any_new_result1_2_upvr = var1_result1_upvr.new()
		any_new_result1_2_upvr:GiveTask(arg2.InputBegan:Connect(function(arg1_2) -- Line 71
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: any_new_result1_2_upvr (readonly)
			]]
			if arg1_2.UserInputType == Enum.UserInputType.MouseButton1 then
				arg1._isMouseDown.Value = true
				arg1._activePositions.mouse = arg1:_toButtonSpace(arg2, arg1_2.Position)
				arg1:_updateCurrentPosition()
			end
			if arg1_2.UserInputType == Enum.UserInputType.Touch then
				arg1:_trackTouch(any_new_result1_2_upvr, arg2, arg1_2)
			end
		end))
		any_new_result1_2_upvr:GiveTask(arg2.InputEnded:Connect(function(arg1_3) -- Line 83
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_2_upvr (readonly)
			]]
			if arg1_3.UserInputType == Enum.UserInputType.MouseButton1 then
				arg1._isMouseDown.Value = false
			end
			if arg1_3.UserInputType == Enum.UserInputType.Touch then
				arg1:_stopTouchTrack(any_new_result1_2_upvr, arg1_3)
			end
		end))
		any_new_result1_2_upvr:GiveTask(UserInputService_upvr.InputEnded:Connect(function(arg1_4) -- Line 93
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1_4.UserInputType == Enum.UserInputType.MouseButton1 then
				arg1._isMouseDown.Value = false
			end
		end))
		any_new_result1_2_upvr:GiveTask(function() -- Line 99
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._isMouseDown.Value = false
		end)
		any_new_result1_2_upvr:GiveTask(arg1._isMouseDown.Changed:Connect(function() -- Line 103
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_2_upvr (readonly)
				[3]: arg2 (readonly)
			]]
			arg1:_updateMouseTracking(any_new_result1_2_upvr, arg2)
		end))
		arg1._maid._button = any_new_result1_2_upvr
	end
end
function setmetatable_result1_upvr_2._updateIsPressed(arg1) -- Line 110
	if 0 < arg1._numFingerDown.Value or arg1._isMouseDown.Value then
		arg1._isPressed.Value = true
	else
		arg1._isPressed.Value = false
	end
end
local var1_result1_upvr_3 = any_load_result1("InputObjectUtils")
function setmetatable_result1_upvr_2._updateMouseTracking(arg1, arg2, arg3) -- Line 118
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	if not arg1._isMouseDown.Value then
		arg2._mouse = nil
	else
		local any_new_result1 = var1_result1_upvr.new()
		any_new_result1:GiveTask(UserInputService_upvr.InputChanged:Connect(function(arg1_5) -- Line 126
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: arg3 (readonly)
				[3]: arg1 (readonly)
			]]
			if not var1_result1_upvr_3.isMouseUserInputType(arg1_5.UserInputType) then
			else
				local class_ScreenGui = arg3:FindFirstAncestorWhichIsA("ScreenGui")
				if not class_ScreenGui then return end
				if not class_ScreenGui:FindFirstAncestorWhichIsA("PlayerGui") and not class_ScreenGui:FindFirstAncestorWhichIsA("CoreGui") then return end
				arg1._activePositions.mouse = arg1:_toButtonSpace(arg3, arg1_5.Position)
				arg1:_updateCurrentPosition()
			end
		end))
		any_new_result1:GiveTask(arg3.InputChanged:Connect(function(arg1_6) -- Line 145
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg3 (readonly)
			]]
			if var1_result1_upvr_3.isMouseUserInputType(arg1_6.UserInputType) then
				arg1._activePositions.mouse = arg1:_toButtonSpace(arg3, arg1_6.Position)
				arg1:_updateCurrentPosition()
			end
		end))
		any_new_result1:GiveTask(function() -- Line 152
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._activePositions.mouse = nil
			arg1:_updateCurrentPosition()
		end)
		arg2._mouse = any_new_result1
	end
end
function setmetatable_result1_upvr_2._trackTouch(arg1, arg2, arg3, arg4) -- Line 160
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	arg2[arg4] = nil
	if arg4.UserInputState == Enum.UserInputState.End then
	else
		local any_new_result1_3_upvr = var1_result1_upvr.new()
		arg1._activePositions[arg4] = arg1:_toButtonSpace(arg3, arg4.Position)
		arg1._numFingerDown.Value = arg1._numFingerDown.Value + 1
		any_new_result1_3_upvr:GiveTask(arg4:GetPropertyChangedSignal("Position"):Connect(function() -- Line 172
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg4 (readonly)
				[3]: arg3 (readonly)
			]]
			arg1._activePositions[arg4] = arg1:_toButtonSpace(arg3, arg4.Position)
			arg1:_updateCurrentPosition()
		end))
		any_new_result1_3_upvr:GiveTask(arg4:GetPropertyChangedSignal("UserInputState"):Connect(function() -- Line 176
			--[[ Upvalues[2]:
				[1]: arg4 (readonly)
				[2]: any_new_result1_3_upvr (readonly)
			]]
			if arg4.UserInputState == Enum.UserInputState.End then
				any_new_result1_3_upvr[arg4] = nil
			end
		end))
		any_new_result1_3_upvr:GiveTask(function() -- Line 182
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg4 (readonly)
			]]
			arg1._activePositions[arg4] = nil
			arg1._numFingerDown.Value = arg1._numFingerDown.Value - 1
			arg1:_updateCurrentPosition()
		end)
		arg1:_updateCurrentPosition()
		any_new_result1_3_upvr[arg4] = any_new_result1_3_upvr
	end
end
function setmetatable_result1_upvr_2._stopTouchTrack(arg1, arg2, arg3) -- Line 193
	arg2[arg3] = nil
end
function setmetatable_result1_upvr_2._toButtonSpace(arg1, arg2, arg3) -- Line 198
	local var25 = (arg3 - Vector3.new(arg2.AbsolutePosition.x, arg2.AbsolutePosition.y, 0)) / Vector3.new(arg2.AbsoluteSize.x, arg2.AbsoluteSize.y, 1)
	return Vector3.new(math.clamp(var25.x, 0, 1), math.clamp(var25.y, 0, 1), 0)
end
function setmetatable_result1_upvr_2._updateCurrentPosition(arg1) -- Line 206
	local var30 = Vector3.new(0, 0, 0)
	local var31 = 0
	for _, v in pairs(arg1._activePositions) do
		var30 += v
		var31 += 1
	end
	if var31 == 0 then
	else
		arg1._currentPosition.Value = var30 / var31
	end
end
return setmetatable_result1_upvr_2