-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:25
-- Luau version 6, Types version 3
-- Time taken: 0.002084 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_3 = any_load_result1("DialogTextBoxOptionUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("DialogTextBoxPane")
local var1_result1_upvr_2 = any_load_result1("DialogConstants")
local function makePane_upvr(arg1, arg2, arg3) -- Line 15, Named "makePane"
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, 175)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
	arg2:GiveTask(Frame)
	local any_new_result1_upvr_2 = any_load_result1_result1_upvr_2.new(arg1, var1_result1_upvr_3.createTextBoxOptions({
		key = "test";
		promptText = "Enter your username";
		text = "OnlyTwentyCharacters";
		maxCharacters = 20;
		inputRequired = true;
	}))
	any_new_result1_upvr_2:SetAccentColor(var1_result1_upvr_2.DEFAULT_ACCENT_COLOR)
	arg2:GiveTask(any_new_result1_upvr_2)
	arg2:GiveTask(any_new_result1_upvr_2.SelectionConfirmed:Connect(function() -- Line 34
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:Hide()
		delay(1.5, function() -- Line 37
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (copied, readonly)
			]]
			if any_new_result1_upvr_2.Destroy then
				any_new_result1_upvr_2:Show()
			end
		end)
	end))
	any_new_result1_upvr_2.Gui.Parent = Frame
	Frame.Parent = arg3
	spawn(function() -- Line 47
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		if any_new_result1_upvr_2.Destroy then
			any_new_result1_upvr_2:Show()
		end
	end)
	return any_new_result1_upvr_2
end
local any_load_result1_result1_upvr_4 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr_3 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr = any_load_result1("UIPaddingUtils")
return function(arg1) -- Line 56
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr (readonly)
		[5]: makePane_upvr (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_result1_upvr_4.new()
	local any_new_result1 = any_load_result1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(any_new_result1)
	any_load_result1_result1_upvr_3.createThemeButton(any_new_result1_upvr, any_new_result1, arg1)
	local Frame_2 = Instance.new("Frame")
	Frame_2.Size = UDim2.new(1, 0, 1, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
	any_new_result1_upvr:GiveTask(Frame_2)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 30)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame_2
	local any_fromUDim_result1 = var1_result1_upvr.fromUDim(UDim.new(0, 30))
	any_fromUDim_result1.Parent = Frame_2
	any_new_result1_upvr:GiveTask(any_fromUDim_result1)
	makePane_upvr(any_new_result1, any_new_result1_upvr, Frame_2)
	Frame_2.Parent = arg1
	return function() -- Line 85
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end