-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:40
-- Luau version 6, Types version 3
-- Time taken: 0.002667 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "RoundedBackingBuilder"
module_upvr.DEFAULT_SHADOW_TRANSPARENCY = 0.7
module_upvr.BACKING_ASSET_ID = "rbxassetid://735637144"
module_upvr.SHADOW_ASSET_ID = "rbxassetid://735644155"
function module_upvr.new(arg1) -- Line 20
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var3 = arg1
	if not var3 then
		var3 = {}
		var3.sibling = true
	end
	setmetatable_result1._options = var3
	return setmetatable_result1
end
function module_upvr.Create(arg1, arg2) -- Line 30
	local any_CreateBacking_result1 = arg1:CreateBacking(arg2)
	arg1:CreateShadow(any_CreateBacking_result1)
	return any_CreateBacking_result1
end
function module_upvr.CreateBacking(arg1, arg2) -- Line 37
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.Name = "Backing"
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Image = arg1.BACKING_ASSET_ID
	ImageLabel.SliceCenter = Rect.new(4, 4, 16, 16)
	ImageLabel.ImageColor3 = arg2.BackgroundColor3
	ImageLabel.ScaleType = Enum.ScaleType.Slice
	ImageLabel.BackgroundTransparency = 1
	if arg1._options.sibling then
		ImageLabel.ZIndex = -1
	else
		ImageLabel.ZIndex = arg2.ZIndex - 1
	end
	ImageLabel.Parent = arg2
	arg2.BackgroundTransparency = 1
	return ImageLabel
end
function module_upvr.CreateTopBacking(arg1, arg2) -- Line 59
	local any_CreateBacking_result1_3 = arg1:CreateBacking(arg2)
	any_CreateBacking_result1_3.ImageRectSize = Vector2.new(20, 16)
	any_CreateBacking_result1_3.SliceCenter = Rect.new(4, 4, 16, 16)
	return any_CreateBacking_result1_3
end
function module_upvr.CreateLeftBacking(arg1, arg2) -- Line 67
	local any_CreateBacking_result1_5 = arg1:CreateBacking(arg2)
	any_CreateBacking_result1_5.ImageRectSize = Vector2.new(16, 20)
	any_CreateBacking_result1_5.SliceCenter = Rect.new(4, 4, 16, 16)
	return any_CreateBacking_result1_5
end
function module_upvr.CreateRightBacking(arg1, arg2) -- Line 75
	local any_CreateBacking_result1_2 = arg1:CreateBacking(arg2)
	any_CreateBacking_result1_2.ImageRectSize = Vector2.new(16, 20)
	any_CreateBacking_result1_2.SliceCenter = Rect.new(4, 4, 16, 16)
	any_CreateBacking_result1_2.ImageRectOffset = Vector2.new(4, 0)
	return any_CreateBacking_result1_2
end
function module_upvr.CreateBottomBacking(arg1, arg2) -- Line 85
	local any_CreateBacking_result1_4 = arg1:CreateBacking(arg2)
	any_CreateBacking_result1_4.ImageRectSize = Vector2.new(20, 16)
	any_CreateBacking_result1_4.ImageRectOffset = Vector2.new(0, 4)
	any_CreateBacking_result1_4.SliceCenter = Rect.new(4, 4, 12, 12)
	return any_CreateBacking_result1_4
end
function module_upvr.CreateTopShadow(arg1, arg2) -- Line 94
	local any_CreateShadow_result1 = arg1:CreateShadow(arg2)
	any_CreateShadow_result1.ImageRectSize = Vector2.new(80, 64)
	any_CreateShadow_result1.SliceCenter = Rect.new(16, 16, 64, 64)
	return any_CreateShadow_result1
end
function module_upvr.CreateShadow(arg1, arg2) -- Line 102
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local ImageLabel_2 = Instance.new("ImageLabel")
	ImageLabel_2.Name = "Shadow"
	ImageLabel_2.Size = UDim2.new(1, 6, 1, 6)
	ImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_2.Position = UDim2.new(0.5, 0, 0.5, 1)
	ImageLabel_2.Image = arg1.SHADOW_ASSET_ID
	ImageLabel_2.SliceCenter = Rect.new(16, 16, 64, 64)
	ImageLabel_2.ImageColor3 = Color3.new(0, 0, 0)
	ImageLabel_2.ScaleType = Enum.ScaleType.Slice
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.ImageTransparency = module_upvr.DEFAULT_SHADOW_TRANSPARENCY
	ImageLabel_2.ZIndex = arg2.ZIndex - 1
	ImageLabel_2.Parent = arg2.Parent
	return ImageLabel_2
end
return module_upvr