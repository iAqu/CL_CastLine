-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:14
-- Luau version 6, Types version 3
-- Time taken: 0.001239 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_4 = any_load_result1("UICornerUtils")
local var1_result1_upvr_2 = any_load_result1("AnimatedSpritesheetPlayer")
local function makeLabel_upvr(arg1, arg2, arg3) -- Line 12, Named "makeLabel"
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local any_GetSpriteSize_result1 = arg2:GetSpriteSize()
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.BackgroundTransparency = 0
	ImageLabel.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
	ImageLabel.Size = UDim2.fromOffset(any_GetSpriteSize_result1.x, any_GetSpriteSize_result1.y)
	ImageLabel.BorderSizePixel = 0
	arg1:GiveTask(ImageLabel)
	var1_result1_upvr_4.fromOffset(8, ImageLabel)
	arg1:GiveTask(var1_result1_upvr_2.new(ImageLabel, arg2))
	ImageLabel.Parent = arg3
	return ImageLabel
end
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("AnimatedSpritesheet")
return function(arg1) -- Line 32
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: makeLabel_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.Parent = arg1
	any_new_result1_upvr:GiveTask(Frame)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame
	makeLabel_upvr(any_new_result1_upvr, var1_result1_upvr.new({
		texture = "rbxassetid://5085366281";
		frames = 34;
		spritesPerRow = 6;
		spriteSize = Vector2.new(85.33333, 85.33333);
		framesPerSecond = 30;
	}), Frame)
	return function() -- Line 58
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end