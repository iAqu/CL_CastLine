-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:41
-- Luau version 6, Types version 3
-- Time taken: 0.006743 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_6 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_6)
setmetatable_result1_upvr.ClassName = "DialogChoiceGridButton"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_11 = any_load_result1("DialogTemplatesClient")
local var1_result1_upvr_2 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_12 = any_load_result1("Signal")
local any_load_result1_result1_upvr_10 = any_load_result1("DialogConstants")
local any_load_result1_result1_upvr_8 = any_load_result1("SelectionImageUtils")
local any_load_result1_result1_upvr_3 = any_load_result1("HapticFeedbackUtils")
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr_9 = any_load_result1("HairLines")
local any_load_result1_result1_upvr_13 = any_load_result1("ValueObject")
local var1_result1_upvr = any_load_result1("PillBackingBuilder")
local any_load_result1_result1_upvr_4 = any_load_result1("ButtonHighlightModel")
local any_load_result1_result1_upvr_5 = any_load_result1("FunctionUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogButtonUtils")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 32
	--[[ Upvalues[15]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: any_load_result1_result1_upvr_11 (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: any_load_result1_result1_upvr_12 (readonly)
		[6]: any_load_result1_result1_upvr_10 (readonly)
		[7]: any_load_result1_result1_upvr_8 (readonly)
		[8]: any_load_result1_result1_upvr_3 (readonly)
		[9]: UserInputService_upvr (readonly)
		[10]: any_load_result1_result1_upvr_9 (readonly)
		[11]: any_load_result1_result1_upvr_13 (readonly)
		[12]: var1_result1_upvr (readonly)
		[13]: any_load_result1_result1_upvr_4 (readonly)
		[14]: any_load_result1_result1_upvr_5 (readonly)
		[15]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_6.new(arg1:GetService(any_load_result1_result1_upvr_11):Clone("DialogChoiceGridButtonTemplate")), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._guiThemeService = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr_2)
	setmetatable_result1_upvr_2.Selected = any_load_result1_result1_upvr_12.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Selected)
	setmetatable_result1_upvr_2.Gui = setmetatable_result1_upvr_2._obj
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._obj)
	setmetatable_result1_upvr_2._container = setmetatable_result1_upvr_2.Gui.Container
	setmetatable_result1_upvr_2._insideContainer = setmetatable_result1_upvr_2._container.InsideContainer
	setmetatable_result1_upvr_2._uiScale = setmetatable_result1_upvr_2._container.UIScale
	setmetatable_result1_upvr_2._accentColor = any_load_result1_result1_upvr_10.DEFAULT_ACCENT_COLOR
	setmetatable_result1_upvr_2._color = any_load_result1_result1_upvr_10.DEFAULT_ACCENT_COLOR
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr_8.overrideWithBlank(setmetatable_result1_upvr_2._obj))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Gui.Activated:Connect(function() -- Line 54
		--[[ Upvalues[4]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: any_load_result1_result1_upvr_3 (copied, readonly)
			[3]: UserInputService_upvr (copied, readonly)
			[4]: any_load_result1_result1_upvr_9 (copied, readonly)
		]]
		if setmetatable_result1_upvr_2._model:IsInteractionEnabled() then
			any_load_result1_result1_upvr_3.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.75)
			setmetatable_result1_upvr_2.Selected:Fire()
			local any_new_result1_upvr = any_load_result1_result1_upvr_9.new(setmetatable_result1_upvr_2._serviceBag, 0, 300, 6)
			any_new_result1_upvr:SetColor(setmetatable_result1_upvr_2._color)
			any_new_result1_upvr.Gui.Parent = setmetatable_result1_upvr_2.Gui
			any_new_result1_upvr:Play(function() -- Line 63
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (readonly)
				]]
				any_new_result1_upvr:Destroy()
			end)
		end
	end))
	setmetatable_result1_upvr_2._originalOutlineColor = setmetatable_result1_upvr_2._container.BackgroundColor3
	setmetatable_result1_upvr_2._borderColor = any_load_result1_result1_upvr_13.fromObservable(setmetatable_result1_upvr_2._guiThemeService:ObserveColor("surface", "border"))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._borderColor)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._borderColor.Changed:Connect(function() -- Line 73
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._model:StartAnimation()
	end))
	setmetatable_result1_upvr_2._successBorderColor = any_load_result1_result1_upvr_13.fromObservable(setmetatable_result1_upvr_2._guiThemeService:ObserveColor("success", "border"))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._successBorderColor)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._successBorderColor.Changed:Connect(function() -- Line 79
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._model:StartAnimation()
	end))
	setmetatable_result1_upvr_2._circle = var1_result1_upvr.new():CreateCircle(setmetatable_result1_upvr_2._container)
	setmetatable_result1_upvr_2._insideCircle = var1_result1_upvr.new():CreateCircle(setmetatable_result1_upvr_2._insideContainer)
	setmetatable_result1_upvr_2._uiGradient = Instance.new("UIGradient")
	setmetatable_result1_upvr_2._uiGradient.Parent = setmetatable_result1_upvr_2._insideCircle
	setmetatable_result1_upvr_2:_setChoice(arg2)
	setmetatable_result1_upvr_2._model = any_load_result1_result1_upvr_4.new(setmetatable_result1_upvr_2._obj, any_load_result1_result1_upvr_5.bind(setmetatable_result1_upvr_2, setmetatable_result1_upvr_2._update))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._model)
	setmetatable_result1_upvr_2._maid:GiveTask(any_load_result1_result1_upvr.setupFeedback(setmetatable_result1_upvr_2._serviceBag, setmetatable_result1_upvr_2._model))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetIsChoosen(arg1, arg2) -- Line 99
	arg1._model:SetIsChoosen(arg2)
