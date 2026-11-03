-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:28
-- Luau version 6, Types version 3
-- Time taken: 0.013844 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_7 = any_load_result1("DialogPromptPaneBase")
local var1_result1_upvr_4 = any_load_result1("DialogSliderOptionUtils")
local var1_result1_upvr = any_load_result1("Math")
local var1_result1_upvr_7 = any_load_result1("RoundedBackingBuilder")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_7)
setmetatable_result1_upvr_2.ClassName = "DialogSlider"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_10 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_9 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_3 = any_load_result1("DialogInputKeyMap")
local var1_result1_upvr_2 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_8 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_5 = any_load_result1("DialogSliderOptionTypes")
local var1_result1_upvr_6 = any_load_result1("DialogLocalizedSliderUtils")
local HttpService_upvr = game:GetService("HttpService")
local any_load_result1_result1_upvr_6 = any_load_result1("Signal")
local any_load_result1_result1_upvr = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_4 = any_load_result1("StepUtils")
local var1_result1_upvr_5 = any_load_result1("SliderButton")
local var1_result1_upvr_8 = any_load_result1("ConfirmChoicePane")
local any_load_result1_result1_upvr_11 = any_load_result1("Blend")
function setmetatable_result1_upvr_2.new(arg1, arg2, arg3) -- Line 42
	--[[ Upvalues[17]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
		[2]: any_load_result1_result1_upvr_10 (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_9 (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
		[6]: var1_result1_upvr_2 (readonly)
		[7]: any_load_result1_result1_upvr_8 (readonly)
		[8]: any_load_result1_result1_upvr_5 (readonly)
		[9]: var1_result1_upvr_6 (readonly)
		[10]: HttpService_upvr (readonly)
		[11]: any_load_result1_result1_upvr_6 (readonly)
		[12]: any_load_result1_result1_upvr (readonly)
		[13]: any_load_result1_result1_upvr_4 (readonly)
		[14]: var1_result1_upvr_5 (readonly)
		[15]: var1_result1_upvr_8 (readonly)
		[16]: var1_result1_upvr_4 (readonly)
		[17]: any_load_result1_result1_upvr_11 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_7.new(arg1:GetService(any_load_result1_result1_upvr_10):Clone("DialogSliderTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._dialogTemplates = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_10)
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_9)
	setmetatable_result1_upvr._dialogInputKeyMap = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_3)
	local var22 = arg2
	if not var22 then
		var22 = error("No options")
	end
	setmetatable_result1_upvr._sliderOptions = var22
	var22 = arg3
	local var23 = var22
	if not var23 then
		var23 = error("No dialogInput")
	end
	setmetatable_result1_upvr._dialogInput = var23
	setmetatable_result1_upvr._accentColorValue = var1_result1_upvr_2.new(any_load_result1_result1_upvr_8.DEFAULT_ACCENT_COLOR)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._accentColorValue)
	if setmetatable_result1_upvr._sliderOptions.type == any_load_result1_result1_upvr_5.LOCALIZED_SLIDER_OPTIONS then
		setmetatable_result1_upvr._sliderOptions = var1_result1_upvr_6.createOptionsFromLocalizedOptions(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._sliderOptions)
	end
	setmetatable_result1_upvr._key = HttpService_upvr:GenerateGUID(false)
	setmetatable_result1_upvr._thumbstickData = {}
	setmetatable_result1_upvr.SelectionChanged = any_load_result1_result1_upvr_6.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.SelectionChanged)
	setmetatable_result1_upvr.SelectionConfirmed = any_load_result1_result1_upvr_6.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.SelectionConfirmed)
	setmetatable_result1_upvr._percentVisible = any_load_result1_result1_upvr.new(300)
	setmetatable_result1_upvr._percentVisible.t = 0
	setmetatable_result1_upvr._percentVisible.p = 0
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_4.bindToRenderStep(setmetatable_result1_upvr._updateAnimate)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr._currentPercent = Instance.new("NumberValue")
	local initialValue = setmetatable_result1_upvr._sliderOptions.initialValue
	if not initialValue then
		initialValue = error("No initialValue")
	end
	setmetatable_result1_upvr._currentPercent.Value = setmetatable_result1_upvr:_convertValueToPercent(initialValue)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._currentPercent)
	setmetatable_result1_upvr._uiScale = setmetatable_result1_upvr._gui.UIScale
	setmetatable_result1_upvr._mainContainer = setmetatable_result1_upvr._gui.MainContainer
	setmetatable_result1_upvr._choiceContainer = setmetatable_result1_upvr._gui.ChoiceContainer
	setmetatable_result1_upvr._mainContainerUIPadding = setmetatable_result1_upvr._mainContainer.UIPadding
	setmetatable_result1_upvr._sliderContainerButton = setmetatable_result1_upvr._mainContainer.SliderContainerButton
	setmetatable_result1_upvr._sliderBar = setmetatable_result1_upvr._sliderContainerButton.SliderBar
	setmetatable_result1_upvr._buttonContainer = setmetatable_result1_upvr._sliderBar.ButtonContainer
	setmetatable_result1_upvr._button = var1_result1_upvr_5.new(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._buttonContainer.SliderButton, setmetatable_result1_upvr._sliderOptions.formatType)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._button)
	setmetatable_result1_upvr.WaitingForRequestNextInput = Instance.new("BoolValue")
	setmetatable_result1_upvr.WaitingForRequestNextInput.Value = true
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.WaitingForRequestNextInput)
	setmetatable_result1_upvr._choicePane = var1_result1_upvr_8.new(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._choiceContainer)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._choicePane)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._accentColorValue.Changed:Connect(function(arg1_2) -- Line 103
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._button:SetAccentColor(arg1_2)
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._button.DraggingDone:Connect(function() -- Line 107
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.WaitingForRequestNextInput.Value = true
	end))
	setmetatable_result1_upvr._minLabel = setmetatable_result1_upvr._sliderContainerButton.MinLabel
	setmetatable_result1_upvr._maxLabel = setmetatable_result1_upvr._sliderContainerButton.MaxLabel
	setmetatable_result1_upvr:_buildBacking()
	setmetatable_result1_upvr:_updateLabelsAndSizes()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._choicePane.ChoiceConfirmed:Connect(function() -- Line 117
		--[[ Upvalues[2]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
		]]
		local Value_2 = setmetatable_result1_upvr._currentPercent.Value
		setmetatable_result1_upvr.SelectionConfirmed:Fire(var1_result1_upvr_4.createSliderResult(setmetatable_result1_upvr:_convertPercentToValue(Value_2), Value_2))
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._dialogInput.RequestedNextInput:Connect(function() -- Line 123
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if not setmetatable_result1_upvr:IsVisible() then
		else
			if not setmetatable_result1_upvr.WaitingForRequestNextInput.Value then return end
			setmetatable_result1_upvr._choicePane:ShowChoicePane()
		end
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_3, arg2_2, arg3_2) -- Line 135
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		local var33 = setmetatable_result1_upvr
		if arg1_3 then
			var33 = 1
		else
			var33 = 0
		end
		var33._percentVisible.t = var33
		if arg2_2 then
			setmetatable_result1_upvr._percentVisible.p = setmetatable_result1_upvr._percentVisible.t
		else
			setmetatable_result1_upvr._percentVisible.v = setmetatable_result1_upvr._percentVisible.v + 20
		end
		setmetatable_result1_upvr:_startAnimation()
		if arg1_3 then
			setmetatable_result1_upvr:_listenForInput(arg3_2)
		else
			setmetatable_result1_upvr._choicePane:HideChoicePane()
		end
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._currentPercent.Changed:Connect(function() -- Line 152
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_updateCurrentPercent()
	end))
	setmetatable_result1_upvr:_updateCurrentPercent(true)
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_11.mount(setmetatable_result1_upvr._minLabel, {
		Font = setmetatable_result1_upvr._guiThemeService:ObserveFont("font");
		TextColor3 = setmetatable_result1_upvr._guiThemeService:ObserveColor("text");
	}))
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_11.mount(setmetatable_result1_upvr._maxLabel, {
		Font = setmetatable_result1_upvr._guiThemeService:ObserveFont("font");
		TextColor3 = setmetatable_result1_upvr._guiThemeService:ObserveColor("text");
	}))
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_11.mount(setmetatable_result1_upvr._backing, {
		ImageColor3 = setmetatable_result1_upvr._guiThemeService:ObserveColor("surface");
	}))
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_11.mount(setmetatable_result1_upvr._barBacking, {
		ImageColor3 = setmetatable_result1_upvr._guiThemeService:ObserveColor("surface", "subdued_surface");
	}))
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetAccentColor(arg1, arg2) -- Line 176
	local var39
	if typeof(arg2) ~= "Color3" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Bad accentColor")
	var39 = arg2
	if not var39 then
		var39 = error("No accentColor")
	end
	arg1._accentColorValue.Value = var39
	arg1._choicePane:SetAccentColor(arg2)
