-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:51
-- Luau version 6, Types version 3
-- Time taken: 0.001894 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_4 = any_load_result1("DialogChoiceUtils")
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr = any_load_result1("DialogChoicesPane")
return function(arg1) -- Line 15
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
		[5]: HttpService_upvr (readonly)
		[6]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr_3.new()
	local any_new_result1 = var1_result1_upvr_2.new()
	any_new_result1_2_upvr:GiveTask(any_new_result1)
	any_load_result1_result1_upvr.createThemeButton(any_new_result1_2_upvr, any_new_result1, arg1)
	local any_new_result1_upvr = var1_result1_upvr.new(any_new_result1, var1_result1_upvr_4.createChoices(HttpService_upvr:GenerateGUID(false), {var1_result1_upvr_4.createChoice("choice_1", "Yes!"), var1_result1_upvr_4.createChoice("choice_2", "No."), var1_result1_upvr_4.createChoice("choice_3", "You're cute too!")}))
	any_new_result1_2_upvr:GiveTask(any_new_result1_upvr)
	any_new_result1_upvr.Gui.Position = UDim2.fromScale(0.5, 0.5)
	any_new_result1_upvr.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
	any_new_result1_upvr.Gui.Parent = arg1
	any_new_result1_upvr:Show()
	any_new_result1_2_upvr:GiveTask(any_new_result1_upvr.ChoiceSelected:Connect(function() -- Line 37
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Hide()
	end))
	return function() -- Line 41
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:DoCleaning()
	end
end