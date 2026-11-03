-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:01
-- Luau version 6, Types version 3
-- Time taken: 0.017097 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_6 = any_load_result1("BasicPane")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_6)
setmetatable_result1_upvr.ClassName = "DialogTextBox"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_7 = any_load_result1("DialogTemplatesClient")
local var1_result1_upvr_4 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_10 = any_load_result1("DialogInputKeyMap")
local any_load_result1_result1_upvr_9 = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_8 = any_load_result1("Spring")
local any_load_result1_result1_upvr_2 = any_load_result1("StepUtils")
local var1_result1_upvr = any_load_result1("SoundUtils")
local var1_result1_upvr_5 = any_load_result1("HapticFeedbackUtils")
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_3 = any_load_result1("DialogTextBoxUtils")
local any_load_result1_result1_upvr_3 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_5 = any_load_result1("Blend")
function setmetatable_result1_upvr.new(arg1) -- Line 33
	--[[ Upvalues[14]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: any_load_result1_result1_upvr_7 (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
		[5]: any_load_result1_result1_upvr_10 (readonly)
		[6]: any_load_result1_result1_upvr_9 (readonly)
		[7]: any_load_result1_result1_upvr_8 (readonly)
		[8]: any_load_result1_result1_upvr_2 (readonly)
		[9]: var1_result1_upvr (readonly)
		[10]: var1_result1_upvr_5 (readonly)
		[11]: UserInputService_upvr (readonly)
		[12]: var1_result1_upvr_3 (readonly)
		[13]: any_load_result1_result1_upvr_3 (readonly)
		[14]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_6.new(arg1:GetService(any_load_result1_result1_upvr_7):Clone("DialogTextBoxTemplate")), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._dialogTemplates = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr_7)
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr_4)
	setmetatable_result1_upvr_2._dialogInputKeyMap = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr_10)
	setmetatable_result1_upvr_2._container = setmetatable_result1_upvr_2._gui.Container
	setmetatable_result1_upvr_2._textboxContainer = setmetatable_result1_upvr_2._container.TextBoxContainer
	setmetatable_result1_upvr_2._textBox = setmetatable_result1_upvr_2._textboxContainer.TextBox
	setmetatable_result1_upvr_2._previewFilterLabel = setmetatable_result1_upvr_2._textBox.PreviewFilterLabel
	setmetatable_result1_upvr_2._hintInputContainer = setmetatable_result1_upvr_2._container.InputHintContainer
	setmetatable_result1_upvr_2:_buildBacking()
	setmetatable_result1_upvr_2._percentVisible = any_load_result1_result1_upvr_9.new(50)
	setmetatable_result1_upvr_2._percentVisible.t = 0
	setmetatable_result1_upvr_2._percentVisible.p = 0
	setmetatable_result1_upvr_2._percentFocused = any_load_result1_result1_upvr_9.new(200)
	setmetatable_result1_upvr_2._percentFocused.t = 0
	setmetatable_result1_upvr_2._percentFocused.p = 0
	setmetatable_result1_upvr_2._percentPreviewVisible = any_load_result1_result1_upvr_9.new(400)
	setmetatable_result1_upvr_2._percentPreviewVisible.t = 0
	setmetatable_result1_upvr_2._percentPreviewVisible.p = 0
	setmetatable_result1_upvr_2._shake = any_load_result1_result1_upvr_8.new(0)
	setmetatable_result1_upvr_2._shake.d = 0.25
	setmetatable_result1_upvr_2._shake.s = 50
	setmetatable_result1_upvr_2._shake.t = 0
	setmetatable_result1_upvr_2._shake.p = 0
	setmetatable_result1_upvr_2._textBoxSizeOffset = 0
	setmetatable_result1_upvr_2._percentInvalid = any_load_result1_result1_upvr_9.new(200)
	setmetatable_result1_upvr_2._percentInvalid.t = 0
	setmetatable_result1_upvr_2._percentInvalid.p = 0
	setmetatable_result1_upvr_2._percentMouseOver = any_load_result1_result1_upvr_9.new(200)
	setmetatable_result1_upvr_2._percentMouseOver.t = 0
	setmetatable_result1_upvr_2._percentMouseOver.p = 0
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_2.bindToRenderStep(setmetatable_result1_upvr_2._update)
	setmetatable_result1_upvr_2._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr_2._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._textBox.Focused:Connect(function() -- Line 80
		--[[ Upvalues[4]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: var1_result1_upvr_5 (copied, readonly)
			[4]: UserInputService_upvr (copied, readonly)
		]]
		setmetatable_result1_upvr_2._percentMouseOver.t = 0
		var1_result1_upvr.playTemplate(setmetatable_result1_upvr_2._dialogTemplates, "SinglePlopTemplate")
		var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
		setmetatable_result1_upvr_2:_updateFocused()
		if setmetatable_result1_upvr_2._textBox.CursorPosition - 1 == #setmetatable_result1_upvr_2._textBox.Text then
			setmetatable_result1_upvr_2._textBox.SelectionStart = 0
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._container.InputBegan:Connect(function(arg1_2) -- Line 92
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if arg1_2.UserInputType == Enum.UserInputType.MouseMovement or arg1_2.UserInputType == Enum.UserInputType.Touch then
			if not setmetatable_result1_upvr_2._textBox:IsFocused() then
				setmetatable_result1_upvr_2._percentMouseOver.t = 1
				setmetatable_result1_upvr_2:_startAnimation()
			end
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._container.InputEnded:Connect(function(arg1_3) -- Line 102
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if arg1_3.UserInputType == Enum.UserInputType.MouseMovement or arg1_3.UserInputType == Enum.UserInputType.Touch then
			setmetatable_result1_upvr_2._percentMouseOver.t = 0
			setmetatable_result1_upvr_2:_startAnimation()
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._textBox.FocusLost:Connect(function() -- Line 110
		--[[ Upvalues[5]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: setmetatable_result1_upvr_2 (readonly)
			[3]: var1_result1_upvr_5 (copied, readonly)
			[4]: UserInputService_upvr (copied, readonly)
			[5]: var1_result1_upvr_3 (copied, readonly)
		]]
		var1_result1_upvr.playTemplate(setmetatable_result1_upvr_2._dialogTemplates, "SinglePlopTemplate")
		var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
		setmetatable_result1_upvr_2._textBox.Text = var1_result1_upvr_3.sanitize(setmetatable_result1_upvr_2._textBox.Text)
		setmetatable_result1_upvr_2:_updateFocused()
	end))
	setmetatable_result1_upvr_2._textBox.TextEditable = setmetatable_result1_upvr_2:IsVisible()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.VisibleChanged:Connect(function(arg1_4, arg2, arg3) -- Line 119
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._textBox.TextEditable = arg1_4
		local var24 = setmetatable_result1_upvr_2
		if arg1_4 then
			var24 = 1
		else
			var24 = 0
		end
		var24._percentVisible.t = var24
		setmetatable_result1_upvr_2:_startAnimation()
	end))
	setmetatable_result1_upvr_2._backColorValue = any_load_result1_result1_upvr_3.fromObservable(setmetatable_result1_upvr_2._guiThemeService:ObserveColor("surface", "subdued_surface"))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._backColorValue)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._backColorValue.Changed:Connect(function() -- Line 127
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_startAnimation()
	end))
	setmetatable_result1_upvr_2._errorColorValue = any_load_result1_result1_upvr_3.fromObservable(setmetatable_result1_upvr_2._guiThemeService:ObserveColor("critical", "border"))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._errorColorValue.Changed:Connect(function() -- Line 132
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_startAnimation()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr_5.mount(setmetatable_result1_upvr_2._textBox, {
		Font = setmetatable_result1_upvr_2._guiThemeService:ObserveFont("font");
		TextColor3 = setmetatable_result1_upvr_2._guiThemeService:ObserveColor("text");
	}))
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr_5.mount(setmetatable_result1_upvr_2._previewFilterLabel, {
		Font = setmetatable_result1_upvr_2._guiThemeService:ObserveFont("font");
		TextColor3 = setmetatable_result1_upvr_2._guiThemeService:ObserveColor("text");
	}))
	setmetatable_result1_upvr_2:_updateFocused()
	setmetatable_result1_upvr_2:_startAnimation()
	return setmetatable_result1_upvr_2