end
function setmetatable_result1_upvr.SetInteractionEnabled(arg1, arg2) -- Line 103
	arg1._model:SetInteractionEnabled(arg2)
end
function setmetatable_result1_upvr.SetAccentColor(arg1, arg2) -- Line 107
	arg1._accentColor = arg2
	arg1._model:StartAnimation()
end
local GuiService_upvr = game:GetService("GuiService")
function setmetatable_result1_upvr.SetSelectable(arg1, arg2) -- Line 112
	--[[ Upvalues[1]:
		[1]: GuiService_upvr (readonly)
	]]
	arg1._obj.Selectable = arg2
	if not arg2 and GuiService_upvr.SelectedObject == arg1._obj then
		GuiService_upvr.SelectedObject = nil
	end
end
local any_load_result1_result1_upvr_7 = any_load_result1("DialogChoiceTypes")
function setmetatable_result1_upvr._setChoice(arg1, arg2) -- Line 122
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
	]]
	if arg2.type == any_load_result1_result1_upvr_7.DIALOG_COLOR_CHOICE then
		arg1:SetColor(arg2.color)
	else
		error("Bad choice")
	end
end
local any_load_result1_result1_upvr_2 = any_load_result1("ColorSequenceUtils")
function setmetatable_result1_upvr.SetColor(arg1, arg2) -- Line 130
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg1._color = arg2
	arg1._insideCircle.ImageColor3 = Color3.new(1, 1, 1)
	local Color3_toHSV_result1_3, Color3_toHSV_result2_4, Color3_toHSV_result3 = Color3.toHSV(arg2)
	local var29
	local var30
	if Color3_toHSV_result3 <= 0.5 then
		var29 = Color3.fromHSV(Color3_toHSV_result1_3, Color3_toHSV_result2_4, Color3_toHSV_result3 + 0.075)
		var30 = arg2
	else
		var29 = Color3.fromHSV(Color3_toHSV_result1_3, Color3_toHSV_result2_4, Color3_toHSV_result3 - 0.075)
		var30 = arg2
	end
	arg1._uiGradient.Color = any_load_result1_result1_upvr_2.stripe(3, var29, var30, 0.5, 0.2)
end
function setmetatable_result1_upvr.SetNumber(arg1, arg2) -- Line 154
	arg1._maid._number = nil
	arg1.Gui.LayoutOrder = arg2
end
function setmetatable_result1_upvr.SetTransparency(arg1, arg2) -- Line 160
	arg1._circle.ImageTransparency = arg2
	arg1._insideCircle.ImageTransparency = arg2
end
function setmetatable_result1_upvr._update(arg1, arg2, arg3, arg4) -- Line 165
	local p_4 = arg2.p
	local p_2 = arg3.p
	arg1._uiScale.Scale = 0.9 + p_4 * 0.1 + p_2 * 0.1 - arg4.p * 0.1
	local any_Lerp_result1 = arg1._borderColor.Value:Lerp(arg1._accentColor, p_4)
	if 0 < p_2 then
		local Color3_toHSV_result1_2, Color3_toHSV_result2, Color3_toHSV_result3_2 = Color3.toHSV(arg1._successBorderColor.Value)
		any_Lerp_result1 = any_Lerp_result1:Lerp(Color3.fromHSV(Color3_toHSV_result1_2, math.clamp(Color3_toHSV_result2 * 2, 0, 1), math.clamp(Color3_toHSV_result3_2 + math.sin(tick() * math.pi * 2 / 0.75) * 0.05, 0, 1)), p_2)
	end
	arg1._circle.ImageColor3 = any_Lerp_result1
	arg1._uiGradient.Rotation = 30 + p_4 * 15 + 15 * p_2
	local var51 = true
	if 0 >= arg2.rtime then
		var51 = true
		if 0 >= arg3.t then
			var51 = true
			if 0 >= arg3.rtime then
				if 0 >= arg4.rtime then
					var51 = false
				else
					var51 = true
				end
			end
		end
	end
	return var51
end
return setmetatable_result1_upvr