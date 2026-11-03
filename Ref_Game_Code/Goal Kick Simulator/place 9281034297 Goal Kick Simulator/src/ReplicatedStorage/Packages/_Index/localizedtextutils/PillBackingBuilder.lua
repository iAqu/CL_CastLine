-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:16
-- Luau version 6, Types version 3
-- Time taken: 0.010724 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "PillBackingBuilder"
module_upvr.CIRCLE_IMAGE_ID = "rbxassetid://633244888"
module_upvr.CIRCLE_SIZE = Vector2.new(256, 256)
module_upvr.SHADOW_IMAGE_ID = "rbxassetid://707852973"
module_upvr.SHADOW_SIZE = Vector2.new(128, 128)
module_upvr.PILL_SHADOW_IMAGE_ID = "rbxassetid://1304004290"
module_upvr.PILL_SHADOW_SIZE = Vector2.new(256, 128)
module_upvr.SHADOW_OFFSET_Y = UDim.new(0.05, 0)
module_upvr.SHADOW_TRANSPARENCY = 0.85
function module_upvr.new(arg1) -- Line 24
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var3 = arg1
	if not var3 then
		var3 = {}
	end
	setmetatable_result1._options = var3
	return setmetatable_result1
end
function module_upvr.CreateSingle(arg1, arg2, arg3) -- Line 32
	local any__configureOptions_result1 = arg1:_configureOptions(arg2, arg3)
	local ImageLabel_4 = Instance.new("ImageLabel")
	ImageLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_4.BackgroundTransparency = 1
	ImageLabel_4.ImageColor3 = any__configureOptions_result1.BackgroundColor3
	ImageLabel_4.BorderSizePixel = 0
	ImageLabel_4.Name = "PillBacking"
	ImageLabel_4.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel_4.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel_4.ZIndex = any__configureOptions_result1.ZIndex
	ImageLabel_4.ScaleType = Enum.ScaleType.Slice
	ImageLabel_4.SliceScale = 1024
	ImageLabel_4.SliceCenter = Rect.new(arg1.CIRCLE_SIZE.x / 2, arg1.CIRCLE_SIZE.x / 2, arg1.CIRCLE_SIZE.y / 2, arg1.CIRCLE_SIZE.y / 2)
	ImageLabel_4.Image = arg1.CIRCLE_IMAGE_ID
	arg2.BackgroundTransparency = 1
	ImageLabel_4.Parent = arg2
	return ImageLabel_4
end
function module_upvr.Create(arg1, arg2, arg3) -- Line 56
	warn("Use CreateSingle"..debug.traceback())
	local any__configureOptions_result1_3 = arg1:_configureOptions(arg2, arg3)
	local Y_2 = arg2.Size.Y
	local Frame = Instance.new("Frame")
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = any__configureOptions_result1_3.BackgroundColor3
	Frame.BorderSizePixel = 0
	Frame.Name = "PillBacking"
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(1 - Y_2.Scale, -Y_2.Offset, 1, 0)
	Frame.ZIndex = any__configureOptions_result1_3.ZIndex
	local UISizeConstraint_3 = Instance.new("UISizeConstraint")
	UISizeConstraint_3.MaxSize = Vector2.new(math.huge, math.huge)
	UISizeConstraint_3.MinSize = Vector2.new(0, 0)
	UISizeConstraint_3.Parent = Frame
	arg1:_createRight(any__configureOptions_result1_3).Parent = Frame
	arg1:_createLeft(any__configureOptions_result1_3).Parent = Frame
	arg2.BackgroundTransparency = 1
	Frame.Parent = arg2
	return Frame
end
function module_upvr.CreateVertical(arg1, arg2, arg3) -- Line 87
	warn("Use CreateSingle"..debug.traceback())
	local any__configureOptions_result1_2 = arg1:_configureOptions(arg2, arg3)
	local X_2 = arg2.Size.X
	local Frame_2 = Instance.new("Frame")
	Frame_2.SizeConstraint = Enum.SizeConstraint.RelativeXX
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_2.BackgroundColor3 = any__configureOptions_result1_2.BackgroundColor3
	Frame_2.BorderSizePixel = 0
	Frame_2.Name = "PillBacking"
	Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame_2.Size = UDim2.new(1, 0, 1 - X_2.Scale, -X_2.Offset)
	Frame_2.ZIndex = any__configureOptions_result1_2.ZIndex
	local UISizeConstraint = Instance.new("UISizeConstraint")
	UISizeConstraint.MaxSize = Vector2.new(math.huge, math.huge)
	UISizeConstraint.MinSize = Vector2.new(0, 0)
	UISizeConstraint.Parent = Frame_2
	arg1:_createTop(any__configureOptions_result1_2).Parent = Frame_2
	arg1:_createBottom(any__configureOptions_result1_2).Parent = Frame_2
	arg2.BackgroundTransparency = 1
	Frame_2.Parent = arg2
	return Frame_2