end
local var1_result1_upvr_6 = any_load_result1("DialogTextBoxFilterPreview")
function setmetatable_result1_upvr.PreviewFilterText(arg1) -- Line 151
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_6 (readonly)
	]]
	if arg1._previewFilter then
		return arg1._previewFilter
	end
	arg1._previewFilter = var1_result1_upvr_6.new(arg1._serviceBag, arg1._textBox)
	arg1._maid:GiveTask(arg1._previewFilter)
	arg1._maid:GiveTask(arg1._previewFilter.Filtered.Changed:Connect(function(arg1_5, arg2) -- Line 159
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:SetFilterPreviewText(arg1_5)
	end))
	if arg1._previewFilter.Filtered.Value then
		arg1:SetFilterPreviewText(arg1._previewFilter.Filtered.Value)
	end
	return arg1._previewFilter
end
function setmetatable_result1_upvr.SetFilterPreviewText(arg1, arg2) -- Line 170
	if arg2 then
		arg1._previewFilterLabel.Text = arg2
		arg1._percentPreviewVisible.t = 1
	else
		arg1._previewFilterLabel.Text = ""
		arg1._percentPreviewVisible.t = 0
	end
	arg1:_startAnimation()
end
local var1_result1_upvr_2 = any_load_result1("HintInput")
function setmetatable_result1_upvr.HintActivationKey(arg1, arg2) -- Line 182
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg2, "Bad inputKeyType")
	assert(not arg1._inputHint, "Already set inputHint")
	arg1._inputHint = var1_result1_upvr_2.new(arg1._serviceBag, arg1._dialogInputKeyMap:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	arg1._inputHint.Gui.Parent = arg1._hintInputContainer
	arg1._inputHint.Gui.Size = UDim2.new(1, 0, 1, 0)
	arg1._inputHint:OverrideTheme(arg1._theme)
	arg1._maid:GiveTask(arg1._inputHint)
	local function updateSize() -- Line 192
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1._inputHint.ShowingHint.Value then
			arg1._textBoxSizeOffset = arg1._hintInputContainer.AbsoluteSize.Y
			arg1:_startAnimation()
		else
			arg1._textBoxSizeOffset = 0
			arg1:_startAnimation()
		end
	end
	arg1._maid:GiveTask(arg1.VisibleChanged:Connect(function(arg1_6, arg2_2, arg3) -- Line 203
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._inputHint:SetVisible(arg1_6, arg2_2)
	end))
	arg1._inputHint:SetVisible(arg1:IsVisible())
	arg1:_startAnimation()
	arg1._maid:GiveTask(arg1._hintInputContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize))
	arg1._maid:GiveTask(arg1._inputHint.ShowingHint.Changed:Connect(updateSize))
	if arg1._inputHint.ShowingHint.Value then
		arg1._textBoxSizeOffset = arg1._hintInputContainer.AbsoluteSize.Y
		arg1:_startAnimation()
	else
		arg1._textBoxSizeOffset = 0
		arg1:_startAnimation()
	end
