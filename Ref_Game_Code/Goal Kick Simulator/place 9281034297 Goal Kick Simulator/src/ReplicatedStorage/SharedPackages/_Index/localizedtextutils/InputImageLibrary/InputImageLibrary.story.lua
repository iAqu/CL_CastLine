-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:46
-- Luau version 6, Types version 3
-- Time taken: 0.003998 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local tbl_upvr_2 = {Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonR2, Enum.KeyCode.Menu, Enum.KeyCode.ButtonSelect, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2, "DPad"}
local tbl_upvr = {Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Space, Enum.KeyCode.Backspace, Enum.KeyCode.LeftControl, Enum.KeyCode.Tab, Enum.KeyCode.Return, Enum.KeyCode.Delete, Enum.KeyCode.Backspace, Enum.KeyCode.A, Enum.KeyCode.B, Enum.KeyCode.C, Enum.KeyCode.D, Enum.KeyCode.E, Enum.KeyCode.F, Enum.KeyCode.G, Enum.KeyCode.H, Enum.KeyCode.I, Enum.KeyCode.J, Enum.KeyCode.K, Enum.KeyCode.L, Enum.KeyCode.M, Enum.KeyCode.N, Enum.KeyCode.O, Enum.KeyCode.P, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.S, Enum.KeyCode.T, Enum.KeyCode.U, Enum.KeyCode.V, Enum.KeyCode.W, Enum.KeyCode.X, Enum.KeyCode.Y, Enum.KeyCode.Z, Enum.KeyCode.Zero, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine}
local tbl_upvr_3 = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseWheel, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseMovement}
local var1_result1_upvr_4 = any_load_result1("UICornerUtils")
local var1_result1_upvr = any_load_result1("UIPaddingUtils")
local var1_result1_upvr_2 = any_load_result1("String")
local var1_result1_upvr_5 = any_load_result1("InputImageLibrary")
local function create_upvr(arg1, arg2, arg3) -- Line 93, Named "create"
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr_5 (readonly)
	]]
	local Frame_2 = Instance.new("Frame")
	Frame_2.BorderSizePixel = 0
	Frame_2.Size = UDim2.new(1, 0, 1, 0)
	var1_result1_upvr_4.fromOffset(8, Frame_2)
	var1_result1_upvr.fromUDim(UDim.new(0, 5)).Parent = Frame_2
	local TextLabel = Instance.new("TextLabel")
	local var11
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var11 = arg1
		return var11
	end
	if type(arg1) ~= "string" or not INLINED() then
		var11 = arg1.Name
	end
	TextLabel.Text = var1_result1_upvr_2.removePrefix(var11, "Mouse")
	TextLabel.TextSize = 20
	TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel.Font = Enum.Font.Highway
	var11 = 0.1
	TextLabel.TextColor3 = Color3.new(var11, 0.1, 0.1)
	var11 = 1
	TextLabel.Size = UDim2.new(var11, 0, 0, 30)
	var11 = 0.5
	TextLabel.AnchorPoint = Vector2.new(var11, 0)
	var11 = 0.5
	TextLabel.Position = UDim2.new(var11, 0, 0, 0)
	TextLabel.TextWrapped = false
	TextLabel.BackgroundTransparency = 1
	TextLabel.LayoutOrder = 2
	TextLabel.Parent = Frame_2
	var11 = "UIListLayout"
	Instance.new(var11).Parent = Frame_2
	var11 = var1_result1_upvr_5:GetScaledImageLabel(arg1, arg2)
	var11.Parent = Frame_2
	Frame_2.Parent = arg3
