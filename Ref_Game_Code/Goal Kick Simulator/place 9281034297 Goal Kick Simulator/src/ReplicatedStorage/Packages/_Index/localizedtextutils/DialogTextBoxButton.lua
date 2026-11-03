-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:01
-- Luau version 6, Types version 3
-- Time taken: 0.008007 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_7 = any_load_result1("BasicPane")
local var1_result1_upvr_2 = any_load_result1("Math")
local any_load_result1_result1_upvr_3 = any_load_result1("RoundedBackingBuilder")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_7)
setmetatable_result1_upvr_2.ClassName = "DialogTextBoxButton"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr_6 = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeService")
local var1_result1_upvr_9 = any_load_result1("AccelTween")
local any_load_result1_result1_upvr_2 = any_load_result1("ButtonHighlightModel")
local var1_result1_upvr = any_load_result1("FunctionUtils")
local var1_result1_upvr_4 = any_load_result1("DialogButtonUtils")
local var1_result1_upvr_10 = any_load_result1("Blend")
function setmetatable_result1_upvr_2.new(arg1) -- Line 29
	--[[ Upvalues[9]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: var1_result1_upvr_9 (readonly)
		[6]: any_load_result1_result1_upvr_2 (readonly)
		[7]: var1_result1_upvr (readonly)
		[8]: var1_result1_upvr_4 (readonly)
		[9]: var1_result1_upvr_10 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_7.new(arg1:GetService(var1_result1_upvr_6):Clone("DialogTextBoxButtonTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(any_load_result1_result1_upvr)
	setmetatable_result1_upvr._percentVisible = var1_result1_upvr_9.new(50)
	setmetatable_result1_upvr._percentVisible.t = 0
	setmetatable_result1_upvr._percentVisible.p = 0
	setmetatable_result1_upvr._totalTransparency = 0
	setmetatable_result1_upvr._uiAspectRatio = setmetatable_result1_upvr._gui.UIAspectRatioConstraint
	setmetatable_result1_upvr._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr._sizeValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._sizeValue)
	setmetatable_result1_upvr._container = setmetatable_result1_upvr._gui.Container
	setmetatable_result1_upvr._containerUIAspectRatio = setmetatable_result1_upvr._container.UIAspectRatioConstraint
	setmetatable_result1_upvr._uiScale = setmetatable_result1_upvr._container.UIScale
	setmetatable_result1_upvr._content = setmetatable_result1_upvr._container.Content
	setmetatable_result1_upvr._hintInputContainer = setmetatable_result1_upvr._content.InputHintContainer
	setmetatable_result1_upvr._textLabelContainer = setmetatable_result1_upvr._content.TextLabelContainer
	setmetatable_result1_upvr._textLabel = setmetatable_result1_upvr._textLabelContainer.TextLabel
	setmetatable_result1_upvr._textAspectRatio = setmetatable_result1_upvr._textLabelContainer.UIAspectRatioConstraint
	setmetatable_result1_upvr:_buildBacking()
	setmetatable_result1_upvr._backingColor = Color3.new(0, 0, 0)
	setmetatable_result1_upvr.Activated = setmetatable_result1_upvr._gui.Activated
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.Activated:Connect(function() -- Line 64
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_playHairlines()
	end))
	setmetatable_result1_upvr:_updateSizePosition()
	setmetatable_result1_upvr._model = any_load_result1_result1_upvr_2.new(setmetatable_result1_upvr._gui, var1_result1_upvr.bind(setmetatable_result1_upvr, setmetatable_result1_upvr._update))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._model)
	setmetatable_result1_upvr._maid:GiveTask(var1_result1_upvr_4.setupFeedback(setmetatable_result1_upvr._serviceBag, setmetatable_result1_upvr._model))
	setmetatable_result1_upvr._model:SetInteractionEnabled(false)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_2, arg2) -- Line 76
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._model:SetInteractionEnabled(arg1_2)
		local var16 = setmetatable_result1_upvr
		if arg1_2 then
			var16 = 1
		else
			var16 = 0
		end
		var16._percentVisible.t = var16
		if arg2 then
			setmetatable_result1_upvr._percentVisible.p = setmetatable_result1_upvr._percentVisible.t
			setmetatable_result1_upvr._percentVisible.v = 0
		else
			setmetatable_result1_upvr._percentVisible.v = setmetatable_result1_upvr._percentVisible.v + 4
		end
		setmetatable_result1_upvr._model:StartAnimation()
	end))
	setmetatable_result1_upvr:SetText(nil)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._guiThemeService:ObserveColor("text", setmetatable_result1_upvr._guiThemeService:ObserveGradeOn("text", "action")):Subscribe(function(arg1_3) -- Line 93
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_setTextColor3(arg1_3)
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._guiThemeService:ObserveColor("action"):Subscribe(function(arg1_4) -- Line 98
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_setBackingColor(arg1_4)
	end))
	setmetatable_result1_upvr._maid:GiveTask(var1_result1_upvr_10.mount(setmetatable_result1_upvr._textLabel, {
		Font = setmetatable_result1_upvr._guiThemeService:ObserveFont("font");
	}))
	setmetatable_result1_upvr._model:StartAnimation()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetSizeValue(arg1) -- Line 110
	return arg1._sizeValue
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 114
	local var20
	if type(arg2) ~= "number" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad transparency")
	arg1._totalTransparency = arg2
	arg1._model:StartAnimation()
