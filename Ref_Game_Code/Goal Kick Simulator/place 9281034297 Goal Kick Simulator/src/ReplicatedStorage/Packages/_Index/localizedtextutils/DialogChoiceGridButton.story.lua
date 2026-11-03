-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:33
-- Luau version 6, Types version 3
-- Time taken: 0.001679 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr = any_load_result1("DialogChoiceUtils")
local var1_result1_upvr_4 = any_load_result1("DialogChoiceGridButton")
local function makeButton_upvr(arg1, arg2, arg3, arg4) -- Line 13, Named "makeButton"
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_4.new(arg1, var1_result1_upvr.createColorChoice("choice_1", Color3.fromRGB(2, 138, 123)))
	arg2:GiveTask(any_new_result1_upvr_2)
	any_new_result1_upvr_2:SetColor(arg4)
	any_new_result1_upvr_2.Gui.Parent = arg3
	local var6_upvw = false
	arg2:GiveTask(any_new_result1_upvr_2.Selected:Connect(function() -- Line 23
		--[[ Upvalues[2]:
			[1]: var6_upvw (read and write)
			[2]: any_new_result1_upvr_2 (readonly)
		]]
		var6_upvw = not var6_upvw
		any_new_result1_upvr_2:SetIsChoosen(var6_upvw)
	end))
	return any_new_result1_upvr_2
end
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr_5 = any_load_result1("ServiceBag")
local var1_result1_upvr_2 = any_load_result1("GuiThemeServiceStoryUtils")
return function(arg1) -- Line 31
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: makeButton_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	local any_new_result1 = var1_result1_upvr_5.new()
	any_new_result1_upvr:GiveTask(any_new_result1)
	var1_result1_upvr_2.createThemeButton(any_new_result1_upvr, any_new_result1, arg1)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.Parent = arg1
	any_new_result1_upvr:GiveTask(Frame)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 30)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame
	makeButton_upvr(any_new_result1, any_new_result1_upvr, Frame, Color3.fromRGB(0, 0, 0))
	makeButton_upvr(any_new_result1, any_new_result1_upvr, Frame, Color3.fromRGB(170, 85, 127))
	makeButton_upvr(any_new_result1, any_new_result1_upvr, Frame, Color3.fromRGB(255, 255, 255))
	makeButton_upvr(any_new_result1, any_new_result1_upvr, Frame, Color3.fromRGB(255, 255, 255)):SetIsChoosen(true)
	return function() -- Line 60
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end