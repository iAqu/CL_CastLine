-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:49
-- Luau version 6, Types version 3
-- Time taken: 0.011269 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_2 = any_load_result1("DialogTranslator")
local any_load_result1_result1_upvr_8 = any_load_result1("DialogPromptPaneBase")
local var1_result1_upvr_5 = any_load_result1("HapticFeedbackUtils")
local any_load_result1_result1_upvr_11 = any_load_result1("RoundedBackingBuilder")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_8)
setmetatable_result1_upvr_2.ClassName = "DialogTextBoxPane"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_10 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_3 = any_load_result1("DialogInputKeyMap")
local var1_result1_upvr = any_load_result1("GuiThemeService")
local var1_result1_upvr_8 = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_6 = any_load_result1("Signal")
local var1_result1_upvr_4 = any_load_result1("DialogTextBox")
local any_load_result1_result1_upvr_4 = any_load_result1("DialogTextBoxCharacterLimit")
local any_load_result1_result1_upvr_12 = any_load_result1("DialogTextBoxButton")
local any_load_result1_result1_upvr_2 = any_load_result1("StepUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("DialogTextBoxInput")
local var1_result1_upvr_3 = any_load_result1("DialogTextBoxOptionTypes")
local var1_result1_upvr_6 = any_load_result1("DialogLocalizedTextBoxUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 34
	--[[ Upvalues[17]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: any_load_result1_result1_upvr_10 (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr (readonly)
		[6]: var1_result1_upvr_8 (readonly)
		[7]: any_load_result1_result1_upvr_6 (readonly)
		[8]: var1_result1_upvr_4 (readonly)
		[9]: any_load_result1_result1_upvr_4 (readonly)
		[10]: any_load_result1_result1_upvr_12 (readonly)
		[11]: var1_result1_upvr_2 (readonly)
		[12]: any_load_result1_result1_upvr_2 (readonly)
		[13]: any_load_result1_result1_upvr_5 (readonly)
		[14]: var1_result1_upvr_5 (readonly)
		[15]: UserInputService_upvr (readonly)
		[16]: var1_result1_upvr_3 (readonly)
		[17]: var1_result1_upvr_6 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_8.new(arg1:GetService(any_load_result1_result1_upvr_10):Clone("DialogTextBoxPaneTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._dialogInputKeyMap = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_3)
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1_upvr._dialogTemplates = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_10)
	setmetatable_result1_upvr._textBoxOptions = assert(arg2, "No textBoxOptions")
	setmetatable_result1_upvr._mainContainer = setmetatable_result1_upvr._gui.MainContainer
	setmetatable_result1_upvr._promptLabel = setmetatable_result1_upvr._mainContainer.PromptLabel
	setmetatable_result1_upvr._filteredCheckboxLabel = setmetatable_result1_upvr._mainContainer.FilteredCheckboxLabel
	setmetatable_result1_upvr._uiScale = setmetatable_result1_upvr._gui.UIScale
	setmetatable_result1_upvr._percentVisible = var1_result1_upvr_8.new(50)
	setmetatable_result1_upvr._percentVisible.t = 0
	setmetatable_result1_upvr._percentVisible.p = 0
	setmetatable_result1_upvr._percentFiltered = var1_result1_upvr_8.new(400)
	setmetatable_result1_upvr._percentFiltered.t = 0
	setmetatable_result1_upvr._percentFiltered.p = 0
	setmetatable_result1_upvr.SelectionConfirmed = any_load_result1_result1_upvr_6.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.SelectionConfirmed)
	setmetatable_result1_upvr._textBox = var1_result1_upvr_4.new(arg1)
	setmetatable_result1_upvr._textBox.Gui.Parent = setmetatable_result1_upvr._mainContainer.TextBoxContainer
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textBox)
	setmetatable_result1_upvr._textBox:HintActivationKey(setmetatable_result1_upvr._dialogInputKeyMap:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	setmetatable_result1_upvr._characterLimitLabel = any_load_result1_result1_upvr_4.new(arg1, setmetatable_result1_upvr._textBox:GetTextBox())
	setmetatable_result1_upvr._characterLimitLabel.Gui.Parent = setmetatable_result1_upvr._mainContainer.CharacterRemainingContainer
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._characterLimitLabel)
	setmetatable_result1_upvr._textBox:SetInvalid(setmetatable_result1_upvr._characterLimitLabel.Invalid.Value)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._characterLimitLabel.Invalid.Changed:Connect(function() -- Line 73
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._textBox:SetInvalid(setmetatable_result1_upvr._characterLimitLabel.Invalid.Value)
	end))
	setmetatable_result1_upvr._button = any_load_result1_result1_upvr_12.new(arg1)
	setmetatable_result1_upvr._button:SetText(setmetatable_result1_upvr._serviceBag:GetService(var1_result1_upvr_2):FormatByKey("textbox.button.confirm"))
	setmetatable_result1_upvr._button:SetActivationHint(setmetatable_result1_upvr._dialogInputKeyMap:GetInputKeyMapList("DIALOG_CONFIRM_SHORTCUT"))
	setmetatable_result1_upvr._button.Gui.AnchorPoint = Vector2.new(1, 0.5)
	setmetatable_result1_upvr._button.Gui.Position = UDim2.new(1, 0, 0.5, 1)
	setmetatable_result1_upvr._button.Gui.Parent = setmetatable_result1_upvr._mainContainer.ConfirmButtonContainer
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._button)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._button.Activated:Connect(function() -- Line 86
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_tryToConfirm()
	end))
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_2.bindToRenderStep(setmetatable_result1_upvr._update)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr:_buildBacking()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_2, arg2_2, arg3) -- Line 93
		--[[ Upvalues[4]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: any_load_result1_result1_upvr_5 (copied, readonly)
			[3]: var1_result1_upvr_5 (copied, readonly)
			[4]: UserInputService_upvr (copied, readonly)
		]]
		local var30 = setmetatable_result1_upvr
		if arg1_2 then
			var30 = 1
		else
			var30 = 0
		end
		var30._percentVisible.t = var30
		setmetatable_result1_upvr._textBox:SetVisible(arg1_2, arg2_2)
		setmetatable_result1_upvr._button:SetVisible(arg1_2, arg2_2)
		if arg1_2 then
			local any_new_result1_2 = any_load_result1_result1_upvr_5.new(setmetatable_result1_upvr._serviceBag)
			arg3:GiveTask(any_new_result1_2)
			arg3:GiveTask(any_new_result1_2.ToggleFocusTextbox:Connect(function() -- Line 102
				--[[ Upvalues[3]:
					[1]: var1_result1_upvr_5 (copied, readonly)
					[2]: UserInputService_upvr (copied, readonly)
					[3]: setmetatable_result1_upvr (copied, readonly)
				]]
				var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
				setmetatable_result1_upvr._textBox:ToggleCaptureFocus()
			end))
			arg3:GiveTask(any_new_result1_2.ConfirmRequest:Connect(function() -- Line 107
				--[[ Upvalues[1]:
					[1]: setmetatable_result1_upvr (copied, readonly)
				]]
				setmetatable_result1_upvr:_tryToConfirm()
			end))
			if UserInputService_upvr:GetLastInputType().Name:find("Gamepad") then
				setmetatable_result1_upvr._textBox:CaptureFocus()
			end
		end
		if arg2_2 then
			setmetatable_result1_upvr._percentVisible.p = setmetatable_result1_upvr._percentVisible.t
			setmetatable_result1_upvr._percentVisible.v = 0
		else
			setmetatable_result1_upvr._percentVisible.v = setmetatable_result1_upvr._percentVisible.v + 4
		end
		setmetatable_result1_upvr:_startAnimation()
	end))
	local var34
	if type(arg2) ~= "table" then
		var34 = false
	else
		var34 = true
	end
	assert(var34, "Bad textBoxOptions")
	var34 = var1_result1_upvr_3.LOCALIZED_TEXTBOX_OPTIONS
	if arg2.type == var34 then
		var34 = var1_result1_upvr_6
		var34 = setmetatable_result1_upvr._serviceBag
		local any_createOptionsFromLocalizedOptions_result1 = var34.createOptionsFromLocalizedOptions(var34, arg2)
	end
	setmetatable_result1_upvr:SetPromptText(any_createOptionsFromLocalizedOptions_result1.promptText or nil)
	setmetatable_result1_upvr:SetText(assert(any_createOptionsFromLocalizedOptions_result1.text, "Bad text"))
	setmetatable_result1_upvr:SetMaxCharacters(assert(any_createOptionsFromLocalizedOptions_result1.maxCharacters, "Bad maxCharacters"))
	if any_createOptionsFromLocalizedOptions_result1.previewFilter then
		setmetatable_result1_upvr:_setupFilterPreview()
	end
	setmetatable_result1_upvr:_startAnimation()
	setmetatable_result1_upvr:_setupTheme()
	return setmetatable_result1_upvr
