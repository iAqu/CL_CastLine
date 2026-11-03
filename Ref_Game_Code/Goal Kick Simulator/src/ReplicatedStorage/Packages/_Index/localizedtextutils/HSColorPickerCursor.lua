-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:16
-- Luau version 6, Types version 3
-- Time taken: 0.006194 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "HSColorPickerCursor"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new() -- Line 17
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_2.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._backgroundColorHint = Instance.new("Color3Value")
	setmetatable_result1_upvr._backgroundColorHint.Value = Color3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._backgroundColorHint)
	setmetatable_result1_upvr._height = Instance.new("NumberValue")
	setmetatable_result1_upvr._height.Value = 0.075
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._height)
	setmetatable_result1_upvr._crossHairWidthAbs = Instance.new("NumberValue")
	setmetatable_result1_upvr._crossHairWidthAbs.Value = 1
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._crossHairWidthAbs)
	setmetatable_result1_upvr._verticalHairVisible = Instance.new("BoolValue")
	setmetatable_result1_upvr._verticalHairVisible.Value = true
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._verticalHairVisible)
	setmetatable_result1_upvr._horizontalHairVisible = Instance.new("BoolValue")
	setmetatable_result1_upvr._horizontalHairVisible.Value = true
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._horizontalHairVisible)
	setmetatable_result1_upvr._position = Instance.new("Vector3Value")
	setmetatable_result1_upvr._position.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._position)
	setmetatable_result1_upvr._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr._transparency.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._transparency)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1) -- Line 48
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1
	end))
	setmetatable_result1_upvr.PositionChanged = assert(setmetatable_result1_upvr._position.Changed, "No .Changed event")
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.HintBackgroundColor(arg1, arg2) -- Line 62
	local var6
	if typeof(arg2) ~= "Color3" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad color")
	arg1._backgroundColorHint.Value = arg2
end
function setmetatable_result1_upvr_2.SetVerticalHairVisible(arg1, arg2) -- Line 68
	arg1._verticalHairVisible.Value = arg2
end
function setmetatable_result1_upvr_2.SetHorizontalHairVisible(arg1, arg2) -- Line 72
	arg1._horizontalHairVisible.Value = arg2
end
function setmetatable_result1_upvr_2.SetHeight(arg1, arg2) -- Line 81
	arg1._height.Value = arg2
end
function setmetatable_result1_upvr_2.SetPosition(arg1, arg2) -- Line 90
	arg1._position.Value = arg2
end
function setmetatable_result1_upvr_2.GetPosition(arg1) -- Line 99
	return arg1._position.Value
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 108
	local var7
	if type(arg2) ~= "number" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad transparency")
	arg1._transparency.Value = arg2
end
local any_load_result1_result1_upvr_3 = any_load_result1("Blend")
local any_load_result1_result1_upvr = any_load_result1("ColorPickerUtils")
function setmetatable_result1_upvr_2._render(arg1) -- Line 114
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr_3.New("Frame")({
		Name = "HSColorPickerCursor";
		Size = any_load_result1_result1_upvr_3.Computed(arg1._height, function(arg1_2) -- Line 117
			return UDim2.fromScale(arg1_2, arg1_2)
		end);
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = any_load_result1_result1_upvr_3.Computed(arg1._position, function(arg1_3) -- Line 122
			return UDim2.fromScale(arg1_3.x, arg1_3.y)
		end);
		[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UIAspectRatioConstraint")({
			AspectRatio = 1;
		}), any_load_result1_result1_upvr_3.New("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Visible = arg1._horizontalHairVisible;
			Size = any_load_result1_result1_upvr_3.Computed(arg1._crossHairWidthAbs, function(arg1_4) -- Line 135
				return UDim2.new(1, 0, 0, arg1_4)
			end);
			BackgroundColor3 = any_load_result1_result1_upvr_3.Computed(arg1._backgroundColorHint, function(arg1_5) -- Line 138
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr (copied, readonly)
				]]
				return any_load_result1_result1_upvr.getOutlineWithContrast(Color3.new(0, 0, 0), arg1_5)
			end);
			BackgroundTransparency = arg1._transparency;
			[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UICorner")({
				CornerRadius = UDim.new(1, 0);
			})};
		}), any_load_result1_result1_upvr_3.New("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Visible = arg1._verticalHairVisible;
			Size = any_load_result1_result1_upvr_3.Computed(arg1._crossHairWidthAbs, function(arg1_6) -- Line 154
				return UDim2.new(0, arg1_6, 1, 0)
			end);
			BackgroundColor3 = any_load_result1_result1_upvr_3.Spring(any_load_result1_result1_upvr_3.Computed(arg1._backgroundColorHint, function(arg1_7) -- Line 157
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr (copied, readonly)
				]]
				return any_load_result1_result1_upvr.getOutlineWithContrast(Color3.new(0, 0, 0), arg1_7)
			end), 20);
			BackgroundTransparency = arg1._transparency;
			[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UICorner")({
				CornerRadius = UDim.new(1, 0);
			})};
		})};
	})
end
return setmetatable_result1_upvr_2