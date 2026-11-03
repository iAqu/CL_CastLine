-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:25
-- Luau version 6, Types version 3
-- Time taken: 0.007728 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_5 = any_load_result1("BasicPane")
local any_load_result1_result1_upvr_17 = any_load_result1("CoreGuiEnabler")
local any_load_result1_result1_upvr_13 = any_load_result1("RoundedBackingBuilder")
local any_load_result1_result1_upvr_6 = any_load_result1("Blend")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_5)
setmetatable_result1_upvr_2.ClassName = "DialogPane"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_16 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_7 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_19 = any_load_result1("DialogInput")
local var1_result1_upvr = any_load_result1("StepUtils")
local any_load_result1_result1_upvr_10 = any_load_result1("DialogNameLabel")
local any_load_result1_result1_upvr_12 = any_load_result1("DialogTextContainer")
local any_load_result1_result1_upvr_8 = any_load_result1("DialogChoiceContainer")
local any_load_result1_result1_upvr_11 = any_load_result1("DialogSliderContainer")
local any_load_result1_result1_upvr_4 = any_load_result1("DialogTextBoxContainer")
local any_load_result1_result1_upvr_9 = any_load_result1("Spring")
local any_load_result1_result1_upvr_18 = any_load_result1("BasicPaneUtils")
local any_load_result1_result1_upvr_14 = any_load_result1("HapticFeedbackUtils")
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr_15 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr_2.new(arg1) -- Line 35
	--[[ Upvalues[17]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr_16 (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_7 (readonly)
		[5]: any_load_result1_result1_upvr_19 (readonly)
		[6]: var1_result1_upvr (readonly)
		[7]: any_load_result1_result1_upvr_10 (readonly)
		[8]: any_load_result1_result1_upvr_12 (readonly)
		[9]: any_load_result1_result1_upvr_8 (readonly)
		[10]: any_load_result1_result1_upvr_11 (readonly)
		[11]: any_load_result1_result1_upvr_4 (readonly)
		[12]: any_load_result1_result1_upvr_9 (readonly)
		[13]: any_load_result1_result1_upvr_6 (readonly)
		[14]: any_load_result1_result1_upvr_18 (readonly)
		[15]: any_load_result1_result1_upvr_14 (readonly)
		[16]: UserInputService_upvr (readonly)
		[17]: any_load_result1_result1_upvr_15 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_5.new(arg1:GetService(any_load_result1_result1_upvr_16):Clone("DialogPaneTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._dialogTemplates = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_16)
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr_7)
	setmetatable_result1_upvr._dialogInput = any_load_result1_result1_upvr_19.new(setmetatable_result1_upvr._serviceBag)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._dialogInput)
	setmetatable_result1_upvr._mainContainer = setmetatable_result1_upvr._gui.MainContainer
	setmetatable_result1_upvr._uiScale = setmetatable_result1_upvr._gui.UIScale
	setmetatable_result1_upvr._textContainerContainer = setmetatable_result1_upvr._mainContainer.TextContainerContainer
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr.bindToRenderStep(setmetatable_result1_upvr._updateVisible)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr._nameLabel = any_load_result1_result1_upvr_10.new(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._mainContainer.NameContainer)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._nameLabel)
	setmetatable_result1_upvr:_setupBacking()
	setmetatable_result1_upvr._textContainer = any_load_result1_result1_upvr_12.new(arg1, setmetatable_result1_upvr._dialogInput)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textContainer)
	setmetatable_result1_upvr._textContainer.Gui.Parent = setmetatable_result1_upvr._textContainerContainer
	setmetatable_result1_upvr.CurrentTextRenderer = setmetatable_result1_upvr._textContainer.CurrentTextRenderer
	setmetatable_result1_upvr._choiceContainer = any_load_result1_result1_upvr_8.new(arg1, setmetatable_result1_upvr._mainContainer.ChoiceContainer, setmetatable_result1_upvr._textContainer, setmetatable_result1_upvr._dialogInput)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._choiceContainer)
	setmetatable_result1_upvr._sliderContainer = any_load_result1_result1_upvr_11.new(arg1, setmetatable_result1_upvr._mainContainer.SliderContainer, setmetatable_result1_upvr._textContainer, setmetatable_result1_upvr._dialogInput)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._sliderContainer)
	setmetatable_result1_upvr._textBoxContainer = any_load_result1_result1_upvr_4.new(arg1, setmetatable_result1_upvr._mainContainer.TextBoxContainer)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textBoxContainer)
	setmetatable_result1_upvr._percentVisible = any_load_result1_result1_upvr_9.new(0)
	setmetatable_result1_upvr._percentVisible.Speed = 20
	setmetatable_result1_upvr._percentVisible.Damper = 1
	setmetatable_result1_upvr._percentVisible.Target = 0
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr_6.mount(setmetatable_result1_upvr.Gui, {
		[any_load_result1_result1_upvr_6.Children] = {any_load_result1_result1_upvr_6.New("TextButton")({
			Size = UDim2.new(0, 1, 0, 1);
			Selectable = false;
			Text = "";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			TextTransparency = 1;
			Modal = true;
			Visible = any_load_result1_result1_upvr_18.observeVisible(setmetatable_result1_upvr);
		})};
	}))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_2, arg2, arg3) -- Line 105
		--[[ Upvalues[4]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: any_load_result1_result1_upvr_14 (copied, readonly)
			[3]: UserInputService_upvr (copied, readonly)
			[4]: any_load_result1_result1_upvr_15 (copied, readonly)
		]]
		setmetatable_result1_upvr._dialogInput:SetEnabled(arg1_2)
		any_load_result1_result1_upvr_14.smallVibrate(UserInputService_upvr:GetLastInputType())
		if arg1_2 then
			if setmetatable_result1_upvr._talker then
				local any_playTemplate_result1 = any_load_result1_result1_upvr_15.playTemplate(setmetatable_result1_upvr._dialogTemplates, "DialogStartTemplate")
				any_playTemplate_result1.Pitch += setmetatable_result1_upvr._talker.voicePitchAdjustment / 4
			else
				any_load_result1_result1_upvr_15.playTemplate(setmetatable_result1_upvr._dialogTemplates, "ButtonPlopTemplate")
			end
			setmetatable_result1_upvr:_disableBackpack(arg3)
			setmetatable_result1_upvr:_setModalEnabled(arg3)
		else
			setmetatable_result1_upvr:HideCurrentPrompt()
		end
		local var30 = setmetatable_result1_upvr
		if arg1_2 then
			var30 = 1
		else
			var30 = 0
		end
		var30._percentVisible.t = var30
		if arg2 then
			setmetatable_result1_upvr._percentVisible.Position = setmetatable_result1_upvr._percentVisible.Target
		elseif arg1_2 then
			setmetatable_result1_upvr._percentVisible:Impulse(5)
		end
		setmetatable_result1_upvr:_startAnimation()
	end))
	setmetatable_result1_upvr:_mountTheme()
	setmetatable_result1_upvr:_startAnimation()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetUIScale(arg1, arg2) -- Line 141
	arg1._uiScale.Scale = arg2
	arg1._textContainer:SetParentUIScale(arg1._uiScale.Scale)
