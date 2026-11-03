-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:15
-- Luau version 6, Types version 3
-- Time taken: 0.002014 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_3 = any_load_result1("GuiThemeService")
local var1_result1_upvr_6 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_7 = any_load_result1("DialogChoiceButton")
local var1_result1_upvr_4 = any_load_result1("Blend")
local var1_result1_upvr_8 = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_2 = any_load_result1("DialogChoiceUtils")
return function(arg1) -- Line 16
	--[[ Upvalues[8]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_6 (readonly)
		[5]: var1_result1_upvr_7 (readonly)
		[6]: var1_result1_upvr_4 (readonly)
		[7]: var1_result1_upvr_8 (readonly)
		[8]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_5.new()
	local any_new_result1_4_upvr = var1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(any_new_result1_4_upvr)
	var1_result1_upvr_6.createThemeButton(any_new_result1_upvr, any_new_result1_4_upvr, arg1)
	local function _(arg1_2) -- Line 24, Named "createButton"
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_7 (copied, readonly)
			[2]: any_new_result1_4_upvr (readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		local any_new_result1 = var1_result1_upvr_7.new(any_new_result1_4_upvr, arg1_2)
		any_new_result1:SetNumber(1)
		any_new_result1_upvr:GiveTask(any_new_result1)
		return any_new_result1.Gui
	end
	local tbl_2 = {
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 0;
		BorderSizePixel = 0;
		BackgroundColor3 = any_new_result1_4_upvr:GetService(var1_result1_upvr_3):ObserveColor("action");
	}
	tbl_2.Parent = arg1
	local tbl = {}
	local any_new_result1_3 = var1_result1_upvr_7.new(any_new_result1_4_upvr, var1_result1_upvr_2.createChoice("choice_1", "Yes!"))
	any_new_result1_3:SetNumber(1)
	any_new_result1_upvr:GiveTask(any_new_result1_3)
	local any_new_result1_2 = var1_result1_upvr_7.new(any_new_result1_4_upvr, var1_result1_upvr_2.createChoice("choice_2", "No!"))
	any_new_result1_2:SetNumber(1)
	any_new_result1_upvr:GiveTask(any_new_result1_2)
	tbl[1] = var1_result1_upvr_8.fromUDim(UDim.new(0, 30))
	tbl[2] = var1_result1_upvr_4.New("UIListLayout")({
		FillDirection = Enum.FillDirection.Vertical;
		VerticalAlignment = Enum.VerticalAlignment.Center;
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		Padding = UDim.new(0, 10);
		SortOrder = Enum.SortOrder.LayoutOrder;
	})
	tbl[3] = any_new_result1_3.Gui
	tbl[4] = any_new_result1_2.Gui
	tbl_2[var1_result1_upvr_4.Children] = tbl
	any_new_result1_upvr:GiveTask(var1_result1_upvr_4.New("Frame")(tbl_2):Subscribe())
	return function() -- Line 55
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end