end
function module_upvr.CreateSingleShadow(arg1, arg2, arg3) -- Line 120
	local Y_3 = arg2.Size.Y
	local X = arg2.Size.X
	local var16 = 0
	if X.Scale ~= 0 then
		var16 = Y_3.Scale / X.Scale / 2
	end
	local ImageLabel_5 = Instance.new("ImageLabel")
	ImageLabel_5.SliceScale = 1024
	ImageLabel_5.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_5.BackgroundTransparency = 1
	ImageLabel_5.BorderSizePixel = 0
	ImageLabel_5.ImageTransparency = arg1.SHADOW_TRANSPARENCY
	ImageLabel_5.Name = "PillShadow"
	ImageLabel_5.Position = UDim2.new(0.5, 0, 0.5, arg1.SHADOW_OFFSET_Y)
	ImageLabel_5.Size = UDim2.new(var16 + 1, Y_3.Offset / 2, 2, 0)
	ImageLabel_5.ZIndex = arg1:_configureOptions(arg2, arg3).ShadowZIndex
	ImageLabel_5.ScaleType = Enum.ScaleType.Slice
	ImageLabel_5.SliceCenter = Rect.new(arg1.SHADOW_SIZE.x / 2, arg1.SHADOW_SIZE.x / 2, arg1.SHADOW_SIZE.y / 2, arg1.SHADOW_SIZE.y / 2)
	ImageLabel_5.Image = arg1.SHADOW_IMAGE_ID
	ImageLabel_5.Parent = arg2
	return ImageLabel_5
end
function module_upvr.CreateShadow(arg1, arg2, arg3) -- Line 150
	local any__configureOptions_result1_4 = arg1:_configureOptions(arg2, arg3)
	local Y = arg2.Size.Y
	local any__createPillShadow_result1_2 = arg1:_createPillShadow(any__configureOptions_result1_4)
	any__createPillShadow_result1_2.SizeConstraint = Enum.SizeConstraint.RelativeXY
	any__createPillShadow_result1_2.AnchorPoint = Vector2.new(0.5, 0.5)
	any__createPillShadow_result1_2.Name = "PillShadow"
	any__createPillShadow_result1_2.ImageRectSize = arg1.PILL_SHADOW_SIZE * Vector2.new(0.5, 1)
	any__createPillShadow_result1_2.ImageRectOffset = arg1.PILL_SHADOW_SIZE * Vector2.new(0.25, 0)
	any__createPillShadow_result1_2.Position = UDim2.new(UDim.new(0.5, 0), UDim.new(0.5, 0) + arg1.SHADOW_OFFSET_Y)
	any__createPillShadow_result1_2.Size = UDim2.new(1 - Y.Scale, -Y.Offset, 2, 0)
	any__createPillShadow_result1_2.ZIndex = any__configureOptions_result1_4.ShadowZIndex
	local UISizeConstraint_2 = Instance.new("UISizeConstraint")
	UISizeConstraint_2.MaxSize = Vector2.new(math.huge, math.huge)
	UISizeConstraint_2.MinSize = Vector2.new(0, 0)
	UISizeConstraint_2.Parent = any__createPillShadow_result1_2
	arg1:_createRightShadow(any__configureOptions_result1_4).Parent = any__createPillShadow_result1_2
	arg1:_createLeftShadow(any__configureOptions_result1_4).Parent = any__createPillShadow_result1_2
	any__createPillShadow_result1_2.Parent = arg2
	return any__createPillShadow_result1_2
end
function module_upvr.CreateCircle(arg1, arg2, arg3) -- Line 181
	local any__createCircle_result1_2 = arg1:_createCircle(arg1:_configureOptions(arg2, arg3))
	any__createCircle_result1_2.ImageTransparency = arg2.BackgroundTransparency
	arg2.BackgroundTransparency = 1
	any__createCircle_result1_2.Parent = arg2
	return any__createCircle_result1_2