end
function setmetatable_result1_upvr_2.GetSliderOptions(arg1) -- Line 182
	return arg1._sliderOptions
end
function setmetatable_result1_upvr_2.SetValue(arg1, arg2) -- Line 186
	arg1:SetPercent(arg1:_convertValueToPercent(arg2))
end
function setmetatable_result1_upvr_2.GetValue(arg1) -- Line 190
	return arg1:_convertPercentToValue(arg1._currentPercent.Value)
end
function setmetatable_result1_upvr_2.SetPercent(arg1, arg2) -- Line 194
	arg1._currentPercent.Value = arg1:_convertValueToPercent(arg1:_convertPercentToValue(arg2))
end
local ContextActionService_upvr = game:GetService("ContextActionService")
function setmetatable_result1_upvr_2._listenForInput(arg1, arg2) -- Line 200
	--[[ Upvalues[1]:
		[1]: ContextActionService_upvr (readonly)
	]]
	local any_GetInputKeyMapList_result1_2 = arg1._dialogInputKeyMap:GetInputKeyMapList("DIALOG_SLIDER_MOVE_LEFT")
	local any_GetInputKeyMapList_result1 = arg1._dialogInputKeyMap:GetInputKeyMapList("DIALOG_SLIDER_MOVE_RIGHT")
	arg2:GiveTask(arg1._sliderContainerButton.MouseWheelForward:Connect(function() -- Line 204
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_doMoveSlider(1)
	end))
	arg2:GiveTask(arg1._sliderContainerButton.MouseWheelBackward:Connect(function() -- Line 207
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_doMoveSlider(-1)
	end))
	arg2:GiveTask(arg1._sliderContainerButton.InputBegan:Connect(function(arg1_4) -- Line 211
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleInputBegan(arg1_4, arg1)
	end))
	arg2:GiveTask(any_GetInputKeyMapList_result1_2:ObserveInputEnumsList():Subscribe(function(arg1_5) -- Line 215
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:BindActionAtPriority(arg1._key.."MoveSliderLeft", function(arg1_6, arg2_3, arg3) -- Line 217
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			return arg1:_moveSliderLeft(arg3)
		end, false, Enum.ContextActionPriority.High.Value, unpack(arg1_5))
	end))
	arg2:GiveTask(any_GetInputKeyMapList_result1:ObserveInputEnumsList():Subscribe(function(arg1_7) -- Line 225
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:BindActionAtPriority(arg1._key.."MoveSliderRight", function(arg1_8, arg2_4, arg3) -- Line 227
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			return arg1:_moveSliderRight(arg3)
		end, false, Enum.ContextActionPriority.High.Value, unpack(arg1_7))
	end))
	arg1:_makeInputHint(arg2, arg1._minLabel.InputHintContainer, any_GetInputKeyMapList_result1_2)
	arg1:_makeInputHint(arg2, arg1._maxLabel.InputHintContainer, any_GetInputKeyMapList_result1)
	arg2:GiveTask(function() -- Line 238
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:UnbindAction(arg1._key.."MoveSliderLeft")
		ContextActionService_upvr:UnbindAction(arg1._key.."MoveSliderRight")
	end)
