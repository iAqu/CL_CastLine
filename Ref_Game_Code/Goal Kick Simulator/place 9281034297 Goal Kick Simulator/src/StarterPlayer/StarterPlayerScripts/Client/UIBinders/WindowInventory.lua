-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:56
-- Luau version 6, Types version 3
-- Time taken: 0.016524 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr_3 = {
	Equip = function(arg1) -- Line 6, Named "Equip"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local any_new_result1_upvr_4 = Util_upvr.Maid.new()
		local Content_4 = arg1.Container.Content
		local function UpdateItemFrame(arg1_2) -- Line 11
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_4 (readonly)
				[2]: Util_upvr (copied, readonly)
			]]
			if not arg1_2:IsA("ImageButton") then
			else
				any_new_result1_upvr_4[arg1_2] = arg1_2.MouseButton1Click:Connect(function() -- Line 13
					--[[ Upvalues[2]:
						[1]: Util_upvr (copied, readonly)
						[2]: arg1_2 (readonly)
					]]
					Util_upvr.Network:Fire("EquipBall", arg1_2:GetAttribute("ItemID"))
				end)
			end
		end
		for _, v_upvr in pairs(Content_4.Contents:GetChildren()) do
			if not v_upvr:IsA("ImageButton") then
			else
				any_new_result1_upvr_4[v_upvr] = v_upvr.MouseButton1Click:Connect(function() -- Line 13
					--[[ Upvalues[2]:
						[1]: Util_upvr (copied, readonly)
						[2]: v_upvr (readonly)
					]]
					Util_upvr.Network:Fire("EquipBall", v_upvr:GetAttribute("ItemID"))
				end)
			end
		end
		any_new_result1_upvr_4.ContentAdded = Content_4.Contents.ChildAdded:Connect(UpdateItemFrame)
		any_new_result1_upvr_4.ContentRemoved = Content_4.Contents.ChildRemoved:Connect(function(arg1_3) -- Line 22
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_4 (readonly)
			]]
			any_new_result1_upvr_4[arg1_3] = nil
		end)
		return any_new_result1_upvr_4
	end;
	Sell = function(arg1) -- Line 28, Named "Sell"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local tbl_upvr = {}
		local any_new_result1_upvr = Util_upvr.Maid.new()
		local Content = arg1.Container.Content
		local any_GetLink_result1_upvr_3 = Util_upvr.Link:GetLink("PlayerData")
		local function CalculateSellPrice_upvr() -- Line 35, Named "CalculateSellPrice"
			--[[ Upvalues[4]:
				[1]: tbl_upvr (readonly)
				[2]: any_GetLink_result1_upvr_3 (readonly)
				[3]: Util_upvr (copied, readonly)
				[4]: arg1 (readonly)
			]]
			local var27
			for _, v_2 in pairs(tbl_upvr) do
				local var28 = any_GetLink_result1_upvr_3.Inventory[v_2]
				if var28 then
					var27 += Util_upvr.GameMath:GetBallSellPrice(var28.Name, var28.Level)
				end
			end
			arg1.SellInfo.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(var27)
		end
		local function ToggleToSell_upvr(arg1_4, arg2) -- Line 46, Named "ToggleToSell"
			--[[ Upvalues[4]:
				[1]: tbl_upvr (readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: CalculateSellPrice_upvr (readonly)
				[4]: arg1 (readonly)
			]]
			for i_3, v_3 in pairs(tbl_upvr) do
				if v_3 == arg1_4 then
					any_new_result1_upvr[arg1_4] = nil
					table.remove(tbl_upvr, i_3)
					CalculateSellPrice_upvr()
					arg1.SellInfo.Sell.SelectedNum.Text = (#tbl_upvr).." Selected"
					return
				end
			end
			arg2.ToSell.Visible = true
			any_new_result1_upvr[arg1_4] = function() -- Line 57
				--[[ Upvalues[1]:
					[1]: arg2 (readonly)
				]]
				if not arg2 or not arg2.Parent then
				else
					arg2.ToSell.Visible = false
				end
			end
			tbl_upvr[#tbl_upvr + 1] = arg1_4
			arg1.SellInfo.Sell.SelectedNum.Text = (#tbl_upvr).." Selected"
			CalculateSellPrice_upvr()
		end
		arg1.SellInfo.Sell.SelectedNum.Text = "0 Selected"
		local function UpdateItemFrame(arg1_5) -- Line 67
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: ToggleToSell_upvr (readonly)
			]]
			if not arg1_5:IsA("ImageButton") then
			else
				any_new_result1_upvr[arg1_5] = arg1_5.MouseButton1Down:Connect(function() -- Line 69
					--[[ Upvalues[2]:
						[1]: ToggleToSell_upvr (copied, readonly)
						[2]: arg1_5 (readonly)
					]]
					ToggleToSell_upvr(arg1_5:GetAttribute("ItemID"), arg1_5)
				end)
			end
		end
		for _, v_4_upvr in pairs(Content.Contents:GetChildren()) do
			if not v_4_upvr:IsA("ImageButton") then
			else
				any_new_result1_upvr[v_4_upvr] = v_4_upvr.MouseButton1Down:Connect(function() -- Line 69
					--[[ Upvalues[2]:
						[1]: ToggleToSell_upvr (readonly)
						[2]: v_4_upvr (readonly)
					]]
					ToggleToSell_upvr(v_4_upvr:GetAttribute("ItemID"), v_4_upvr)
				end)
			end
		end
		any_new_result1_upvr.ContentAdded = Content.Contents.ChildAdded:Connect(UpdateItemFrame)
		any_new_result1_upvr.ContentRemoved = Content.Contents.ChildRemoved:Connect(function(arg1_6) -- Line 77
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr[arg1_6] = nil
		end)
		arg1.SellInfo.Price.AmountText.Text = '0'
		any_new_result1_upvr.Animation = Util_upvr.Thread.LoopFor(0.1, function(arg1_7) -- Line 82
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1.SellInfo.AnchorPoint = Vector2.new(0.5, 1 - arg1_7 * 0.5)
		end)
		any_new_result1_upvr.PromptToSell = arg1.SellInfo.Sell.MouseButton1Click:Connect(function() -- Line 85
			--[[ Upvalues[5]:
				[1]: tbl_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg1 (readonly)
				[4]: any_new_result1_upvr (readonly)
				[5]: CalculateSellPrice_upvr (readonly)
			]]
			local var43
			if #tbl_upvr == 0 then
			else
				local tbl = {
					Sound = "windowswitch";
				}
				if #tbl_upvr ~= 1 then
					var43 = 's'
				else
					var43 = ""
				end
				tbl.Text = "Do you really want to sell "..Util_upvr.ValueConvertor:FormatMarkupColor(#tbl_upvr, Color3.new(1, 0, 0)).." Ball"..var43.." for <font color=\"#f2d84c\">"..arg1.SellInfo.Price.AmountText.Text.." Coins</font>!"
				tbl.Text1 = "Back"
				tbl.Text2 = "Sell"
				function tbl.Option2() -- Line 92
					--[[ Upvalues[4]:
						[1]: Util_upvr (copied, readonly)
						[2]: tbl_upvr (copied, readonly)
						[3]: any_new_result1_upvr (copied, readonly)
						[4]: CalculateSellPrice_upvr (copied, readonly)
					]]
					Util_upvr.Network:Fire("SellItems", tbl_upvr)
					for i_17, v_12 in pairs(tbl_upvr) do
						any_new_result1_upvr[v_12] = nil
						tbl_upvr[i_17] = nil
					end
					CalculateSellPrice_upvr()
				end
				Util_upvr.Windows:PromptNotification(tbl)
			end
		end)
		function any_new_result1_upvr.Enabled() -- Line 102
			--[[ Upvalues[2]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			Util_upvr.Thread.LoopFor(0.1, function(arg1_8) -- Line 103
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1.SellInfo.AnchorPoint = Vector2.new(0.5, 0.5 + arg1_8 * 0.5)
			end)
		end
		return any_new_result1_upvr
	end;
	Fuse = function(arg1) -- Line 110, Named "Fuse"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
		local any_new_result1_upvr_2 = Util_upvr.Maid.new()
		local Content_3_upvr = arg1.Container.Content
		local tbl_upvr_4 = {}
		local function ShowAvailable_upvr() -- Line 118, Named "ShowAvailable"
			--[[ Upvalues[4]:
				[1]: tbl_upvr_4 (readonly)
				[2]: Content_3_upvr (readonly)
				[3]: any_GetLink_result1_upvr (readonly)
				[4]: arg1 (readonly)
			]]
			local var64 = 0
			for _ in pairs(tbl_upvr_4) do
				var64 += 1
			end
			for i_6, v_5 in pairs(Content_3_upvr.Contents:GetChildren()) do
				if v_5:IsA("ImageButton") then
					local _, next_result2_2 = next(tbl_upvr_4)
					local Inventory = any_GetLink_result1_upvr.Inventory
					local var74 = Inventory[v_5:GetAttribute("ItemID")]
					local function INLINED() -- Internal function, doesn't exist in bytecode
						Inventory = Color3.new(1, 1, 1)
						return Inventory
					end
					if not var74.Tier or var74.Tier < 4 or var64 >= 4 or next_result2_2 and (next_result2_2.Name ~= var74.Name or next_result2_2.Tier ~= var74.Tier) or not INLINED() then
						Inventory = Color3.new(0.25, 0.25, 0.25)
					end
					v_5.BackgroundColor3 = Inventory
				end
			end
			if var64 == 4 then
				i_6 = 213
				v_5 = 0
				arg1.FuseInfo.Merge.ImageColor3 = Color3.fromRGB(80, i_6, v_5)
				i_6 = arg1
				i_6.FuseInfo.Merge.X.Text = "Merge"
			else
				arg1.FuseInfo.Merge.ImageColor3 = Color3.fromRGB(213, 213, 213)
				arg1.FuseInfo.Merge.X.Text = "%d/4 Required":format(var64)
			end
		end
		any_new_result1_upvr_2.PromptToFuse = arg1.FuseInfo.Merge.Activated:Connect(function() -- Line 145
			--[[ Upvalues[2]:
				[1]: tbl_upvr_4 (readonly)
				[2]: Util_upvr (copied, readonly)
			]]
			local tbl_2 = {}
			for i_7 in pairs(tbl_upvr_4) do
				tbl_2[#tbl_2 + 1] = i_7
			end
			if Util_upvr.Network:Invoke("MergeItems", tbl_2) then
				Util_upvr.Sounds:Play("MergeSuccess")
			end
		end)
		any_new_result1_upvr_2.Animation = Util_upvr.Thread.LoopFor(0.1, function(arg1_9) -- Line 155
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1.FuseInfo.AnchorPoint = Vector2.new(0.5, 1 - arg1_9 * 0.5)
		end)
		any_new_result1_upvr_2:GiveTask(function() -- Line 159
			--[[ Upvalues[5]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: tbl_upvr_4 (readonly)
				[4]: ShowAvailable_upvr (readonly)
				[5]: Content_3_upvr (readonly)
			]]
			Util_upvr.Thread.LoopFor(0.1, function(arg1_10) -- Line 160
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1.FuseInfo.AnchorPoint = Vector2.new(0.5, 0.5 + arg1_10 * 0.5)
			end)
			Util_upvr.Table.Empty(tbl_upvr_4)
			ShowAvailable_upvr()
			for _, v_6 in pairs(Content_3_upvr.Contents:GetChildren()) do
				if v_6:IsA("ImageButton") then
					v_6.Merging.Visible = false
				end
			end
		end)
		local function Toggle_upvr(arg1_11) -- Line 172, Named "Toggle"
			--[[ Upvalues[6]:
				[1]: tbl_upvr_4 (readonly)
				[2]: any_new_result1_upvr_2 (readonly)
				[3]: ShowAvailable_upvr (readonly)
				[4]: any_GetLink_result1_upvr (readonly)
				[5]: Util_upvr (copied, readonly)
				[6]: arg1 (readonly)
			]]
			local var92_upvr = "Item_"..arg1_11
			local var93
			if tbl_upvr_4[arg1_11] then
				any_new_result1_upvr_2[var92_upvr] = nil
				ShowAvailable_upvr()
			else
				local _, next_result2 = next(tbl_upvr_4)
				var93 = any_GetLink_result1_upvr.Inventory
				local var96 = var93[arg1_11]
				var93 = 0
				for _ in pairs(tbl_upvr_4) do
					var93 += 1
				end
				if 4 <= var93 or next_result2 and (next_result2.Name ~= var96.Name or next_result2.Tier ~= var96.Tier) then
					Util_upvr.Sounds:Play("Error")
					return
				end
				local any_CreateFrameItem_result1, any_CreateFrameItem_result2 = Util_upvr.BallFrameController:CreateFrameItem(arg1_11)
				any_CreateFrameItem_result1.Visible = true
				any_CreateFrameItem_result1.Parent = arg1.FuseInfo.Items.Contents
				any_new_result1_upvr_2[var92_upvr] = any_CreateFrameItem_result2
				any_CreateFrameItem_result2:GiveTask(function() -- Line 194
					--[[ Upvalues[5]:
						[1]: any_new_result1_upvr_2 (copied, readonly)
						[2]: var92_upvr (readonly)
						[3]: tbl_upvr_4 (copied, readonly)
						[4]: arg1_11 (readonly)
						[5]: ShowAvailable_upvr (copied, readonly)
					]]
					any_new_result1_upvr_2[var92_upvr] = nil
					tbl_upvr_4[arg1_11] = nil
					ShowAvailable_upvr()
				end)
				any_CreateFrameItem_result2:GiveTask(any_CreateFrameItem_result1.MouseButton1Down:Connect(function() -- Line 200
					--[[ Upvalues[5]:
						[1]: any_new_result1_upvr_2 (copied, readonly)
						[2]: var92_upvr (readonly)
						[3]: tbl_upvr_4 (copied, readonly)
						[4]: arg1_11 (readonly)
						[5]: ShowAvailable_upvr (copied, readonly)
					]]
					any_new_result1_upvr_2[var92_upvr] = nil
					tbl_upvr_4[arg1_11] = nil
					ShowAvailable_upvr()
				end))
				tbl_upvr_4[arg1_11] = var96
				ShowAvailable_upvr()
				return any_CreateFrameItem_result1, any_CreateFrameItem_result2
			end
		end
		for _, v_7_upvr in pairs(Content_3_upvr.Contents:GetChildren()) do
			if not v_7_upvr:IsA("ImageButton") then
			else
				any_new_result1_upvr_2[v_7_upvr] = v_7_upvr.MouseButton1Click:Connect(function() -- Line 214
					--[[ Upvalues[2]:
						[1]: v_7_upvr (readonly)
						[2]: Toggle_upvr (readonly)
					]]
					local Toggle_result1, Toggle_result2 = Toggle_upvr(v_7_upvr:GetAttribute("ItemID"))
					if Toggle_result1 and Toggle_result2 then
						v_7_upvr.Merging.Visible = true
						Toggle_result2.UnmergeToggle = function() -- Line 219
							--[[ Upvalues[1]:
								[1]: v_7_upvr (copied, readonly)
							]]
							if not v_7_upvr.Parent then
							else
								v_7_upvr.Merging.Visible = false
							end
						end
					end
				end)
			end
		end
		any_new_result1_upvr_2.ContentAdded = Content_3_upvr.Contents.ChildAdded:Connect(function(arg1_12) -- Line 211, Named "UpdateItemFrame"
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: Toggle_upvr (readonly)
			]]
			if not arg1_12:IsA("ImageButton") then
			else
				any_new_result1_upvr_2[arg1_12] = arg1_12.MouseButton1Click:Connect(function() -- Line 214
					--[[ Upvalues[2]:
						[1]: arg1_12 (readonly)
						[2]: Toggle_upvr (copied, readonly)
					]]
					local Toggle_result1_2, Toggle_result2_2 = Toggle_upvr(arg1_12:GetAttribute("ItemID"))
					if Toggle_result1_2 and Toggle_result2_2 then
						arg1_12.Merging.Visible = true
						Toggle_result2_2.UnmergeToggle = function() -- Line 219
							--[[ Upvalues[1]:
								[1]: arg1_12 (copied, readonly)
							]]
							if not arg1_12.Parent then
							else
								arg1_12.Merging.Visible = false
							end
						end
					end
				end)
			end
		end)
		any_new_result1_upvr_2.ContentRemoved = Content_3_upvr.Contents.ChildRemoved:Connect(function(arg1_13) -- Line 231
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (readonly)
			]]
			any_new_result1_upvr_2[arg1_13] = nil
		end)
		ShowAvailable_upvr()
		return any_new_result1_upvr_2
	end;
}
function module.Binder(arg1) -- Line 241
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr_3 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_upvr_3 = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr_2 = Util_upvr.Link:GetLink("PlayerData")
	local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink("PlayerData")
	local Content_2_upvr = arg1.Container:WaitForChild("Content")
	local Fill_upvr = Content_2_upvr.Fill.Assets.Fill
	local function UpdateFillCells_upvr() -- Line 254, Named "UpdateFillCells"
		--[[ Upvalues[3]:
			[1]: Content_2_upvr (readonly)
			[2]: any_new_result1_upvr_3 (readonly)
			[3]: Fill_upvr (readonly)
		]]
		local maximum = math.max(math.ceil((#Content_2_upvr.Contents:GetChildren() - 2) / 6), 5)
		for i_10 = 1, maximum * 6 do
			if not any_new_result1_upvr_3["Fill"..i_10] then
				local clone = Fill_upvr:Clone()
				clone.Visible = true
				clone.Parent = Content_2_upvr.Fill
				any_new_result1_upvr_3["Fill"..i_10] = clone
			end
		end
		for i_11 = maximum * 6 + 1, #Content_2_upvr.Fill:GetChildren() - 2 do
			if any_new_result1_upvr_3["Fill"..i_11] then
				any_new_result1_upvr_3["Fill"..i_11] = nil
			end
		end
	end
	repeat
		task.wait()
	until Util_upvr.Windows
	local function UpdateSlots() -- Line 277
		--[[ Upvalues[3]:
			[1]: any_GetRawLink_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr_2 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		-- KONSTANTERROR: [0] 1. Error Block 17 start (CF ANALYSIS FAILED)
		local var154 = 0
		for _, _ in pairs(any_GetRawLink_result1_upvr.Inventory) do
			var154 += 1
		end
		if any_GetLink_result1_upvr_2.BagExpansion1 then
			-- KONSTANTWARNING: GOTO [26] #21
		end
		-- KONSTANTERROR: [0] 1. Error Block 17 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [25] 20. Error Block 20 start (CF ANALYSIS FAILED)
		if any_GetLink_result1_upvr_2.BagExpansion2 then
		else
		end
		arg1.Container.Slots.Text = var154..'/'..(30 + 0 + 0).." Slots"
		-- KONSTANTERROR: [25] 20. Error Block 20 end (CF ANALYSIS FAILED)
	end
	for _, _ in pairs(any_GetRawLink_result1_upvr.Inventory) do
	end
	if any_GetLink_result1_upvr_2.BagExpansion1 then
		-- KONSTANTWARNING: GOTO [85] #62
	end
	if any_GetLink_result1_upvr_2.BagExpansion2 then
	else
	end
	arg1.Container.Slots.Text = (0 + 1)..'/'..(30 + 0 + 0).." Slots"
	any_new_result1_upvr_3.BagUpdate1 = any_GetLink_result1_upvr_2.Changed:On("BagExpansion1", UpdateSlots)
	any_new_result1_upvr_3.BagUpdate2 = any_GetLink_result1_upvr_2.Changed:On("BagExpansion2", UpdateSlots)
	local tbl_upvr_2 = {}
	local Inventory_2_upvr = Util_upvr.Windows.Object.Side:FindFirstChild("Inventory", true)
	local function UpdateContent(arg1_14) -- Line 288
		--[[ Upvalues[9]:
			[1]: any_GetLink_result1_upvr_2 (readonly)
			[2]: any_GetRawLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: any_new_result1_upvr_3 (readonly)
			[5]: Util_upvr (copied, readonly)
			[6]: Content_2_upvr (readonly)
			[7]: tbl_upvr_2 (readonly)
			[8]: Inventory_2_upvr (readonly)
			[9]: UpdateFillCells_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
		local var167 = 0
		for _, _ in pairs(any_GetRawLink_result1_upvr.Inventory) do
			var167 += 1
		end
		if any_GetLink_result1_upvr_2.BagExpansion1 then
			-- KONSTANTWARNING: GOTO [33] #27
		end
		-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [32] 26. Error Block 33 start (CF ANALYSIS FAILED)
		if any_GetLink_result1_upvr_2.BagExpansion2 then
			-- KONSTANTWARNING: GOTO [41] #34
		end
		-- KONSTANTERROR: [32] 26. Error Block 33 end (CF ANALYSIS FAILED)
	end
	for i_15 in pairs(any_GetRawLink_result1_upvr.Inventory) do
		UpdateContent(i_15)
	end
	any_GetLink_result1_upvr_2.Inventory.Changed:Connect(UpdateContent)
	Content_2_upvr.Fill.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 344, Named "UpdateCanvasSize"
		--[[ Upvalues[1]:
			[1]: Content_2_upvr (readonly)
		]]
		Content_2_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_2_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	end)
	UpdateFillCells_upvr()
	Content_2_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_2_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	local var174_upvw
	local function ChangeSection_upvr(arg1_15) -- Line 353, Named "ChangeSection"
		--[[ Upvalues[5]:
			[1]: var174_upvw (read and write)
			[2]: tbl_upvr_3 (copied, readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: any_new_result1_upvr_3 (readonly)
		]]
		local var179 = arg1_15 or "Equip"
		if var179 == var174_upvw then
		else
			var174_upvw = var179
			local var180 = tbl_upvr_3[var179]
			Util_upvr.Sounds:Play("window_switch")
			for _, v_13 in pairs(arg1.Index:GetChildren()) do
				local var184
				if var184 then
					local function INLINED_2() -- Internal function, doesn't exist in bytecode
						var184 = Color3.fromRGB(48, 184, 255)
						return var184
					end
					if v_13.Name ~= var179 or not INLINED_2() then
						var184 = Color3.fromRGB(197, 197, 197)
					end
					v_13.ImageColor3 = var184
				end
			end
			if var180 then
				any_new_result1_upvr_3.CurrentSection = var180(arg1)
				return
			end
			any_new_result1_upvr_3.CurrentSection = nil
		end
	end
	ChangeSection_upvr()
	for _, v_11_upvr in pairs(arg1.Index:GetChildren()) do
		if v_11_upvr:IsA("ImageButton") then
			any_new_result1_upvr_3:GiveTask(v_11_upvr.MouseButton1Down:Connect(function() -- Line 376
				--[[ Upvalues[2]:
					[1]: ChangeSection_upvr (readonly)
					[2]: v_11_upvr (readonly)
				]]
				ChangeSection_upvr(v_11_upvr.Name)
			end))
		end
	end
	return any_new_result1_upvr_3
end
return module