end
function module_upvr.CreateCircleShadow(arg1, arg2, arg3) -- Line 192
	local ImageLabel_3 = Instance.new("ImageLabel")
	ImageLabel_3.SliceScale = 1024
	ImageLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_3.BackgroundTransparency = 1
	ImageLabel_3.Image = arg1.SHADOW_IMAGE_ID
	ImageLabel_3.ImageTransparency = arg1.SHADOW_TRANSPARENCY
	ImageLabel_3.Name = "CircleShadow"
	ImageLabel_3.Position = UDim2.new(UDim.new(0.5, 0), UDim.new(0.5, 0) + arg1.SHADOW_OFFSET_Y)
	ImageLabel_3.Size = UDim2.new(2, 0, 2, 0)
	ImageLabel_3.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ImageLabel_3.ZIndex = arg1:_configureOptions(arg2, arg3).ShadowZIndex
	ImageLabel_3.Parent = arg2
	return ImageLabel_3
end
function module_upvr.CreateLeft(arg1, arg2, arg3) -- Line 212
	local any__createLeft_result1 = arg1:_createLeft(arg1:_configureOptions(arg2, arg3))
	any__createLeft_result1.Parent = arg2
	return any__createLeft_result1
end
function module_upvr.CreateRight(arg1, arg2, arg3) -- Line 219
	local any__createRight_result1 = arg1:_createRight(arg1:_configureOptions(arg2, arg3))
	any__createRight_result1.Parent = arg2
	return any__createRight_result1
end
function module_upvr.CreateTop(arg1, arg2, arg3) -- Line 226
	local any__createTop_result1 = arg1:_createTop(arg1:_configureOptions(arg2, arg3))
	any__createTop_result1.Parent = arg2
	return any__createTop_result1
end
function module_upvr.CreateBottom(arg1, arg2, arg3) -- Line 233
	local any__createBottom_result1 = arg1:_createBottom(arg1:_configureOptions(arg2, arg3))
	any__createBottom_result1.Parent = arg2
	return any__createBottom_result1
end
function module_upvr._createTop(arg1, arg2) -- Line 240
	local any__createCircle_result1_3 = arg1:_createCircle(arg2)
	any__createCircle_result1_3.SizeConstraint = Enum.SizeConstraint.RelativeXX
	any__createCircle_result1_3.AnchorPoint = Vector2.new(0.5, 1)
	any__createCircle_result1_3.ImageRectSize = arg1.CIRCLE_SIZE * Vector2.new(1, 0.5)
	any__createCircle_result1_3.Name = "TopHalfCircle"
	any__createCircle_result1_3.Position = UDim2.new(0.5, 0, 0, 0)
	any__createCircle_result1_3.Size = UDim2.new(1, 0, 0.5, 0)
	return any__createCircle_result1_3
end
function module_upvr._createBottom(arg1, arg2) -- Line 252
	local any__createCircle_result1_4 = arg1:_createCircle(arg2)
	any__createCircle_result1_4.SizeConstraint = Enum.SizeConstraint.RelativeXX
	any__createCircle_result1_4.AnchorPoint = Vector2.new(0.5, 0)
	any__createCircle_result1_4.ImageRectOffset = arg1.CIRCLE_SIZE * Vector2.new(0, 0.5)
	any__createCircle_result1_4.ImageRectSize = arg1.CIRCLE_SIZE * Vector2.new(1, 0.5)
	any__createCircle_result1_4.Name = "BottomHalfCircle"
	any__createCircle_result1_4.Position = UDim2.new(0.5, 0, 1, 0)
	any__createCircle_result1_4.Size = UDim2.new(1, 0, 0.5, 0)
	return any__createCircle_result1_4
end
function module_upvr._createLeft(arg1, arg2) -- Line 265
	local any__createCircle_result1_5 = arg1:_createCircle(arg2)
	any__createCircle_result1_5.AnchorPoint = Vector2.new(1, 0.5)
	any__createCircle_result1_5.ImageRectSize = arg1.CIRCLE_SIZE * Vector2.new(0.5, 1)
	any__createCircle_result1_5.Name = "LeftHalfCircle"
	any__createCircle_result1_5.Position = UDim2.new(0, 0, 0.5, 0)
	any__createCircle_result1_5.Size = UDim2.new(0.5, 0, 1, 0)
	return any__createCircle_result1_5