end
local var1_result1_upvr_3 = any_load_result1("HintInput")
function setmetatable_result1_upvr_2._makeInputHint(arg1, arg2, arg3, arg4) -- Line 244
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr_3.new(arg1._serviceBag, arg4)
	any_new_result1_2_upvr.Gui.Position = UDim2.new(0, 0, 0, 0)
	any_new_result1_2_upvr.Gui.AnchorPoint = Vector2.new(0, 0)
	any_new_result1_2_upvr.Gui.Parent = arg3
	local function updateVisible() -- Line 250
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_2_upvr (readonly)
		]]
		if arg1._choicePane:IsShowingChoicePane() or not arg1:IsVisible() then
			any_new_result1_2_upvr:Hide()
		else
			any_new_result1_2_upvr:Show()
		end
	end
	arg2:GiveTask(function() -- Line 259
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:Hide()
		task.delay(1, function() -- Line 261
			--[[ Upvalues[1]:
				[1]: any_new_result1_2_upvr (copied, readonly)
			]]
			any_new_result1_2_upvr:Destroy()
		end)
	end)
	arg2:GiveTask(arg1._choicePane.CurrentChoicePaneValue.Changed:Connect(updateVisible))
	arg2:GiveTask(arg1.VisibleChanged:Connect(updateVisible))
	if arg1._choicePane:IsShowingChoicePane() or not arg1:IsVisible() then
		any_new_result1_2_upvr:Hide()
	else
		any_new_result1_2_upvr:Show()
	end