end
local function makeTitle_upvr(arg1, arg2) -- Line 126, Named "makeTitle"
	local TextLabel_2 = Instance.new("TextLabel")
	TextLabel_2.Text = arg1
	TextLabel_2.TextSize = 24
	TextLabel_2.TextColor3 = Color3.new(0, 0, 0)
	TextLabel_2.TextColor3 = Color3.new(0.1, 0.1, 0.1)
	TextLabel_2.Font = Enum.Font.Highway
	TextLabel_2.Size = UDim2.new(1, -10, 0, 40)
	TextLabel_2.AnchorPoint = Vector2.new(0.5, 0)
	TextLabel_2.Position = UDim2.new(0.5, 0, 0, 0)
	TextLabel_2.TextWrapped = true
	TextLabel_2.BackgroundTransparency = 1
	TextLabel_2.LayoutOrder = 2
	TextLabel_2.Parent = arg2
	return TextLabel_2
end
local function makeSection_upvr(arg1, arg2, arg3) -- Line 144, Named "makeSection"
	--[[ Upvalues[1]:
		[1]: create_upvr (readonly)
	]]
	local Frame = Instance.new("Frame")
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(1, 0, 1, 0)
	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellSize = UDim2.new(0, 100, 0, 130)
	UIGridLayout.Parent = Frame
	for _, v in pairs(arg1) do
		create_upvr(v, arg2, Frame)
	end
	Frame.Parent = arg3
	Frame.Size = UDim2.new(1, 0, 0, UIGridLayout.AbsoluteContentSize.y)
	return Frame
end
local var1_result1_upvr_3 = any_load_result1("Maid")
return function(arg1) -- Line 168
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: makeTitle_upvr (readonly)
		[3]: makeSection_upvr (readonly)
		[4]: tbl_upvr_3 (readonly)
		[5]: tbl_upvr_2 (readonly)
		[6]: tbl_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	local ScrollingFrame = Instance.new("ScrollingFrame")
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.CanvasSize = UDim2.new(1, 0, 5, 0)
	ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	ScrollingFrame.BackgroundTransparency = 0
	ScrollingFrame.BorderSizePixel = 0
	any_new_result1_upvr:GiveTask(ScrollingFrame)
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollingFrame
	ScrollingFrame.Parent = arg1
	local var27_upvw = 1
	local function _(arg1_2) -- Line 186, Named "add"
		--[[ Upvalues[1]:
			[1]: var27_upvw (read and write)
		]]
		var27_upvw += 1
		arg1_2.LayoutOrder = var27_upvw
	end
	var27_upvw += 1
	local var28 = var27_upvw
	makeTitle_upvr("Mouse Light", ScrollingFrame).LayoutOrder = var28
	var28 += 1
	local var29 = var28
	makeSection_upvr(tbl_upvr_3, "Light", ScrollingFrame).LayoutOrder = var29
	var29 += 1
	local var30 = var29
	makeTitle_upvr("Mouse Dark", ScrollingFrame).LayoutOrder = var30
	var30 += 1
	local var31 = var30
	makeSection_upvr(tbl_upvr_3, "Dark", ScrollingFrame).LayoutOrder = var31
	var31 += 1
	local var32 = var31
	makeTitle_upvr("XBox Dark", ScrollingFrame).LayoutOrder = var32
	var32 += 1
	local var33 = var32
	makeSection_upvr(tbl_upvr_2, "Dark", ScrollingFrame).LayoutOrder = var33
	var33 += 1
	local var34 = var33
	makeTitle_upvr("XBox Light", ScrollingFrame).LayoutOrder = var34
	var34 += 1
	local var35 = var34
	makeSection_upvr(tbl_upvr_2, "Light", ScrollingFrame).LayoutOrder = var35
	var35 += 1
	local var36 = var35
	makeTitle_upvr("Keyboard Dark", ScrollingFrame).LayoutOrder = var36
	var36 += 1
	local var37 = var36
	makeSection_upvr(tbl_upvr, "Dark", ScrollingFrame).LayoutOrder = var37
	var37 += 1
	local var38 = var37
	makeTitle_upvr("Keyboard Light", ScrollingFrame).LayoutOrder = var38
	var38 += 1
	makeSection_upvr(tbl_upvr, "Light", ScrollingFrame).LayoutOrder = var38
	return function() -- Line 210
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end