-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:30
-- Luau version 6, Types version 3
-- Time taken: 0.026866 seconds

local Players_upvr = game:GetService("Players")
local Chat_upvr = game:GetService("Chat")
local var3_upvw
while var3_upvw == nil do
	Players_upvr.ChildAdded:wait()
	var3_upvw = Players_upvr.LocalPlayer
end
local pcall_result1_3, pcall_result2_4 = pcall(function() -- Line 24
	return UserSettings():IsUserFeatureEnabled("UserShouldLocalizeGameChatBubble")
end)
local pcall_result1_2, pcall_result2 = pcall(function() -- Line 30
	return UserSettings():IsUserFeatureEnabled("UserFixBubbleChatText")
end)
local var10_upvw = pcall_result1_2 and pcall_result2
local pcall_result1_4, pcall_result2_3 = pcall(function() -- Line 37
	return UserSettings():IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)
local var14_upvw = pcall_result1_4 and pcall_result2_3
local pcall_result1, pcall_result2_2 = pcall(function() -- Line 44
	return UserSettings():IsUserFeatureEnabled("UserPreventOldBubbleChatOverlap")
end)
local var18_upvw = pcall_result1 and pcall_result2_2
local function _(arg1) -- Line 50, Named "getMessageLength"
	return utf8.len(utf8.nfcnormalize(arg1))
end
local SourceSans_upvr = Enum.Font.SourceSans
local tbl_3_upvr = {
	WHITE = "dub";
	BLUE = "blu";
	GREEN = "gre";
	RED = "red";
}
local ScreenGui_upvr = Instance.new("ScreenGui")
ScreenGui_upvr.Name = "BubbleChat"
ScreenGui_upvr.ResetOnSpawn = false
ScreenGui_upvr.Parent = var3_upvw:WaitForChild("PlayerGui")
local function _(arg1, arg2, arg3) -- Line 93, Named "lerpLength"
	return arg2 + (arg3 - arg2) * math.min(utf8.len(utf8.nfcnormalize(arg1)) / 75, 1)
end
local function createFifo_upvr() -- Line 97, Named "createFifo"
	local module_upvr = {
		data = {};
	}
	local BindableEvent_upvr = Instance.new("BindableEvent")
	module_upvr.Emptied = BindableEvent_upvr.Event
	local function Size(arg1) -- Line 104
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		return #module_upvr.data
	end
	module_upvr.Size = Size
	function module_upvr.Empty(arg1) -- Line 108
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		local var24
		if module_upvr:Size() > 0 then
			var24 = false
		else
			var24 = true
		end
		return var24
	end
	function module_upvr.PopFront(arg1) -- Line 112
		--[[ Upvalues[2]:
			[1]: module_upvr (readonly)
			[2]: BindableEvent_upvr (readonly)
		]]
		table.remove(module_upvr.data, 1)
		if module_upvr:Empty() then
			BindableEvent_upvr:Fire()
		end
	end
	function module_upvr.Front(arg1) -- Line 117
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		return module_upvr.data[1]
	end
	local function Get(arg1, arg2) -- Line 121
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		return module_upvr.data[arg2]
	end
	module_upvr.Get = Get
	function module_upvr.PushBack(arg1, arg2) -- Line 125
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		table.insert(module_upvr.data, arg2)
	end
	local function GetData(arg1) -- Line 129
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		return module_upvr.data
	end
	module_upvr.GetData = GetData
	return module_upvr
end
local function _() -- Line 136, Named "createCharacterChats"
	--[[ Upvalues[1]:
		[1]: createFifo_upvr (readonly)
	]]
	return {
		Fifo = createFifo_upvr();
		BillboardGui = nil;
	}
end
local function createChatLine_upvr(arg1, arg2, arg3) -- Line 184, Named "createChatLine"
	local module_3 = {
		ComputeBubbleLifetime = function(arg1_2, arg2_2, arg3_2) -- Line 187, Named "ComputeBubbleLifetime"
			if arg3_2 then
				return 8 + 7 * math.min(utf8.len(utf8.nfcnormalize(arg2_2)) / 75, 1)
			end
			return 12 + 8 * math.min(utf8.len(utf8.nfcnormalize(arg2_2)) / 75, 1)
		end;
		Origin = nil;
		RenderBubble = nil;
	}
	module_3.Message = arg1
	module_3.BubbleDieDelay = module_3:ComputeBubbleLifetime(arg1, arg3)
	module_3.BubbleColor = arg2
	module_3.IsLocalPlayer = arg3
	return module_3
