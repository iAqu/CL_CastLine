-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:25
-- Luau version 6, Types version 3
-- Time taken: 0.010603 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_2_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink("PlayerData")
	local Content_upvr = arg1.Container:WaitForChild("Content")
	local var20
	repeat
		task.wait()
		var20 = Util_upvr
	until var20.Windows
	local function _() -- Line 17, Named "UpdateSlots"
		--[[ Upvalues[2]:
			[1]: any_GetRawLink_result1_upvr (readonly)
			[2]: arg1 (readonly)
		]]
		local var25 = 0
		for _, _ in pairs(any_GetRawLink_result1_upvr.Stars) do
			var25 += 1
		end
		arg1.Container.Slots.Text = var25.."/20 Slots"
	end
	var20 = 0
	for _, _ in pairs(any_GetRawLink_result1_upvr.Stars) do
		var20 += 1
	end
	arg1.Container.Slots.Text = var20.."/20 Slots"
	local var32_upvw
	local Details_upvr = arg1.Container.Details
	local function ShowDetails_upvr(arg1_2) -- Line 29, Named "ShowDetails"
		--[[ Upvalues[8]:
			[1]: var32_upvw (read and write)
			[2]: Util_upvr (copied, readonly)
			[3]: any_new_result1_2_upvr (readonly)
			[4]: any_GetLink_result1_upvr (readonly)
			[5]: arg1 (readonly)
			[6]: Details_upvr (readonly)
			[7]: ShowDetails_upvr (readonly)
			[8]: any_GetRawLink_result1_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var34
		if var32_upvw == arg1_2 then
		else
			local any_new_result1 = Util_upvr.Maid.new()
			any_new_result1_2_upvr.SelectMaid = any_new_result1
			var34 = any_GetLink_result1_upvr
			local var36_upvr = var34.Stars[arg1_2]
			if not var36_upvr then
				var34 = false
				arg1.Visible = var34
				return
			end
			var32_upvw = arg1_2
			var34 = Util_upvr
			local any_GetAsset_result1 = var34.Assets:GetAsset("Stars", var36_upvr.Name)
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var34 = any_GetAsset_result1:GetAttribute("Rarity")
				return var34
			end
			if not any_GetAsset_result1 or not INLINED() then
				var34 = 1
			end
			local var38 = var34 % 5
			if var38 == 0 then
			else
			end
			local var39 = var38
			if not any_GetAsset_result1 or not any_GetAsset_result1:GetAttribute("Icon") then
			end
			Details_upvr.Profile.Image = "rbxassetid://9561109778"
			Details_upvr.Stars.Icon.TileSize = UDim2.new(1 / var39, 0, 1, 0)
			Details_upvr.Stars.Icon.Size = UDim2.new(var39 / 5, 0, 1, 0)
			Details_upvr.Profile.Title.Text = var36_upvr.Name
			local function TrackXP_upvr(arg1_3) -- Line 50, Named "TrackXP"
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: var36_upvr (readonly)
					[3]: Details_upvr (copied, readonly)
				]]
				local any_GetStarLevelXP_result1 = Util_upvr.GameMath:GetStarLevelXP(var36_upvr.Level)
				Details_upvr.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(math.clamp(arg1_3 / any_GetStarLevelXP_result1, 0, 1), 0.025)
				Details_upvr.ProgressBar.SubText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1_3).." / "..Util_upvr.ValueConvertor:ShrinkNumber(any_GetStarLevelXP_result1)
			end
			local function TrackLevel(arg1_4) -- Line 56
				--[[ Upvalues[4]:
					[1]: Details_upvr (copied, readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: var36_upvr (readonly)
					[4]: TrackXP_upvr (readonly)
				]]
				Details_upvr.Level.Text = "Level "..arg1_4
				local any_GetCompanionKickValues_result1_2, any_GetCompanionKickValues_result2_2, any_GetCompanionKickValues_result3 = Util_upvr.GameMath:GetCompanionKickValues(var36_upvr.Name, var36_upvr.Level)
				for i_5, v_4 in pairs({
					KickPower = any_GetCompanionKickValues_result1_2;
					KickAccuracy = any_GetCompanionKickValues_result2_2;
					StarMulti = any_GetCompanionKickValues_result3;
				}) do
					local SOME = Details_upvr.Stats:FindFirstChild(i_5)
					if not SOME then return end
					SOME.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(v_4)
				end
				TrackXP_upvr(var36_upvr.XP)
			end
			TrackLevel(var36_upvr.Level)
			any_new_result1.TrackLevel = var36_upvr.Changed:On("Level", TrackLevel)
			any_new_result1.TrackXP = var36_upvr.Changed:On("XP", TrackXP_upvr)
			local function TrackEquipped(arg1_5) -- Line 72
				--[[ Upvalues[1]:
					[1]: Details_upvr (copied, readonly)
				]]
				local Equip = Details_upvr.Functions.Equip
				local var52
				if arg1_5 then
					Equip = "Unequip"
				else
					Equip = "Equip"
				end
				Equip.Title.Text = Equip
				local function INLINED_2() -- Internal function, doesn't exist in bytecode
					var52 = Color3.new(0.5, 0.5, 0.5)
					return var52
				end
				if not arg1_5 or not INLINED_2() then
					var52 = Color3.fromRGB(80, 213, 0)
				end
				Details_upvr.Functions.Equip:SetAttribute("UI_ButtonColor", var52)
			end
			TrackEquipped(var36_upvr.Equipped)
			any_new_result1.TrackEquipped = var36_upvr.Changed:On("Equipped", TrackEquipped)
			any_new_result1.TrackEquipSubmit = Details_upvr.Functions.Equip.MouseButton1Click:Connect(function() -- Line 78
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1_2 (readonly)
				]]
				if not Util_upvr.Network:Invoke("EquipStar", arg1_2) then
					Util_upvr.Sounds:Play("BuyFailed")
					return
				end
			end)
			Details_upvr.Sell.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetStarSellPrice(var36_upvr.Name))
			any_new_result1.TrackSellStar = Details_upvr.Sell.MouseButton1Click:Connect(function() -- Line 85
				--[[ Upvalues[5]:
					[1]: Util_upvr (copied, readonly)
					[2]: var36_upvr (readonly)
					[3]: arg1_2 (readonly)
					[4]: ShowDetails_upvr (copied, readonly)
					[5]: any_GetRawLink_result1_upvr (copied, readonly)
				]]
				Util_upvr.Windows:PromptNotification({
					Sound = "windowswitch";
					Text = "Do you really want to sell "..Util_upvr.ValueConvertor:FormatMarkupColor(var36_upvr.Name, Color3.new(1, 0, 0)).." for <font color=\"#FF89FF\">"..Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetStarSellPrice(var36_upvr.Name)).." Gems</font>!";
					Text1 = "Back";
					Text2 = "Sell";
					Option2 = function() -- Line 91, Named "Option2"
						--[[ Upvalues[4]:
							[1]: Util_upvr (copied, readonly)
							[2]: arg1_2 (copied, readonly)
							[3]: ShowDetails_upvr (copied, readonly)
							[4]: any_GetRawLink_result1_upvr (copied, readonly)
						]]
						if Util_upvr.Network:Invoke("SellStar", arg1_2) then
							ShowDetails_upvr(next(any_GetRawLink_result1_upvr.Stars) or 1)
						else
							Util_upvr.Sounds:Play("BuyFailed")
						end
					end;
				})
			end)
			any_new_result1.TrackBallEquipSubmit = Details_upvr.Functions.BallEquip.MouseButton1Click:Connect(function() -- Line 100
				--[[ Upvalues[3]:
					[1]: var36_upvr (readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: arg1_2 (readonly)
				]]
				if var36_upvr.EquippedBall then
					Util_upvr.Network:Fire("EquipStarBall", arg1_2)
				else
					Util_upvr.Network:Fire("EquipStarBall", arg1_2, Util_upvr.BallPick:SelectBall())
				end
			end)
			local function UpdateEquippedBall(arg1_6) -- Line 108
				--[[ Upvalues[3]:
					[1]: any_GetLink_result1_upvr (copied, readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: Details_upvr (copied, readonly)
				]]
				-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [17] 14. Error Block 5 start (CF ANALYSIS FAILED)
				Details_upvr.Functions.BallEquip.Plus.Visible = false
				Details_upvr.Functions.BallEquip.BallIcon.Visible = true
				-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [47.2]
				Details_upvr.Functions.BallEquip.BallIcon.Icon.Image = nil:GetAttribute("Icon")
				do
					return
				end
				-- KONSTANTERROR: [17] 14. Error Block 5 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [53] 36. Error Block 6 start (CF ANALYSIS FAILED)
				Details_upvr.Functions.BallEquip.BallIcon.Visible = false
				Details_upvr.Functions.BallEquip.Plus.Visible = true
				-- KONSTANTERROR: [53] 36. Error Block 6 end (CF ANALYSIS FAILED)
			end
			UpdateEquippedBall(var36_upvr.EquippedBall)
			any_new_result1.TrackEquippedBall = var36_upvr.Changed:On("EquippedBall", UpdateEquippedBall)
			local var57_upvr = any_new_result1_2_upvr["Item_"..arg1_2]
			if var57_upvr then
				var57_upvr = any_new_result1_2_upvr["Item_"..arg1_2].ItemFrame
			end
			if var57_upvr then
				function any_new_result1.ResetSelection() -- Line 127
					--[[ Upvalues[1]:
						[1]: var57_upvr (readonly)
					]]
					if not var57_upvr.Parent then
					else
						var57_upvr.UIStroke.Color = Color3.new(0, 0, 0)
						var57_upvr.UIStroke.Thickness = 3
					end
				end
				var57_upvr.UIStroke.Color = Color3.new(0, 0.5, 1)
				var57_upvr.UIStroke.Thickness = 4
				return
			end
			any_new_result1.ResetSelection = nil
		end
	end
	local StarFrame_upvr = Content_upvr.Assets.StarFrame
	for i_4 in pairs(any_GetRawLink_result1_upvr.Stars) do
		(function(arg1_7) -- Line 139, Named "UpdateContent"
			--[[ Upvalues[9]:
				[1]: any_GetLink_result1_upvr (readonly)
				[2]: any_GetRawLink_result1_upvr (readonly)
				[3]: arg1 (readonly)
				[4]: any_new_result1_2_upvr (readonly)
				[5]: Util_upvr (copied, readonly)
				[6]: StarFrame_upvr (readonly)
				[7]: var32_upvw (read and write)
				[8]: ShowDetails_upvr (readonly)
				[9]: Content_upvr (readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			-- KONSTANTERROR: [0] 1. Error Block 39 start (CF ANALYSIS FAILED)
			local var68_upvr = any_GetLink_result1_upvr.Stars[arg1_7]
			local var69 = "Item_"..arg1_7
			local var70 = 0
			for _, _ in pairs(any_GetRawLink_result1_upvr.Stars) do
				var70 += 1
			end
			arg1.Container.Slots.Text = var70.."/20 Slots"
			-- KONSTANTERROR: [0] 1. Error Block 39 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [29] 23. Error Block 41 start (CF ANALYSIS FAILED)
			var70 = any_new_result1_2_upvr[var69]
			if var70 then return end
			var70 = Util_upvr.Maid.new()
			local clone_upvr = StarFrame_upvr:Clone()
			clone_upvr.Visible = true
			local any_GetAsset_result1_2 = Util_upvr.Assets:GetAsset("Stars", var68_upvr.Name)
			if not any_GetAsset_result1_2 or not any_GetAsset_result1_2:GetAttribute("Rarity") then
			end
			if not any_GetAsset_result1_2 or not any_GetAsset_result1_2:GetAttribute("Icon") then
			end
			clone_upvr.Profile.Image = "rbxassetid://9561109778"
			local var76 = 1 % 5
			if var76 == 0 then
			else
			end
			local var77 = var76
			if not any_GetAsset_result1_2 or not any_GetAsset_result1_2:GetAttribute("Icon") then
			end
			clone_upvr.Profile.Image = "rbxassetid://9561109778"
			clone_upvr.Stars.Icon.TileSize = UDim2.new(1 / var77, 0, 1, 0)
			clone_upvr.Stars.Icon.Size = UDim2.new(var77 / 5, 0, 1, 0)
			function var70.ClearDetails() -- Line 163
				--[[ Upvalues[4]:
					[1]: var32_upvw (copied, read and write)
					[2]: arg1_7 (readonly)
					[3]: ShowDetails_upvr (copied, readonly)
					[4]: any_GetRawLink_result1_upvr (copied, readonly)
				]]
				if var32_upvw == arg1_7 then
					ShowDetails_upvr(next(any_GetRawLink_result1_upvr.Stars) or 1)
				end
			end
			var70.ToggleEquip = clone_upvr.MouseButton1Click:Connect(function() -- Line 168
				--[[ Upvalues[3]:
					[1]: ShowDetails_upvr (copied, readonly)
					[2]: arg1_7 (readonly)
					[3]: Util_upvr (copied, readonly)
				]]
				ShowDetails_upvr(arg1_7)
				Util_upvr.Sounds:Play("ChestPopInfo")
			end)
			local function UpdateXP_upvr(arg1_9) -- Line 176, Named "UpdateXP"
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: var68_upvr (readonly)
					[3]: clone_upvr (readonly)
				]]
				local clamped = math.clamp(arg1_9 / Util_upvr.GameMath:GetStarLevelXP(var68_upvr.Level), 0, 1)
				clone_upvr.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(clamped, 0.025)
				clone_upvr.ProgressBar.SubText.Text = math.floor(clamped * 100)..'%'
			end
			local function UpdateLevel(arg1_10) -- Line 182
				--[[ Upvalues[4]:
					[1]: clone_upvr (readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: var68_upvr (readonly)
					[4]: UpdateXP_upvr (readonly)
				]]
				clone_upvr.Level.Text = "Level "..arg1_10
				local any_GetCompanionKickValues_result1, any_GetCompanionKickValues_result2 = Util_upvr.GameMath:GetCompanionKickValues(var68_upvr.Name, arg1_10)
				clone_upvr.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetMinKickDistance(any_GetCompanionKickValues_result1, any_GetCompanionKickValues_result2) ^ 0.8)
				clone_upvr.LayoutOrder = -(any_GetCompanionKickValues_result1 * 10)
				UpdateXP_upvr(var68_upvr.XP)
			end
			var70.LevelChanged = var68_upvr.Changed:On("Level", UpdateLevel)
			var70.XPChanged = var68_upvr.Changed:On("XP", UpdateXP_upvr)
			var70.EquippedChanged = var68_upvr.Changed:On("Equipped", function(arg1_8) -- Line 173, Named "UpdateEquipped"
				--[[ Upvalues[1]:
					[1]: clone_upvr (readonly)
				]]
				clone_upvr.Equipped.Visible = arg1_8
			end)
			UpdateLevel(var68_upvr.Level)
			clone_upvr.Equipped.Visible = var68_upvr.Equipped
			clone_upvr.Parent = Content_upvr
			var70.ItemFrame = clone_upvr
			any_new_result1_2_upvr[var69] = var70
			-- KONSTANTERROR: [29] 23. Error Block 41 end (CF ANALYSIS FAILED)
		end)(i_4)
		local var86
	end
	any_GetLink_result1_upvr.Stars.Changed:Connect(var86)
	Content_upvr.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 219, Named "UpdateCanvasSize"
		--[[ Upvalues[1]:
			[1]: Content_upvr (readonly)
		]]
		Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.UIGridLayout.AbsoluteContentSize.Y + 4)
	end)
	Content_upvr.CanvasSize = UDim2.new(0, 0, 0, Content_upvr.UIGridLayout.AbsoluteContentSize.Y + 4)
	return any_new_result1_2_upvr
end
return module