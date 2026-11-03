-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:45
-- Luau version 6, Types version 3
-- Time taken: 0.006630 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_12 = any_load_result1("BaseObject")
local var1_result1_upvr_2 = any_load_result1("Maid")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_12)
setmetatable_result1_upvr.ClassName = "DialogTextContainer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr_15 = any_load_result1("DialogTemplatesClient")
local var1_result1_upvr_3 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_2 = any_load_result1("ValueObject")
local var1_result1_upvr_18 = any_load_result1("Spring")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 35
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_12 (readonly)
		[2]: var1_result1_upvr_15 (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr_2 (readonly)
		[6]: var1_result1_upvr_18 (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_12.new(arg1:GetService(var1_result1_upvr_15):Clone("DialogTextContainerTemplate")), setmetatable_result1_upvr)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1._guiThemeService = setmetatable_result1._serviceBag:GetService(var1_result1_upvr_3)
	setmetatable_result1._dialogTemplates = setmetatable_result1._serviceBag:GetService(var1_result1_upvr_15)
	setmetatable_result1.Gui = setmetatable_result1._obj
	setmetatable_result1._maid:GiveTask(setmetatable_result1._obj)
	setmetatable_result1.CurrentTextRenderer = any_load_result1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.CurrentTextRenderer)
	local var10 = arg2
	if not var10 then
		var10 = error("No dialogInput")
	end
	setmetatable_result1._dialogInput = var10
	setmetatable_result1._contentContainer = setmetatable_result1._obj.ContentContainer
	setmetatable_result1._contentUIScale = setmetatable_result1._contentContainer.UIScale
	setmetatable_result1._hintInputContainer = setmetatable_result1._obj.HintInputContainer
	setmetatable_result1._initialHintInputContainerPosition = setmetatable_result1._hintInputContainer.Position
	setmetatable_result1._percentVisible = Instance.new("NumberValue")
	setmetatable_result1._percentVisible.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._percentVisible)
	setmetatable_result1._hintInputSpring = var1_result1_upvr_18.new(0)
	setmetatable_result1._hintInputSpring.Damper = 0
	setmetatable_result1._hintInputSpring.Speed = 10
	setmetatable_result1._hintInputSpring.Position = 3
	setmetatable_result1.SizeRecorded = Instance.new("BoolValue")
	setmetatable_result1.SizeRecorded.Value = false
	setmetatable_result1._maid:GiveTask(setmetatable_result1.SizeRecorded)
	setmetatable_result1:SetParentUIScale(1)
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetParentUIScale(arg1, arg2) -- Line 75
	arg1._contentContainer.Size = UDim2.new(arg2, 0, arg2, 0)
	arg1._contentUIScale.Scale = 1 / arg2
	arg1._parentUIScale = arg2
end
function setmetatable_result1_upvr._setDarkTheme(arg1) -- Line 82
	arg1._backing.ImageColor3 = Color3.fromRGB(32, 29, 27)
end
function setmetatable_result1_upvr._setLightTheme(arg1) -- Line 86
	arg1._backing.ImageColor3 = Color3.new(1, 1, 1)
end
function setmetatable_result1_upvr.RecordSize(arg1) -- Line 90
	arg1._size = arg1._contentContainer.AbsoluteSize
	if arg1._size.x <= 0 then
		warn("self._size.x is %q":format(tostring(arg1._size.x)))
	end
	if arg1._size.y <= 0 then
		warn("self._size.y is %q":format(tostring(arg1._size.y)))
	end
	arg1.SizeRecorded.Value = true