end
local any_load_result1_result1_upvr_7 = any_load_result1("Blend")
function setmetatable_result1_upvr_2._setupTheme(arg1) -- Line 145
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
	]]
	arg1._maid:GiveTask(any_load_result1_result1_upvr_7.mount(arg1._backing, {
		ImageColor3 = arg1._guiThemeService:ObserveColor("surface");
	}))
	arg1._maid:GiveTask(any_load_result1_result1_upvr_7.mount(arg1._promptLabel, {
		TextColor3 = arg1._guiThemeService:ObserveColor("text");
		Font = arg1._guiThemeService:ObserveFont("title");
	}))
	arg1._maid:GiveTask(any_load_result1_result1_upvr_7.mount(arg1._filteredCheckboxLabel, {
		ImageColor3 = arg1._guiThemeService:ObserveColor("text", "subdued_text");
	}))
end
function setmetatable_result1_upvr_2.SetAccentColor(arg1, arg2) -- Line 160
	assert(arg2, "Bad color")
end
function setmetatable_result1_upvr_2.SetText(arg1, arg2) -- Line 164
	local var40
	if type(arg2) ~= "string" then
		var40 = false
	else
		var40 = true
	end
	assert(var40, "Bad text")
	arg1._textBox:SetText(arg2)
end
function setmetatable_result1_upvr_2.SetPromptText(arg1, arg2) -- Line 170
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if arg2 then
		arg1._promptLabel.Text = arg2
	else
		arg1._promptLabel.Text = arg1._serviceBag:GetService(var1_result1_upvr_2):FormatByKey("textbox.defaultPrompt")
	end