end
function setmetatable_result1_upvr_2._setTextColor3(arg1, arg2) -- Line 121
	local var21
	if typeof(arg2) ~= "Color3" then
		var21 = false
	else
		var21 = true
	end
	assert(var21, "Bad color")
	arg1._textLabel.TextColor3 = arg2
	arg1._model:StartAnimation()
end
function setmetatable_result1_upvr_2._setBackingColor(arg1, arg2) -- Line 127
	local var22
	if typeof(arg2) ~= "Color3" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Bad color")
	arg1._backingColor = arg2
	arg1._model:StartAnimation()
end
local var1_result1_upvr_3 = any_load_result1("HintInput")
local var1_result1_upvr_8 = any_load_result1("Maid")
local UserInputService_upvr = game:GetService("UserInputService")
function setmetatable_result1_upvr_2.SetActivationHint(arg1, arg2) -- Line 133
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_8 (readonly)
		[3]: UserInputService_upvr (readonly)
	]]
	assert(arg2, "Bad inputKeyMapList")
	assert(not arg1._inputHint, "Already set")
	arg1._inputHint = var1_result1_upvr_3.new(arg1._serviceBag, arg2)
	arg1._inputHint.Gui.Parent = arg1._hintInputContainer
	arg1._inputHint.Gui.Size = UDim2.new(1, 0, 1, 0)
	arg1._inputHint:OverrideTheme("Light")
	arg1._maid:GiveTask(arg1._inputHint)
	arg1._maid:GiveTask(arg1._inputHint.ShowingHint.Changed:Connect(function() -- Line 143
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateSizePosition()
	end))
	arg1._maid:GiveTask(arg2:ObserveInputEnumsSet():Subscribe(function(arg1_5) -- Line 147
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_8 (copied, readonly)
			[3]: UserInputService_upvr (copied, readonly)
		]]
		arg1._maid._currentInputKeys = nil
		local any_new_result1 = var1_result1_upvr_8.new()
		any_new_result1:GiveTask(UserInputService_upvr.InputBegan:Connect(function(arg1_6) -- Line 151
			--[[ Upvalues[3]:
				[1]: arg1_5 (readonly)
				[2]: UserInputService_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			if arg1_5[arg1_6.KeyCode] and not UserInputService_upvr:GetFocusedTextBox() then
				arg1:_playHairlines()
				arg1._model:SetKeyDown(true)
			end
		end))
		any_new_result1:GiveTask(UserInputService_upvr.InputEnded:Connect(function(arg1_7) -- Line 157
			--[[ Upvalues[2]:
				[1]: arg1_5 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			if arg1_5[arg1_7.KeyCode] then
				arg1._model:SetKeyDown(false)
			end
		end))
		any_new_result1:GiveTask(function() -- Line 163
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			if arg1._model.Destroy then
				arg1._model:SetKeyDown(false)
			end
		end)
		arg1._maid._currentInputKeys = any_new_result1
	end))
	arg1._inputHint:Show()
	arg1:_updateSizePosition()
	arg1._model:StartAnimation()
end
local any_load_result1_result1_upvr_4 = any_load_result1("HairLines")
function setmetatable_result1_upvr_2._playHairlines(arg1) -- Line 178
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_2_upvr = any_load_result1_result1_upvr_4.new(arg1._serviceBag, 45, 135, 3)
	any_new_result1_2_upvr:SetColor(arg1._backing.ImageColor3)
	any_new_result1_2_upvr.Gui.AnchorPoint = Vector2.new(1, 0.5)
	any_new_result1_2_upvr.Gui.Position = UDim2.fromScale(1, 0.5)
	any_new_result1_2_upvr.Gui.Parent = arg1._container
	any_new_result1_2_upvr:Play(function() -- Line 186
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:Destroy()
	end)
	any_new_result1_2_upvr = any_load_result1_result1_upvr_4.new(arg1._serviceBag, -45, -135, 3)
	local var35_upvr = any_new_result1_2_upvr
	var35_upvr:SetColor(arg1._backing.ImageColor3)
	var35_upvr.Gui.AnchorPoint = Vector2.new(0, 0.5)
	var35_upvr.Gui.Position = UDim2.fromScale(0, 0.5)
	var35_upvr.Gui.Parent = arg1._container
	var35_upvr:Play(function() -- Line 198
		--[[ Upvalues[1]:
			[1]: var35_upvr (readonly)
		]]
		var35_upvr:Destroy()
	end)
end
function setmetatable_result1_upvr_2._setTransparency(arg1, arg2) -- Line 204
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	arg1._textLabel.TextTransparency = arg2
	arg1._backing.ImageTransparency = arg2
	arg1._shadow.ImageTransparency = var1_result1_upvr_2.lerp(any_load_result1_result1_upvr_3.DEFAULT_SHADOW_TRANSPARENCY, 1, arg2)
	if arg1._inputHint then
		arg1._inputHint:SetTransparency(arg2)
	end
end
function setmetatable_result1_upvr_2.SetText(arg1, arg2) -- Line 214
	if arg2 then
		arg1._textLabel.Text = arg2
		arg1._textLabelContainer.Visible = true
	else
		arg1._textLabelContainer.Visible = false
	end
	arg1:_updateSizePosition()
end
local TextService_upvr = game:GetService("TextService")
function setmetatable_result1_upvr_2._updateSizePosition(arg1) -- Line 225
	--[[ Upvalues[1]:
		[1]: TextService_upvr (readonly)
	]]
	local var38
	if var38 then
		var38 = arg1._inputHint.ShowingHint.Value
	end
	if arg1._textLabelContainer.Visible then
		local any_GetTextSize_result1 = TextService_upvr:GetTextSize(arg1._textLabel.Text, arg1._textLabel.TextSize, arg1._textLabel.Font, Vector2.new(1000000, 1000000))
		local var40 = any_GetTextSize_result1 + Vector2.new(20, any_GetTextSize_result1.y)
		arg1._textAspectRatio.AspectRatio = var40.x / var40.y
		local var41
		if var38 then
			var41 = var40 + Vector2.new(var40.y, 0)
		else
			var41 = var40
		end
		local var42 = var41.x / var41.y
		arg1._containerUIAspectRatio.AspectRatio = var42
		arg1._uiAspectRatio.AspectRatio = var42
		local var43 = 1 / arg1._textLabel.Size.Y.Scale
		arg1._sizeValue.Value = Vector3.new(var42 * var43, var43, 0)
	else
		arg1._containerUIAspectRatio.AspectRatio = 1
		arg1._uiAspectRatio.AspectRatio = 1
		arg1._sizeValue.Value = Vector3.new(0, 0, 0)
	end
	arg1._hintInputContainer.Visible = var38
end
function setmetatable_result1_upvr_2._buildBacking(arg1) -- Line 259
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_3 = any_load_result1_result1_upvr_3.new()
	arg1._backing = any_new_result1_3:CreateBacking(arg1._container)
	arg1._shadow = any_new_result1_3:CreateShadow(arg1._backing)
end
local var1_result1_upvr_5 = any_load_result1("ButtonUtils")
function setmetatable_result1_upvr_2._update(arg1, arg2, arg3, arg4) -- Line 265
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local p_5 = arg1._percentVisible.p
	local p_2 = arg2.p
	local p_6 = arg4.p
	arg1._container.Rotation = ((1 - p_5) * 0.5 + p_6 * 0.5) / arg1._uiAspectRatio.AspectRatio * 10
	arg1._uiScale.Scale = p_5 * (1 + p_2 * 0.1 - p_6 * 0.2)
	arg1._backing.ImageColor3 = var1_result1_upvr_5.getMouseOverColor(arg1._backingColor, p_2)
	arg1:_setTransparency(var1_result1_upvr_2.map(p_5, 0, 1, 1, arg1._totalTransparency))
	local var53 = true
	if 0 >= arg2.rtime then
		var53 = true
		if 0 >= arg4.rtime then
			if 0 >= arg1._percentVisible.rtime then
				var53 = false
			else
				var53 = true
			end
		end
	end
	return var53
end
return setmetatable_result1_upvr_2