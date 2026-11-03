-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:11
-- Luau version 6, Types version 3
-- Time taken: 0.001043 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_4 = any_load_result1("Maid")
local var1_result1_upvr_3 = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr = any_load_result1("DialogTranslator")
local var1_result1_upvr_5 = any_load_result1("DialogTestTranslator")
local var1_result1_upvr_6 = any_load_result1("InputKeyMapServiceClient")
local var1_result1_upvr_2 = any_load_result1("GuiThemeServiceStoryUtils")
local any_load_result1_result1_upvr_3 = any_load_result1("DialogScreenGuiProvider")
local any_load_result1_result1_upvr_2 = any_load_result1("LocalDialogSessionClient")
local var1_result1_upvr = any_load_result1("DialogTestUtils")
return function(arg1) -- Line 17
	--[[ Upvalues[9]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_5 (readonly)
		[5]: var1_result1_upvr_6 (readonly)
		[6]: var1_result1_upvr_2 (readonly)
		[7]: any_load_result1_result1_upvr_3 (readonly)
		[8]: any_load_result1_result1_upvr_2 (readonly)
		[9]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_3_upvr = var1_result1_upvr_4.new()
	local any_new_result1 = var1_result1_upvr_3.new()
	any_new_result1:GetService(any_load_result1_result1_upvr):FallbackTo(any_new_result1:GetService(var1_result1_upvr_5))
	any_new_result1:GetService(var1_result1_upvr_6)
	var1_result1_upvr_2.createThemeButton(any_new_result1_3_upvr, any_new_result1, arg1)
	any_new_result1_3_upvr:GiveTask(any_load_result1_result1_upvr_3:SetupMockParent(arg1))
	local any_new_result1_2 = any_load_result1_result1_upvr_2.new(any_new_result1)
	any_new_result1_3_upvr:GiveTask(any_new_result1_2)
	any_new_result1_3_upvr:GiveTask(var1_result1_upvr.showTestDialogForSession(any_new_result1_2))
	return function() -- Line 33
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end