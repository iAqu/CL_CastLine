-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:09
-- Luau version 6, Types version 3
-- Time taken: 0.002123 seconds

local longstring1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce malesuada porta est, id egestas ex porta semper. Donec ullamcorper condimentum diam, at tempus nunc viverra in. Integer porta rutrum eleifend. Cras sem enim, vestibulum non rutrum non, varius nec erat. Aenean efficitur mi diam, a condimentum nunc rhoncus sed. Praesent in sagittis sem. Aenean fermentum consectetur augue, dignissim posuere lorem semper pellentesque. Curabitur vitae est ipsum. Nunc vitae porttitor velit. Donec porta risus vitae metus luctus, eu feugiat mi rhoncus. Nam turpis enim, ullamcorper eu suscipit vitae, elementum in arcu. Vestibulum tempor sed libero a vulputate. Donec egestas lacus sit amet finibus accumsan. Cras lacinia nunc id urna rutrum vestibulum. Fusce aliquet tortor accumsan dapibus tristique. Maecenas consectetur venenatis aliquet.\n"
local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogTextBox")
local function createTextBox_upvr(arg1, arg2, arg3, arg4) -- Line 20, Named "createTextBox"
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, arg4 or 50)
	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	arg2:GiveTask(Frame)
	local any_new_result1_upvr = var1_result1_upvr_2.new(arg1)
	any_new_result1_upvr:PreviewFilterText()
	arg2:GiveTask(any_new_result1_upvr)
	any_new_result1_upvr.Gui.Parent = Frame
	Frame.Parent = arg3
	spawn(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Show()
	end)
	return any_new_result1_upvr
end
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr_4 = any_load_result1("ServiceBag")
local var1_result1_upvr_6 = any_load_result1("DialogInputKeyMap")
local var1_result1_upvr_3 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr = any_load_result1("UIPaddingUtils")
return function(arg1) -- Line 42
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr_6 (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr (readonly)
		[6]: createTextBox_upvr (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr_5.new()
	local any_new_result1 = var1_result1_upvr_4.new()
	local service = any_new_result1:GetService(var1_result1_upvr_6)
	any_new_result1_2_upvr:GiveTask(any_new_result1)
	var1_result1_upvr_3.createThemeButton(any_new_result1_2_upvr, any_new_result1, arg1)
	local Frame_2 = Instance.new("Frame")
	Frame_2.Size = UDim2.new(1, 0, 1, 0)
	Frame_2.BackgroundTransparency = 1
	Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	any_new_result1_2_upvr:GiveTask(Frame_2)
	local any_fromUDim_result1 = var1_result1_upvr.fromUDim(UDim.new(0, 30))
	any_fromUDim_result1.Parent = Frame_2
	any_new_result1_2_upvr:GiveTask(any_fromUDim_result1)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.Parent = Frame_2
	createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2):HintActivationKey(service:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	local createTextBox_upvr_result1_2 = createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2)
	createTextBox_upvr_result1_2:SetText("Invalid state example")
	createTextBox_upvr_result1_2:SetInvalid(true)
	local createTextBox_result1 = createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2)
	createTextBox_result1:HintActivationKey(service:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	createTextBox_result1:SetText(longstring1)
	createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2):SetText(longstring1)
	local createTextBox_upvr_result1 = createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2, 75)
	createTextBox_upvr_result1:HintActivationKey(service:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	createTextBox_upvr_result1:SetText(longstring1)
	createTextBox_upvr(any_new_result1, any_new_result1_2_upvr, Frame_2):SetText("Fuck")
	Frame_2.Parent = arg1
	return function() -- Line 88
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:DoCleaning()
	end
end