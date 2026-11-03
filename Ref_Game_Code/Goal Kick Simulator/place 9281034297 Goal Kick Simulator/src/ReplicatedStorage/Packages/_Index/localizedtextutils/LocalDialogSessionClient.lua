-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:23
-- Luau version 6, Types version 3
-- Time taken: 0.009691 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("DialogSessionBase")
local var1_result1_upvr_5 = any_load_result1("Promise")
local var1_result1_upvr_2 = any_load_result1("Maid")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "LocalDialogSessionClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_2 = any_load_result1("BusyCharacterServiceClient")
local any_load_result1_result1_upvr_4 = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1) -- Line 25
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1._busyCharacterServiceClient = setmetatable_result1._serviceBag:GetService(any_load_result1_result1_upvr_2)
	setmetatable_result1.CurrentTextRenderer = any_load_result1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.CurrentTextRenderer)
	setmetatable_result1.CurrentSlider = any_load_result1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.CurrentSlider)
	setmetatable_result1._promiseShown = var1_result1_upvr_5.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._promiseShown)
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetPromiseIsShown(arg1) -- Line 44
	return arg1._promiseShown
end
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr_3 = any_load_result1("DialogChoiceUtils")
function setmetatable_result1_upvr.ShowChoiceList(arg1, arg2) -- Line 48
	--[[ Upvalues[2]:
		[1]: HttpService_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	local var11
	if type(arg2) ~= "table" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad choiceList")
	if 0 >= #arg2 then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad choiceList")
	var11 = var1_result1_upvr_3.createChoices(HttpService_upvr:GenerateGUID(false), arg2)
	return arg1:ShowChoices(var11)
end
function setmetatable_result1_upvr.ShowTextBox(arg1, arg2) -- Line 58
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	local var12_upvr
	if type(arg2) ~= "table" then
		var12_upvr = false
	else
		var12_upvr = true
	end
	assert(var12_upvr, "Bad textBoxOptions")
	var12_upvr = var1_result1_upvr_2
	local any_new_result1_upvr_3 = var12_upvr.new()
	var12_upvr = var1_result1_upvr_5.new()
	any_new_result1_upvr_3:GiveTask(var12_upvr)
	local any__getDialogPane_result1_2_upvr = arg1:_getDialogPane()
	local any_ShowTextBox_result1_upvr = any__getDialogPane_result1_2_upvr:ShowTextBox(arg2)
	any_new_result1_upvr_3:GiveTask(function() -- Line 68
		--[[ Upvalues[2]:
			[1]: any__getDialogPane_result1_2_upvr (readonly)
			[2]: any_ShowTextBox_result1_upvr (readonly)
		]]
		if not any__getDialogPane_result1_2_upvr.Destroy then
		elseif any__getDialogPane_result1_2_upvr:GetCurrentTextBox() == any_ShowTextBox_result1_upvr then
			any__getDialogPane_result1_2_upvr:HideCurrentPrompt()
		end
	end)
	any_new_result1_upvr_3:GiveTask(any_ShowTextBox_result1_upvr.Removing:Connect(function() -- Line 77
		--[[ Upvalues[1]:
			[1]: var12_upvr (readonly)
		]]
		var12_upvr:Reject("Choice renderer removed before option selected")
	end))
	any_new_result1_upvr_3:GiveTask(any_ShowTextBox_result1_upvr.SelectionConfirmed:Connect(function(arg1_2) -- Line 80
		--[[ Upvalues[2]:
			[1]: var12_upvr (readonly)
			[2]: arg1 (readonly)
		]]
		local var19
		if type(arg1_2) ~= "string" then
			var19 = false
		else
			var19 = true
		end
		assert(var19, "Bad text")
		var12_upvr:Resolve(arg1_2, arg1)
	end))
	var12_upvr:Finally(function() -- Line 85
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_3 (readonly)
		]]
		any_new_result1_upvr_3:DoCleaning()
	end)
	any__getDialogPane_result1_2_upvr:Show()
	any_new_result1_upvr_3._currentPromptMaid = any_new_result1_upvr_3
	return var12_upvr
