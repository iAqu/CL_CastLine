-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:15
-- Luau version 6, Types version 3
-- Time taken: 0.002209 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogTextBoxButton")
local function createButton_upvr(arg1, arg2, arg3, arg4) -- Line 15, Named "createButton"
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
	arg2:GiveTask(any_new_result1_upvr)
	any_new_result1_upvr.Gui.Parent = Frame
	Frame.Parent = arg3
	any_new_result1_upvr:Show()
	arg2:GiveTask(any_new_result1_upvr.Activated:Connect(function() -- Line 31
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Hide()
		task.delay(2, function() -- Line 34
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (copied, readonly)
			]]
			if any_new_result1_upvr.Destroy then
				any_new_result1_upvr:Show()
			end
		end)
	end))
	return any_new_result1_upvr
end
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr_6 = any_load_result1("ServiceBag")
local var1_result1_upvr_3 = any_load_result1("DialogInputKeyMap")
local var1_result1_upvr = any_load_result1("SharedInputKeyMap")
local var1_result1_upvr_7 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_4 = any_load_result1("UIPaddingUtils")
return function(arg1) -- Line 44
	--[[ Upvalues[7]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr (readonly)
		[5]: var1_result1_upvr_7 (readonly)
		[6]: var1_result1_upvr_4 (readonly)
		[7]: createButton_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_5.new()
	local any_new_result1 = var1_result1_upvr_6.new()
	local service = any_new_result1:GetService(var1_result1_upvr_3)
	local service_2 = any_new_result1:GetService(var1_result1_upvr)
	any_new_result1_upvr_2:GiveTask(any_new_result1)
	var1_result1_upvr_7.createThemeButton(any_new_result1_upvr_2, any_new_result1, arg1)
	local Frame_2 = Instance.new("Frame")
	Frame_2.Size = UDim2.new(1, 0, 1, 0)
	Frame_2.BackgroundTransparency = 1
	Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	any_new_result1_upvr_2:GiveTask(Frame_2)
	local any_fromUDim_result1 = var1_result1_upvr_4.fromUDim(UDim.new(0, 30))
	any_fromUDim_result1.Parent = Frame_2
	any_new_result1_upvr_2:GiveTask(any_fromUDim_result1)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.Parent = Frame_2
	createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2):SetText("OnlyTwentyCharacters")
	local createButton_upvr_result1_2 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2)
	createButton_upvr_result1_2:SetText("Confirm")
	createButton_upvr_result1_2:SetActivationHint(service:GetInputKeyMapList("DIALOG_CONFIRM_SHORTCUT"))
	local createButton_result1 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2)
	createButton_result1:SetText("OnlyTwentyCharacters But My Text Can be Longer")
	createButton_result1:SetActivationHint(service_2:GetInputKeyMapList("PRIMARY"))
	local createButton_upvr_result1 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2)
	createButton_upvr_result1:SetText("Confirm")
	createButton_upvr_result1:SetActivationHint(service_2:GetInputKeyMapList("PRIMARY"))
	local createButton_upvr_result1_3 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2)
	createButton_upvr_result1_3:SetText(nil)
	createButton_upvr_result1_3:SetActivationHint(service_2:GetInputKeyMapList("PRIMARY"))
	local createButton_result1_3 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2, 25)
	createButton_result1_3:SetText("Testing")
	createButton_result1_3:SetActivationHint(service_2:GetInputKeyMapList("PRIMARY"))
	local createButton_result1_2 = createButton_upvr(any_new_result1, any_new_result1_upvr_2, Frame_2)
	createButton_result1_2:SetText("Confirm")
	createButton_result1_2:SetActivationHint(service:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"))
	Frame_2.Parent = arg1
	return function() -- Line 97
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
	end
end