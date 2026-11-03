-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:38
-- Luau version 6, Types version 3
-- Time taken: 0.008469 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local GuiService_upvr = game:GetService("GuiService")
local var1_result1_upvr_4 = any_load_result1("DialogPromptPaneBase")
local var1_result1_upvr_2 = any_load_result1("RoundedBackingBuilder")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_4)
setmetatable_result1_upvr.ClassName = "DialogChoiceGridPane"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr_8 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_6 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_2 = any_load_result1("AccelTween")
local var1_result1_upvr_3 = any_load_result1("Signal")
local any_load_result1_result1_upvr_7 = any_load_result1("ConfirmChoicePane")
local any_load_result1_result1_upvr_4 = any_load_result1("StepUtils")
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr_3 = any_load_result1("Blend")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 31
	--[[ Upvalues[12]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
		[5]: any_load_result1_result1_upvr_6 (readonly)
		[6]: any_load_result1_result1_upvr_2 (readonly)
		[7]: var1_result1_upvr_3 (readonly)
		[8]: any_load_result1_result1_upvr_7 (readonly)
		[9]: any_load_result1_result1_upvr_4 (readonly)
		[10]: UserInputService_upvr (readonly)
		[11]: GuiService_upvr (readonly)
		[12]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_4.new(arg1:GetService(any_load_result1_result1_upvr):Clone("DialogChoiceGridPaneTemplate")), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._dialogTemplates = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr)
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(any_load_result1_result1_upvr_8)
	setmetatable_result1_upvr_2._accentColor = any_load_result1_result1_upvr_6.DEFAULT_ACCENT_COLOR
	setmetatable_result1_upvr_2._percentVisible = any_load_result1_result1_upvr_2.new(100)
	setmetatable_result1_upvr_2._percentVisible.t = 0
	setmetatable_result1_upvr_2._percentVisible.p = 0
	setmetatable_result1_upvr_2._percentPending = any_load_result1_result1_upvr_2.new(100)
	setmetatable_result1_upvr_2._percentPending.t = 0
	setmetatable_result1_upvr_2._percentPending.p = 0
	setmetatable_result1_upvr_2._mainContainer = setmetatable_result1_upvr_2._gui.MainContainer
	setmetatable_result1_upvr_2._buttonContainer = setmetatable_result1_upvr_2._mainContainer.ButtonContainer
	setmetatable_result1_upvr_2._choiceContainer = setmetatable_result1_upvr_2._gui.ChoiceContainer
	setmetatable_result1_upvr_2._uiScale = setmetatable_result1_upvr_2._gui.UIScale
	setmetatable_result1_upvr_2._uiPadding = setmetatable_result1_upvr_2._mainContainer.UIPadding
	setmetatable_result1_upvr_2._uiGridLayout = setmetatable_result1_upvr_2._buttonContainer.UIGridLayout
	setmetatable_result1_upvr_2.ChoiceSelected = var1_result1_upvr_3.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.ChoiceSelected)
	setmetatable_result1_upvr_2._choicePane = any_load_result1_result1_upvr_7.new(setmetatable_result1_upvr_2._serviceBag, setmetatable_result1_upvr_2._choiceContainer)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._choicePane)
	setmetatable_result1_upvr_2.WaitingForRequestNextInput = Instance.new("BoolValue")
	setmetatable_result1_upvr_2.WaitingForRequestNextInput.Value = true
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.WaitingForRequestNextInput)
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = any_load_result1_result1_upvr_4.bindToRenderStep(setmetatable_result1_upvr_2._update)
	setmetatable_result1_upvr_2._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr_2._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._choicePane.CurrentChoicePaneValue.Changed:Connect(function(arg1_2) -- Line 68
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: UserInputService_upvr (copied, readonly)
			[3]: GuiService_upvr (copied, readonly)
		]]
		setmetatable_result1_upvr_2._percentPending.v = setmetatable_result1_upvr_2._percentPending.v + 2
		if arg1_2 then
			setmetatable_result1_upvr_2.WaitingForRequestNextInput.Value = false
			setmetatable_result1_upvr_2._percentPending.t = 1
			setmetatable_result1_upvr_2:_startAnimation()
		else
			setmetatable_result1_upvr_2._percentPending.t = 0
			setmetatable_result1_upvr_2:_startAnimation()
			if setmetatable_result1_upvr_2._lastChoiceButton then
				setmetatable_result1_upvr_2._lastChoiceButton:SetIsChoosen(false)
				if UserInputService_upvr:GetLastInputType().Name:find("Gamepad") then
					GuiService_upvr.SelectedObject = setmetatable_result1_upvr_2._lastChoiceButton.Gui
				end
			end
			setmetatable_result1_upvr_2.WaitingForRequestNextInput.Value = true
		end
	end))
	setmetatable_result1_upvr_2._choiceButtons = {}
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._choicePane.ChoiceConfirmed:Connect(function() -- Line 94
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if setmetatable_result1_upvr_2._lastChoice then
			for _, v in pairs(setmetatable_result1_upvr_2._choiceButtons) do
				v:SetInteractionEnabled(false)
			end
			setmetatable_result1_upvr_2.ChoiceSelected:Fire(setmetatable_result1_upvr_2._lastChoice)
		end
	end))
	setmetatable_result1_upvr_2:_buildBacking()
	setmetatable_result1_upvr_2:_createChoices(arg2)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.VisibleChanged:Connect(function(arg1_3, arg2_2, arg3) -- Line 106
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: UserInputService_upvr (copied, readonly)
			[3]: GuiService_upvr (copied, readonly)
		]]
		local var26 = setmetatable_result1_upvr_2
		if arg1_3 then
			var26 = 1
		else
			var26 = 0
		end
		var26._percentVisible.t = var26
		if arg2_2 then
			setmetatable_result1_upvr_2._percentVisible.p = setmetatable_result1_upvr_2._percentVisible.t
		else
			setmetatable_result1_upvr_2._percentVisible.v = setmetatable_result1_upvr_2._percentVisible.v + 8
		end
		setmetatable_result1_upvr_2:_updateSelectable()
		setmetatable_result1_upvr_2:_startAnimation()
		if arg1_3 then
			if UserInputService_upvr:GetLastInputType().Name:find("Gamepad") then
				setmetatable_result1_upvr_2:_autoselectTopChoice()
			end
			arg3:GiveTask(UserInputService_upvr.LastInputTypeChanged:Connect(function(arg1_4) -- Line 122
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
				if arg1_4.Name:find("Mouse") or arg1_4.Name:find("Touch") then
					if GuiService_upvr.SelectedObject then
						GuiService_upvr.SelectedObject = nil
					end
				end
				-- KONSTANTERROR: [16] 13. Error Block 12 end (CF ANALYSIS FAILED)
			end))
		else
			setmetatable_result1_upvr_2._choicePane:HideChoicePane()
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr_3.mount(setmetatable_result1_upvr_2._backing, {
		ImageColor3 = setmetatable_result1_upvr_2._guiThemeService:ObserveColor("surface");
	}))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr._updateSelectable(arg1) -- Line 145
	local any_IsVisible_result1 = arg1:IsVisible()
	for _, v_2 in pairs(arg1._choiceButtons) do
		v_2:SetSelectable(any_IsVisible_result1)
	end