end
function setmetatable_result1_upvr.Shake(arg1) -- Line 216
	local var33
	if 0.5 < math.random() then
		var33 = 1
	else
		var33 = -1
	end
	arg1._shake:Impulse(var33 * 2)
	arg1:_startAnimation()
end
function setmetatable_result1_upvr.SetInvalid(arg1, arg2) -- Line 221
	local var34
	if arg2 then
		var34 = 1
	else
		var34 = 0
	end
	arg1._percentInvalid.t = var34
	arg1:_startAnimation()
end
function setmetatable_result1_upvr.ToggleCaptureFocus(arg1) -- Line 226
	if arg1._textBox:IsFocused() then
		arg1._textBox:ReleaseFocus()
	else
		arg1._textBox:CaptureFocus()
	end
end
function setmetatable_result1_upvr.CaptureFocus(arg1) -- Line 234
	arg1._textBox:CaptureFocus()
end
function setmetatable_result1_upvr.GetTextBox(arg1) -- Line 238
	return arg1._textBox
end
function setmetatable_result1_upvr.SetText(arg1, arg2) -- Line 242
	local var35
	if type(arg2) ~= "string" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad text")
	arg1._textBox.Text = arg2
	if arg1._previewFilter then
		arg1._previewFilter:Update()
	end
end
function setmetatable_result1_upvr.GetText(arg1) -- Line 252
	return arg1._textBox.Text
end
function setmetatable_result1_upvr._setTransparency(arg1, arg2) -- Line 256
	arg1._textBoxBacking.ImageTransparency = math.clamp(arg2, 0, 1) ^ 0.5
	arg1._textBoxErrorBacking.ImageTransparency = math.clamp(arg2, 0, 1) ^ 0.5