end
function setmetatable_result1_upvr.ShowSlider(arg1, arg2) -- Line 96
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	local var21_upvr
	if type(arg2) ~= "table" then
		var21_upvr = false
	else
		var21_upvr = true
	end
	assert(var21_upvr, "Bad sliderOptions")
	var21_upvr = var1_result1_upvr_2
	local any_new_result1_upvr_2 = var21_upvr.new()
	var21_upvr = var1_result1_upvr_5.new()
	any_new_result1_upvr_2:GiveTask(var21_upvr)
	var21_upvr:Finally(function() -- Line 104
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
	end)
	local any__getDialogPane_result1_3_upvr = arg1:_getDialogPane()
	local any_ShowSlider_result1_upvr = any__getDialogPane_result1_3_upvr:ShowSlider(arg2)
	any_new_result1_upvr_2:GiveTask(function() -- Line 110
		--[[ Upvalues[2]:
			[1]: any__getDialogPane_result1_3_upvr (readonly)
			[2]: any_ShowSlider_result1_upvr (readonly)
		]]
		if not any__getDialogPane_result1_3_upvr.Destroy then
		elseif any__getDialogPane_result1_3_upvr:GetCurrentSlider() == any_ShowSlider_result1_upvr then
			any__getDialogPane_result1_3_upvr:HideCurrentPrompt()
		end
	end)
	arg1.CurrentSlider.Value = any_ShowSlider_result1_upvr
	any_new_result1_upvr_2:GiveTask(function() -- Line 120
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_ShowSlider_result1_upvr (readonly)
		]]
		if arg1.CurrentSlider.Value == any_ShowSlider_result1_upvr then
			arg1.CurrentSlider.Value = nil
		end
	end)
	any_new_result1_upvr_2:GiveTask(any_ShowSlider_result1_upvr.Removing:Connect(function() -- Line 126
		--[[ Upvalues[1]:
			[1]: var21_upvr (readonly)
		]]
		var21_upvr:Reject("Choice renderer removed before option selected")
	end))
	any_new_result1_upvr_2:GiveTask(any_ShowSlider_result1_upvr.SelectionConfirmed:Connect(function(arg1_3) -- Line 129
		--[[ Upvalues[2]:
			[1]: var21_upvr (readonly)
			[2]: arg1 (readonly)
		]]
		var21_upvr:Resolve(arg1_3, arg1)
	end))
	any__getDialogPane_result1_3_upvr:Show()
	any_new_result1_upvr_2._currentPromptMaid = any_new_result1_upvr_2
	return var21_upvr
end
function setmetatable_result1_upvr.ShowChoices(arg1, arg2) -- Line 140
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var30_upvr
	if type(arg2) ~= "table" then
		var30_upvr = false
	else
		var30_upvr = true
	end
	assert(var30_upvr, "Bad choices")
	if type(arg2.choices) ~= "table" then
		var30_upvr = false
		-- KONSTANTWARNING: GOTO [25] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [24] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var30_upvr = true
	assert(var30_upvr, "Bad choices.choices")
	if type(arg2.key) ~= "string" then
		var30_upvr = false
	else
		var30_upvr = true
	end
	assert(var30_upvr, "Bad choices.key")
	var30_upvr = var1_result1_upvr_2
	local any_new_result1_upvr = var30_upvr.new()
	var30_upvr = var1_result1_upvr_5.new()
	any_new_result1_upvr:GiveTask(var30_upvr)
	var30_upvr:Finally(function() -- Line 150
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end)
	local any__getDialogPane_result1_upvr = arg1:_getDialogPane()
	local any_ShowChoices_result1_upvr = any__getDialogPane_result1_upvr:ShowChoices(arg2)
	any_new_result1_upvr:GiveTask(function() -- Line 156
		--[[ Upvalues[2]:
			[1]: any__getDialogPane_result1_upvr (readonly)
			[2]: any_ShowChoices_result1_upvr (readonly)
		]]
		if not any__getDialogPane_result1_upvr.Destroy then
		elseif any__getDialogPane_result1_upvr:GetCurrentChoicesPane() == any_ShowChoices_result1_upvr then
			any__getDialogPane_result1_upvr:HideCurrentPrompt()
		end
	end)
	any_new_result1_upvr:GiveTask(any_ShowChoices_result1_upvr.Removing:Connect(function() -- Line 165
		--[[ Upvalues[1]:
			[1]: var30_upvr (readonly)
		]]
		var30_upvr:Reject("Choice renderer removed before option selected")
	end))
	any_new_result1_upvr:GiveTask(any_ShowChoices_result1_upvr.ChoiceSelected:Connect(function(arg1_4) -- Line 168
		--[[ Upvalues[2]:
			[1]: var30_upvr (readonly)
			[2]: arg1 (readonly)
		]]
		var30_upvr:Resolve(arg1_4, arg1)
	end))
	any__getDialogPane_result1_upvr:Show()
	any_new_result1_upvr._currentPromptMaid = any_new_result1_upvr
	do
		return var30_upvr
	end
	-- KONSTANTERROR: [24] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