end
function setmetatable_result1_upvr_2.SetMaxCharacters(arg1, arg2) -- Line 178
	arg1._characterLimitLabel:SetMaxCharacters(arg2)
end
function setmetatable_result1_upvr_2._setupFilterPreview(arg1) -- Line 182
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg1._filterPreviewer = arg1._textBox:PreviewFilterText()
	local any_GetTextBox_result1_upvr = arg1._textBox:GetTextBox()
	local function updateFiltered() -- Line 187
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_GetTextBox_result1_upvr (readonly)
		]]
		local Value_2 = arg1._filterPreviewer.Filtered.Value
		if Value_2 then
			Value_2 = not any_GetTextBox_result1_upvr:IsFocused()
		end
		local var43 = arg1
		if Value_2 then
			var43 = 1
		else
			var43 = 0
		end
		var43._percentFiltered.t = var43
		arg1:_startAnimation()
	end
	arg1._maid:GiveTask(arg1._filterPreviewer.Filtered.Changed:Connect(updateFiltered))
	arg1._maid:GiveTask(any_GetTextBox_result1_upvr.Focused:Connect(updateFiltered))
	arg1._maid:GiveTask(any_GetTextBox_result1_upvr.FocusLost:Connect(updateFiltered))
	local Value = arg1._filterPreviewer.Filtered.Value
	if Value then
		Value = not any_GetTextBox_result1_upvr:IsFocused()
	end
	if Value then
	else
	end
	arg1._percentFiltered.t = 0
	arg1:_startAnimation()
end
local any_load_result1_result1_upvr_9 = any_load_result1("DialogTextBoxUtils")
local var1_result1_upvr_7 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr_2._tryToConfirm(arg1) -- Line 201
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
		[3]: var1_result1_upvr_5 (readonly)
		[4]: UserInputService_upvr (readonly)
	]]
	local any_sanitize_result1 = any_load_result1_result1_upvr_9.sanitize(arg1._textBox:GetText())
	local utf8_len_result1 = utf8.len(any_sanitize_result1)
	if not utf8_len_result1 then
		arg1._textBox:SetText("")
		var1_result1_upvr_7.playTemplate(arg1._dialogTemplates, "SinglePlopTemplate")
		var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
		arg1._textBox:Shake()
	else
		if arg1._characterLimitLabel:GetMaxCharacters() < utf8_len_result1 then
			arg1._characterLimitLabel:Shake()
			var1_result1_upvr_7.playTemplate(arg1._dialogTemplates, "SinglePlopTemplate")
			var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
			arg1._textBox:Shake()
			return
		end
		if utf8_len_result1 <= 0 and arg1._textBoxOptions.inputRequired then
			arg1._characterLimitLabel:Shake()
			var1_result1_upvr_7.playTemplate(arg1._dialogTemplates, "SinglePlopTemplate")
			var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
			arg1._textBox:Shake()
			return
		end
		var1_result1_upvr_7.playTemplate(arg1._dialogTemplates, "SuccessChimeTemplate")
		var1_result1_upvr_5.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.75)
		arg1.SelectionConfirmed:Fire(any_sanitize_result1)
	end
end
function setmetatable_result1_upvr_2._buildBacking(arg1) -- Line 237
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_11 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_11.new()
	arg1._backing = any_new_result1:CreateBacking(arg1._gui)
	arg1._shadow = any_new_result1:CreateShadow(arg1._backing)
end
local any_load_result1_result1_upvr = any_load_result1("Math")
function setmetatable_result1_upvr_2._setTransparency(arg1, arg2) -- Line 243
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_11 (readonly)
	]]
	arg1._backing.ImageTransparency = arg2
	arg1._shadow.ImageTransparency = any_load_result1_result1_upvr.lerp(any_load_result1_result1_upvr_11.DEFAULT_SHADOW_TRANSPARENCY, 1, arg2)
	arg1._promptLabel.TextTransparency = arg2
	arg1._characterLimitLabel:SetTransparency(arg2)
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 251
	local p = arg1._percentVisible.p
	arg1:_setTransparency(1 - p)
	arg1._uiScale.Scale = 0.5 + 0.5 * p
	local var52
	if var52 then
		var52 = arg1._filteredCheckboxLabel
		var52.ImageTransparency = 1 - p * arg1._percentFiltered.p
	else
		var52 = arg1._filteredCheckboxLabel
		var52.ImageTransparency = 1
	end
	var52 = true
	if 0 >= arg1._percentVisible.rtime then
		if 0 >= arg1._percentFiltered.rtime then
			var52 = false
		else
			var52 = true
		end
	end
	return var52
end
return setmetatable_result1_upvr_2