end
local any_load_result1_result1_upvr_3 = any_load_result1("DialogTextUtils")
local var1_result1_upvr_7 = any_load_result1("DialogThemeUtils")
local var1_result1_upvr_14 = any_load_result1("DialogUIScaleUtils")
local var1_result1_upvr_5 = any_load_result1("DialogTagUtils")
local var1_result1_upvr_8 = any_load_result1("DialogEmoteUtils")
local var1_result1_upvr = any_load_result1("DialogParenthesesUtils")
local var1_result1_upvr_6 = any_load_result1("DialogItalicUtils")
local var1_result1_upvr_11 = any_load_result1("DialogBoldUtils")
local var1_result1_upvr_16 = any_load_result1("DialogEntityTagUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogTalkerUtils")
local any_load_result1_result1_upvr_4 = any_load_result1("DialogPunctuationEffectUtils")
local var1_result1_upvr_9 = any_load_result1("DialogTalkingSoundsUtils")
local var1_result1_upvr_13 = any_load_result1("DialogLineUtils")
function setmetatable_result1_upvr._parseIntoRenderer(arg1, arg2, arg3, arg4) -- Line 103
	--[[ Upvalues[13]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
		[3]: var1_result1_upvr_14 (readonly)
		[4]: var1_result1_upvr_5 (readonly)
		[5]: var1_result1_upvr_8 (readonly)
		[6]: var1_result1_upvr (readonly)
		[7]: var1_result1_upvr_6 (readonly)
		[8]: var1_result1_upvr_11 (readonly)
		[9]: var1_result1_upvr_16 (readonly)
		[10]: any_load_result1_result1_upvr (readonly)
		[11]: any_load_result1_result1_upvr_4 (readonly)
		[12]: var1_result1_upvr_9 (readonly)
		[13]: var1_result1_upvr_13 (readonly)
	]]
	assert(arg1._size, "Bad size")
	local any_parseWordsToStack_result1 = any_load_result1_result1_upvr_3.parseWordsToStack(any_load_result1_result1_upvr_3.splitIntoWords(arg3))
	var1_result1_upvr_7.pushTheme(any_parseWordsToStack_result1, arg1._guiThemeService)
	var1_result1_upvr_14.addScale(any_parseWordsToStack_result1, arg1._parentUIScale)
	var1_result1_upvr_5.separateIntoTags(any_parseWordsToStack_result1)
	var1_result1_upvr_8.replaceEmoteTags(any_parseWordsToStack_result1)
	var1_result1_upvr.addWhispers(any_parseWordsToStack_result1)
	var1_result1_upvr_6.addItalics(any_parseWordsToStack_result1)
	var1_result1_upvr_11.addBold(any_parseWordsToStack_result1, arg1._guiThemeService)
	var1_result1_upvr_16.replaceContextTags(any_parseWordsToStack_result1, arg4)
	local any_getTalkerFromLocalizedContext_result1 = any_load_result1_result1_upvr.getTalkerFromLocalizedContext(arg4)
	if any_getTalkerFromLocalizedContext_result1 then
		any_load_result1_result1_upvr_4.addPunctuationPauses(any_parseWordsToStack_result1)
		arg2:SetTalkingSounds(var1_result1_upvr_9.getForTalkerEntity(any_getTalkerFromLocalizedContext_result1))
	else
		arg2:DisableTextScrolling()
	end
	local any_parseStackToLines_result1 = var1_result1_upvr_13.parseStackToLines(any_parseWordsToStack_result1, arg1._size.x)
	if not any_getTalkerFromLocalizedContext_result1 then
		var1_result1_upvr_13.centerLines(any_parseStackToLines_result1, arg1._size.x)
	end
	arg2:ShowLines(any_parseStackToLines_result1, arg1._size.y)
end
function setmetatable_result1_upvr.SetPercentVisible(arg1, arg2) -- Line 137
	assert(arg2, "Bad percentVisible")
	arg1._percentVisible.Value = arg2
