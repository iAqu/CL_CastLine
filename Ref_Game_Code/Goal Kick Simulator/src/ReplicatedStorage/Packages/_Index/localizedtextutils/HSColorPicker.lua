-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:05
-- Luau version 6, Types version 3
-- Time taken: 0.008212 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "HSColorPicker"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("ColorPickerInput")
local var1_result1_upvr_4 = any_load_result1("HSColorPickerCursor")
local var1_result1_upvr_2 = any_load_result1("ColorPickerCursorPreview")
function setmetatable_result1_upvr.new() -- Line 20
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
		[5]: var1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._hsvColorValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._hsvColorValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue)
	setmetatable_result1_upvr_2.ColorChanged = setmetatable_result1_upvr_2._hsvColorValue.Changed
	setmetatable_result1_upvr_2._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._sizeValue.Value = Vector3.new(4, 4, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._sizeValue)
	setmetatable_result1_upvr_2._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._transparency.Value = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency)
	setmetatable_result1_upvr_2._input = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input)
	setmetatable_result1_upvr_2._cursor = var1_result1_upvr_4.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._cursor)
	setmetatable_result1_upvr_2._preview = var1_result1_upvr_2.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._preview)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2:_render():Subscribe(function(arg1) -- Line 46
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2.Gui = arg1
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency.Changed:Connect(function() -- Line 50
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._cursor:SetTransparency(setmetatable_result1_upvr_2._transparency.Value)
		setmetatable_result1_upvr_2._preview:SetTransparency(setmetatable_result1_upvr_2._transparency.Value)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input.PositionChanged:Connect(function() -- Line 56
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		local any_GetPosition_result1 = setmetatable_result1_upvr_2._input:GetPosition()
		setmetatable_result1_upvr_2._hsvColorValue.Value = Vector3.new(1 - any_GetPosition_result1.x, 1 - any_GetPosition_result1.y, setmetatable_result1_upvr_2._hsvColorValue.Value.z)
		setmetatable_result1_upvr_2._cursor:SetPosition(any_GetPosition_result1)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 63
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		local Value = setmetatable_result1_upvr_2._hsvColorValue.Value
		setmetatable_result1_upvr_2._cursor:SetPosition(Vector3.new(1 - Value.x, 1 - Value.y, 0))
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input.IsPressedChanged:Connect(function() -- Line 70
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._preview:SetVisible(setmetatable_result1_upvr_2._input:GetIsPressed())
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._cursor.PositionChanged:Connect(function() -- Line 73
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._preview:SetPosition(setmetatable_result1_upvr_2._cursor:GetPosition())
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 76
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateHintedColors()
	end))
	setmetatable_result1_upvr_2:_updateHintedColors()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.GetIsPressedValue(arg1) -- Line 89
	return arg1._input:GetIsPressedValue()
end
function setmetatable_result1_upvr._updateHintedColors(arg1) -- Line 93
	local Color3_fromHSV_result1 = Color3.fromHSV(1 - arg1._cursor:GetPosition().x, arg1._hsvColorValue.Value.y, 0.95)
	arg1._cursor:HintBackgroundColor(Color3_fromHSV_result1)
	arg1._preview:HintBackgroundColor(Color3_fromHSV_result1)
	arg1._preview:SetColor(Color3_fromHSV_result1)
end
function setmetatable_result1_upvr.SetHSVColor(arg1, arg2) -- Line 108
	local var18
	if typeof(arg2) ~= "Vector3" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad hsvColor")
	arg1._hsvColorValue.Value = arg2
end
function setmetatable_result1_upvr.GetHSVColor(arg1) -- Line 118
	return arg1._hsvColorValue.Value
end
function setmetatable_result1_upvr.SetColor(arg1, arg2) -- Line 127
	local Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3 = Color3.toHSV(arg2)
	arg1._hsvColorValue.Value = Vector3.new(Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3)
end
function setmetatable_result1_upvr.GetColor(arg1) -- Line 137
	local Value_2 = arg1._hsvColorValue.Value
	return Color3.fromHSV(Value_2.x, Value_2.y, Value_2.z)
end
function setmetatable_result1_upvr.GetSizeValue(arg1) -- Line 148
	return arg1._sizeValue
end
function setmetatable_result1_upvr.SetTransparency(arg1, arg2) -- Line 157
	local var23
	if type(arg2) ~= "number" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad transparency")
	arg1._transparency.Value = arg2
end
function setmetatable_result1_upvr.SetSize(arg1, arg2) -- Line 168
	local var24
	if type(arg2) ~= "number" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad height")
	var24 = Vector3.new(arg2, arg2, 0)
	arg1._sizeValue.Value = var24
end
local var1_result1_upvr_5 = any_load_result1("Blend")
function setmetatable_result1_upvr._render(arg1) -- Line 174
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	return var1_result1_upvr_5.New("ImageButton")({
		Name = "HSColorPicker";
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 1;
		Active = true;
		Image = "rbxassetid://9290917908";
		ImageTransparency = arg1._transparency;
		[var1_result1_upvr_5.Instance] = function(arg1_2) -- Line 182
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._input:SetButton(arg1_2)
		end;
		[var1_result1_upvr_5.Children] = {var1_result1_upvr_5.New("UIAspectRatioConstraint")({
			AspectRatio = var1_result1_upvr_5.Computed(arg1._sizeValue, function(arg1_3) -- Line 187
				if arg1_3.x == 0 or arg1_3.y == 0 then
					return 1
				end
				return arg1_3.x / arg1_3.y
			end);
		}), var1_result1_upvr_5.New("UICorner")({
			CornerRadius = UDim.new(0, 4);
		}), arg1._preview.Gui, arg1._cursor.Gui};
	})
end
return setmetatable_result1_upvr