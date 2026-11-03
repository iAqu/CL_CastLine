-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:23
-- Luau version 6, Types version 3
-- Time taken: 0.008220 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local var1_result1_upvr_15 = any_load_result1("Blend")
local var1_result1_upvr_5 = any_load_result1("PillBackingBuilder")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "DialogChoiceButton"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
any_load_result1("MouseOverMixin"):Add(setmetatable_result1_upvr_2)
local var1_result1_upvr_16 = any_load_result1("DialogTemplatesClient")
local var1_result1_upvr_14 = any_load_result1("GuiThemeService")
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr = any_load_result1("Signal")
local var1_result1_upvr_6 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_2 = any_load_result1("Spring")
local var1_result1_upvr_4 = any_load_result1("HapticFeedbackUtils")
local var1_result1_upvr_10 = any_load_result1("SelectionImageUtils")
local var1_result1_upvr_12 = any_load_result1("ButtonHighlightModel")
local var1_result1_upvr_9 = any_load_result1("StepUtils")
local var1_result1_upvr_11 = any_load_result1("DialogButtonUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 37
	--[[ Upvalues[16]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_16 (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr_14 (readonly)
		[5]: HttpService_upvr (readonly)
		[6]: var1_result1_upvr (readonly)
		[7]: var1_result1_upvr_15 (readonly)
		[8]: var1_result1_upvr_6 (readonly)
		[9]: any_load_result1_result1_upvr_2 (readonly)
		[10]: var1_result1_upvr_5 (readonly)
		[11]: var1_result1_upvr_4 (readonly)
		[12]: UserInputService_upvr (readonly)
		[13]: var1_result1_upvr_10 (readonly)
		[14]: var1_result1_upvr_12 (readonly)
		[15]: var1_result1_upvr_9 (readonly)
		[16]: var1_result1_upvr_11 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(arg1:GetService(var1_result1_upvr_16):Clone("DialogChoiceButtonTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(var1_result1_upvr_14)
	setmetatable_result1_upvr._key = HttpService_upvr:GenerateGUID(false)
	setmetatable_result1_upvr.Selected = var1_result1_upvr.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.Selected)
	setmetatable_result1_upvr._transparency = var1_result1_upvr_15.State(0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._transparency)
	setmetatable_result1_upvr._accentColor = var1_result1_upvr_15.State(var1_result1_upvr_6.DEFAULT_ACCENT_COLOR)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._accentColor)
	setmetatable_result1_upvr._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr._sizeValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._sizeValue)
	setmetatable_result1_upvr._textValue = Instance.new("StringValue")
	setmetatable_result1_upvr._textValue.Value = ""
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._textValue)
	setmetatable_result1_upvr.Gui = setmetatable_result1_upvr._obj
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr._indicatorSpring = any_load_result1_result1_upvr_2.new(0)
	setmetatable_result1_upvr._indicatorSpring.Speed = 12
	setmetatable_result1_upvr._indicatorSpring.Damper = 0
	setmetatable_result1_upvr._indicatorSpring.Position = 2
	setmetatable_result1_upvr._seperator = setmetatable_result1_upvr._obj.Seperator
	setmetatable_result1_upvr._defaultSeperatorTransparency = setmetatable_result1_upvr._seperator.BackgroundTransparency
	setmetatable_result1_upvr._textLabel = setmetatable_result1_upvr._obj.Container.TextLabel
	setmetatable_result1_upvr._uiPadding = setmetatable_result1_upvr._obj.Container.UIPadding
	setmetatable_result1_upvr._selectedIndicator = setmetatable_result1_upvr._obj.Container.SelectedIndicator
	setmetatable_result1_upvr._selectedIndicatorDefaultPosition = setmetatable_result1_upvr._selectedIndicator.Position
	setmetatable_result1_upvr._indicatorBacking = var1_result1_upvr_5.new():CreateCircle(setmetatable_result1_upvr._selectedIndicator)
	setmetatable_result1_upvr._indicatorShadow = var1_result1_upvr_5.new():CreateCircleShadow(setmetatable_result1_upvr._selectedIndicator)
	setmetatable_result1_upvr:SetChoice(arg2)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._obj.Activated:Connect(function() -- Line 83
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: UserInputService_upvr (copied, readonly)
		]]
		if setmetatable_result1_upvr._model:IsInteractionEnabled() then
			var1_result1_upvr_4.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.75)
			setmetatable_result1_upvr.Selected:Fire()
		end
	end))
	setmetatable_result1_upvr._maid:GiveTask(var1_result1_upvr_10.overrideWithBlank(setmetatable_result1_upvr._obj))
	setmetatable_result1_upvr._model = var1_result1_upvr_12.new(setmetatable_result1_upvr._obj)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._model)
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr_9.bindToRenderStep(setmetatable_result1_upvr._update)
	setmetatable_result1_upvr._startIndicatorAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._stop = any_bindToRenderStep_result2
	setmetatable_result1_upvr._maid:GiveTask(var1_result1_upvr_11.setupFeedback(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._model))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._model.IsHighlighted.Changed:Connect(function() -- Line 99
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_startIndicatorAnimation()
	end))
	setmetatable_result1_upvr:_startIndicatorAnimation()
	setmetatable_result1_upvr:_mount()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetInteractionEnabled(arg1, arg2) -- Line 108
	arg1._model:SetInteractionEnabled(arg2)