end
local var1_result1_upvr_4 = any_load_result1("DialogTextRenderer")
local var1_result1_upvr_17 = any_load_result1("SoundUtils")
function setmetatable_result1_upvr.ShowText(arg1, arg2, arg3) -- Line 143
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr_17 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	local any_new_result1_upvr_4 = var1_result1_upvr_4.new(arg1._serviceBag, arg1._contentContainer, arg1._dialogInput)
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_4)
	arg1.CurrentTextRenderer.Value = any_new_result1_upvr_4
	any_new_result1_upvr:GiveTask(function() -- Line 151
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr_4 (readonly)
		]]
		if arg1.CurrentTextRenderer.Value == any_new_result1_upvr_4 then
			arg1.CurrentTextRenderer.Value = nil
		end
	end)
	any_new_result1_upvr_4:SetPercentVisible(arg1._percentVisible.Value)
	any_new_result1_upvr:GiveTask(arg1._percentVisible.Changed:Connect(function() -- Line 158
		--[[ Upvalues[2]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: arg1 (readonly)
		]]
		any_new_result1_upvr_4:SetPercentVisible(arg1._percentVisible.Value)
	end))
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_4.DoneWaitingForInput:Connect(function() -- Line 162
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_17 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		var1_result1_upvr_17.playTemplate(arg1._dialogTemplates, "ButtonPlopTemplate")
	end))
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_4.WaitingForRequestNextInput.Changed:Connect(function() -- Line 166
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr_4 (readonly)
		]]
		arg1:HandleWaitingForRequestNextInput(any_new_result1_upvr_4.WaitingForRequestNextInput)
	end))
	arg1:HandleWaitingForRequestNextInput(any_new_result1_upvr_4.WaitingForRequestNextInput)
	if arg1.SizeRecorded.Value then
		arg1:_parseIntoRenderer(any_new_result1_upvr_4, arg2, arg3)
	else
		any_new_result1_upvr._sizeChangedEvent = arg1.SizeRecorded.Changed:Connect(function() -- Line 175
			--[[ Upvalues[5]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: any_new_result1_upvr_4 (readonly)
				[4]: arg2 (readonly)
				[5]: arg3 (readonly)
			]]
			if arg1.SizeRecorded.Value then
				any_new_result1_upvr._sizeChangedEvent = nil
				arg1:_parseIntoRenderer(any_new_result1_upvr_4, arg2, arg3)
			end
		end)
	end
	arg1._maid._currentRender = any_new_result1_upvr
	return any_new_result1_upvr_4
end
local var1_result1_upvr_10 = any_load_result1("HintInput")
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr.HandleWaitingForRequestNextInput(arg1, arg2) -- Line 188
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_10 (readonly)
		[3]: RunService_upvr (readonly)
	]]
	if not arg2.Value then
		arg1._maid._hintInput = nil
	else
		local any_new_result1_upvr_3 = var1_result1_upvr_2.new()
		local any_new_result1_upvr_2 = var1_result1_upvr_10.new(arg1._serviceBag, arg1._dialogInput:GetInputKeyMapList())
		any_new_result1_upvr_2.Gui.AnchorPoint = Vector2.new(0, 0)
		any_new_result1_upvr_2.Gui.Position = UDim2.new(0, 0, 0, 0)
		any_new_result1_upvr_2.Gui.Parent = arg1._hintInputContainer
		any_new_result1_upvr_3:GiveTask(any_new_result1_upvr_2)
		any_new_result1_upvr_2:Show()
		any_new_result1_upvr_2:SetTransparency(1 - arg1._percentVisible.Value)
		any_new_result1_upvr_3:GiveTask(arg1._percentVisible.Changed:Connect(function() -- Line 205
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: arg1 (readonly)
			]]
			any_new_result1_upvr_2:SetTransparency(1 - arg1._percentVisible.Value)
		end))
		any_new_result1_upvr_3:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 209
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._hintInputContainer.Position = arg1._initialHintInputContainerPosition + UDim2.new(0, 0, 0, arg1._hintInputSpring.p)
		end))
		arg1._maid._hintInput = function() -- Line 214
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: any_new_result1_upvr_3 (readonly)
			]]
			any_new_result1_upvr_2:Hide()
			any_new_result1_upvr_3:DoCleaning()
		end
	end
end
return setmetatable_result1_upvr