end
function setmetatable_result1_upvr.SetAccentColor(arg1, arg2) -- Line 152
	arg1._accentColor = arg2
	for _, v_3 in pairs(arg1._choiceButtons) do
		v_3:SetAccentColor(arg2)
	end
end
function setmetatable_result1_upvr.GetSize(arg1) -- Line 160
	return arg1._gui.Size
end
function setmetatable_result1_upvr._autoselectTopChoice(arg1) -- Line 164
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
local var1_result1_upvr_7 = any_load_result1("UIPaddingUtils")
function setmetatable_result1_upvr._createChoices(arg1, arg2) -- Line 174
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_7 (readonly)
	]]
	local var48
	if type(arg2) ~= "table" then
		var48 = false
	else
		var48 = true
	end
	assert(var48, "Bad choices")
	var48 = arg2.choices
	local pairs_result1, pairs_result2_4, pairs_result3 = pairs(var48)
	for _, v_4 in pairs_result1, pairs_result2_4, pairs_result3 do
		arg1:_addChoice(v_4)
	end
	pairs_result2_4 = var1_result1_upvr_7.getTotalPadding(arg1._uiPadding)
	pairs_result2_4 = arg1._gui
	pairs_result2_4.Size = arg1:_getSize(arg2.choices) + pairs_result2_4