end
function setmetatable_result1_upvr_2._moveSliderLeft(arg1, arg2) -- Line 271
	return arg1:_moveSlider(arg2, -1)
end
function setmetatable_result1_upvr_2._moveSliderRight(arg1, arg2) -- Line 275
	return arg1:_moveSlider(arg2, 1)
end
local UserInputService_upvr = game:GetService("UserInputService")
function setmetatable_result1_upvr_2._moveSlider(arg1, arg2, arg3) -- Line 279
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	assert(arg1._sliderOptions.round, "Bad round")
	if arg1._choicePane:IsShowingChoicePane() then
		return Enum.ContextActionResult.Pass
	end
	if arg2.UserInputState == Enum.UserInputState.Begin and not arg2.KeyCode.Name:find("Thumbstick") then
		arg1:_doMoveSlider(arg3)
		local var57_upvw
		var57_upvw = UserInputService_upvr.InputEnded:Connect(function(arg1_9) -- Line 293
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: var57_upvw (read and write)
			]]
			if arg1_9.KeyCode == arg2.KeyCode then
				var57_upvw:Disconnect()
			end
		end)
		task.delay(0.15, function() -- Line 299
			--[[ Upvalues[5]:
				[1]: UserInputService_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: var57_upvw (read and write)
				[4]: arg1 (readonly)
				[5]: arg3 (readonly)
			]]
			while UserInputService_upvr:IsKeyDown(arg2.KeyCode) and var57_upvw.Connected do
				arg1:_doMoveSlider(arg3)
				task.wait(0.15)
			end
		end)
		return Enum.ContextActionResult.Sink
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	if not arg2.KeyCode.Name:find("Thumbstick") then
		return Enum.ContextActionResult.Pass
	end
	local x = arg2.Position.x
	if math.abs(x) < 0.4 then
		return Enum.ContextActionResult.Pass
	end
	if math.sign(x) ~= math.sign(arg3) then
		return Enum.ContextActionResult.Pass
	end
	if tick() - (arg1._thumbstickData[arg3] or 0) <= 0.3 then
		return Enum.ContextActionResult.Pass
	end
	arg1:_doMoveSlider(arg3)
	local tick_result1_upvw = tick()
	arg1._thumbstickData[arg3] = tick_result1_upvw
	task.delay(0.15, function() -- Line 332
		--[[ Upvalues[4]:
			[1]: arg2 (readonly)
			[2]: arg3 (readonly)
			[3]: arg1 (readonly)
			[4]: tick_result1_upvw (read and write)
		]]
		while 0.4 <= math.abs(arg2.Position.x) and math.sign(arg2.Position.x) == math.sign(arg3) and arg1._thumbstickData[arg3] == tick_result1_upvw do
			tick_result1_upvw = tick()
			arg1._thumbstickData[arg3] = tick_result1_upvw
			arg1:_doMoveSlider(arg3)
			task.wait(0.15)
		end
	end)
	return Enum.ContextActionResult.Sink
end
local any_load_result1_result1_upvr_2 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr_2._doMoveSlider(arg1, arg2) -- Line 349
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_GetValue_result1 = arg1:GetValue()
	arg1:SetValue(any_GetValue_result1 + arg2 * arg1._sliderOptions.round)
	if any_GetValue_result1 == arg1:GetValue() then
		arg1._button:BounceImpulse(arg2)
		any_load_result1_result1_upvr_2.playTemplate(arg1._dialogTemplates, "NuttyClickTemplate")
	else
		any_load_result1_result1_upvr_2.playTemplate(arg1._dialogTemplates, "SinglePlopTemplate")
	end
	arg1._button:NotifyInteraction()
	arg1.WaitingForRequestNextInput.Value = true
