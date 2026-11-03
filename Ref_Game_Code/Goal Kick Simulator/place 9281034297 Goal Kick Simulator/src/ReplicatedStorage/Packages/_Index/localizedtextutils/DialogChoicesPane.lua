-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:17
-- Luau version 6, Types version 3
-- Time taken: 0.009984 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local GuiService_upvr = game:GetService("GuiService")
local var1_result1_upvr_4 = any_load_result1("DialogPromptPaneBase")
local var1_result1_upvr = any_load_result1("RoundedBackingBuilder")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_4)
setmetatable_result1_upvr.ClassName = "DialogChoicesPane"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_3 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_7 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_4 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr = any_load_result1("AccelTween")
local var1_result1_upvr_3 = any_load_result1("Signal")
local var1_result1_upvr_8 = any_load_result1("StepUtils")
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_5 = any_load_result1("Blend")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 31
	--[[ Upvalues[11]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_7 (readonly)
		[5]: any_load_result1_result1_upvr_4 (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
		[7]: var1_result1_upvr_3 (readonly)
		[8]: var1_result1_upvr_8 (readonly)
		[9]: UserInputService_upvr (readonly)
		[10]: GuiService_upvr (readonly)
		[11]: var1_result1_upvr_5 (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2, "No choices")
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_4.new(arg1:GetService(any_load_result1_result1_upvr_3):Clone("DialogChoicesPaneTemplate")), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._accentColor = any_load_result1_result1_upvr_7.DEFAULT_ACCENT_COLOR
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._dialogTemplates = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr_3)
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr_4)
	setmetatable_result1_upvr_2._percentVisible = any_load_result1_result1_upvr.new(400)
	setmetatable_result1_upvr_2._percentVisible.t = 0
	setmetatable_result1_upvr_2._percentVisible.p = 0
	setmetatable_result1_upvr_2._mainContainer = setmetatable_result1_upvr_2._gui.MainContainer
	setmetatable_result1_upvr_2._uiScale = setmetatable_result1_upvr_2._mainContainer.UIScale
	setmetatable_result1_upvr_2._buttonContainer = setmetatable_result1_upvr_2._mainContainer.ButtonContainer
	setmetatable_result1_upvr_2._uiPadding = setmetatable_result1_upvr_2._buttonContainer.UIPadding
	setmetatable_result1_upvr_2._uiListLayout = setmetatable_result1_upvr_2._buttonContainer.UIListLayout
	setmetatable_result1_upvr_2._choiceButtons = {}
	setmetatable_result1_upvr_2.ChoiceSelected = var1_result1_upvr_3.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.ChoiceSelected)
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr_8.bindToRenderStep(setmetatable_result1_upvr_2._update)
	setmetatable_result1_upvr_2._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr_2._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.VisibleChanged:Connect(function(arg1_2, arg2_2, arg3) -- Line 61
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: UserInputService_upvr (copied, readonly)
			[3]: GuiService_upvr (copied, readonly)
		]]
		local var18 = setmetatable_result1_upvr_2
		if arg1_2 then
			var18 = 1
		else
			var18 = 0
		end
		var18._percentVisible.t = var18
		if arg2_2 then
			setmetatable_result1_upvr_2._percentVisible.p = setmetatable_result1_upvr_2._percentVisible.t
		else
			setmetatable_result1_upvr_2._percentVisible.v = setmetatable_result1_upvr_2._percentVisible.v + 20
		end
		setmetatable_result1_upvr_2:_updateSelectable()
		setmetatable_result1_upvr_2:_startAnimation()
		if arg1_2 then
			if UserInputService_upvr:GetLastInputType().Name:find("Gamepad") then
				setmetatable_result1_upvr_2:_autoselectTopChoice()
			end
			arg3:GiveTask(UserInputService_upvr.LastInputTypeChanged:Connect(function(arg1_3) -- Line 77
				--[[ Upvalues[2]:
					[1]: GuiService_upvr (copied, readonly)
					[2]: setmetatable_result1_upvr_2 (copied, readonly)
				]]
				-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [11] 9. Error Block 3 start (CF ANALYSIS FAILED)
				setmetatable_result1_upvr_2:_autoselectTopChoice()
				do
					return
				end
				-- KONSTANTERROR: [11] 9. Error Block 3 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [16] 13. Error Block 12 start (CF ANALYSIS FAILED)
				if arg1_3.Name:find("Mouse") or arg1_3.Name:find("Touch") then
					if GuiService_upvr.SelectedObject then
						GuiService_upvr.SelectedObject = nil
					end
				end
				-- KONSTANTERROR: [16] 13. Error Block 12 end (CF ANALYSIS FAILED)
			end))
		end
	end))
	setmetatable_result1_upvr_2:_buildBacking()
	setmetatable_result1_upvr_2:_createChoices(arg2)
	setmetatable_result1_upvr_2:_startAnimation()
	setmetatable_result1_upvr_2._maid:GiveTask(var1_result1_upvr_5.mount(setmetatable_result1_upvr_2._backing, {
		ImageColor3 = setmetatable_result1_upvr_2._guiThemeService:ObserveColor("action");
	}))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetAccentColor(arg1, arg2) -- Line 103
	local var25
	if typeof(arg2) ~= "Color3" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Not a color3")
	arg1._accentColor = arg2
	var25 = arg1._choiceButtons
	for _, v in pairs(var25) do
		v:SetAccentColor(arg2)
	end
