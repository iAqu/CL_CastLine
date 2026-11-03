-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:11
-- Luau version 6, Types version 3
-- Time taken: 0.008452 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_10 = any_load_result1("BasicPane")
local var1_result1_upvr_4 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("RxValueBaseUtils")
local var1_result1_upvr_5 = any_load_result1("InputKeyMapList")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_10)
setmetatable_result1_upvr_2.ClassName = "HintInput"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr_13 = any_load_result1("HintInputTemplatesClient")
local var1_result1_upvr_12 = any_load_result1("GuiThemeService")
local var1_result1_upvr_9 = any_load_result1("ValueObject")
local var1_result1_upvr_2 = any_load_result1("Spring")
local var1_result1_upvr_11 = any_load_result1("StepUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 32
	--[[ Upvalues[9]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_10 (readonly)
		[3]: var1_result1_upvr_13 (readonly)
		[4]: setmetatable_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_12 (readonly)
		[6]: var1_result1_upvr_9 (readonly)
		[7]: var1_result1_upvr_2 (readonly)
		[8]: var1_result1_upvr_11 (readonly)
		[9]: var1_result1_upvr_4 (readonly)
	]]
	assert(arg1, "No serviceBag")
	local any_isInputKeyMapList_result1_2 = var1_result1_upvr_5.isInputKeyMapList(arg2)
	if not any_isInputKeyMapList_result1_2 then
		if arg2 ~= nil then
			any_isInputKeyMapList_result1_2 = false
		else
			any_isInputKeyMapList_result1_2 = true
		end
	end
	assert(any_isInputKeyMapList_result1_2, "Bad inputKeyMapList")
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_10.new(arg1:GetService(var1_result1_upvr_13):Clone("HintInputTemplate")), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr._guiThemeService = setmetatable_result1_upvr._serviceBag:GetService(var1_result1_upvr_12)
	setmetatable_result1_upvr._uiAspectRatio = setmetatable_result1_upvr.Gui.UIAspectRatioConstraint
	setmetatable_result1_upvr._overriddenTheme = Instance.new("StringValue")
	setmetatable_result1_upvr._overriddenTheme.Value = ""
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._overriddenTheme)
	setmetatable_result1_upvr._currentInputKeyMapList = var1_result1_upvr_9.new(arg2)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._currentInputKeyMapList)
	setmetatable_result1_upvr.InputKeyMapListChanged = setmetatable_result1_upvr._currentInputKeyMapList.Changed
	setmetatable_result1_upvr._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr._sizeValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._sizeValue)
	setmetatable_result1_upvr._sizeSpring = var1_result1_upvr_2.new(Vector2.new())
	setmetatable_result1_upvr._sizeSpring.Speed = 50
	setmetatable_result1_upvr._sizeSpring.Damper = 1
	setmetatable_result1_upvr.ShowingHint = Instance.new("BoolValue")
	setmetatable_result1_upvr.ShowingHint.Value = false
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.ShowingHint)
	setmetatable_result1_upvr._imageLabels = {}
	setmetatable_result1_upvr._transparency = 0
	local any_bindToRenderStep_result1, any_bindToRenderStep_result2 = var1_result1_upvr_11.bindToRenderStep(setmetatable_result1_upvr._update)
	setmetatable_result1_upvr._startAnimation = any_bindToRenderStep_result1
	setmetatable_result1_upvr._maid._cancelUpdate = any_bindToRenderStep_result2
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.VisibleChanged:Connect(function(arg1_2, arg2_2) -- Line 69
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: setmetatable_result1_upvr (readonly)
		]]
		local any_new_result1_2 = var1_result1_upvr_4.new()
		setmetatable_result1_upvr._maid._hintVisibleMaid = any_new_result1_2
		setmetatable_result1_upvr:_handleVisibleChanged(arg1_2, arg2_2, any_new_result1_2)
	end))
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetSizeValue(arg1) -- Line 84
	return arg1._sizeValue
end
function setmetatable_result1_upvr_2.SetInputKeyMapList(arg1, arg2) -- Line 92
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	local any_isInputKeyMapList_result1 = var1_result1_upvr_5.isInputKeyMapList(arg2)
	if not any_isInputKeyMapList_result1 then
		if arg2 ~= nil then
			any_isInputKeyMapList_result1 = false
		else
			any_isInputKeyMapList_result1 = true
		end
	end
	assert(any_isInputKeyMapList_result1, "Bad inputKeyMapList")
	arg1._currentInputKeyMapList.Value = arg2
end
function setmetatable_result1_upvr_2.GetInputKeyMapList(arg1) -- Line 102
	return arg1._currentInputKeyMapList.Value
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 110
	local var23
	if type(arg2) ~= "number" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad transparency")
	arg1._transparency = arg2
	var23 = arg1._imageLabels
	for i, _ in pairs(var23) do
		i.ImageTransparency = arg1._transparency
	end
end
function setmetatable_result1_upvr_2.OverrideTheme(arg1, arg2) -- Line 124
	if arg2 then
		arg1._overriddenTheme.Value = arg2
	else
		arg1._overriddenTheme.Value = ""
	end
end
function setmetatable_result1_upvr_2.ObserveShowingHint(arg1) -- Line 132
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.observeValue(arg1.ShowingHint)
end
function setmetatable_result1_upvr_2._handleVisibleChanged(arg1, arg2, arg3, arg4) -- Line 136
	if arg2 then
		arg4:GiveTask(arg1._currentInputKeyMapList.Changed:Connect(function() -- Line 138
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg4 (readonly)
			]]
			if arg1.Destroy then
				arg1:_renderForCurrentInputKeyMapList(arg4)
			end
		end))
		arg1:_renderForCurrentInputKeyMapList(arg4, arg3)
	else
		arg1:_setHide(arg3)
	end