end
function setmetatable_result1_upvr._updateFocused(arg1) -- Line 261
	local var36
	if arg1._textBox:IsFocused() then
		var36 = 1
	else
		var36 = 0
	end
	arg1._percentFocused.t = var36
	arg1:_startAnimation()
end
local any_load_result1_result1_upvr_4 = any_load_result1("RoundedBackingBuilder")
function setmetatable_result1_upvr._buildBacking(arg1) -- Line 271
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_4.new()
	arg1._textBoxErrorBacking = any_new_result1:CreateBacking(arg1._container)
	arg1._textBoxErrorBacking.Position = UDim2.new(0.5, 0, 0.5, 0)
	arg1._textBoxErrorBacking.AnchorPoint = Vector2.new(0.5, 0.5)
	arg1._textBoxErrorBacking.Size = UDim2.new(1, 6, 1, 6)
	arg1._textBoxErrorBacking.ZIndex = -1
	arg1._textBoxErrorBacking.ImageColor3 = arg1._container.BackgroundColor3
	arg1._textBoxBacking = any_new_result1:CreateBacking(arg1._textBoxErrorBacking)
	arg1._textBoxBacking.ImageColor3 = arg1._container.BackgroundColor3
	arg1._textBoxBacking.Size = UDim2.new(1, -6, 1, -6)
	arg1._textBoxBacking.Position = UDim2.new(0.5, 0, 0.5, 0)
	arg1._textBoxBacking.AnchorPoint = Vector2.new(0.5, 0.5)
end
local any_load_result1_result1_upvr_11 = any_load_result1("Math")
local any_load_result1_result1_upvr = any_load_result1("ButtonUtils")
function setmetatable_result1_upvr._update(arg1) -- Line 288
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_11 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local p_9 = arg1._percentVisible.p
	local p_15 = arg1._percentFocused.p
	local p_7 = arg1._percentMouseOver.p
	local var89 = (1 - p_15) * arg1._percentPreviewVisible.p
	local var90 = 1 - p_9
	arg1:_setTransparency(var90)
	arg1._textBox.TextTransparency = any_load_result1_result1_upvr_11.map(var90, 0, 1, var89, 1)
	arg1._previewFilterLabel.TextTransparency = any_load_result1_result1_upvr_11.map(var90, 0, 1, 1 - var89, 1)
	local any_getMouseOverColor_result1 = any_load_result1_result1_upvr.getMouseOverColor(arg1._backColorValue.Value, 0.5 * p_7)
	local var92 = -5 * p_15
	arg1._textBoxErrorBacking.Size = UDim2.new(1, var92, 1, 2 * var92)
	arg1._textBoxBacking.ImageColor3 = any_getMouseOverColor_result1
	arg1._textBoxErrorBacking.ImageColor3 = any_load_result1_result1_upvr.getMouseOverColor(any_getMouseOverColor_result1:Lerp(arg1._errorColorValue.Value, arg1._percentInvalid.p), p_7)
	local var93
	local var94
	if var94 then
		var94 = 1 - p_15
		var93 = p_9 * var94
		var94 = arg1._inputHint.Gui
		var94.Position = UDim2.new(0, 10 - var93 * 10, 0, 0)
		var94 = arg1._inputHint:SetTransparency
		var94(1 - var93)
	else
		var93 = 0
	end
	var94 = arg1._textBox
	var94.Size = UDim2.new(UDim.new(1, -arg1._textBoxSizeOffset * var93), arg1._textBox.Size.Y)
	var94 = arg1._container
	var94.Position = UDim2.fromScale(0.5 + 0.25 * arg1._shake.p, 0.5)
	var94 = true
	if 0 >= arg1._percentVisible.rtime then
		var94 = true
		if 0 >= arg1._percentFocused.rtime then
			var94 = true
			if 0 >= arg1._percentInvalid.rtime then
				var94 = true
				if 0 >= arg1._percentMouseOver.rtime then
					var94 = true
					if 0 >= arg1._percentPreviewVisible.rtime then
						var94 = true
						if 0.000001 >= math.abs(arg1._shake.v) then
							if 0.000001 >= math.abs(arg1._shake.t - arg1._shake.p) then
								var94 = false
							else
								var94 = true
							end
						end
					end
				end
			end
		end
	end
	return var94
end
return setmetatable_result1_upvr