-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:37
-- Luau version 6, Types version 3
-- Time taken: 0.001201 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_4 = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_5 = any_load_result1("UICornerUtils")
local var1_result1_upvr = any_load_result1("DialogTextBoxCharacterLimit")
return function(arg1) -- Line 14
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
		[6]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_3_upvr = var1_result1_upvr_3.new()
	local any_new_result1_2 = var1_result1_upvr_2.new()
	any_new_result1_3_upvr:GiveTask(any_new_result1_2)
	any_load_result1_result1_upvr.createThemeButton(any_new_result1_3_upvr, any_new_result1_2, arg1)
	local any_fromUDim_result1 = var1_result1_upvr_4.fromUDim(UDim.new(0, 30))
	any_fromUDim_result1.Parent = arg1
	any_new_result1_3_upvr:GiveTask(any_fromUDim_result1)
	local TextBox = Instance.new("TextBox")
	TextBox.ClearTextOnFocus = false
	TextBox.Size = UDim2.new(1, 0, 0, 40)
	TextBox.Font = Enum.Font.Highway
	TextBox.TextSize = 20
	TextBox.Text = "Test text"
	TextBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	any_new_result1_3_upvr:GiveTask(TextBox)
	var1_result1_upvr_5.fromOffset(8, TextBox)
	local any_new_result1 = var1_result1_upvr.new(any_new_result1_2, TextBox)
	any_new_result1:SetMaxCharacters(5)
	any_new_result1_3_upvr:GiveTask(any_new_result1)
	any_new_result1.Gui.Parent = arg1
	TextBox.Parent = arg1
	return function() -- Line 43
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end