end
function setmetatable_result1_upvr.GetSize(arg1) -- Line 113
	return arg1._gui.Size
end
local any_load_result1_result1_upvr_6 = any_load_result1("DialogLocalizedChoiceUtils")
function setmetatable_result1_upvr._createChoices(arg1, arg2) -- Line 117
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
	local var34
	if type(arg2) ~= "table" then
		var34 = false
	else
		var34 = true
	end
	assert(var34, "Bad choices")
	if type(arg2.choices) ~= "table" then
		var34 = false
		-- KONSTANTWARNING: GOTO [25] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [24] 18. Error Block 30 start (CF ANALYSIS FAILED)
	var34 = true
	assert(var34, "Bad choices.choices")
	if type(arg2.key) ~= "string" then
		var34 = false
	else
		var34 = true
	end
	assert(var34, "Bad choices.key")
	var34 = any_load_result1_result1_upvr_6
	var34 = arg1._serviceBag
	var34 = pairs(var34.replaceWithLocalizedText(var34, arg2).choices)
	local pairs_result1, pairs_result2_5, pairs_result3_2 = pairs(var34.replaceWithLocalizedText(var34, arg2).choices)
	for _, v_2 in pairs_result1, pairs_result2_5, pairs_result3_2 do
		arg1:_addChoice(v_2)
	end
	pairs_result1 = #arg1._choiceButtons
	if 0 < pairs_result1 then
		_ = arg1._choiceButtons
		pairs_result1 = arg1._choiceButtons[#_]:HideSeperator
		pairs_result1()
	end
	pairs_result1 = arg1:_updateSize
	pairs_result1()
	pairs_result1 = arg1:_setNextSelectionValues
	pairs_result1()
	-- KONSTANTERROR: [24] 18. Error Block 30 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr._autoselectTopChoice(arg1) -- Line 137
	--[[ Upvalues[1]:
		[1]: GuiService_upvr (readonly)
	]]
	local _1 = arg1._choiceButtons[1]
	if not _1 then
		warn("[DialogChoicesPane._autoselectTopChoice] - No button")
	else
		GuiService_upvr.SelectedObject = _1.Gui
	end
end
function setmetatable_result1_upvr._updateSelectable(arg1) -- Line 147
	local any_IsVisible_result1 = arg1:IsVisible()
	for _, v_3 in pairs(arg1._choiceButtons) do
		v_3:SetSelectable(any_IsVisible_result1)
	end
end
local any_load_result1_result1_upvr_5 = any_load_result1("UIPaddingUtils")
function setmetatable_result1_upvr._updateSize(arg1) -- Line 154
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var59
	for i_4, v_4 in pairs(arg1._choiceButtons) do
		local Value = v_4:GetSizeValue().Value
		local x = Value.x
		if var59 < x then
			var59 = x
		end
		if i_4 ~= #arg1._choiceButtons then
		end
	end
	arg1._gui.Size = UDim2.new(0, var59, 0, 0 + Value.y + arg1._uiListLayout.Padding.Offset) + any_load_result1_result1_upvr_5.getTotalPadding(arg1._uiPadding)
end
function setmetatable_result1_upvr._setNextSelectionValues(arg1) -- Line 182
	local len = #arg1._choiceButtons
	for i_5, v_5 in pairs(arg1._choiceButtons) do
		local var70 = i_5 + 1
		if len < var70 then
			var70 = 1
		end
		v_5.Gui.NextSelectionDown = arg1._choiceButtons[var70].Gui
		local var71 = i_5 - 1
		if var71 <= 0 then
			var71 = len
		end
		v_5.Gui.NextSelectionUp = arg1._choiceButtons[var71].Gui
	end
end
local var1_result1_upvr_7 = any_load_result1("DialogChoiceTypes")
local var1_result1_upvr_6 = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("DialogChoiceButton")
local any_load_result1_result1_upvr_8 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr._addChoice(arg1, arg2) -- Line 199
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
	]]
	local var76_upvr
	if arg2.type ~= var1_result1_upvr_7.DIALOG_CHOICE then
		var76_upvr = false
	else
		var76_upvr = true
	end
	assert(var76_upvr, "Bad choice.type")
	var76_upvr = var1_result1_upvr_6
	local any_new_result1 = var76_upvr.new()
	var76_upvr = any_load_result1_result1_upvr_2.new(arg1._serviceBag, arg2)
	var76_upvr:SetSelectable(arg1:IsVisible())
	var76_upvr:SetAccentColor(arg1._accentColor)
	var76_upvr:SetNumber(#arg1._choiceButtons + 1)
	var76_upvr:SetInteractionEnabled(true)
	var76_upvr.Gui.Parent = arg1._buttonContainer
	any_new_result1:GiveTask(var76_upvr)
	any_new_result1:GiveTask(var76_upvr:GetSizeValue().Changed:Connect(function() -- Line 213
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateSize()
	end))
	any_new_result1:GiveTask(var76_upvr.Selected:Connect(function() -- Line 217
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: var76_upvr (readonly)
			[4]: any_load_result1_result1_upvr_8 (copied, readonly)
		]]
		arg1.ChoiceSelected:Fire(arg2)
		var76_upvr:SetIsChoosen(true)
		for _, v_6 in pairs(arg1._choiceButtons) do
			v_6:SetInteractionEnabled(false)
			if v_6 ~= var76_upvr then
				v_6:SetIsChoosen(false)
			end
		end
		any_load_result1_result1_upvr_8.playTemplate(arg1._dialogTemplates, "SuccessChimeTemplate")
	end))
	table.insert(arg1._choiceButtons, var76_upvr)
	arg1._maid:GiveTask(any_new_result1)
