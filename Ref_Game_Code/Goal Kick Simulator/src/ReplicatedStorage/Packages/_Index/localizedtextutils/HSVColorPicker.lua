-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:15
-- Luau version 6, Types version 3
-- Time taken: 0.008742 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "HSVColorPicker"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("HSColorPicker")
local any_load_result1_result1_upvr_3 = any_load_result1("ValueColorPicker")
function setmetatable_result1_upvr.new() -- Line 31
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._hsvColorValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._hsvColorValue.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue)
	setmetatable_result1_upvr_2.ColorChanged = setmetatable_result1_upvr_2._hsvColorValue.Changed
	setmetatable_result1_upvr_2._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr_2._sizeValue.Value = Vector3.new(6, 4, 0)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._sizeValue)
	setmetatable_result1_upvr_2._innerPadding = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._innerPadding.Value = 0.2
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._innerPadding)
	setmetatable_result1_upvr_2._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr_2._transparency.Value = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency)
	setmetatable_result1_upvr_2._hueSaturationPicker = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hueSaturationPicker)
	setmetatable_result1_upvr_2._valuePicker = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._valuePicker)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2:_render():Subscribe(function(arg1) -- Line 58
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2.Gui = arg1
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._transparency.Changed:Connect(function() -- Line 63
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._hueSaturationPicker:SetTransparency(setmetatable_result1_upvr_2._transparency.Value)
		setmetatable_result1_upvr_2._valuePicker:SetTransparency(setmetatable_result1_upvr_2._transparency.Value)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hsvColorValue.Changed:Connect(function() -- Line 69
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._hueSaturationPicker:SetHSVColor(setmetatable_result1_upvr_2._hsvColorValue.Value)
		setmetatable_result1_upvr_2._valuePicker:SetHSVColor(setmetatable_result1_upvr_2._hsvColorValue.Value)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hueSaturationPicker.ColorChanged:Connect(function() -- Line 73
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._hsvColorValue.Value = setmetatable_result1_upvr_2._hueSaturationPicker:GetHSVColor()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._valuePicker.ColorChanged:Connect(function() -- Line 76
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._hsvColorValue.Value = setmetatable_result1_upvr_2._valuePicker:GetHSVColor()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._hueSaturationPicker:GetSizeValue().Changed:Connect(function() -- Line 81
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateSize()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._valuePicker:GetSizeValue().Changed:Connect(function() -- Line 84
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateSize()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._innerPadding.Changed:Connect(function() -- Line 87
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateSize()
	end))
	setmetatable_result1_upvr_2:_updateSize()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetSize(arg1, arg2) -- Line 101
	local var15
	if type(arg2) ~= "number" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad height")
	arg1._hueSaturationPicker:SetSize(arg2)
	arg1._valuePicker:SetSize(arg2)
end
local var1_result1_upvr_2 = any_load_result1("Maid")
function setmetatable_result1_upvr.SyncValue(arg1, arg2) -- Line 114
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1 = var1_result1_upvr_2.new()
	arg1:SetColor(arg2.Value)
	any_new_result1:GiveTask(arg1.ColorChanged:Connect(function() -- Line 119
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: arg1 (readonly)
		]]
		arg2.Value = arg1:GetColor()
	end))
	any_new_result1:GiveTask(arg2.Changed:Connect(function() -- Line 123
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: arg1 (readonly)
		]]
		local Value_3 = arg2.Value
		if Value_3 ~= arg1:GetColor() then
			local Color3_toHSV_result1_2, Color3_toHSV_result2_2, Color3_toHSV_result3_2 = Color3.toHSV(Value_3)
			arg1._hsvColorValue.Value = Vector3.new(Color3_toHSV_result1_2, Color3_toHSV_result2_2, Color3_toHSV_result3_2)
		end
	end))
	return any_new_result1
end
function setmetatable_result1_upvr.HintBackgroundColor(arg1, arg2) -- Line 143
	arg1._valuePicker:HintBackgroundColor(arg2)
end
function setmetatable_result1_upvr.SetHSVColor(arg1, arg2) -- Line 152
	local var24
	if typeof(arg2) ~= "Vector3" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad hsvColor")
	arg1._hsvColorValue.Value = arg2
end
function setmetatable_result1_upvr.GetHSVColor(arg1) -- Line 163
	return arg1._hsvColorValue.Value
end
function setmetatable_result1_upvr.SetColor(arg1, arg2) -- Line 172
	local Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3 = Color3.toHSV(arg2)
	arg1._hsvColorValue.Value = Vector3.new(Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3)
end
function setmetatable_result1_upvr.GetColor(arg1) -- Line 182
	local Value_2 = arg1._hsvColorValue.Value
	return Color3.fromHSV(Value_2.x, Value_2.y, Value_2.z)
end
function setmetatable_result1_upvr.GetSizeValue(arg1) -- Line 192
	return arg1._sizeValue
end
function setmetatable_result1_upvr.SetTransparency(arg1, arg2) -- Line 201
	local var29
	if type(arg2) ~= "number" then
		var29 = false
	else
		var29 = true
	end
	assert(var29, "Bad transparency")
	arg1._transparency.Value = arg2
end
function setmetatable_result1_upvr._updateSize(arg1) -- Line 207
	local Value_4 = arg1._valuePicker:GetSizeValue().Value
	local Value = arg1._hueSaturationPicker:GetSizeValue().Value
	arg1._sizeValue.Value = Vector3.new(Value_4.x + Value.x + arg1._innerPadding.Value, math.max(Value_4.y, Value.y))
end
local any_load_result1_result1_upvr = any_load_result1("Blend")
function setmetatable_result1_upvr._render(arg1) -- Line 217
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local function container(arg1_2, arg2) -- Line 218
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.New("Frame")({
			AnchorPoint = arg2.AnchorPoint;
			Position = arg2.Position;
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 1, 0);
			ZIndex = any_load_result1_result1_upvr.Computed(arg1_2:GetIsPressedValue(), function(arg1_3) -- Line 224
				if arg1_3 then
					return 2
				end
				return 1
			end);
			[any_load_result1_result1_upvr.Children] = {arg1_2.Gui, any_load_result1_result1_upvr.New("UIAspectRatioConstraint")({
				AspectRatio = any_load_result1_result1_upvr.Computed(arg1_2:GetSizeValue(), function(arg1_4) -- Line 230
					if arg1_4.x == 0 or arg1_4.y == 0 then
						return 1
					end
					return arg1_4.x / arg1_4.y
				end);
			})};
		})
	end
	return any_load_result1_result1_upvr.New("Frame")({
		Name = "HSVColorPicker";
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 1;
		[any_load_result1_result1_upvr.Children] = {any_load_result1_result1_upvr.New("UIAspectRatioConstraint")({
			AspectRatio = any_load_result1_result1_upvr.Computed(arg1._sizeValue, function(arg1_5) -- Line 248
				if arg1_5.x == 0 or arg1_5.y == 0 then
					return 1
				end
				return arg1_5.x / arg1_5.y
			end);
		}), container(arg1._hueSaturationPicker, {
			AnchorPoint = Vector2.new(0, 0);
			Position = UDim2.fromScale(0, 0);
		}), container(arg1._valuePicker, {
			AnchorPoint = Vector2.new(1, 0);
			Position = UDim2.fromScale(1, 0);
		})};
	})
end
return setmetatable_result1_upvr