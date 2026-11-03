-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:56
-- Luau version 6, Types version 3
-- Time taken: 0.002637 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("HintInput")
local function makeInput_upvr(arg1, arg2, arg3, arg4) -- Line 17, Named "makeInput"
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_3.new(arg1, arg4)
	arg2:GiveTask(any_new_result1)
	any_new_result1:Show()
	any_new_result1.Gui.Size = UDim2.new(1, 0, 1, 0)
	any_new_result1.Gui.BackgroundTransparency = 0.5
	any_new_result1.Gui.Parent = arg3
end
local RunService_upvr = game:GetService("RunService")
local function makeChangingInput_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 28, Named "makeChangingInput"
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local any_new_result1_5_upvr = any_load_result1_result1_upvr_3.new(arg1)
	arg2:GiveTask(any_new_result1_5_upvr)
	any_new_result1_5_upvr:Show()
	arg2:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 34
		--[[ Upvalues[3]:
			[1]: any_new_result1_5_upvr (readonly)
			[2]: arg4 (readonly)
			[3]: arg5 (readonly)
		]]
		if os.clock() % 1 < 0.5 then
			any_new_result1_5_upvr:SetInputKeyMapList(arg4)
		else
			any_new_result1_5_upvr:SetInputKeyMapList(arg5)
		end
	end))
	any_new_result1_5_upvr.Gui.Size = UDim2.new(1, 0, 1, 0)
	any_new_result1_5_upvr.Gui.BackgroundTransparency = 0.5
	any_new_result1_5_upvr.Gui.Parent = arg3
end
local any_load_result1_result1_upvr_5 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr_6 = any_load_result1("InputKeyMapList")
local var1_result1_upvr = any_load_result1("InputKeyMap")
local any_load_result1_result1_upvr_2 = any_load_result1("InputModeTypes")
local any_load_result1_result1_upvr_4 = any_load_result1("SlottedTouchButtonUtils")
return function(arg1) -- Line 47
	--[[ Upvalues[8]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_6 (readonly)
		[4]: var1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_2 (readonly)
		[6]: any_load_result1_result1_upvr_4 (readonly)
		[7]: makeInput_upvr (readonly)
		[8]: makeChangingInput_upvr (readonly)
	]]
	local any_new_result1_3_upvr = any_load_result1_result1_upvr_5.new()
	local any_new_result1_4 = any_load_result1_result1_upvr.new()
	any_new_result1_3_upvr:GiveTask(any_new_result1_4)
	local any_new_result1_6 = any_load_result1_result1_upvr_6.new("Primary", {var1_result1_upvr.new(any_load_result1_result1_upvr_2.KeyboardAndMouse, {Enum.UserInputType.MouseButton1}), var1_result1_upvr.new(any_load_result1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonA}), var1_result1_upvr.new(any_load_result1_result1_upvr_2.Touch, {"Tap"})}, {
		bindingName = "Primary binding";
		rebindable = false;
	})
	any_new_result1_3_upvr:GiveTask(any_new_result1_6)
	local any_new_result1_2 = any_load_result1_result1_upvr_6.new("Secondary", {var1_result1_upvr.new(any_load_result1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.E}), var1_result1_upvr.new(any_load_result1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonY}), var1_result1_upvr.new(any_load_result1_result1_upvr_2.Touch, {any_load_result1_result1_upvr_4.createSlottedTouchButton("primary2")})}, {
		bindingName = "Secondary";
		rebindable = false;
	})
	any_new_result1_3_upvr:GiveTask(any_new_result1_2)
	local any_new_result1_7 = any_load_result1_result1_upvr_6.new("Custom", {var1_result1_upvr.new(any_load_result1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.A, Enum.KeyCode.B})}, {
		bindingName = "Custom";
		rebindable = false;
	})
	any_new_result1_3_upvr:GiveTask(any_new_result1_7)
	local Frame = Instance.new("Frame")
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(1, 0, 1, 0)
	any_new_result1_3_upvr:GiveTask(Frame)
	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellPadding = UDim2.fromOffset(50, 50)
	UIGridLayout.CellSize = UDim2.new(0, 50, 0, 50)
	UIGridLayout.Parent = Frame
	makeInput_upvr(any_new_result1_4, any_new_result1_3_upvr, Frame, any_new_result1_6)
	makeInput_upvr(any_new_result1_4, any_new_result1_3_upvr, Frame, any_new_result1_2)
	makeInput_upvr(any_new_result1_4, any_new_result1_3_upvr, Frame, any_new_result1_7)
	makeChangingInput_upvr(any_new_result1_4, any_new_result1_3_upvr, Frame, any_new_result1_6, any_new_result1_2)
	Frame.Parent = arg1
	return function() -- Line 105
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end