end
function setmetatable_result1_upvr_2.ShowChoices(arg1, arg2) -- Line 146
	local var31
	if type(arg2) ~= "table" then
		var31 = false
	else
		var31 = true
	end
	assert(var31, "Bad choices")
	return arg1._choiceContainer:ShowPrompt(arg2, arg1._nameLabel:GetAccentColor())
end
function setmetatable_result1_upvr_2.ShowSlider(arg1, arg2) -- Line 152
	local var32
	if type(arg2) ~= "table" then
		var32 = false
	else
		var32 = true
	end
	assert(var32, "Bad sliderOptions")
	var32 = arg1._uiScale.Scale
	var32 = arg1._sliderContainer:GetContainer()
	var32.Size = UDim2.new(1, -(arg1._nameLabel:GetAbsoluteWidth() / var32) - 30, 0, 60)
	var32 = arg1:HideCurrentPrompt
	var32()
	var32 = arg1._sliderContainer:ShowPrompt(arg2, arg1._nameLabel:GetAccentColor())
	return var32
end
function setmetatable_result1_upvr_2.ShowTextBox(arg1, arg2) -- Line 164
	local var33
	if type(arg2) ~= "table" then
		var33 = false
	else
		var33 = true
	end
	assert(var33, "Bad textBoxOptions")
	return arg1._textBoxContainer:ShowPrompt(arg2, arg1._nameLabel:GetAccentColor())
end
function setmetatable_result1_upvr_2.GetCurrentSlider(arg1) -- Line 170
	return arg1._sliderContainer:GetCurrentPrompt()
