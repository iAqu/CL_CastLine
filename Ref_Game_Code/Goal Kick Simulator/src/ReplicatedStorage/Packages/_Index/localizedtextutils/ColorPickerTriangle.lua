-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:46
-- Luau version 6, Types version 3
-- Time taken: 0.002642 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr)
setmetatable_result1_upvr_2.ClassName = "ColorPickerTriangle"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new() -- Line 15
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._transparency = Instance.new("NumberValue")
	setmetatable_result1_upvr._transparency.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._transparency)
	setmetatable_result1_upvr._backgroundColorHint = Instance.new("Color3Value")
	setmetatable_result1_upvr._backgroundColorHint.Value = Color3.new(0, 0, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._backgroundColorHint)
	setmetatable_result1_upvr._color = Instance.new("Color3Value")
	setmetatable_result1_upvr._color.Value = Color3.new(1, 1, 1)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._color)
	setmetatable_result1_upvr._sizeValue = Instance.new("Vector3Value")
	setmetatable_result1_upvr._sizeValue.Value = Vector3.new(0.05000, 0.10000, 0)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._sizeValue)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1) -- Line 34
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1
	end))
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.HintBackgroundColor(arg1, arg2) -- Line 41
	arg1._backgroundColorHint.Value = arg2
end
function setmetatable_result1_upvr_2.GetSizeValue(arg1) -- Line 45
	return arg1._sizeValue
end
function setmetatable_result1_upvr_2.SetColor(arg1, arg2) -- Line 49
	arg1._color.Value = arg2
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 53
	local var6
	if type(arg2) ~= "number" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad transparency")
	arg1._transparency.Value = arg2
end
local any_load_result1_result1_upvr_2 = any_load_result1("Blend")
local any_load_result1_result1_upvr = any_load_result1("ColorPickerUtils")
function setmetatable_result1_upvr_2._render(arg1) -- Line 59
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr_2.New("Frame")({
		Name = "ColorPickerTriangle";
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 1;
		[any_load_result1_result1_upvr_2.Children] = {any_load_result1_result1_upvr_2.New("ImageLabel")({
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 1, 0);
			ImageColor3 = any_load_result1_result1_upvr_2.Computed(arg1._color, arg1._backgroundColorHint, function(arg1_2, arg2) -- Line 68
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr (copied, readonly)
				]]
				return any_load_result1_result1_upvr.getOutlineWithContrast(arg1_2, arg2)
			end);
			ImageTransparency = arg1._transparency;
			Image = "rbxassetid://9291514809";
		}), any_load_result1_result1_upvr_2.New("UIAspectRatioConstraint")({
			AspectRatio = any_load_result1_result1_upvr_2.Computed(arg1._sizeValue, function(arg1_3) -- Line 75
				if arg1_3.x == 0 or arg1_3.y == 0 then
					return 1
				end
				return arg1_3.x / arg1_3.y
			end);
		})};
	})
end
return setmetatable_result1_upvr_2