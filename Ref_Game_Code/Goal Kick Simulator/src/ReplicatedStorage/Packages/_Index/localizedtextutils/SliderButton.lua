-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:29
-- Luau version 6, Types version 3
-- Time taken: 0.011877 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_7 = any_load_result1("BaseObject")
local var1_result1_upvr_2 = any_load_result1("PillBackingBuilder")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_7)
setmetatable_result1_upvr.ClassName = "SliderButton"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
any_load_result1("MouseOverMixin"):Add(setmetatable_result1_upvr)
local var1_result1_upvr_4 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_12 = any_load_result1("Signal")
local any_load_result1_result1_upvr_9 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_3 = any_load_result1("Spring")
local var1_result1_upvr = any_load_result1("AccelTween")
local var1_result1_upvr_5 = any_load_result1("StepUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("Blend")
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 37
	--[[ Upvalues[10]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_12 (readonly)
		[6]: any_load_result1_result1_upvr_9 (readonly)
		[7]: any_load_result1_result1_upvr_3 (readonly)
		[8]: var1_result1_upvr (readonly)
		[9]: var1_result1_upvr_5 (readonly)
		[10]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_7.new(arg2), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._dialogTemplates = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr_4)
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr)
	setmetatable_result1_upvr_2.DraggingDone = any_load_result1_result1_upvr_12.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.DraggingDone)
	setmetatable_result1_upvr_2._transparency = 0
	local var14 = arg3
	if not var14 then
		var14 = error("No formatType")
	end
	setmetatable_result1_upvr_2._formatType = var14
	setmetatable_result1_upvr_2._accentColor = any_load_result1_result1_upvr_9.DEFAULT_ACCENT_COLOR
	setmetatable_result1_upvr_2._toolTip = setmetatable_result1_upvr_2._obj.ToolTip
	setmetatable_result1_upvr_2._toolTipTextLabel = setmetatable_result1_upvr_2._toolTip.TextLabel
	setmetatable_result1_upvr_2:_buildBacking()
	setmetatable_result1_upvr_2._defaultSize = setmetatable_result1_upvr_2._obj.Size
	setmetatable_result1_upvr_2._bounceSpring = any_load_result1_result1_upvr_3.new(0)
	setmetatable_result1_upvr_2._bounceSpring.Speed = 30
	setmetatable_result1_upvr_2._bounceSpring.Damper = 0.5
	setmetatable_result1_upvr_2._bounceSpring.Target = 0
	setmetatable_result1_upvr_2._lastInteractionTime = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._lastInteractionTime.Value = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._lastInteractionTime)
	local any_GetMouseOverBoolValue_result1, any_GetMouseOverBoolValue_result2 = setmetatable_result1_upvr_2:GetMouseOverBoolValue(setmetatable_result1_upvr_2._obj)
	setmetatable_result1_upvr_2._maid._mouseOver = any_GetMouseOverBoolValue_result1
	setmetatable_result1_upvr_2._mouseOver = any_GetMouseOverBoolValue_result2
	setmetatable_result1_upvr_2._positionPercent = var1_result1_upvr.new(200)
	setmetatable_result1_upvr_2._positionPercent.t = 0
	setmetatable_result1_upvr_2._positionPercent.p = setmetatable_result1_upvr_2._positionPercent.t
	setmetatable_result1_upvr_2._sizeAdjustment = var1_result1_upvr.new(400)
	setmetatable_result1_upvr_2._sizeAdjustment.t = 0
	setmetatable_result1_upvr_2._sizeAdjustment.p = setmetatable_result1_upvr_2._sizeAdjustment.t
	setmetatable_result1_upvr_2._percentDragging = var1_result1_upvr.new(200)
	setmetatable_result1_upvr_2._percentDragging.t = 0
	setmetatable_result1_upvr_2._percentDragging.p = setmetatable_result1_upvr_2._percentDragging.t
	setmetatable_result1_upvr_2._percentToolTipShown = var1_result1_upvr.new(300)
	setmetatable_result1_upvr_2._percentToolTipShown.t = setmetatable_result1_upvr_2:_getPercentToolTipShown()
	setmetatable_result1_upvr_2._percentToolTipShown.p = setmetatable_result1_upvr_2._percentToolTipShown.t
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr_5.bindToRenderStep(setmetatable_result1_upvr_2._updateAnimate)
	setmetatable_result1_upvr_2._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr_2._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._mouseOver.Changed:Connect(function() -- Line 87
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._percentToolTipShown.t = setmetatable_result1_upvr_2:_getPercentToolTipShown()
		setmetatable_result1_upvr_2:_startAnimation()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._lastInteractionTime.Changed:Connect(function() -- Line 92
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._percentToolTipShown.t = setmetatable_result1_upvr_2:_getPercentToolTipShown()
		setmetatable_result1_upvr_2:_startAnimation()
	end))
	setmetatable_result1_upvr_2:_startAnimation()
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr_5.mount(setmetatable_result1_upvr_2._toolTipTextLabel, {
		Font = setmetatable_result1_upvr_2._guiThemeService:ObserveFont("font");
	}))
	return setmetatable_result1_upvr_2
