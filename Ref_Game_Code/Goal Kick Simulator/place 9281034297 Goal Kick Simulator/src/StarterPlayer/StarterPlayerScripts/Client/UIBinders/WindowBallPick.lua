-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:17
-- Luau version 6, Types version 3
-- Time taken: 0.004874 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
function module_upvr.Binder(arg1) -- Line 5
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_upvr_3 = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local Content_upvr = arg1.Container:WaitForChild("Content")
	local Fill_upvr = Content_upvr.Fill.Assets.Fill
	local function UpdateFillCells_upvr() -- Line 19, Named "UpdateFillCells"
		--[[ Upvalues[3]:
			[1]: Content_upvr (readonly)
			[2]: any_new_result1_upvr_3 (readonly)
			[3]: Fill_upvr (readonly)
		]]
		local maximum = math.max(math.ceil((#Content_upvr.Contents:GetChildren() - 2) / 6), 4)
		for i = 1, maximum * 6 do
			if not any_new_result1_upvr_3["Fill"..i] then
				local clone = Fill_upvr:Clone()
				clone.Visible = true
				clone.Parent = Content_upvr.Fill
				any_new_result1_upvr_3["Fill"..i] = clone
			end
		end
		for i_2 = maximum * 6 + 1, #Content_upvr.Fill:GetChildren() - 2 do
			if any_new_result1_upvr_3["Fill"..i_2] then
				any_new_result1_upvr_3["Fill"..i_2] = nil
			end
		end
	end
	repeat
		task.wait()
	until Util_upvr.Windows
	local var16_upvw
	arg1.Container.Select:SetAttribute("UI_ButtonColor", Color3.fromRGB(50, 50, 50))
	local function ClickSelect_upvr(arg1_2, arg2) -- Line 44, Named "ClickSelect"
		--[[ Upvalues[3]:
			[1]: var16_upvw (read and write)
			[2]: any_new_result1_upvr_3 (readonly)
			[3]: arg1 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [26] 21. Error Block 4 start (CF ANALYSIS FAILED)
		arg2.ToSelect.Visible = true
		do
			return
		end
		-- KONSTANTERROR: [26] 21. Error Block 4 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [32] 25. Error Block 5 start (CF ANALYSIS FAILED)
		any_new_result1_upvr_3.SelectionHighlight = nil
		-- KONSTANTERROR: [32] 25. Error Block 5 end (CF ANALYSIS FAILED)
	end
	function module_upvr.SelectBall(arg1_3) -- Line 64
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr_3 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: var16_upvw (read and write)
		]]
		local var24
		if any_new_result1_upvr_3.SelectMaid then return end
		any_new_result1_upvr_3.SelectionHighlight = nil
		local any_new_result1_upvr = Util_upvr.Maid.new()
		any_new_result1_upvr_3.SelectMaid = any_new_result1_upvr
		var24 = "BallPick"
		Util_upvr.Windows:SwitchWindow(var24, nil, 2)
		var24 = Util_upvr
		local any_new_result1_upvr_2 = var24.Signal.new()
		local var20_upvw
		var24 = arg1.Container.Select.MouseButton1Click
		var24 = var24:Connect(function() -- Line 75
			--[[ Upvalues[2]:
				[1]: var20_upvw (read and write)
				[2]: any_new_result1_upvr (readonly)
			]]
			var20_upvw = true
			any_new_result1_upvr.OnClose = nil
			any_new_result1_upvr:Destroy()
		end)
		any_new_result1_upvr.OnSelect = var24
		var24 = arg1.Close.MouseButton1Click
		var24 = var24:Connect(function() -- Line 80
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr.OnClose = nil
			any_new_result1_upvr:Destroy()
		end)
		any_new_result1_upvr.OnClosePressed = var24
		var24 = arg1:GetPropertyChangedSignal("Visible")
		var24 = var24:Connect(function() -- Line 84
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: any_new_result1_upvr (readonly)
			]]
			if arg1.Visible then
			else
				any_new_result1_upvr.OnClose = nil
				any_new_result1_upvr:Destroy()
			end
		end)
		any_new_result1_upvr.OnSelectClosed = var24
		function var24() -- Line 89
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			any_new_result1_upvr_2:Fire()
			arg1.Visible = false
		end
		any_new_result1_upvr.OnClose = var24
		var24 = any_new_result1_upvr_2:Wait
		var24()
		var24 = Util_upvr.Windows.State:RemoveState
		var24(2)
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var24 = var16_upvw
			return var24
		end
		if not var20_upvw or not INLINED() then
			var24 = nil
		end
		any_new_result1_upvr_3.SelectMaid = nil
		return var24
	end
	for i_3 in pairs(Util_upvr.Link:GetRawLink("PlayerData").Inventory) do
		(function(arg1_4) -- Line 101, Named "UpdateContent"
			--[[ Upvalues[6]:
				[1]: any_GetLink_result1_upvr (readonly)
				[2]: any_new_result1_upvr_3 (readonly)
				[3]: Util_upvr (copied, readonly)
				[4]: ClickSelect_upvr (readonly)
				[5]: Content_upvr (readonly)
				[6]: UpdateFillCells_upvr (readonly)
			]]
			local var25_upvr = any_GetLink_result1_upvr.Inventory[arg1_4]
			local var26 = "Item_"..arg1_4
			if var25_upvr then
				if any_new_result1_upvr_3[var26] then return end
				local any_CreateFrameItem_result1_upvr, any_CreateFrameItem_result2 = Util_upvr.BallFrameController:CreateFrameItem(arg1_4)
				any_CreateFrameItem_result1_upvr.Visible = true
				any_CreateFrameItem_result2.ToggleEquip = any_CreateFrameItem_result1_upvr.MouseButton1Click:Connect(function() -- Line 111
					--[[ Upvalues[6]:
						[1]: any_new_result1_upvr_3 (copied, readonly)
						[2]: var25_upvr (readonly)
						[3]: Util_upvr (copied, readonly)
						[4]: ClickSelect_upvr (copied, readonly)
						[5]: arg1_4 (readonly)
						[6]: any_CreateFrameItem_result1_upvr (readonly)
					]]
					if any_new_result1_upvr_3.SelectMaid then
						if var25_upvr.Equipped then
							Util_upvr.Sounds:Play("BuyFailed")
							return
						end
						ClickSelect_upvr(arg1_4, any_CreateFrameItem_result1_upvr)
						Util_upvr.Sounds:Play("ChestPopInfo")
					end
				end)
				;(function(arg1_5) -- Line 122, Named "UpdateEquipped"
					--[[ Upvalues[3]:
						[1]: Util_upvr (copied, readonly)
						[2]: any_CreateFrameItem_result1_upvr (readonly)
						[3]: any_GetLink_result1_upvr (copied, readonly)
					]]
					-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [73] 55. Error Block 15 start (CF ANALYSIS FAILED)
					local var30 = any_GetLink_result1_upvr.Stars[arg1_5]
					local var31 = var30
					if var31 then
						var31 = Util_upvr.Assets:GetAsset("Stars", var30.Name)
					end
					any_CreateFrameItem_result1_upvr.EquippedStar.Image = var31:GetAttribute("Icon") or "rbxassetid://9561109778"
					any_CreateFrameItem_result1_upvr.Equipped.Visible = false
					any_CreateFrameItem_result1_upvr.EquippedStar.Visible = true
					do
						return
					end
					-- KONSTANTERROR: [73] 55. Error Block 15 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [111] 82. Error Block 12 start (CF ANALYSIS FAILED)
					any_CreateFrameItem_result1_upvr.Equipped.Visible = false
					any_CreateFrameItem_result1_upvr.EquippedStar.Visible = false
					-- KONSTANTERROR: [111] 82. Error Block 12 end (CF ANALYSIS FAILED)
				end)(var25_upvr.Equipped)
				any_CreateFrameItem_result1_upvr.Parent = Content_upvr.Contents
				any_CreateFrameItem_result2:GiveTask(any_CreateFrameItem_result1_upvr)
				any_new_result1_upvr_3[var26] = any_CreateFrameItem_result2
			else
				any_CreateFrameItem_result1_upvr = any_new_result1_upvr_3[var26]
				if any_CreateFrameItem_result1_upvr then
					any_CreateFrameItem_result1_upvr = any_new_result1_upvr_3
					any_CreateFrameItem_result1_upvr[var26] = nil
				end
			end
			any_CreateFrameItem_result1_upvr = UpdateFillCells_upvr
			any_CreateFrameItem_result1_upvr()
		end)(i_3)
		local var35
	end
	any_GetLink_result1_upvr.Inventory.Changed:Connect(var35)
	Content_upvr.Fill.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 164, Named "UpdateCanvasSize"
		--[[ Upvalues[1]:
			[1]: Content_upvr (readonly)
		]]
		Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	end)
	UpdateFillCells_upvr()
	Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.Fill.UIGridLayout.AbsoluteContentSize.Y + 4)
	return any_new_result1_upvr_3
end
Util_upvr.BallPick = module_upvr
return module_upvr