end
function setmetatable_result1_upvr_2._setHide(arg1, arg2) -- Line 149
	arg1.ShowingHint.Value = false
	arg1._sizeSpring.t = Vector2.new(0, 0)
	if arg2 then
		arg1._sizeSpring.p = arg1._sizeSpring.t
		arg1._sizeSpring.v = Vector2.new(0, 0)
	end
	arg1:_startAnimation()
end
local var1_result1_upvr_6 = any_load_result1("Rx")
local var1_result1_upvr_8 = any_load_result1("InputKeyMapListUtils")
function setmetatable_result1_upvr_2._renderForCurrentInputKeyMapList(arg1, arg2, arg3) -- Line 160
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_3_upvr = var1_result1_upvr_4.new()
	local Value = arg1._currentInputKeyMapList.Value
	if Value and Value.Destroy then
		any_new_result1_3_upvr:GiveTask(var1_result1_upvr_6.combineLatest({
			inputTypes = var1_result1_upvr_8.observeActiveInputTypesList(Value, arg1._serviceBag);
			themeName = var1_result1_upvr_6.combineLatest({
				defaultTheme = var1_result1_upvr.observeValue(arg1._guiThemeService:GetPreferredThemeNameValue());
				overriddenTheme = var1_result1_upvr.observeValue(arg1._overriddenTheme);
			}):Pipe({var1_result1_upvr_6.map(function(arg1_3) -- Line 171
				if arg1_3.overriddenTheme ~= "" then
					return arg1_3.overriddenTheme
				end
				return arg1_3.defaultTheme
			end), var1_result1_upvr_6.distinct()});
		}):Subscribe(function(arg1_4) -- Line 180
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr_4 (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg3 (readonly)
				[4]: any_new_result1_3_upvr (readonly)
			]]
			local var42 = 0
			local var43 = false
			if arg1_4.inputTypes then
				for i_2, v_2 in pairs(arg1_4.inputTypes) do
					local any__renderInputType_result1 = arg1:_renderInputType(v_2, 1, arg1_4.themeName)
					if any__renderInputType_result1 then
						var42 += 1
						var43 = true
						var1_result1_upvr_4.new():GiveTask(any__renderInputType_result1)
					end
				end
			end
			arg1.ShowingHint.Value = var43
			if var43 then
				i_2 = 1
				arg1._sizeSpring.t = Vector2.new(var42, i_2)
			else
				arg1._sizeSpring.t = Vector2.new(0, 0)
			end
			if arg3 then
				arg1._sizeSpring.p = arg1._sizeSpring.t
				arg1._sizeSpring.v = Vector2.new(0, 0)
			end
			any_new_result1_3_upvr._renderMaid = var1_result1_upvr_4.new()
			arg1:_startAnimation()
		end))
	else
		arg1:_setHide(arg3)
	end
	arg2._currentInputMap = any_new_result1_3_upvr
end
local var1_result1_upvr_7 = any_load_result1("InputImageLibrary")
local var1_result1_upvr_3 = any_load_result1("ResizeOnInput")
function setmetatable_result1_upvr_2._renderInputType(arg1, arg2, arg3, arg4) -- Line 221
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	local any_GetScaledImageLabel_result1_upvr = var1_result1_upvr_7:GetScaledImageLabel(arg2, arg4)
	if not any_GetScaledImageLabel_result1_upvr then
		return nil
	end
	local any_new_result1 = var1_result1_upvr_4.new()
	local Frame = Instance.new("Frame")
	Frame.Name = "HintInputContainer"
	Frame.Transparency = 1
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.LayoutOrder = arg3
	any_new_result1:GiveTask(Frame)
	any_GetScaledImageLabel_result1_upvr.ImageTransparency = arg1._transparency
	any_GetScaledImageLabel_result1_upvr.Size = UDim2.new(1, 0, 1, 0)
	any_GetScaledImageLabel_result1_upvr.AnchorPoint = Vector2.new(0.5, 0.5)
	any_GetScaledImageLabel_result1_upvr.Position = UDim2.new(0.5, 0, 0.5, 0)
	any_GetScaledImageLabel_result1_upvr.Parent = Frame
	any_new_result1:GiveTask(any_GetScaledImageLabel_result1_upvr)
	arg1._imageLabels[any_GetScaledImageLabel_result1_upvr] = true
	any_new_result1:GiveTask(function() -- Line 245
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_GetScaledImageLabel_result1_upvr (readonly)
		]]
		arg1._imageLabels[any_GetScaledImageLabel_result1_upvr] = nil
	end)
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.AspectRatio = 1
	UIAspectRatioConstraint.Parent = Frame
	any_new_result1:GiveTask(UIAspectRatioConstraint)
	if typeof(arg2) == "EnumItem" then
		any_new_result1:GiveTask(var1_result1_upvr_3.new(any_GetScaledImageLabel_result1_upvr, arg2))
	end
	Frame.Parent = arg1.Gui
	return any_new_result1
end
function setmetatable_result1_upvr_2._update(arg1) -- Line 265
	local var55 = true
	local var56
	if 0.000001 > var56 then
		var56 = arg1._sizeSpring.v.magnitude
		if 0.000001 > var56 then
			var55 = false
		else
			var55 = true
		end
	end
	var56 = nil
	if var55 then
		var56 = arg1._sizeSpring.p
	else
		var56 = arg1._sizeSpring.t
	end
	if 0 < var56.x and 0 < var56.y then
		arg1._uiAspectRatio.AspectRatio = var56.x / var56.y
	end
	arg1._sizeValue.Value = Vector3.new(var56.x, var56.y, 0)
	return var55
end
return setmetatable_result1_upvr_2