local any_load_result1_result1_upvr = any_load_result1("DialogTranslator")
function setmetatable_result1_upvr.ShowText(arg1, arg2, arg3) -- Line 179
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var39
	if type(arg2) ~= "string" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Bad textKey")
	if type(arg3) ~= "table" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Bad context")
	return arg1._serviceBag:GetService(any_load_result1_result1_upvr):PromiseFormatByKey(arg2):Then(function(arg1_5) -- Line 184
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
		]]
		return arg1:_showRawText(arg1_5, arg3)
	end)
end
function setmetatable_result1_upvr.ShowRawText(arg1, arg2, arg3) -- Line 189
	return arg1:_showRawText(arg2, arg3)
end
function setmetatable_result1_upvr._showRawText(arg1, arg2, arg3) -- Line 194
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	local var41_upvr
	if type(arg2) ~= "string" then
		var41_upvr = false
	else
		var41_upvr = true
	end
	assert(var41_upvr, "Bad text")
	if type(arg3) ~= "table" then
		var41_upvr = false
	else
		var41_upvr = true
	end
	assert(var41_upvr, "Bad context")
	local any__getDialogPane_result1 = arg1:_getDialogPane()
	var41_upvr = var1_result1_upvr_2.new()
	local any_new_result1_upvr_4 = var1_result1_upvr_5.new()
	var41_upvr:GiveTask(any_new_result1_upvr_4)
	any_new_result1_upvr_4:Finally(function() -- Line 204
		--[[ Upvalues[1]:
			[1]: var41_upvr (readonly)
		]]
		var41_upvr:DoCleaning()
	end)
	var41_upvr:GiveTask(any__getDialogPane_result1:ShowText(arg2, arg3).Done:Connect(function() -- Line 209
		--[[ Upvalues[2]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: arg1 (readonly)
		]]
		any_new_result1_upvr_4:Resolve(arg1)
	end))
	any__getDialogPane_result1:Show()
	arg1._maid._currentTextMaid = var41_upvr
	return any_new_result1_upvr_4
end
function setmetatable_result1_upvr.EndSession(arg1) -- Line 220
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	arg1:Destroy()
	return var1_result1_upvr_5.rejected()
end
local var1_result1_upvr_7 = any_load_result1("DialogScreenGuiProvider")
local var1_result1_upvr = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_6 = any_load_result1("GameScalingUtils")
local var1_result1_upvr_4 = any_load_result1("DialogPane")
function setmetatable_result1_upvr._getDialogPane(arg1) -- Line 226
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_6 (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	if arg1._dialogPane then
		return arg1._dialogPane
	end
	local any_Get_result1_upvr = var1_result1_upvr_7:Get("DIALOG")
	var1_result1_upvr.fromUDim(UDim.new(0, var1_result1_upvr_6.getDialogPadding(any_Get_result1_upvr.AbsoluteSize))).Parent = any_Get_result1_upvr
	arg1._dialogPane = var1_result1_upvr_4.new(arg1._serviceBag)
	arg1._dialogPane:SetUIScale(var1_result1_upvr_6.getUIScale(any_Get_result1_upvr.AbsoluteSize))
	arg1._maid:GiveTask(function() -- Line 238
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_Get_result1_upvr (readonly)
		]]
		arg1._dialogPane:Hide()
		delay(1, function() -- Line 240
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: any_Get_result1_upvr (copied, readonly)
			]]
			arg1._dialogPane:Destroy()
			any_Get_result1_upvr:Destroy()
		end)
	end)
	arg1._maid:GiveTask(arg1._busyCharacterServiceClient:MarkAsBusy())
	arg1._dialogPane.Gui.Parent = any_Get_result1_upvr
	arg1._maid:GiveTask(arg1._dialogPane.CurrentTextRenderer.Changed:Connect(function() -- Line 252
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.CurrentTextRenderer.Value = arg1._dialogPane.CurrentTextRenderer.Value
	end))
	arg1.CurrentTextRenderer.Value = arg1._dialogPane.CurrentTextRenderer.Value
	arg1._maid:GiveTask(arg1._dialogPane.VisibleChanged:Connect(function(arg1_6) -- Line 257
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_6 then
			arg1._promiseShown:Resolve(true)
		end
	end))
	return arg1._dialogPane
end
return setmetatable_result1_upvr