end
local var1_result1_upvr_3 = any_load_result1("DialogAccentColorUtils")
function setmetatable_result1_upvr.SetAccentColor(arg1, arg2) -- Line 106
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var23
	if typeof(arg2) ~= "Color3" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad accentColor")
	arg1._accentColor = arg2
	var23 = arg1._accentColor
	arg1._obj.BackgroundColor3 = var23
	var23 = arg1._accentColor
	arg1._toolTip.BackgroundColor3 = var23
	var23 = arg1._accentColor
	arg1._backing.ImageColor3 = var23
	var23 = arg1._accentColor
	arg1._toolTipBacking.ImageColor3 = var23
	var23 = var1_result1_upvr_3.getTextColorForColoredBacking(arg1._accentColor)
	arg1._toolTipTextLabel.TextColor3 = var23
end
local any_load_result1_result1_upvr_8 = any_load_result1("HairLines")
function setmetatable_result1_upvr._createLines(arg1) -- Line 120
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
	]]
	local any_new_result1_2_upvr = any_load_result1_result1_upvr_8.new(arg1._serviceBag, 0, 300, 6)
	any_new_result1_2_upvr:SetColor(arg1._accentColor)
	any_new_result1_2_upvr:SetWidth(0.4)
	any_new_result1_2_upvr.Gui.Parent = arg1._obj
	any_new_result1_2_upvr:Play(function() -- Line 125
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:Destroy()
	end)
end
function setmetatable_result1_upvr.NotifyInteraction(arg1) -- Line 130
	arg1._lastInteractionTime.Value = tick()
end
local any_load_result1_result1_upvr_2 = any_load_result1("DialogSliderFormatTypeUtils")
function setmetatable_result1_upvr.Update(arg1, arg2, arg3, arg4) -- Line 134
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg1._positionPercent.t = arg3
	if arg4 then
		arg1._positionPercent.p = arg1._positionPercent.t
	end
	arg1._toolTipTextLabel.Text = tostring(arg2)
	arg1:_setToolTipText(any_load_result1_result1_upvr_2.formatValue(arg1._formatType, arg2))
	arg1:_startAnimation()
end
local TextService_upvr = game:GetService("TextService")
function setmetatable_result1_upvr._setToolTipText(arg1, arg2) -- Line 147
	--[[ Upvalues[1]:
		[1]: TextService_upvr (readonly)
	]]
	arg1._toolTipTextLabel.Text = arg2
	arg1._toolTip.Size = UDim2.new(0, math.max(20, TextService_upvr:GetTextSize(arg2, arg1._toolTipTextLabel.TextSize, arg1._toolTipTextLabel.Font, Vector2.new(1000000, 1000000)).x) + 30, 0, 30)