end
local function _(arg1, arg2, arg3) -- Line 205, Named "createPlayerChatLine"
	--[[ Upvalues[2]:
		[1]: createChatLine_upvr (readonly)
		[2]: tbl_3_upvr (readonly)
	]]
	local createChatLine_upvr_result1_2 = createChatLine_upvr(arg2, tbl_3_upvr.WHITE, arg3)
	if arg1 then
		createChatLine_upvr_result1_2.User = arg1.Name
		createChatLine_upvr_result1_2.Origin = arg1.Character
	end
	return createChatLine_upvr_result1_2
end
local function _(arg1, arg2, arg3, arg4) -- Line 216, Named "createGameChatLine"
	--[[ Upvalues[1]:
		[1]: createChatLine_upvr (readonly)
	]]
	local createChatLine_result1 = createChatLine_upvr(arg2, arg4, arg3)
	createChatLine_result1.Origin = arg1
	return createChatLine_result1
end
function createChatBubbleMain(arg1, arg2) -- Line 223
	local ImageLabel_2 = Instance.new("ImageLabel")
	ImageLabel_2.Name = "ChatBubble"
	ImageLabel_2.ScaleType = Enum.ScaleType.Slice
	ImageLabel_2.SliceCenter = arg2
	ImageLabel_2.Image = "rbxasset://textures/"..tostring(arg1)..".png"
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.BorderSizePixel = 0
	ImageLabel_2.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel_2.Position = UDim2.new(0, 0, 0, 0)
	return ImageLabel_2
end
function createChatBubbleTail(arg1, arg2) -- Line 237
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.Name = "ChatBubbleTail"
	ImageLabel.Image = "rbxasset://textures/ui/dialog_tail.png"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = arg1
	ImageLabel.Size = arg2
	return ImageLabel
end
function createChatBubbleWithTail(arg1, arg2, arg3, arg4) -- Line 249
	local createChatBubbleMain_result1_2 = createChatBubbleMain(arg1, arg4)
	createChatBubbleTail(arg2, arg3).Parent = createChatBubbleMain_result1_2
	return createChatBubbleMain_result1_2
end
function createScaledChatBubbleWithTail(arg1, arg2, arg3, arg4) -- Line 258
	local createChatBubbleMain_result1 = createChatBubbleMain(arg1, arg4)
	local Frame = Instance.new("Frame")
	Frame.Name = "ChatBubbleTailFrame"
	Frame.BackgroundTransparency = 1
	Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
	Frame.Position = UDim2.new(0.5, 0, 1, 0)
	Frame.Size = UDim2.new(arg2, 0, arg2, 0)
	Frame.Parent = createChatBubbleMain_result1
	createChatBubbleTail(arg3, UDim2.new(1, 0, 0.5, 0)).Parent = Frame
	return createChatBubbleMain_result1
end
function createChatImposter(arg1, arg2, arg3) -- Line 275
	local ImageLabel_4 = Instance.new("ImageLabel")
	ImageLabel_4.Name = "DialogPlaceholder"
	ImageLabel_4.Image = "rbxasset://textures/"..tostring(arg1)..".png"
	ImageLabel_4.BackgroundTransparency = 1
	ImageLabel_4.BorderSizePixel = 0
	ImageLabel_4.Position = UDim2.new(0, 0, -1.25, 0)
	ImageLabel_4.Size = UDim2.new(1, 0, 1, 0)
	local ImageLabel_3 = Instance.new("ImageLabel")
	ImageLabel_3.Name = "DotDotDot"
	ImageLabel_3.Image = "rbxasset://textures/"..tostring(arg2)..".png"
	ImageLabel_3.BackgroundTransparency = 1
	ImageLabel_3.BorderSizePixel = 0
	ImageLabel_3.Position = UDim2.new(0.001, 0, arg3, 0)
	ImageLabel_3.Size = UDim2.new(1, 0, 0.7, 0)
	ImageLabel_3.Parent = ImageLabel_4
	return ImageLabel_4
