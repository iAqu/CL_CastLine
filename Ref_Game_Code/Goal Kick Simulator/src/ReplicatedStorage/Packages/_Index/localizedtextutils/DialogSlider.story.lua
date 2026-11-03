-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:11
-- Luau version 6, Types version 3
-- Time taken: 0.001171 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_3 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_6 = any_load_result1("DialogInput")
local var1_result1_upvr_7 = any_load_result1("DialogSlider")
local var1_result1_upvr_4 = any_load_result1("DialogSliderOptionUtils")
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr_2 = any_load_result1("UIPaddingUtils")
return function(arg1) -- Line 17
	--[[ Upvalues[8]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_6 (readonly)
		[5]: var1_result1_upvr_7 (readonly)
		[6]: var1_result1_upvr_4 (readonly)
		[7]: HttpService_upvr (readonly)
		[8]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_3_upvr = var1_result1_upvr_5.new()
	local any_new_result1_2 = var1_result1_upvr.new()
	any_new_result1_3_upvr:GiveTask(any_new_result1_2)
	var1_result1_upvr_3.createThemeButton(any_new_result1_3_upvr, any_new_result1_2, arg1)
	local any_new_result1 = var1_result1_upvr_6.new(any_new_result1_2)
	any_new_result1_3_upvr:GiveTask(any_new_result1)
	any_new_result1:SetEnabled(true)
	local any_new_result1_upvr = var1_result1_upvr_7.new(any_new_result1_2, var1_result1_upvr_4.createSliderOptions({
		key = HttpService_upvr:GenerateGUID(false);
		initialValue = 50;
		min = 0;
		minLabel = '0';
		max = 100;
		maxLabel = "100";
		round = 5;
	}), any_new_result1)
	any_new_result1_upvr:SetAccentColor(Color3.new(1, 0.5, 0.5))
	any_new_result1_3_upvr:GiveTask(any_new_result1_upvr)
	local any_fromUDim_result1 = var1_result1_upvr_2.fromUDim(UDim.new(0, 30))
	any_new_result1_3_upvr:GiveTask(any_fromUDim_result1)
	any_new_result1_upvr:Show()
	any_new_result1_3_upvr:GiveTask(any_new_result1_upvr.SelectionConfirmed:Connect(function() -- Line 46
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Hide()
	end))
	any_fromUDim_result1.Parent = arg1
	any_new_result1_upvr.Gui.Parent = arg1
	return function() -- Line 53
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end