-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:20
-- Luau version 6, Types version 3
-- Time taken: 0.002058 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_3 = any_load_result1("SharedInputKeyMap")
local var1_result1_upvr_6 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_7 = any_load_result1("DialogTestTranslator")
local var1_result1_upvr_4 = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_8 = any_load_result1("GameScalingUtils")
local var1_result1_upvr_2 = any_load_result1("DialogPane")
local var1_result1_upvr_10 = any_load_result1("DialogEntityUtils")
local var1_result1_upvr_9 = any_load_result1("DialogChoiceUtils")
return function(arg1) -- Line 18
	--[[ Upvalues[10]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_6 (readonly)
		[5]: var1_result1_upvr_7 (readonly)
		[6]: var1_result1_upvr_4 (readonly)
		[7]: var1_result1_upvr_8 (readonly)
		[8]: var1_result1_upvr_2 (readonly)
		[9]: var1_result1_upvr_10 (readonly)
		[10]: var1_result1_upvr_9 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_5.new()
	local any_new_result1 = var1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(any_new_result1)
	var1_result1_upvr_6.createThemeButton(any_new_result1_upvr, any_new_result1, arg1)
	local any_fromUDim_result1 = var1_result1_upvr_4.fromUDim(UDim.new(0, var1_result1_upvr_8.getDialogPadding(arg1.AbsoluteSize)))
	any_fromUDim_result1.Parent = arg1
	any_new_result1_upvr:GiveTask(any_fromUDim_result1)
	local any_new_result1_upvr_2 = var1_result1_upvr_2.new(any_new_result1)
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_2)
	any_new_result1_upvr_2.Gui.Parent = arg1
	any_new_result1_upvr_2:SetUIScale(var1_result1_upvr_8.getUIScale(arg1.AbsoluteSize))
	any_new_result1_upvr_2:Show()
	local any_createGridChoices_result1_upvr = var1_result1_upvr_9.createGridChoices("haha", {var1_result1_upvr_9.createColorChoice("choice_1", Color3.fromRGB(2, 138, 123)), var1_result1_upvr_9.createColorChoice("choice_2", Color3.fromRGB(255, 85, 127)), var1_result1_upvr_9.createColorChoice("choice_3", Color3.fromRGB(170, 85, 127)), var1_result1_upvr_9.createColorChoice("choice_4", Color3.fromRGB(255, 170, 127)), var1_result1_upvr_9.createColorChoice("choice_5", Color3.fromRGB(127, 213, 255)), var1_result1_upvr_9.createColorChoice("choice_6", Color3.fromRGB(255, 255, 255)), var1_result1_upvr_9.createColorChoice("choice_7", Color3.new(0.5, 0.5, 0.5)), var1_result1_upvr_9.createColorChoice("choice_8", Color3.new(0, 0, 0))})
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_2:ShowText(any_new_result1:GetService(var1_result1_upvr_7):FormatByKey("dialogTest.test"), {
		player = var1_result1_upvr_10.createPlayerEntity("Quenty");
		talker = var1_result1_upvr_10.createTalkerEntity("John", Color3.new(1, 0.5, 0.5), 0);
		hint = var1_result1_upvr_10.createInputHint(any_new_result1:GetService(var1_result1_upvr_3):GetInputKeyMapList("PRIMARY"));
	}).Done:Connect(function() -- Line 57
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: any_createGridChoices_result1_upvr (readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:GiveTask(any_new_result1_upvr_2:ShowChoices(any_createGridChoices_result1_upvr).ChoiceSelected:Connect(function() -- Line 59
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (copied, readonly)
			]]
			any_new_result1_upvr_2:HideCurrentPrompt()
			any_new_result1_upvr_2:Hide()
		end))
	end))
	return function() -- Line 66
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end