end
local tbl_2_upvr = {
	ChatBubble = {};
	ChatBubbleWithTail = {};
	ScalingChatBubbleWithTail = {};
	CharacterSortedMsg = (function() -- Line 145, Named "createMap"
		--[[ Upvalues[1]:
			[1]: createFifo_upvr (readonly)
		]]
		local module_2_upvr = {
			data = {};
		}
		local var27_upvw = 0
		function module_2_upvr.Size(arg1) -- Line 150
			--[[ Upvalues[1]:
				[1]: var27_upvw (read and write)
			]]
			return var27_upvw
		end
		function module_2_upvr.Erase(arg1, arg2) -- Line 154
			--[[ Upvalues[2]:
				[1]: module_2_upvr (readonly)
				[2]: var27_upvw (read and write)
			]]
			if module_2_upvr.data[arg2] then
				var27_upvw -= 1
			end
			module_2_upvr.data[arg2] = nil
		end
		function module_2_upvr.Set(arg1, arg2, arg3) -- Line 159
			--[[ Upvalues[2]:
				[1]: module_2_upvr (readonly)
				[2]: var27_upvw (read and write)
			]]
			module_2_upvr.data[arg2] = arg3
			if arg3 then
				var27_upvw += 1
			end
		end
		function module_2_upvr.Get(arg1, arg2) -- Line 164
			--[[ Upvalues[2]:
				[1]: module_2_upvr (readonly)
				[2]: createFifo_upvr (copied, readonly)
			]]
			if not arg2 then return end
			if not module_2_upvr.data[arg2] then
				module_2_upvr.data[arg2] = {
					Fifo = createFifo_upvr();
					BillboardGui = nil;
				}
				local var30_upvw
				var30_upvw = module_2_upvr.data[arg2].Fifo.Emptied:connect(function() -- Line 169
					--[[ Upvalues[3]:
						[1]: var30_upvw (read and write)
						[2]: module_2_upvr (copied, readonly)
						[3]: arg2 (readonly)
					]]
					var30_upvw:disconnect()
					module_2_upvr:Erase(arg2)
				end)
			end
			return module_2_upvr.data[arg2]
		end
		function module_2_upvr.GetData(arg1) -- Line 177
			--[[ Upvalues[1]:
				[1]: module_2_upvr (readonly)
			]]
			return module_2_upvr.data
		end
		return module_2_upvr
	end)();
}
local function initChatBubbleType(arg1, arg2, arg3, arg4, arg5) -- Line 304
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	tbl_2_upvr.ChatBubble[arg1] = createChatBubbleMain(arg2, arg5)
	local var42
	if arg4 then
		var42 = -1
	else
		var42 = 0
	end
	var42 = 0
	tbl_2_upvr.ChatBubbleWithTail[arg1] = createChatBubbleWithTail(arg2, UDim2.new(0.5, -14, 1, var42), UDim2.new(0, 30, var42, 14), arg5)
	var42 = 0
	if arg4 then
	else
	end
	tbl_2_upvr.ScalingChatBubbleWithTail[arg1] = createScaledChatBubbleWithTail(arg2, 0.5, UDim2.new(-0.5, 0, var42, 0), arg5)
