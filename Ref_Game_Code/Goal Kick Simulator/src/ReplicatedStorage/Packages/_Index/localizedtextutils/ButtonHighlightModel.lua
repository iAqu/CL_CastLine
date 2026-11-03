-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:09
-- Luau version 6, Types version 3
-- Time taken: 0.015450 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("Blend")
local any_load_result1_result1_upvr_3 = any_load_result1("Rx")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "ButtonHighlightModel"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_5 = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_4 = any_load_result1("StepUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 55
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_5 (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_2.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._onUpdate = arg2
	setmetatable_result1_upvr.InteractionEnabled = Instance.new("BoolValue")
	setmetatable_result1_upvr.InteractionEnabled.Value = true
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.InteractionEnabled)
	setmetatable_result1_upvr.IsSelected = Instance.new("BoolValue")
	setmetatable_result1_upvr.IsSelected.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsSelected)
	setmetatable_result1_upvr.IsMouseOrTouchOver = Instance.new("BoolValue")
	setmetatable_result1_upvr.IsMouseOrTouchOver.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsMouseOrTouchOver)
	setmetatable_result1_upvr._isMouseDown = Instance.new("BoolValue")
	setmetatable_result1_upvr._isMouseDown.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseDown)
	setmetatable_result1_upvr._numFingerDown = Instance.new("IntValue")
	setmetatable_result1_upvr._numFingerDown.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._numFingerDown)
	setmetatable_result1_upvr.IsChoosen = Instance.new("BoolValue")
	setmetatable_result1_upvr.IsChoosen.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsChoosen)
	setmetatable_result1_upvr._isKeyDown = Instance.new("BoolValue")
	setmetatable_result1_upvr._isKeyDown.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isKeyDown)
	setmetatable_result1_upvr._isMouseOver = Instance.new("BoolValue")
	setmetatable_result1_upvr._isMouseOver.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseOver)
	setmetatable_result1_upvr.IsHighlighted = Instance.new("BoolValue")
	setmetatable_result1_upvr.IsHighlighted.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsHighlighted)
	setmetatable_result1_upvr.IsPressed = Instance.new("BoolValue")
	setmetatable_result1_upvr.IsPressed.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsPressed)
	if setmetatable_result1_upvr._onUpdate then
		setmetatable_result1_upvr._percentHighlightedAccelTween = any_load_result1_result1_upvr_5.new(200)
		setmetatable_result1_upvr._percentHighlightedAccelTween.t = 0
		setmetatable_result1_upvr._percentHighlightedAccelTween.p = 0
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsHighlighted.Changed:Connect(function() -- Line 136
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			local var11 = setmetatable_result1_upvr
			if setmetatable_result1_upvr.IsHighlighted.Value then
				var11 = 1
			else
				var11 = 0
			end
			var11._percentHighlightedAccelTween.t = var11
			setmetatable_result1_upvr:StartAnimation()
		end))
		setmetatable_result1_upvr._percentChoosenAccelTween = any_load_result1_result1_upvr_5.new(200)
		setmetatable_result1_upvr._percentChoosenAccelTween.t = 0
		setmetatable_result1_upvr._percentChoosenAccelTween.p = 0
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsChoosen.Changed:Connect(function() -- Line 145
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			local var13 = setmetatable_result1_upvr
			if setmetatable_result1_upvr.IsChoosen.Value then
				var13 = 1
			else
				var13 = 0
			end
			var13._percentChoosenAccelTween.t = var13
			setmetatable_result1_upvr:StartAnimation()
		end))
		setmetatable_result1_upvr._percentPressAccelTween = any_load_result1_result1_upvr_5.new(200)
		setmetatable_result1_upvr._percentPressAccelTween.t = 0
		setmetatable_result1_upvr._percentPressAccelTween.p = 0
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsPressed.Changed:Connect(function() -- Line 154
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			local var15 = setmetatable_result1_upvr
			if setmetatable_result1_upvr.IsPressed.Value then
				var15 = 1
			else
				var15 = 0
			end
			var15._percentPressAccelTween.t = var15
			setmetatable_result1_upvr:StartAnimation()
		end))
		local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_4.bindToRenderStep(setmetatable_result1_upvr._update)
		setmetatable_result1_upvr.StartAnimation = any_bindToRenderStep_result1
		setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
		setmetatable_result1_upvr:StartAnimation()
	end
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseOver.Changed:Connect(function() -- Line 163
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._numFingerDown.Changed:Connect(function() -- Line 166
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsChoosen.Changed:Connect(function() -- Line 170
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isKeyDown.Changed:Connect(function() -- Line 174
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.IsSelected.Changed:Connect(function() -- Line 178
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._isMouseDown.Changed:Connect(function() -- Line 182
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateTargets()
	end))
	setmetatable_result1_upvr:_updateTargets()
	if arg1 then
		setmetatable_result1_upvr:SetButton(arg1)
	end
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetButton(arg1, arg2) -- Line 198
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var24 = true
	if typeof(arg2) ~= "Instance" then
		if arg2 ~= nil then
			var24 = false
		else
			var24 = true
		end
	end
	assert(var24, "Bad button")
	local any_new_result1_2 = any_load_result1_result1_upvr.new()
	if arg2 then
		any_new_result1_2:GiveTask(arg2.InputEnded:Connect(function(arg1_2) -- Line 204
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1_2.UserInputType == Enum.UserInputType.MouseMovement then
				arg1._isMouseOver.Value = false
			end
			if arg1_2.UserInputType == Enum.UserInputType.MouseButton1 then
				arg1._isMouseDown.Value = false
			end
			if arg1_2.UserInputType == Enum.UserInputType.Touch then
				arg1:_stopTouchTrack(arg1_2)
			end
		end))
		any_new_result1_2:GiveTask(arg2.SelectionGained:Connect(function() -- Line 218
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1.IsSelected.Value = true
		end))
		any_new_result1_2:GiveTask(arg2.SelectionLost:Connect(function() -- Line 222
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1.IsSelected.Value = false
		end))
		any_new_result1_2:GiveTask(arg2.InputBegan:Connect(function(arg1_3) -- Line 226
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1_3.UserInputType == Enum.UserInputType.MouseMovement then
				arg1._isMouseOver.Value = true
			end
			if arg1_3.UserInputType == Enum.UserInputType.MouseButton1 then
				arg1._isMouseDown.Value = true
			end
			if arg1_3.UserInputType == Enum.UserInputType.Touch then
				arg1:_trackTouch(arg1_3)
			end
		end))
	end
	arg1._maid._buttonMaid = any_new_result1_2
end
function setmetatable_result1_upvr_2.ObservePercentPressed(arg1) -- Line 248
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr.AccelTween(var1_result1_upvr.toPropertyObservable(arg1.IsPressed):Pipe({any_load_result1_result1_upvr_3.map(function(arg1_4) -- Line 251
		if arg1_4 then
			return 1
		end
		return 0
	end)}), 200)
end
function setmetatable_result1_upvr_2.ObservePercentHighlighted(arg1) -- Line 261
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.AccelTween(arg1:ObservePercentHighlightedTarget(), 200)
end
function setmetatable_result1_upvr_2.ObservePercentHighlightedTarget(arg1) -- Line 269
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr.toPropertyObservable(arg1.IsHighlighted):Pipe({any_load_result1_result1_upvr_3.map(function(arg1_5) -- Line 272
		if arg1_5 then
			return 1
		end
		return 0
	end)})
end
function setmetatable_result1_upvr_2.ObservePercentChoosen(arg1) -- Line 282
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr.AccelTween(var1_result1_upvr.toPropertyObservable(arg1.IsChoosen):Pipe({any_load_result1_result1_upvr_3.map(function(arg1_6) -- Line 285
		if arg1_6 then
			return 1
		end
		return 0
	end)}), 200)
end
function setmetatable_result1_upvr_2.IsInteractionEnabled(arg1) -- Line 295
	return arg1.InteractionEnabled.Value
end
function setmetatable_result1_upvr_2.SetKeyDown(arg1, arg2) -- Line 303
	arg1._isKeyDown.Value = arg2
end
function setmetatable_result1_upvr_2.SetInteractionEnabled(arg1, arg2) -- Line 311
	local var36
	if type(arg2) ~= "boolean" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Bad interactionEnabled")
	arg1.InteractionEnabled.Value = arg2
end
function setmetatable_result1_upvr_2.SetIsChoosen(arg1, arg2) -- Line 321
	local var37
	if type(arg2) ~= "boolean" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad isChoosen")
	arg1.IsChoosen.Value = arg2
end
function setmetatable_result1_upvr_2._trackTouch(arg1, arg2) -- Line 327
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2.UserInputState == Enum.UserInputState.End then
	else
		local any_new_result1 = any_load_result1_result1_upvr.new()
		arg1._maid[arg2] = nil
		arg1._numFingerDown.Value = arg1._numFingerDown.Value + 1
		any_new_result1:GiveTask(function() -- Line 336
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._numFingerDown.Value = arg1._numFingerDown.Value - 1
		end)
		any_new_result1:GiveTask(arg2:GetPropertyChangedSignal("UserInputState"):Connect(function() -- Line 339
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			if arg2.UserInputState == Enum.UserInputState.End then
				arg1._maid[arg2] = nil
			end
		end))
		arg1._maid[arg2] = any_new_result1
	end
end
function setmetatable_result1_upvr_2._stopTouchTrack(arg1, arg2) -- Line 348
	arg1._maid[arg2] = nil
end
function setmetatable_result1_upvr_2._updateTargets(arg1) -- Line 353
	local var43
	if not var43 then
		if 0 >= arg1._numFingerDown.Value then
			var43 = false
		else
			var43 = true
		end
	end
	arg1.IsMouseOrTouchOver.Value = var43
	var43 = arg1._isMouseDown.Value
	if not var43 then
		var43 = arg1._isKeyDown.Value
		if not var43 then
			if 0 >= arg1._numFingerDown.Value then
				var43 = false
			else
				var43 = true
			end
		end
	end
	arg1.IsPressed.Value = var43
	var43 = arg1.IsChoosen.Value
	if not var43 then
		var43 = arg1.IsSelected.Value
		if not var43 then
			var43 = true
			if 0 >= arg1._numFingerDown.Value then
				var43 = arg1._isKeyDown.Value
				if not var43 then
					var43 = arg1._isMouseOver.Value
					if not var43 then
						var43 = arg1._isMouseDown.Value
					end
				end
			end
		end
	end
	arg1.IsHighlighted.Value = var43
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 364
	return arg1._onUpdate(arg1._percentHighlightedAccelTween, arg1._percentChoosenAccelTween, arg1._percentPressAccelTween)
end
return setmetatable_result1_upvr_2