end
function setmetatable_result1_upvr._buildBacking(arg1) -- Line 236
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_2 = var1_result1_upvr.new()
	arg1._backing = any_new_result1_2:CreateBacking(arg1._mainContainer)
	arg1._shadow = any_new_result1_2:CreateShadow(arg1._backing)
end
local var1_result1_upvr_2 = any_load_result1("Math")
function setmetatable_result1_upvr._update(arg1) -- Line 242
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local p = arg1._percentVisible.p
	local var92 = 1 - p
	arg1._gui.Rotation = (1 - p) * 10
	arg1._uiScale.Scale = 0.5 + 0.5 * p
	arg1._backing.ImageTransparency = var92
	arg1._shadow.ImageTransparency = var1_result1_upvr_2.lerp(1, var1_result1_upvr.DEFAULT_SHADOW_TRANSPARENCY, p)
	local pairs_result1_2, pairs_result2, pairs_result3 = pairs(arg1._choiceButtons)
	for _, v_7 in pairs_result1_2, pairs_result2, pairs_result3 do
		v_7:SetTransparency(var92)
	end
	if 0 >= arg1._percentVisible.rtime then
		pairs_result1_2 = false
	else
		pairs_result1_2 = true
	end
	return pairs_result1_2
end
return setmetatable_result1_upvr