end
function setmetatable_result1_upvr_2.GetCurrentChoicesPane(arg1) -- Line 174
	return arg1._choiceContainer:GetCurrentPrompt()
end
function setmetatable_result1_upvr_2.GetCurrentTextBox(arg1) -- Line 178
	return arg1._textBoxContainer:GetCurrentPrompt()
end
function setmetatable_result1_upvr_2.HideCurrentPrompt(arg1) -- Line 182
	arg1._sliderContainer:HidePrompt()
	arg1._choiceContainer:HidePrompt()
	arg1._textBoxContainer:HidePrompt()
end
local any_load_result1_result1_upvr_2 = any_load_result1("DialogEntityLocalizationUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogTalkerUtils")
function setmetatable_result1_upvr_2.ShowText(arg1, arg2, arg3) -- Line 188
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	arg1:HideCurrentPrompt()
	local any_replaceWithLocalizedText_result1 = any_load_result1_result1_upvr_2.replaceWithLocalizedText(arg1._serviceBag, arg3)
	arg1:_setTalker(any_load_result1_result1_upvr.getTalkerFromLocalizedContext(any_replaceWithLocalizedText_result1))
	return arg1._textContainer:ShowText(arg2, any_replaceWithLocalizedText_result1)
end
function setmetatable_result1_upvr_2._mountTheme(arg1) -- Line 199
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
	]]
	arg1._maid:GiveTask(any_load_result1_result1_upvr_6.mount(arg1._backing, {
		ImageColor3 = arg1._guiThemeService:ObserveColor("surface");
	}))
end
function setmetatable_result1_upvr_2._setDarkTheme(arg1) -- Line 205
	arg1._backing.ImageColor3 = Color3.fromRGB(32, 29, 27)
end
function setmetatable_result1_upvr_2._setLightTheme(arg1) -- Line 209
	arg1._backing.ImageColor3 = Color3.new(1, 1, 1)
end
local any_load_result1_result1_upvr_3 = any_load_result1("Math")
function setmetatable_result1_upvr_2._updateVisible(arg1) -- Line 213
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_13 (readonly)
	]]
	local var39 = true
	local var40
	if 0.01 >= math.abs(arg1._percentVisible.Position - arg1._percentVisible.Target) then
		if 0.01 >= math.abs(arg1._percentVisible.Velocity) then
			var39 = false
		else
			var39 = true
		end
	end
	if not var39 then
		var40 = arg1._percentVisible.Target
	end
	arg1._mainContainer.Size = UDim2.new(0.2 + 0.8 * var40, 0, 0.2 + 0.8 * var40, 0)
	arg1._backing.ImageTransparency = any_load_result1_result1_upvr_3.lerp(1, 0, var40)
	arg1._shadow.ImageTransparency = any_load_result1_result1_upvr_3.lerp(1, any_load_result1_result1_upvr_13.DEFAULT_SHADOW_TRANSPARENCY, var40)
	arg1._nameLabel:SetPercentVisible(var40)
	arg1._textContainer:SetPercentVisible(var40)
	if not var39 and var40 == 1 then
		arg1._textContainer:RecordSize()
	end
	return var39
end
function setmetatable_result1_upvr_2._setTalker(arg1, arg2) -- Line 236
	arg1._talker = arg2
	arg1._nameLabel:SetFromEntityData(arg1._talker)
end
function setmetatable_result1_upvr_2._disableBackpack(arg1, arg2) -- Line 241
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: any_load_result1_result1_upvr_17 (readonly)
	]]
	if not RunService_upvr:IsRunning() then
	else
		arg2:GiveTask(any_load_result1_result1_upvr_17:Disable(arg1, Enum.CoreGuiType.Backpack))
	end
end
function setmetatable_result1_upvr_2._setModalEnabled(arg1, arg2) -- Line 249
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: any_load_result1_result1_upvr_17 (readonly)
	]]
	if not RunService_upvr:IsRunning() then
	else
		arg2:GiveTask(any_load_result1_result1_upvr_17:Disable(arg1, "ModalEnabled"))
	end
end
function setmetatable_result1_upvr_2._setupBacking(arg1) -- Line 257
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_13 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_13.new()
	arg1._backing = any_new_result1:CreateBacking(arg1._textContainerContainer)
	arg1._shadow = any_new_result1:CreateShadow(arg1._backing)
end
return setmetatable_result1_upvr_2