end
function module_upvr._createRight(arg1, arg2) -- Line 276
	local any__createCircle_result1 = arg1:_createCircle(arg1:_configureOptions(arg2))
	any__createCircle_result1.AnchorPoint = Vector2.new(0, 0.5)
	any__createCircle_result1.ImageRectOffset = arg1.CIRCLE_SIZE * Vector2.new(0.5, 0)
	any__createCircle_result1.ImageRectSize = arg1.CIRCLE_SIZE * Vector2.new(0.5, 1)
	any__createCircle_result1.Name = "RightHalfCircle"
	any__createCircle_result1.Position = UDim2.new(1, 0, 0.5, 0)
	any__createCircle_result1.Size = UDim2.new(0.5, 0, 1, 0)
	return any__createCircle_result1
end
function module_upvr._createLeftShadow(arg1, arg2) -- Line 290
	local any__createPillShadow_result1_3 = arg1:_createPillShadow(arg2)
	any__createPillShadow_result1_3.AnchorPoint = Vector2.new(1, 0.5)
	any__createPillShadow_result1_3.ImageRectSize = arg1.PILL_SHADOW_SIZE * Vector2.new(0.25, 1)
	any__createPillShadow_result1_3.Name = "LeftShadow"
	any__createPillShadow_result1_3.Position = UDim2.new(0, 0, 0.5, 0)
	any__createPillShadow_result1_3.Size = UDim2.new(0.5, 0, 1, 0)
	return any__createPillShadow_result1_3
end
function module_upvr._createRightShadow(arg1, arg2) -- Line 301
	local any__createPillShadow_result1 = arg1:_createPillShadow(arg2)
	any__createPillShadow_result1.AnchorPoint = Vector2.new(0, 0.5)
	any__createPillShadow_result1.ImageRectOffset = arg1.PILL_SHADOW_SIZE * Vector2.new(0.75, 0)
	any__createPillShadow_result1.ImageRectSize = arg1.PILL_SHADOW_SIZE * Vector2.new(0.25, 1)
	any__createPillShadow_result1.Name = "RightShadow"
	any__createPillShadow_result1.Position = UDim2.new(1, 0, 0.5, 0)
	any__createPillShadow_result1.Size = UDim2.new(0.5, 0, 1, 0)
	return any__createPillShadow_result1
end
function module_upvr._createCircle(arg1, arg2) -- Line 313
	local ImageLabel_2 = Instance.new("ImageLabel")
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.Image = arg1.CIRCLE_IMAGE_ID
	ImageLabel_2.Name = "Circle"
	ImageLabel_2.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel_2.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ImageLabel_2.ImageColor3 = arg2.BackgroundColor3
	ImageLabel_2.ZIndex = arg2.ZIndex
	return ImageLabel_2
end
function module_upvr._createPillShadow(arg1, arg2) -- Line 328
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = arg1.PILL_SHADOW_IMAGE_ID
	ImageLabel.ImageTransparency = arg1.SHADOW_TRANSPARENCY
	ImageLabel.Name = "PillShadow"
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ImageLabel.ZIndex = arg2.ShadowZIndex
	return ImageLabel
end
local var36_upvr = require(script.Parent.loader).load(script)("Table")
function module_upvr._configureOptions(arg1, arg2, arg3) -- Line 342
	--[[ Upvalues[1]:
		[1]: var36_upvr (readonly)
	]]
	assert(arg2, "Must pass in GUI")
	local var37 = arg3
	if not var37 then
		var37 = arg1._options
	end
	local any_copy_result1 = var36_upvr.copy(var37)
	local ZIndex = any_copy_result1.ZIndex
	if not ZIndex then
		ZIndex = arg2.ZIndex
	end
	any_copy_result1.ZIndex = ZIndex
	ZIndex = any_copy_result1.ShadowZIndex
	local var40 = ZIndex
	if not var40 then
		var40 = any_copy_result1.ZIndex - 1
	end
	any_copy_result1.ShadowZIndex = var40
	var40 = any_copy_result1.BackgroundColor3
	local var41 = var40
	if not var41 then
		var41 = arg2.BackgroundColor3
	end
	any_copy_result1.BackgroundColor3 = var41
	return any_copy_result1
end
return module_upvr