end
function setmetatable_result1_upvr_2.SetIsChoosen(arg1, arg2) -- Line 112
	arg1._model:SetIsChoosen(arg2)
end
function setmetatable_result1_upvr_2.GetSizeValue(arg1) -- Line 116
	return arg1._sizeValue
end
local var1_result1_upvr_3 = any_load_result1("NumberToInputKeyUtils")
local ContextActionService_upvr = game:GetService("ContextActionService")
function setmetatable_result1_upvr_2.SetNumber(arg1, arg2) -- Line 120
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: UserInputService_upvr (readonly)
		[3]: ContextActionService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 10 start (CF ANALYSIS FAILED)
	arg1._maid._number = nil
	arg1.Gui.LayoutOrder = arg2
	local any_getInputsForNumber_result1_upvr = var1_result1_upvr_3.getInputsForNumber(arg2)
	if not any_getInputsForNumber_result1_upvr then return end
	local function _() -- Line 130, Named "isKeyDown"
		--[[ Upvalues[2]:
			[1]: any_getInputsForNumber_result1_upvr (readonly)
			[2]: UserInputService_upvr (copied, readonly)
		]]
		for _, v in pairs(any_getInputsForNumber_result1_upvr) do
			if UserInputService_upvr:IsKeyDown(v) then
				return true
			end
		end
		return false
	end
	local pairs_result1, pairs_result2_2, pairs_result3 = pairs(any_getInputsForNumber_result1_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [34] 27. Error Block 6 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [34] 27. Error Block 6 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [26] 20. Error Block 11 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [34.12]
	if nil then
		-- KONSTANTWARNING: GOTO [37] #29
	end
	-- KONSTANTERROR: [26] 20. Error Block 11 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr_2.HideSeperator(arg1) -- Line 161
	arg1._seperator.Visible = false
end
local GuiService_upvr = game:GetService("GuiService")
function setmetatable_result1_upvr_2.SetSelectable(arg1, arg2) -- Line 165
	--[[ Upvalues[1]:
		[1]: GuiService_upvr (readonly)
	]]
	local var36
	if type(arg2) ~= "boolean" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Bad selectable")
	arg1._obj.Selectable = arg2
	if not arg2 then
		var36 = GuiService_upvr
		var36 = arg1._obj
		if var36.SelectedObject == var36 then
			var36 = nil
			GuiService_upvr.SelectedObject = var36
		end
	end
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 177
	arg1._transparency.Value = arg2
end
function setmetatable_result1_upvr_2.SetAccentColor(arg1, arg2) -- Line 181
	local var37
	if typeof(arg2) ~= "Color3" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad color3")
	arg1._accentColor.Value = arg2
end
function setmetatable_result1_upvr_2.SetChoice(arg1, arg2) -- Line 187
	local var38
	if type(arg2.text) ~= "string" then
		var38 = false
	else
		var38 = true
	end
	assert(var38, "Bad choice")
	arg1:SetText(arg2.text)
end
function setmetatable_result1_upvr_2.SetText(arg1, arg2) -- Line 193
	if arg2 then
		arg1._textValue.Value = arg2
	else
		arg1._textValue.Value = ""
	end
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 201
	arg1._selectedIndicator.Position = arg1._selectedIndicatorDefaultPosition + UDim2.new(0, arg1._indicatorSpring.p, 0, 0)
	return arg1._model.IsHighlighted.Value
end
local any_load_result1_result1_upvr = any_load_result1("Math")
local var1_result1_upvr_8 = any_load_result1("TextServiceUtils")
local var1_result1_upvr_13 = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_7 = any_load_result1("ColorGradeUtils")
function setmetatable_result1_upvr_2._mount(arg1) -- Line 209
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_15 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: var1_result1_upvr_13 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
		[6]: var1_result1_upvr_7 (readonly)
	]]
	local any_Computed_result1 = var1_result1_upvr_15.Computed(arg1._model:ObservePercentHighlighted(), arg1._transparency, function(arg1_2, arg2) -- Line 213
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.lerp(1 - arg1_2, 1, arg2)
	end)
	arg1._maid:GiveTask(var1_result1_upvr_8.observeSizeForLabelProps({
		Font = arg1._guiThemeService:ObserveFont("font");
		Text = arg1._textValue;
		TextSize = arg1._textLabel.TextSize;
	}):Subscribe(function(arg1_3) -- Line 222
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_13 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		arg1._sizeValue.Value = Vector3.new(arg1_3.x + var1_result1_upvr_13.getHorizontalPadding(arg1._uiPadding).Offset, arg1.Gui.Size.Y.Offset)
	end))
	arg1._maid:GiveTask(var1_result1_upvr_15.mount(arg1._indicatorShadow, {
		ImageTransparency = var1_result1_upvr_15.Computed(any_Computed_result1, function(arg1_4) -- Line 230
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: var1_result1_upvr_5 (copied, readonly)
			]]
			return any_load_result1_result1_upvr.lerp(var1_result1_upvr_5.SHADOW_TRANSPARENCY, 1, arg1_4)
		end);
	}))
	arg1._maid:GiveTask(var1_result1_upvr_15.mount(arg1._indicatorBacking, {
		ImageColor3 = var1_result1_upvr_15.Computed(arg1._accentColor, arg1._guiThemeService:ObserveGrade("border"), function(arg1_5, arg2) -- Line 237
			--[[ Upvalues[1]:
				[1]: var1_result1_upvr_7 (copied, readonly)
			]]
			return var1_result1_upvr_7.getGradedColor(arg1_5, arg2)
		end);
		ImageTransparency = any_Computed_result1;
	}))
	arg1._maid:GiveTask(var1_result1_upvr_15.mount(arg1._seperator, {
		BackgroundColor3 = arg1._guiThemeService:ObserveColor("action", arg1._guiThemeService:ObserveModifiedGrade("border", "action"), arg1._guiThemeService:ObserveVividness("border"));
		BackgroundTransparency = arg1._transparency;
	}))
	arg1._maid:GiveTask(var1_result1_upvr_15.mount(arg1._textLabel, {
		TextTransparency = arg1._transparency;
		Font = arg1._guiThemeService:ObserveFont("font");
		Text = arg1._textValue;
		TextColor3 = arg1._guiThemeService:ObserveColor("text", var1_result1_upvr_15.Computed(arg1._guiThemeService:ObserveGradeOn("text", "action"), arg1._guiThemeService:ObserveGrade("hover"), arg1._model:ObservePercentHighlighted(), function(arg1_6, arg2, arg3) -- Line 259
			--[[ Upvalues[1]:
				[1]: var1_result1_upvr_7 (copied, readonly)
			]]
			return var1_result1_upvr_7.addGrade(arg1_6, arg2 * arg3)
		end));
	}))
end
return setmetatable_result1_upvr_2