end
local any_load_result1_result1_upvr_5 = any_load_result1("DialogChoiceTypes")
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("DialogChoiceGridButton")
local any_load_result1_result1_upvr_9 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr._addChoice(arg1, arg2) -- Line 187
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_9 (readonly)
	]]
	local var56 = arg2
	assert(var56, "Bad choice")
	if arg2.type ~= any_load_result1_result1_upvr_5.DIALOG_COLOR_CHOICE then
		var56 = false
	else
		var56 = true
	end
	assert(var56, "Bad choice.type")
	local any_new_result1_2 = var1_result1_upvr_5.new()
	local any_new_result1_upvr = var1_result1_upvr.new(arg1._serviceBag, arg2)
	any_new_result1_upvr:SetSelectable(arg1:IsVisible())
	any_new_result1_upvr:SetAccentColor(arg1._accentColor)
	any_new_result1_upvr:SetNumber(#arg1._choiceButtons + 1)
	any_new_result1_upvr:SetInteractionEnabled(true)
	any_new_result1_upvr.Gui.Parent = arg1._buttonContainer
	any_new_result1_2:GiveTask(any_new_result1_2)
	any_new_result1_2:GiveTask(any_new_result1_upvr.Selected:Connect(function() -- Line 202
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: any_load_result1_result1_upvr_9 (copied, readonly)
		]]
		if arg1._lastChoice == arg2 then
			any_new_result1_upvr:SetIsChoosen(false)
			arg1._choicePane:HideChoicePane()
			arg1._lastChoice = nil
			arg1._lastChoiceButton = nil
			any_load_result1_result1_upvr_9.playTemplate(arg1._dialogTemplates, "SinglePlopTemplate")
		else
			arg1._lastChoice = arg2
			arg1._lastChoiceButton = any_new_result1_upvr
			arg1._choicePane:SetAccentColor(arg2.color)
			arg1._choicePane:ShowChoicePane()
			any_new_result1_upvr:SetIsChoosen(true)
			for _, v_6 in pairs(arg1._choiceButtons) do
				if v_6 ~= any_new_result1_upvr then
					v_6:SetIsChoosen(false)
				end
			end
			any_load_result1_result1_upvr_9.playTemplate(arg1._dialogTemplates, "SuccessChimeTemplate")
		end
	end))
	table.insert(arg1._choiceButtons, any_new_result1_upvr)
end
function setmetatable_result1_upvr._getSize(arg1, arg2) -- Line 236
	local minimum = math.min(#arg2, arg1._uiGridLayout.FillDirectionMaxCells)
	local ceiled = math.ceil(#arg2 / minimum)
	local CellSize = arg1._uiGridLayout.CellSize
	local CellPadding = arg1._uiGridLayout.CellPadding
	return UDim2.fromOffset(CellSize.X.Offset * ceiled, CellSize.Y.Offset * minimum) + UDim2.fromOffset(CellPadding.X.Offset * math.max(0, ceiled - 1), CellPadding.Y.Offset * math.max(0, minimum - 1))
end
function setmetatable_result1_upvr._buildBacking(arg1) -- Line 249
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1 = var1_result1_upvr_2.new()
	arg1._backing = any_new_result1:CreateBacking(arg1._gui)
	arg1._shadow = any_new_result1:CreateShadow(arg1._backing)
end
local var1_result1_upvr_6 = any_load_result1("Math")
function setmetatable_result1_upvr._update(arg1) -- Line 255
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local p = arg1._percentVisible.p
	local var76 = 1 - p
	local var77 = p * arg1._percentPending.p
	arg1._gui.Rotation = (1 - p) * 10 + 3 * var77
	arg1._choiceContainer.Rotation = -3 * var77
	arg1._uiScale.Scale = 0.5 + 0.5 * p
	arg1._backing.ImageTransparency = var76
	arg1._shadow.ImageTransparency = var1_result1_upvr_6.lerp(1, var1_result1_upvr_2.DEFAULT_SHADOW_TRANSPARENCY, p)
	local _, pairs_result2_3, pairs_result3_2 = pairs(arg1._choiceButtons)
	local var81
	for _, v_5 in var81, pairs_result2_3, pairs_result3_2 do
		v_5:SetTransparency(var76)
	end
	var81 = true
	if 0 >= arg1._percentVisible.rtime then
		if 0 >= arg1._percentPending.rtime then
			var81 = false
		else
			var81 = true
		end
	end
	return var81
end
return setmetatable_result1_upvr