end
function setmetatable_result1_upvr.SetTransparency(arg1, arg2) -- Line 156
	arg1._transparency = arg2
	arg1:_startAnimation()
end
local any_load_result1_result1_upvr_11 = any_load_result1("Maid")
local any_load_result1_result1_upvr_10 = any_load_result1("SoundUtils")
local UserInputService_upvr = game:GetService("UserInputService")
function setmetatable_result1_upvr.StartDragging(arg1, arg2, arg3) -- Line 162
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_11 (readonly)
		[2]: any_load_result1_result1_upvr_10 (readonly)
		[3]: UserInputService_upvr (readonly)
	]]
	assert(arg2, "Bad startInputObject")
	assert(arg3, "Bad dialogSlider")
	local any_new_result1_3 = any_load_result1_result1_upvr_11.new()
	any_load_result1_result1_upvr_10.playTemplate(arg1._dialogTemplates, "ButtonPlopTemplate")
	arg1._percentDragging.t = 1
	any_new_result1_3:GiveTask(function() -- Line 171
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._percentDragging.t = 0
		arg1:_startAnimation()
	end)
	arg1:_startAnimation()
	arg3:SetPercent(arg1:_calculatePercent(arg2))
	local function onInputChanged(arg1_2) -- Line 180
		--[[ Upvalues[3]:
			[1]: arg2 (readonly)
			[2]: arg3 (readonly)
			[3]: arg1 (readonly)
		]]
		if arg1_2.UserInputType == Enum.UserInputType.MouseMovement or arg1_2 == arg2 then
			arg3:SetPercent(arg1:_calculatePercent(arg1_2))
		end
	end
	local function onInputEnded(arg1_3) -- Line 187
		--[[ Upvalues[3]:
			[1]: arg2 (readonly)
			[2]: any_load_result1_result1_upvr_10 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		if arg1_3.UserInputType == Enum.UserInputType.MouseButton1 or arg1_3 == arg2 then
			any_load_result1_result1_upvr_10.playTemplate(arg1._dialogTemplates, "ButtonPlopTemplate").Pitch = 0.7
			arg1:StopDragging()
		end
	end
	any_new_result1_3:GiveTask(UserInputService_upvr.InputChanged:Connect(onInputChanged))
	any_new_result1_3:GiveTask(UserInputService_upvr.InputEnded:Connect(onInputEnded))
	any_new_result1_3:GiveTask(arg3.Gui.InputChanged:Connect(onInputChanged))
	any_new_result1_3:GiveTask(arg3.Gui.InputEnded:Connect(onInputEnded))
	any_new_result1_3:GiveTask(arg1._obj.InputChanged:Connect(onInputChanged))
	any_new_result1_3:GiveTask(arg1._obj.InputEnded:Connect(onInputEnded))
	any_new_result1_3:GiveTask(function() -- Line 206
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._lastInteractionTime.Value = tick()
		if arg1.DraggingDone.Destroy then
			arg1.DraggingDone:Fire()
		end
		arg1:_startAnimation()
	end)
	arg1:_createLines()
	arg1._maid._draggingMaid = any_new_result1_3
end
function setmetatable_result1_upvr.StopDragging(arg1) -- Line 221
	arg1._maid._draggingMaid = nil
end
function setmetatable_result1_upvr.IsDragging(arg1) -- Line 225
	local var35
	if arg1._maid._draggingMaid == nil then
		var35 = false
	else
		var35 = true
	end
	return var35
end
function setmetatable_result1_upvr.BounceImpulse(arg1, arg2) -- Line 230
	arg1._bounceSpring:Impulse(200 * arg2)
	arg1:_startAnimation()
end
function setmetatable_result1_upvr._getPercentToolTipShown(arg1) -- Line 235
	if tick() - arg1._lastInteractionTime.Value <= 0.4 then
		return 1
	end
	if arg1:IsDragging() then
		return 1
	end
	if arg1._mouseOver.Value then
		return 1
	end
	return 0
end
local any_load_result1_result1_upvr_6 = any_load_result1("Math")
local any_load_result1_result1_upvr_4 = any_load_result1("PillBackingUtils")
function setmetatable_result1_upvr._updateAnimate(arg1) -- Line 251
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg1._percentToolTipShown.t = arg1:_getPercentToolTipShown()
	local var42
	if arg1._mouseOver.Value then
		var42 = 1
	else
		var42 = 0
	end
	arg1._sizeAdjustment.t = math.max(arg1._percentDragging.t, 0.5 * var42)
	local var43 = 10 * arg1._sizeAdjustment.p
	var42 = 0
	arg1._obj.Size = arg1._defaultSize + UDim2.new(var42, var43, 0, var43)
	var42 = arg1._positionPercent
	var42 = arg1._bounceSpring.Position
	arg1._obj.Position = UDim2.new(var42.p, var42, 0.5, 0)
	arg1._backing.ImageTransparency = arg1._transparency
	var42 = 0
	arg1._shadow.ImageTransparency = any_load_result1_result1_upvr_6.map(arg1._transparency, var42, 1, var1_result1_upvr_2.SHADOW_TRANSPARENCY, 1)
	var42 = arg1._percentToolTipShown.p
	var42 = 1
	local any_map_result1 = any_load_result1_result1_upvr_6.map(1 - math.max(var42, arg1._percentDragging.p), 0, var42, arg1._transparency, 1)
	var42 = 0
	arg1._toolTipBacking.ImageTransparency = any_map_result1
	var42 = any_load_result1_result1_upvr_4
	var42 = arg1._toolTipShadow
	var42.setShadowTransparency(var42, any_load_result1_result1_upvr_6.map(any_map_result1, var42, 1, var1_result1_upvr_2.SHADOW_TRANSPARENCY, 1))
	arg1._toolTipTextLabel.TextTransparency = any_map_result1
	var42 = arg1._percentDragging.rtime
	if 0 >= var42 then
		var42 = arg1._percentToolTipShown.rtime
		if 0 >= var42 then
			var42 = arg1._sizeAdjustment.rtime
			if 0 >= var42 then
				var42 = arg1._positionPercent.rtime
				if 0 >= var42 then
					var42 = tick() - arg1._lastInteractionTime.Value
					if var42 >= 0.4 then
						var42 = math.abs(arg1._bounceSpring.Velocity)
						if 0.001 >= var42 then
							var42 = math.abs(arg1._bounceSpring.Target - arg1._bounceSpring.Position)
							if 0.001 >= var42 then
							else
							end
						end
					end
				end
			end
		end
	end
	return true
end
local any_load_result1_result1_upvr_13 = any_load_result1("UIPaddingUtils")
function setmetatable_result1_upvr._calculatePercent(arg1, arg2) -- Line 282
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_13 (readonly)
	]]
	assert(arg2, "Bad inputObject")
	local Parent = arg1._obj.Parent
	local class_UIPadding = Parent:FindFirstChildOfClass("UIPadding")
	if not class_UIPadding then
		class_UIPadding = error("NO uiPadding")
	end
	return math.clamp(((arg2.Position.x) - (Parent.AbsolutePosition.x + class_UIPadding.PaddingLeft.Offset)) / (Parent.AbsoluteSize.x - any_load_result1_result1_upvr_13.getHorizontalPadding(class_UIPadding).Offset), 0, 1)
end
function setmetatable_result1_upvr._buildBacking(arg1) -- Line 301
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1 = var1_result1_upvr_2.new()
	arg1._obj.BackgroundColor3 = arg1._accentColor
	arg1._toolTip.BackgroundColor3 = arg1._accentColor
	arg1._backing = any_new_result1:CreateCircle(arg1._obj)
	arg1._shadow = any_new_result1:CreateCircleShadow(arg1._obj)
	arg1._toolTipBacking = any_new_result1:CreateSingle(arg1._toolTip)
	arg1._toolTipShadow = any_new_result1:CreateShadow(arg1._toolTip)
end
return setmetatable_result1_upvr