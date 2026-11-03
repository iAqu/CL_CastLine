-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:09
-- Luau version 6, Types version 3
-- Time taken: 0.009041 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "ValueColorPicker"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("ColorPickerInput")
local any_load_result1_result1_upvr_3 = any_load_result1("ColorPickerTriangle")
local any_load_result1_result1_upvr = any_load_result1("ColorPickerCursorPreview")
function setmetatable_result1_upvr.new() -- Line 19
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._hsvColorValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._hsvColorValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue)
	setmetatable_result1_upvr_2._backgroundColorHint = Instance.new("Color3Value")
	setmetatable_result1_upvr_2._backgroundColorHint.Value = Color3.new(0, 0, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._backgroundColorHint)
	setmetatable_result1_upvr_2.ColorChanged = setmetatable_result1_upvr_2._hsvColorValue.Changed
	setmetatable_result1_upvr_2._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._sizeValue.Value = Vector3.new(0, 4, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._sizeValue)
	setmetatable_result1_upvr_2._leftWidth = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._leftWidth.Value = 0.25
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._leftWidth)
	setmetatable_result1_upvr_2._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._transparency.Value = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency)
	setmetatable_result1_upvr_2._input = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input)
	setmetatable_result1_upvr_2._triangle = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr_2._triangle.Gui.AnchorPoint = Vector2.new(0, 0.5)
	setmetatable_result1_upvr_2._triangle.Gui.Position = UDim2.fromScale(0, 1)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._triangle)
	setmetatable_result1_upvr_2._preview = any_load_result1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._preview)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2:_render():Subscribe(function(arg1) -- Line 61
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2.Gui = arg1
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency.Changed:Connect(function() -- Line 65
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		local Value_4 = setmetatable_result1_upvr_2._transparency.Value
		setmetatable_result1_upvr_2._preview:SetTransparency(Value_4)
		setmetatable_result1_upvr_2._triangle:SetTransparency(Value_4)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input.PositionChanged:Connect(function() -- Line 73
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		local any_GetPosition_result1 = setmetatable_result1_upvr_2._input:GetPosition()
		local Value_3 = setmetatable_result1_upvr_2._hsvColorValue.Value
		setmetatable_result1_upvr_2._hsvColorValue.Value = Vector3.new(Value_3.x, Value_3.y, 1 - any_GetPosition_result1.y)
		setmetatable_result1_upvr_2._triangle.Gui.Position = UDim2.fromScale(0, any_GetPosition_result1.y)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 81
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._triangle.Gui.Position = UDim2.fromScale(0, 1 - setmetatable_result1_upvr_2._hsvColorValue.Value.z)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._input.IsPressedChanged:Connect(function() -- Line 88
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._preview:SetVisible(setmetatable_result1_upvr_2._input:GetIsPressed())
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 91
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updatePreviewPosition()
	end))
	setmetatable_result1_upvr_2:_updatePreviewPosition()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 95
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateHintedColors()
	end))
	setmetatable_result1_upvr_2:_updateHintedColors()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._backgroundColorHint.Changed:Connect(function() -- Line 101
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._triangle:HintBackgroundColor(setmetatable_result1_upvr_2._backgroundColorHint.Value)
	end))
	setmetatable_result1_upvr_2._triangle:HintBackgroundColor(setmetatable_result1_upvr_2._backgroundColorHint.Value)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._triangle:GetSizeValue().Changed:Connect(function() -- Line 107
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateSize()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._leftWidth.Changed:Connect(function() -- Line 110
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateSize()
	end))
	setmetatable_result1_upvr_2:_updateSize()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetSize(arg1, arg2) -- Line 119
	local var21
	if type(arg2) ~= "number" then
		var21 = false
	else
		var21 = true
	end
	assert(var21, "Bad height")
	arg1:_updateSize(arg2)
end
function setmetatable_result1_upvr.HintBackgroundColor(arg1, arg2) -- Line 125
	arg1._backgroundColorHint.Value = arg2
end
function setmetatable_result1_upvr._updatePreviewPosition(arg1) -- Line 129
	arg1._preview:SetPosition(Vector3.new(0.5, 1 - arg1._hsvColorValue.Value.z))
end
function setmetatable_result1_upvr._updateSize(arg1, arg2) -- Line 133
	local var22 = arg2
	if not var22 then
		var22 = arg1._sizeValue.Value.y
	end
	arg1._sizeValue.Value = Vector3.new(arg1._leftWidth.Value + arg1._triangle:GetSizeValue().Value.y, var22, 0)
