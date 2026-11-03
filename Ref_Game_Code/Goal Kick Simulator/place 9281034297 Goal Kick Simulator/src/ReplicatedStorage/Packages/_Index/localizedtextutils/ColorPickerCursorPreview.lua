-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:03
-- Luau version 6, Types version 3
-- Time taken: 0.008048 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_4 = any_load_result1("BasicPane")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_4)
setmetatable_result1_upvr_2.ClassName = "ColorPickerCursorPreview"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new() -- Line 19
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_4.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._backgroundColorHint = Instance.new("Color3Value")
	setmetatable_result1_upvr._backgroundColorHint.Value = Color3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._backgroundColorHint)
	setmetatable_result1_upvr._heightAbs = Instance.new("NumberValue")
	setmetatable_result1_upvr._heightAbs.Value = 60
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._heightAbs)
	setmetatable_result1_upvr._offsetAbs = Instance.new("NumberValue")
	setmetatable_result1_upvr._offsetAbs.Value = -20
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._offsetAbs)
	setmetatable_result1_upvr._position = Instance.new("Vector3Value")
	setmetatable_result1_upvr._position.Value = Vector3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._position)
	setmetatable_result1_upvr._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr._transparency.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._transparency)
	setmetatable_result1_upvr._colorValue = Instance.new("Color3Value")
	setmetatable_result1_upvr._colorValue.Value = Color3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._colorValue)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1) -- Line 46
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1
	end))
	setmetatable_result1_upvr.PositionChanged = assert(setmetatable_result1_upvr._position.Changed, "No .Changed event")
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.HintBackgroundColor(arg1, arg2) -- Line 55
	local var6
	if typeof(arg2) ~= "Color3" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad color")
	arg1._backgroundColorHint.Value = arg2
end
function setmetatable_result1_upvr_2.SetPosition(arg1, arg2) -- Line 61
	arg1._position.Value = arg2
end
function setmetatable_result1_upvr_2.GetPosition(arg1) -- Line 65
	return arg1._position.Value
end
function setmetatable_result1_upvr_2.SetColor(arg1, arg2) -- Line 69
	local var7
	if typeof(arg2) ~= "Color3" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad color")
	arg1._colorValue.Value = arg2
end
local function SetTransparency(arg1, arg2) -- Line 75
	local var8
	if type(arg2) ~= "number" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad transparency")
	arg1._transparency.Value = arg2
end
setmetatable_result1_upvr_2.SetTransparency = SetTransparency
local var1_result1_upvr_2 = any_load_result1("Blend")
local var1_result1_upvr = any_load_result1("BasicPaneUtils")
local var1_result1_upvr_6 = any_load_result1("Math")
local var1_result1_upvr_3 = any_load_result1("LuvColor3Utils")
local var1_result1_upvr_5 = any_load_result1("ColorPickerUtils")
function setmetatable_result1_upvr_2._render(arg1) -- Line 81
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_6 (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
	]]
	local any_Spring_result1_2 = var1_result1_upvr_2.Spring(var1_result1_upvr.observePercentVisible(arg1), 30, 0.5)
	local any_Spring_result1 = var1_result1_upvr_2.Spring(var1_result1_upvr_2.Computed(var1_result1_upvr.observePercentVisible(arg1), arg1._transparency, function(arg1_2, arg2) -- Line 83
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_6 (copied, readonly)
		]]
		return var1_result1_upvr_6.map(arg1_2, 0, 1, 1, arg2)
	end), 30)
	return var1_result1_upvr_2.New("Frame")({
		Name = "Preview";
		BackgroundTransparency = 1;
		Size = var1_result1_upvr_2.Computed(arg1._heightAbs, function(arg1_4) -- Line 97
			return UDim2.fromOffset(arg1_4, arg1_4)
		end);
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = var1_result1_upvr_2.Computed(arg1._position, arg1._offsetAbs, arg1._heightAbs, function(arg1_5, arg2, arg3) -- Line 101
			return UDim2.new(arg1_5.x, 0, arg1_5.y, arg2 - arg3 / 2)
		end);
		ZIndex = 3;
		[var1_result1_upvr_2.Children] = {var1_result1_upvr_2.New("UIAspectRatioConstraint")({
			AspectRatio = 1;
		}), var1_result1_upvr_2.New("Frame")({
			BackgroundTransparency = any_Spring_result1;
			BackgroundColor3 = arg1._colorValue;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(1, 1);
			[var1_result1_upvr_2.Children] = {var1_result1_upvr_2.New("UIScale")({
				Scale = any_Spring_result1_2;
			}), var1_result1_upvr_2.New("UICorner")({
				CornerRadius = UDim.new(1, 0);
			}), var1_result1_upvr_2.New("UIStroke")({
				Color = var1_result1_upvr_2.Spring(var1_result1_upvr_2.Computed(arg1._colorValue, arg1._backgroundColorHint, var1_result1_upvr_2.Computed(arg1._colorValue, arg1._backgroundColorHint, function(arg1_3, arg2) -- Line 87
					--[[ Upvalues[1]:
						[1]: var1_result1_upvr_3 (copied, readonly)
					]]
					local unpack_result1, _, unpack_result3 = unpack(var1_result1_upvr_3.fromColor3(arg1_3))
					local _, _, unpack_result3_2 = unpack(var1_result1_upvr_3.fromColor3(arg2))
					local var24
					if math.abs(unpack_result3_2 - unpack_result3) > 60 then
						var24 = false
					else
						var24 = true
					end
					return var24
				end), function(arg1_6, arg2, arg3) -- Line 128
					--[[ Upvalues[1]:
						[1]: var1_result1_upvr_5 (copied, readonly)
					]]
					if arg3 then
						return var1_result1_upvr_5.getOutlineWithContrast(arg1_6, arg2)
					end
					return arg1_6
				end), 20);
				Transparency = any_Spring_result1;
				Thickness = var1_result1_upvr_2.Computed(any_Spring_result1_2, function(arg1_7) -- Line 136
					return arg1_7 * 3
				end);
			})};
		})};
	})
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 146
	local var37
	if type(arg2) ~= "number" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad transparency")
	arg1._transparency.Value = arg2
end
return setmetatable_result1_upvr_2