end
local TextService_upvr = game:GetService("TextService")
function setmetatable_result1_upvr_2._updateLabelsAndSizes(arg1) -- Line 364
	--[[ Upvalues[1]:
		[1]: TextService_upvr (readonly)
	]]
	local minLabel = arg1._sliderOptions.minLabel
	if not minLabel then
		minLabel = error("No minLabel")
	end
	arg1._minLabel.Text = minLabel
	minLabel = arg1._sliderOptions.maxLabel
	local var66 = minLabel
	if not var66 then
		var66 = error("No maxLabel")
	end
	arg1._maxLabel.Text = var66
	arg1._mainContainerUIPadding.PaddingLeft = UDim.new(0, TextService_upvr:GetTextSize(arg1._minLabel.Text, arg1._minLabel.TextSize, arg1._minLabel.Font, Vector2.new(1000000, 1000000)).x + 25)
	arg1._mainContainerUIPadding.PaddingRight = UDim.new(0, TextService_upvr:GetTextSize(arg1._maxLabel.Text, arg1._maxLabel.TextSize, arg1._maxLabel.Font, Vector2.new(1000000, 1000000)).x + 25)
end
function setmetatable_result1_upvr_2._updateAnimate(arg1) -- Line 379
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_7 (readonly)
	]]
	local p = arg1._percentVisible.p
	local var68 = 1 - p
	arg1._uiScale.Scale = 0.5 + 0.5 * p
	arg1._minLabel.TextTransparency = var68
	arg1._maxLabel.TextTransparency = var68
	arg1._backing.ImageTransparency = var68
	arg1._shadow.ImageTransparency = var1_result1_upvr.lerp(1, var1_result1_upvr_7.DEFAULT_SHADOW_TRANSPARENCY, p)
	arg1._barBacking.ImageTransparency = var68
	arg1._button:SetTransparency(var68)
	local var69
	if 0 >= arg1._percentVisible.rtime then
		var69 = false
	else
		var69 = true
	end
	return var69
end
function setmetatable_result1_upvr_2._convertPercentToValue(arg1, arg2) -- Line 396
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	assert(arg2, "Bad percent")
	assert(arg1._sliderOptions.round, "Bad sliderOptions.round")
	assert(arg1._sliderOptions.min, "Bad sliderOptions.min")
	assert(arg1._sliderOptions.max, "Bad sliderOptions.max")
	if arg2 == 0 then
		return arg1._sliderOptions.min
	end
	if arg2 == 1 then
		return arg1._sliderOptions.max
	end
	return arg1._sliderOptions.min + var1_result1_upvr.round((arg1._sliderOptions.max - arg1._sliderOptions.min) * arg2, arg1._sliderOptions.round)
end
function setmetatable_result1_upvr_2._convertValueToPercent(arg1, arg2) -- Line 413
	assert(arg2, "Bad value")
	return math.clamp((arg2 - arg1._sliderOptions.min) / (arg1._sliderOptions.max - arg1._sliderOptions.min), 0, 1)
end
function setmetatable_result1_upvr_2._handleInputBegan(arg1, arg2) -- Line 420
	if arg1._button:IsDragging() then
	elseif arg2.UserInputType == Enum.UserInputType.MouseButton1 or arg2.UserInputType == Enum.UserInputType.Touch then
		arg1._choicePane:HideChoicePane()
		arg1._button:StartDragging(arg2, arg1)
	end
end
function setmetatable_result1_upvr_2._updateCurrentPercent(arg1, arg2) -- Line 432
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local Value = arg1._currentPercent.Value
	local any__convertPercentToValue_result1 = arg1:_convertPercentToValue(Value)
	arg1.SelectionChanged:Fire(var1_result1_upvr_4.createSliderResult(any__convertPercentToValue_result1, Value))
	arg1._button:Update(any__convertPercentToValue_result1, Value, arg2)
end
local var1_result1_upvr_9 = any_load_result1("PillBackingBuilder")
function setmetatable_result1_upvr_2._buildBacking(arg1) -- Line 440
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_9 (readonly)
	]]
	local any_new_result1 = var1_result1_upvr_7.new()
	arg1._backing = any_new_result1:CreateBacking(arg1._gui)
	arg1._shadow = any_new_result1:CreateShadow(arg1._backing)
	arg1._barBacking = var1_result1_upvr_9.new():CreateSingle(arg1._sliderBar)
end
return setmetatable_result1_upvr_2