end
function setmetatable_result1_upvr._updateHintedColors(arg1) -- Line 141
	local Value_2 = arg1._hsvColorValue.Value
	local Color3_fromHSV_result1 = Color3.fromHSV(Value_2.x, Value_2.y, Value_2.z)
	arg1._preview:HintBackgroundColor(Color3_fromHSV_result1)
	arg1._preview:SetColor(Color3_fromHSV_result1)
end
function setmetatable_result1_upvr.GetIsPressedValue(arg1) -- Line 151
	return arg1._input:GetIsPressedValue()
end
function setmetatable_result1_upvr.SetHSVColor(arg1, arg2) -- Line 155
	local var25
	if typeof(arg2) ~= "Vector3" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad hsvColor")
	arg1._hsvColorValue.Value = arg2
end
function setmetatable_result1_upvr.GetHSVColor(arg1) -- Line 161
	return arg1._hsvColorValue.Value
end
function setmetatable_result1_upvr.SetColor(arg1, arg2) -- Line 165
	local Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3 = Color3.toHSV(arg2)
	arg1._hsvColorValue.Value = Vector3.new(Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3)
end
function setmetatable_result1_upvr.GetColor(arg1) -- Line 170
	local Value = arg1._hsvColorValue.Value
	return Color3.fromHSV(Value.x, Value.y, Value.z)
end
function setmetatable_result1_upvr.GetSizeValue(arg1) -- Line 176
	return arg1._sizeValue
end
function setmetatable_result1_upvr.SetTransparency(arg1, arg2) -- Line 180
	local var30
	if type(arg2) ~= "number" then
		var30 = false
	else
		var30 = true
	end
	assert(var30, "Bad transparency")
	arg1._transparency.Value = arg2
end
local any_load_result1_result1_upvr_4 = any_load_result1("Blend")
function setmetatable_result1_upvr._render(arg1) -- Line 186
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return any_load_result1_result1_upvr_4.New("ImageButton")({
		Name = "HSColorPicker";
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 1;
		Active = true;
		[any_load_result1_result1_upvr_4.Instance] = function(arg1_2) -- Line 192
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._input:SetButton(arg1_2)
		end;
		[any_load_result1_result1_upvr_4.Children] = {any_load_result1_result1_upvr_4.New("UIAspectRatioConstraint")({
			AspectRatio = any_load_result1_result1_upvr_4.Computed(arg1._sizeValue, function(arg1_3) -- Line 197
				if arg1_3.x == 0 or arg1_3.y == 0 then
					return 1
				end
				return arg1_3.x / arg1_3.y
			end);
		}), any_load_result1_result1_upvr_4.New("Frame")({
			BackgroundColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = arg1._transparency;
			Size = any_load_result1_result1_upvr_4.Computed(arg1._leftWidth, arg1._sizeValue, function(arg1_4, arg2) -- Line 209
				if arg2.x == 0 then
					return UDim2.new(0, 0, 1, 0)
				end
				return UDim2.new(arg1_4 / arg2.x, 0, 1, 0)
			end);
			[any_load_result1_result1_upvr_4.Children] = {any_load_result1_result1_upvr_4.New("UIGradient")({
				Color = any_load_result1_result1_upvr_4.Computed(arg1._hsvColorValue, function(arg1_5) -- Line 218
					local x = arg1_5.x
					local y = arg1_5.y
					return ColorSequence.new(Color3.fromHSV(x, y, 0), Color3.fromHSV(x, y, 1))
				end);
				Rotation = -90;
			}), any_load_result1_result1_upvr_4.New("UICorner")({
				CornerRadius = UDim.new(0, 4);
			}), arg1._preview.Gui};
		}), any_load_result1_result1_upvr_4.New("Frame")({
			BackgroundTransparency = 1;
			Position = UDim2.fromScale(1, 0);
			AnchorPoint = Vector2.new(1, 0);
			Size = any_load_result1_result1_upvr_4.Computed(arg1._leftWidth, arg1._sizeValue, function(arg1_6, arg2) -- Line 239
				if arg2.x == 0 then
					return UDim2.new(0, 0, 1, 0)
				end
				return UDim2.new((arg2.x - arg1_6) / arg2.x, 0, 1, 0)
			end);
			[any_load_result1_result1_upvr_4.Children] = {arg1._triangle.Gui};
		})};
	})
end
return setmetatable_result1_upvr