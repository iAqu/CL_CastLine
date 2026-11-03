-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:35
-- Luau version 6, Types version 3
-- Time taken: 0.003535 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "ReticleHair"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local var1_result1_upvr = any_load_result1("PillBackingBuilder")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 21
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr:_render():Subscribe(function(arg1_2) -- Line 24
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Gui = arg1_2
	end))
	setmetatable_result1_upvr._hair = setmetatable_result1_upvr.Gui.Hair
	setmetatable_result1_upvr._pillBacking = var1_result1_upvr.new():CreateSingle(setmetatable_result1_upvr._hair)
	setmetatable_result1_upvr._lengthPercent = 0.5
	setmetatable_result1_upvr._widthPercent = setmetatable_result1_upvr._hair.Size.X.Scale * 2
	setmetatable_result1_upvr:SetRotation(arg2)
	setmetatable_result1_upvr:_updateSize()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.SetColor(arg1, arg2) -- Line 44
	arg1._pillBacking.ImageColor3 = arg2
end
function setmetatable_result1_upvr_2.SetWidth(arg1, arg2) -- Line 52
	local var7
	if type(arg2) ~= "number" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad widthPercent")
	arg1._widthPercent = arg2
	arg1:_updateSize()
end
function setmetatable_result1_upvr_2.SetRotation(arg1, arg2) -- Line 63
	local var8
	if type(arg2) ~= "number" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad angleDeg")
	arg1.Gui.Rotation = arg2
end
function setmetatable_result1_upvr_2.GetRotation(arg1) -- Line 73
	return arg1.Gui.Rotation
end
function setmetatable_result1_upvr_2.SetDistance(arg1, arg2) -- Line 81
	arg1._hair.Position = UDim2.new(0.5, 0, 0.5 * (1 - arg2), 0)
end
function setmetatable_result1_upvr_2.SetLength(arg1, arg2) -- Line 89
	local var9
	if type(arg2) ~= "number" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad lengthPercent")
	arg1._lengthPercent = arg2
	arg1:_updateSize()
end
function setmetatable_result1_upvr_2.SetTransparency(arg1, arg2) -- Line 100
	arg1._pillBacking.ImageTransparency = arg2
end
function setmetatable_result1_upvr_2._updateSize(arg1) -- Line 104
	arg1._hair.Size = UDim2.new(0.5 * arg1._widthPercent, 0, 0.5 * arg1._lengthPercent, 0)
end
local any_load_result1_result1_upvr = any_load_result1("Blend")
function setmetatable_result1_upvr_2._render(arg1) -- Line 108
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.New("Frame")({
		Name = "ReticleHair";
		Position = UDim2.fromScale(0.5, 0.5);
		AnchorPoint = Vector2.new(0.5, 0.5);
		Size = UDim2.fromScale(1, 1);
		BackgroundTransparency = 1;
		BorderColor3 = Color3.fromRGB(27, 42, 53);
		[any_load_result1_result1_upvr.Children] = {any_load_result1_result1_upvr.New("UIAspectRatioConstraint")({
			AspectRatio = 1;
		}), any_load_result1_result1_upvr.New("Frame")({
			Name = "Hair";
			Position = UDim2.fromScale(0.5, 0.25);
			AnchorPoint = Vector2.new(0.5, 1);
			Size = UDim2.fromScale(0.1, 0.2);
			BorderColor3 = Color3.fromRGB(27, 42, 53);
		})};
	})
end
return setmetatable_result1_upvr_2