end
initChatBubbleType(tbl_3_upvr.WHITE, "ui/dialog_white", "ui/chatBubble_white_notify_bkg", false, Rect.new(5, 5, 15, 15))
initChatBubbleType(tbl_3_upvr.BLUE, "ui/dialog_blue", "ui/chatBubble_blue_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType(tbl_3_upvr.RED, "ui/dialog_red", "ui/chatBubble_red_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType(tbl_3_upvr.GREEN, "ui/dialog_green", "ui/chatBubble_green_notify_bkg", true, Rect.new(7, 7, 33, 33))
local var43_upvr = 128 - utf8.len(utf8.nfcnormalize("...")) - 1
function tbl_2_upvr.SanitizeChatLine(arg1, arg2) -- Line 315
	--[[ Upvalues[1]:
		[1]: var43_upvr (readonly)
	]]
	if var43_upvr < utf8.len(utf8.nfcnormalize(arg2)) then
		return string.sub(arg2, 1, utf8.offset(arg2, var43_upvr + utf8.len(utf8.nfcnormalize("...")) + 1) - 1)
	end
	return arg2
end
local function createBillboardInstance_upvr(arg1) -- Line 324, Named "createBillboardInstance"
	--[[ Upvalues[3]:
		[1]: ScreenGui_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: tbl_3_upvr (readonly)
	]]
	local BillboardGui_upvr = Instance.new("BillboardGui")
	BillboardGui_upvr.Adornee = arg1
	BillboardGui_upvr.Size = UDim2.new(0, 400, 0, 250)
	BillboardGui_upvr.StudsOffset = Vector3.new(0, 1.5, 2)
	BillboardGui_upvr.Parent = ScreenGui_upvr
	local Frame_upvr = Instance.new("Frame")
	Frame_upvr.Name = "BillboardFrame"
	Frame_upvr.Size = UDim2.new(1, 0, 1, 0)
	Frame_upvr.Position = UDim2.new(0, 0, -0.5, 0)
	Frame_upvr.BackgroundTransparency = 1
	Frame_upvr.Parent = BillboardGui_upvr
	local var47_upvw
	var47_upvw = Frame_upvr.ChildRemoved:connect(function() -- Line 339
		--[[ Upvalues[3]:
			[1]: Frame_upvr (readonly)
			[2]: var47_upvw (read and write)
			[3]: BillboardGui_upvr (readonly)
		]]
		if #Frame_upvr:GetChildren() <= 1 then
			var47_upvw:disconnect()
			BillboardGui_upvr:Destroy()
		end
	end)
	tbl_2_upvr:CreateSmallTalkBubble(tbl_3_upvr.WHITE).Parent = Frame_upvr
	return BillboardGui_upvr
end
function tbl_2_upvr.CreateBillboardGuiHelper(arg1, arg2, arg3) -- Line 351
	--[[ Upvalues[2]:
		[1]: tbl_2_upvr (readonly)
		[2]: createBillboardInstance_upvr (readonly)
	]]
	if arg2 and not tbl_2_upvr.CharacterSortedMsg:Get(arg2).BillboardGui then
		if not arg3 and arg2:IsA("BasePart") then
			tbl_2_upvr.CharacterSortedMsg:Get(arg2).BillboardGui = createBillboardInstance_upvr(arg2)
			return
		end
		if arg2:IsA("Model") then
			local Head = arg2:FindFirstChild("Head")
			if Head and Head:IsA("BasePart") then
				tbl_2_upvr.CharacterSortedMsg:Get(arg2).BillboardGui = createBillboardInstance_upvr(Head)
			end
		end
	end
end
local function _(arg1) -- Line 373, Named "distanceToBubbleOrigin"
	if not arg1 then
		return 100000
	end
	return (arg1.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude
end
local function _(arg1) -- Line 379, Named "isPartOfLocalPlayer"
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	if arg1 and Players_upvr.LocalPlayer.Character then
		return arg1:IsDescendantOf(Players_upvr.LocalPlayer.Character)
	end
end
function tbl_2_upvr.SetBillboardLODNear(arg1, arg2) -- Line 385
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 24 start (CF ANALYSIS FAILED)
	local Adornee = arg2.Adornee
	local var55
	if Adornee and Players_upvr.LocalPlayer.Character then
		var55 = Adornee:IsDescendantOf(Players_upvr.LocalPlayer.Character)
	else
		var55 = nil
	end
	arg2.Size = UDim2.new(0, 400, 0, 250)
	if var55 then
		-- KONSTANTWARNING: GOTO [34] #27
	end
	-- KONSTANTERROR: [0] 1. Error Block 24 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [33] 26. Error Block 26 start (CF ANALYSIS FAILED)
	if var55 then
	else
	end
	arg2.StudsOffset = Vector3.new(0, 2.5, 0.1)
	arg2.Enabled = true
	local children_2 = arg2.BillboardFrame:GetChildren()
	for i = 1, #children_2 do
		children_2[i].Visible = true
		local _
	end
	arg2.BillboardFrame.SmallTalkBubble.Visible = false
	-- KONSTANTERROR: [33] 26. Error Block 26 end (CF ANALYSIS FAILED)
end
function tbl_2_upvr.SetBillboardLODDistant(arg1, arg2) -- Line 397
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Adornee_2 = arg2.Adornee
	local var63
	if Adornee_2 and Players_upvr.LocalPlayer.Character then
		var63 = Adornee_2:IsDescendantOf(Players_upvr.LocalPlayer.Character)
	else
		var63 = nil
	end
	arg2.Size = UDim2.new(4, 0, 3, 0)
	if var63 then
	else
	end
	arg2.StudsOffset = Vector3.new(0, 3, 0.1)
	arg2.Enabled = true
	local children = arg2.BillboardFrame:GetChildren()
	for i_2 = 1, #children do
		children[i_2].Visible = false
		local _
	end
	arg2.BillboardFrame.SmallTalkBubble.Visible = true
end
function tbl_2_upvr.SetBillboardLODVeryFar(arg1, arg2) -- Line 409
	arg2.Enabled = false
end
function tbl_2_upvr.SetBillboardGuiLOD(arg1, arg2, arg3) -- Line 413
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	if not arg3 then
	else
		if arg3:IsA("Model") then
			local Head_2 = arg3:FindFirstChild("Head")
			if not Head_2 then
			else
			end
		end
		local var67 = Head_2
		if not var67 then
			local _ = 100000
		else
		end
		if (var67.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude < 65 then
			tbl_2_upvr:SetBillboardLODNear(arg2)
			return
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
		if 65 <= (var67.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude and (var67.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position).magnitude < 100 then
			tbl_2_upvr:SetBillboardLODDistant(arg2)
			return
		end
		tbl_2_upvr:SetBillboardLODVeryFar(arg2)
	end
end
function tbl_2_upvr.CameraCFrameChanged(arg1) -- Line 433
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	for i_3, v in pairs(tbl_2_upvr.CharacterSortedMsg:GetData()) do
		local BillboardGui_2 = v.BillboardGui
		if BillboardGui_2 then
			tbl_2_upvr:SetBillboardGuiLOD(BillboardGui_2, i_3)
		end
	end
end
local Size24_upvr = Enum.FontSize.Size24
function tbl_2_upvr.CreateBubbleText(arg1, arg2, arg3) -- Line 440
	--[[ Upvalues[3]:
		[1]: var10_upvw (read and write)
		[2]: SourceSans_upvr (readonly)
		[3]: Size24_upvr (readonly)
	]]
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "BubbleText"
	TextLabel.BackgroundTransparency = 1
	if var10_upvw then
		TextLabel.Size = UDim2.fromScale(1, 1)
	else
		TextLabel.Position = UDim2.new(0, 15, 0, 0)
		TextLabel.Size = UDim2.new(1, -30, 1, 0)
	end
	TextLabel.Font = SourceSans_upvr
	TextLabel.ClipsDescendants = true
	TextLabel.TextWrapped = true
	TextLabel.FontSize = Size24_upvr
	TextLabel.Text = arg2
	TextLabel.Visible = false
	TextLabel.AutoLocalize = arg3
	if var10_upvw then
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingTop = UDim.new(0, 12)
		UIPadding.PaddingRight = UDim.new(0, 12)
		UIPadding.PaddingBottom = UDim.new(0, 12)
		UIPadding.PaddingLeft = UDim.new(0, 12)
		UIPadding.Parent = TextLabel
	end
	return TextLabel
end
function tbl_2_upvr.CreateSmallTalkBubble(arg1, arg2) -- Line 472
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local clone = tbl_2_upvr.ScalingChatBubbleWithTail[arg2]:Clone()
	clone.Name = "SmallTalkBubble"
	clone.AnchorPoint = Vector2.new(0, 0.5)
	clone.Position = UDim2.new(0, 0, 0.5, 0)
	clone.Visible = false
	local any_CreateBubbleText_result1 = tbl_2_upvr:CreateBubbleText("...")
	any_CreateBubbleText_result1.TextScaled = true
	any_CreateBubbleText_result1.TextWrapped = false
	any_CreateBubbleText_result1.Visible = true
	any_CreateBubbleText_result1.Parent = clone
	return clone
end
function tbl_2_upvr.UpdateChatLinesForOrigin(arg1, arg2, arg3) -- Line 487
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local Fifo_2 = tbl_2_upvr.CharacterSortedMsg:Get(arg2).Fifo
	local any_GetData_result1 = Fifo_2:GetData()
	if #any_GetData_result1 <= 1 then
	else
		for var80 = #any_GetData_result1 - 1, 1, -1 do
			local RenderBubble = any_GetData_result1[var80].RenderBubble
			if not RenderBubble then return end
			if 1 < Fifo_2:Size() - var80 + 1 then
				local ChatBubbleTail = RenderBubble:FindFirstChild("ChatBubbleTail")
				if ChatBubbleTail then
					ChatBubbleTail:Destroy()
				end
				local BubbleText = RenderBubble:FindFirstChild("BubbleText")
				if BubbleText then
					BubbleText.TextTransparency = 0.5
				end
			end
			RenderBubble:TweenPosition(UDim2.new(RenderBubble.Position.X.Scale, RenderBubble.Position.X.Offset, 1, arg3 - RenderBubble.Size.Y.Offset - 14), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
		end
	end
end
function tbl_2_upvr.DestroyBubble(arg1, arg2, arg3) -- Line 513
	if not arg2 then
	else
		if arg2:Empty() then return end
		local RenderBubble_upvw = arg2:Front().RenderBubble
		if not RenderBubble_upvw then
			arg2:PopFront()
			return
		end
		spawn(function() -- Line 523
			--[[ Upvalues[3]:
				[1]: arg2 (readonly)
				[2]: arg3 (readonly)
				[3]: RenderBubble_upvw (read and write)
			]]
			while arg2:Front().RenderBubble ~= arg3 do
				wait()
			end
			RenderBubble_upvw = arg2:Front().RenderBubble
			local BubbleText_2 = RenderBubble_upvw:FindFirstChild("BubbleText")
			local ChatBubbleTail_2 = RenderBubble_upvw:FindFirstChild("ChatBubbleTail")
			while RenderBubble_upvw and RenderBubble_upvw.ImageTransparency < 1 do
				if RenderBubble_upvw then
					local var90 = wait() * 1.5
					RenderBubble_upvw.ImageTransparency += var90
					if BubbleText_2 then
						BubbleText_2.TextTransparency += var90
					end
					if ChatBubbleTail_2 then
						ChatBubbleTail_2.ImageTransparency += var90
					end
				end
			end
			if RenderBubble_upvw then
				RenderBubble_upvw:Destroy()
				arg2:PopFront()
			end
		end)
	end
end
local TextService_upvr = game:GetService("TextService")
function tbl_2_upvr.CreateChatLineRender(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 551
	--[[ Upvalues[4]:
		[1]: tbl_2_upvr (readonly)
		[2]: TextService_upvr (readonly)
		[3]: SourceSans_upvr (readonly)
		[4]: var10_upvw (read and write)
	]]
	if not arg2 then
	else
		if not tbl_2_upvr.CharacterSortedMsg:Get(arg2).BillboardGui then
			tbl_2_upvr:CreateBillboardGuiHelper(arg2, arg4)
		end
		local BillboardGui = tbl_2_upvr.CharacterSortedMsg:Get(arg2).BillboardGui
		if BillboardGui then
			local clone_upvr = tbl_2_upvr.ChatBubbleWithTail[arg3.BubbleColor]:Clone()
			clone_upvr.Visible = false
			local any_CreateBubbleText_result1_upvr = tbl_2_upvr:CreateBubbleText(arg3.Message, arg6)
			any_CreateBubbleText_result1_upvr.Parent = clone_upvr
			clone_upvr.Parent = BillboardGui.BillboardFrame
			arg3.RenderBubble = clone_upvr
			local any_GetTextSize_result1 = TextService_upvr:GetTextSize(any_CreateBubbleText_result1_upvr.Text, 24, SourceSans_upvr, Vector2.new(400, 250))
			if var10_upvw then
				local ceiled = math.ceil(any_GetTextSize_result1.X + 24)
				local var97 = any_GetTextSize_result1.Y / 24 * 34
				clone_upvr.Size = UDim2.fromOffset(0, 0)
				clone_upvr.Position = UDim2.fromScale(0.5, 1)
				clone_upvr:TweenSizeAndPosition(UDim2.fromOffset(ceiled, var97), UDim2.new(0.5, -ceiled / 2, 1, -var97), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function() -- Line 590
					--[[ Upvalues[1]:
						[1]: any_CreateBubbleText_result1_upvr (readonly)
					]]
					any_CreateBubbleText_result1_upvr.Visible = true
				end)
				tbl_2_upvr:SetBillboardGuiLOD(BillboardGui, arg3.Origin)
				tbl_2_upvr:UpdateChatLinesForOrigin(arg3.Origin, -var97)
			else
				local maximum = math.max((any_GetTextSize_result1.X + 30) / 400, 0.1)
				clone_upvr.Size = UDim2.new(0, 0, 0, 0)
				clone_upvr.Position = UDim2.new(0.5, 0, 1, 0)
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				local var100 = any_GetTextSize_result1.Y / 24 * 34
				clone_upvr:TweenSizeAndPosition(UDim2.new(maximum, 0, 0, var100), UDim2.new((1 - maximum) / 2, 0, 1, -var100), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function() -- Line 610
					--[[ Upvalues[1]:
						[1]: any_CreateBubbleText_result1_upvr (readonly)
					]]
					any_CreateBubbleText_result1_upvr.Visible = true
				end)
				tbl_2_upvr:SetBillboardGuiLOD(BillboardGui, arg3.Origin)
				tbl_2_upvr:UpdateChatLinesForOrigin(arg3.Origin, -var100)
			end
			delay(arg3.BubbleDieDelay, function() -- Line 617
				--[[ Upvalues[3]:
					[1]: tbl_2_upvr (copied, readonly)
					[2]: arg5 (readonly)
					[3]: clone_upvr (readonly)
				]]
				tbl_2_upvr:DestroyBubble(arg5, clone_upvr)
			end)
		end
	end
end
function tbl_2_upvr.OnPlayerChatMessage(arg1, arg2, arg3, arg4) -- Line 623
	--[[ Upvalues[4]:
		[1]: tbl_2_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: createChatLine_upvr (readonly)
		[4]: tbl_3_upvr (readonly)
	]]
	if not tbl_2_upvr:BubbleChatEnabled() then
	else
		local LocalPlayer_2 = Players_upvr.LocalPlayer
		local var104 = false
		if LocalPlayer_2 ~= nil then
			if arg2 == LocalPlayer_2 then
				var104 = false
			else
				var104 = true
			end
		end
		local createChatLine_result1_2 = createChatLine_upvr(tbl_2_upvr:SanitizeChatLine(arg3), tbl_3_upvr.WHITE, not var104)
		if arg2 then
			createChatLine_result1_2.User = arg2.Name
			createChatLine_result1_2.Origin = arg2.Character
		end
		local var106 = createChatLine_result1_2
		if arg2 and var106.Origin then
			local Fifo = tbl_2_upvr.CharacterSortedMsg:Get(var106.Origin).Fifo
			Fifo:PushBack(var106)
			tbl_2_upvr:CreateChatLineRender(arg2.Character, var106, true, Fifo, false)
		end
	end
end
local var108_upvr = pcall_result1_3 and pcall_result2_4
function tbl_2_upvr.OnGameChatMessage(arg1, arg2, arg3, arg4) -- Line 642
	--[[ Upvalues[8]:
		[1]: var14_upvw (read and write)
		[2]: var18_upvw (read and write)
		[3]: Chat_upvr (readonly)
		[4]: Players_upvr (readonly)
		[5]: tbl_3_upvr (readonly)
		[6]: tbl_2_upvr (readonly)
		[7]: createChatLine_upvr (readonly)
		[8]: var108_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var109
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var109 = Chat_upvr
		return var109.BubbleChatEnabled
	end
	if var14_upvw or var18_upvw and INLINED() then
	else
		var109 = Players_upvr
		local LocalPlayer = var109.LocalPlayer
		var109 = false
		if LocalPlayer ~= nil then
			if LocalPlayer.Character == arg2 then
				var109 = false
			else
				var109 = true
			end
		end
		if arg4 == Enum.ChatColor.Blue then
		elseif arg4 == Enum.ChatColor.Green then
		elseif arg4 == Enum.ChatColor.Red then
		end
		local createChatLine_upvr_result1 = createChatLine_upvr(tbl_2_upvr:SanitizeChatLine(arg3), tbl_3_upvr.RED, not var109)
		createChatLine_upvr_result1.Origin = arg2
		local var112 = createChatLine_upvr_result1
		tbl_2_upvr.CharacterSortedMsg:Get(var112.Origin).Fifo:PushBack(var112)
		if var108_upvr then
			tbl_2_upvr:CreateChatLineRender(arg2, var112, false, tbl_2_upvr.CharacterSortedMsg:Get(var112.Origin).Fifo, true)
			return
		end
		tbl_2_upvr:CreateChatLineRender(arg2, var112, false, tbl_2_upvr.CharacterSortedMsg:Get(var112.Origin).Fifo, false)
	end
end
function tbl_2_upvr.BubbleChatEnabled(arg1) -- Line 668
	--[[ Upvalues[4]:
		[1]: var14_upvw (read and write)
		[2]: var18_upvw (read and write)
		[3]: Chat_upvr (readonly)
		[4]: Players_upvr (readonly)
	]]
	if var14_upvw or var18_upvw and Chat_upvr.BubbleChatEnabled then
		return false
	end
	local ClientChatModules_5 = Chat_upvr:FindFirstChild("ClientChatModules")
	if ClientChatModules_5 then
		local ChatSettings = ClientChatModules_5:FindFirstChild("ChatSettings")
		if ChatSettings then
			local ChatSettings_5 = require(ChatSettings)
			if ChatSettings_5.BubbleChatEnabled ~= nil then
				return ChatSettings_5.BubbleChatEnabled
			end
		end
	end
	return Players_upvr.BubbleChat
end
function tbl_2_upvr.ShowOwnFilteredMessage(arg1) -- Line 685
	--[[ Upvalues[1]:
		[1]: Chat_upvr (readonly)
	]]
	local ClientChatModules_3 = Chat_upvr:FindFirstChild("ClientChatModules")
	if ClientChatModules_3 then
		local ChatSettings_6 = ClientChatModules_3:FindFirstChild("ChatSettings")
		if ChatSettings_6 then
			return require(ChatSettings_6).ShowUserOwnFilteredMessage
		end
	end
	return false
end
function findPlayer(arg1) -- Line 697
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	for _, v_2 in pairs(Players_upvr:GetPlayers()) do
		if v_2.Name == arg1 then
			return v_2
		end
	end
end
Chat_upvr.Chatted:connect(function(arg1, arg2, arg3) -- Line 705
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	tbl_2_upvr:OnGameChatMessage(arg1, arg2, arg3)
end)
local var128_upvw
if game.Workspace.CurrentCamera then
	var128_upvw = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(arg1) -- Line 709
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		tbl_2_upvr:CameraCFrameChanged()
	end)
end
game.Workspace.Changed:Connect(function(arg1) -- Line 712
	--[[ Upvalues[2]:
		[1]: var128_upvw (read and write)
		[2]: tbl_2_upvr (readonly)
	]]
	if arg1 == "CurrentCamera" then
		if var128_upvw then
			var128_upvw:disconnect()
		end
		if game.Workspace.CurrentCamera then
			var128_upvw = game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function(arg1_3) -- Line 716
				--[[ Upvalues[1]:
					[1]: tbl_2_upvr (copied, readonly)
				]]
				tbl_2_upvr:CameraCFrameChanged()
			end)
		end
	end
end)
local var132_upvw
function getAllowedMessageTypes() -- Line 724
	--[[ Upvalues[2]:
		[1]: var132_upvw (read and write)
		[2]: Chat_upvr (readonly)
	]]
	if var132_upvw then
		return var132_upvw
	end
	local ClientChatModules = Chat_upvr:FindFirstChild("ClientChatModules")
	if ClientChatModules then
		local ChatSettings_3 = ClientChatModules:FindFirstChild("ChatSettings")
		if ChatSettings_3 then
			local ChatSettings_3_2 = require(ChatSettings_3)
			if ChatSettings_3_2.BubbleChatMessageTypes then
				var132_upvw = ChatSettings_3_2.BubbleChatMessageTypes
				return var132_upvw
			end
		end
		local ChatConstants = ClientChatModules:FindFirstChild("ChatConstants")
		if ChatConstants then
			local ChatConstants_2 = require(ChatConstants)
			var132_upvw = {ChatConstants_2.MessageTypeDefault, ChatConstants_2.MessageTypeWhisper}
		end
		return var132_upvw
	end
	return {"Message", "Whisper"}
end
function checkAllowedMessageType(arg1) -- Line 748
	local getAllowedMessageTypes_result1 = getAllowedMessageTypes()
	for i_5 = 1, #getAllowedMessageTypes_result1 do
		if getAllowedMessageTypes_result1[i_5] == arg1.MessageType then
			return true
		end
	end
	return false
end
local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
DefaultChatSystemChatEvents:WaitForChild("OnNewMessage").OnClientEvent:connect(function(arg1, arg2) -- Line 762
	--[[ Upvalues[2]:
		[1]: var3_upvw (read and write)
		[2]: tbl_2_upvr (readonly)
	]]
	if not checkAllowedMessageType(arg1) then
	else
		local findPlayer_result1 = findPlayer(arg1.FromSpeaker)
		if not findPlayer_result1 then return end
		if not arg1.IsFiltered or arg1.FromSpeaker == var3_upvw.Name then
			if arg1.FromSpeaker ~= var3_upvw.Name or tbl_2_upvr:ShowOwnFilteredMessage() then return end
		end
		tbl_2_upvr:OnPlayerChatMessage(findPlayer_result1, arg1.Message, nil)
	end
end)
DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering").OnClientEvent:connect(function(arg1, arg2) -- Line 781
	--[[ Upvalues[2]:
		[1]: var3_upvw (read and write)
		[2]: tbl_2_upvr (readonly)
	]]
	if not checkAllowedMessageType(arg1) then
	else
		local findPlayer_result1_2 = findPlayer(arg1.FromSpeaker)
		if not findPlayer_result1_2 then return end
		if arg1.FromSpeaker == var3_upvw.Name then
			if not tbl_2_upvr:ShowOwnFilteredMessage() then return end
		end
		tbl_2_upvr:OnPlayerChatMessage(findPlayer_result1_2, arg1.Message, nil)
	end
end)