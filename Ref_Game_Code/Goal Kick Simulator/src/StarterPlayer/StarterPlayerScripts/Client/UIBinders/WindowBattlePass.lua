-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:32
-- Luau version 6, Types version 3
-- Time taken: 0.012029 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_2_upvr = {
	Money = "rbxassetid://14775043937";
	Gems = "rbxassetid://14774986318";
}
local tbl_upvr = {"Common", "Rare", "Epic", "Legendary", "Mythic"}
local any_GetLevelCap_result1_upvr = Util_upvr.BattlePassRewards:GetLevelCap()
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local MarketplaceService_upvr = game:GetService("MarketplaceService")
function module.Binder(arg1) -- Line 24
	--[[ Upvalues[6]:
		[1]: Util_upvr (readonly)
		[2]: any_GetLevelCap_result1_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
		[4]: tbl_upvr (readonly)
		[5]: tbl_2_upvr (readonly)
		[6]: MarketplaceService_upvr (readonly)
	]]
	local any_new_result1_2 = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink("PlayerData")
	if not any_GetLink_result1_upvr or not any_GetRawLink_result1_upvr then return end
	local function UpdateBattlePassXP_upvr(arg1_2) -- Line 31, Named "UpdateBattlePassXP"
		--[[ Upvalues[4]:
			[1]: any_GetRawLink_result1_upvr (readonly)
			[2]: any_GetLevelCap_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		if any_GetLevelCap_result1_upvr <= any_GetRawLink_result1_upvr.BattlePassLevel then
			arg1.Container.BattlePassLevel.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(1, 0.01)
			arg1.Container.BattlePassLevel.ProgressBar.SubText.Text = "MAX"
		else
			local any_GetExperienceNeeded_result1 = Util_upvr.BattlePassChallenges:GetExperienceNeeded(any_GetRawLink_result1_upvr.BattlePassLevel)
			arg1.Container.BattlePassLevel.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(arg1_2 / any_GetExperienceNeeded_result1, 0.01)
			arg1.Container.BattlePassLevel.ProgressBar.SubText.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(any_GetExperienceNeeded_result1 - arg1_2)).."XP to LEVEL UP!"
		end
	end
	any_new_result1_2.BattlePassXPChanged = any_GetLink_result1_upvr.Changed:On("BattlePassXP", UpdateBattlePassXP_upvr)
	UpdateBattlePassXP_upvr(any_GetRawLink_result1_upvr.BattlePassXP)
	local function UpdateAwardFrame_upvr(arg1_3, arg2, arg3) -- Line 46, Named "UpdateAwardFrame"
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
		]]
		local any_IsRewardAvailable_result1, any_IsRewardAvailable_result2, any_IsRewardAvailable_result3, any_IsRewardAvailable_result4 = Util_upvr.BattlePassRewards:IsRewardAvailable(LocalPlayer_upvr, arg2, arg3)
		local var17
		if not any_IsRewardAvailable_result1 then
			var17 = arg1_3.Cover
			var17.Free.Visible = any_IsRewardAvailable_result4
			var17 = arg1_3.Cover
			var17 = not any_IsRewardAvailable_result4
			var17.Lock.Visible = var17
			var17 = true
			arg1_3.Cover.Visible = var17
			var17 = arg1_3.Cover
			var17.CoverText.Text = any_IsRewardAvailable_result2
		else
			var17 = false
			arg1_3.Cover.Visible = var17
		end
		if any_IsRewardAvailable_result1 then
			var17 = true
			arg1_3.Claim.Visible = var17
			if any_IsRewardAvailable_result3 then
				var17 = 0.4
			else
				var17 = 0
			end
			arg1_3.Claim.ImageTransparency = var17
			if not any_IsRewardAvailable_result3 then
			else
			end
			arg1_3.Claim.TextLabel.Text = "ALREADY CLAIMED"
			if not any_IsRewardAvailable_result3 or not Color3.new(0.8, 0.8, 0.8) then
			end
			arg1_3.Claim.TextLabel.TextColor3 = Color3.new(1, 1, 1)
		else
			arg1_3.Claim.Visible = false
		end
	end
	local any_GetCurrentSeason_result1_2_upvw = Util_upvr.BattlePassChallenges:GetCurrentSeason()
	;(function(arg1_4) -- Line 66, Named "LoadSeason"
		--[[ Upvalues[10]:
			[1]: Util_upvr (copied, readonly)
			[2]: UpdateAwardFrame_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: any_GetLink_result1_upvr (readonly)
			[5]: LocalPlayer_upvr (copied, readonly)
			[6]: tbl_upvr (copied, readonly)
			[7]: tbl_2_upvr (copied, readonly)
			[8]: MarketplaceService_upvr (copied, readonly)
			[9]: UpdateBattlePassXP_upvr (readonly)
			[10]: any_GetRawLink_result1_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local any_new_result1 = Util_upvr.Maid.new()
		local tbl_3_upvr = {}
		local function _(arg1_5) -- Line 73, Named "UpdateAwardFrameFromLevel"
			--[[ Upvalues[3]:
				[1]: tbl_3_upvr (readonly)
				[2]: UpdateAwardFrame_upvr (copied, readonly)
				[3]: arg1_4 (readonly)
			]]
			local var56 = tbl_3_upvr[arg1_5]
			if var56 then
				UpdateAwardFrame_upvr(var56, arg1_4, arg1_5)
			end
		end
		local var57_upvw
		local function UpdateBattlePassPurchase(arg1_6) -- Line 80
			--[[ Upvalues[5]:
				[1]: var57_upvw (read and write)
				[2]: arg1_4 (readonly)
				[3]: arg1 (copied, readonly)
				[4]: tbl_3_upvr (readonly)
				[5]: UpdateAwardFrame_upvr (copied, readonly)
			]]
			local var62
			if arg1_6 ~= arg1_4 then
				var62 = false
			else
				var62 = true
			end
			var57_upvw = var62
			var62 = arg1.Container.BattlePassLevel.BattlePassIcon.Cover
			var62.Visible = not var57_upvw
			var62 = arg1.Container.BattlePassLevel.BuyBattlePass
			var62.Visible = not var57_upvw
			var62 = pairs(tbl_3_upvr)
			for i, v in pairs(tbl_3_upvr) do
				UpdateAwardFrame_upvr(v, arg1_4, i)
			end
		end
		any_new_result1.BattlePassPurchasedEvent = any_GetLink_result1_upvr.Changed:On("BoughtBattlePassSeason", UpdateBattlePassPurchase)
		UpdateBattlePassPurchase(any_GetLink_result1_upvr.BoughtBattlePassSeason)
		any_new_result1.OnRedeem = any_GetLink_result1_upvr.BattlePassOwnedRewards.Changed:Connect(function(arg1_7, arg2) -- Line 91
			--[[ Upvalues[3]:
				[1]: tbl_3_upvr (readonly)
				[2]: UpdateAwardFrame_upvr (copied, readonly)
				[3]: arg1_4 (readonly)
			]]
			local tonumber_result1 = tonumber(arg1_7)
			if not tonumber_result1 then
			else
				local var68 = tbl_3_upvr[tonumber_result1]
				if var68 then
					UpdateAwardFrame_upvr(var68, arg1_4, tonumber_result1)
				end
			end
		end)
		for i_2_upvr, v_2_upvr in pairs(Util_upvr.BattlePassRewards:GetRewards(LocalPlayer_upvr, arg1_4)) do
			local clone_2 = arg1.Container.Rewards.AwardFrame:Clone()
			clone_2.Name = "Level"..i_2_upvr
			clone_2.LayoutOrder = i_2_upvr
			clone_2.LevelRequired.Text = "Level "..i_2_upvr
			clone_2.Visible = true
			any_new_result1:GiveTask(clone_2)
			any_new_result1:GiveTask(clone_2.Claim.MouseButton1Click:Connect(function() -- Line 107
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: i_2_upvr (readonly)
				]]
				if Util_upvr.Network:Invoke("RedeemChallengesReward", i_2_upvr) then
					Util_upvr.Sounds:Play("BuySuccess")
				else
					Util_upvr.Sounds:Play("BuyFailed")
				end
			end))
			for i_3, v_3_upvr in pairs(v_2_upvr) do
				if typeof(v_3_upvr) ~= "function" and i_3 ~= "NoBattlePass" then
					if i_3 == "Pack" then
						local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("Packs", v_3_upvr)
						local var78
						if not any_GetAsset_result1 then
							var78 = "No PackData found for"
							warn(var78, v_3_upvr)
						else
							local tbl = {}
							var78 = 0
							for _, v_4 in pairs(any_GetAsset_result1:GetChildren()) do
								local var83 = v_4:GetAttribute("Probability") or 0
								var78 += var83
								local var84
								local function INLINED() -- Internal function, doesn't exist in bytecode
									var84 = tbl[v_4.Name] + var83
									return var84
								end
								if not tbl[v_4.Name] or not INLINED() then
									var84 = var83
								end
								tbl[v_4.Name] = var84
							end
							for var95, v_5 in pairs(tbl) do
								var84 = "Stars"
								local any_GetAsset_result1_2 = Util_upvr.Assets:GetAsset(var84, var95)
								local var89
								if not any_GetAsset_result1_2 or not any_GetAsset_result1_2:GetAttribute("Rarity") then
								end
								var84 = math.ceil(v_5 / var78 * 10000)
								local clone = clone_2.Content.ItemFrame:Clone()
								clone.Name = var95
								var89 = Enum.ScaleType.Crop
								clone.ItemIcon.ScaleType = var89
								local function INLINED_2() -- Internal function, doesn't exist in bytecode
									var89 = any_GetAsset_result1_2:GetAttribute("Icon")
									return var89
								end
								if not any_GetAsset_result1_2 or not INLINED_2() then
									var89 = "rbxassetid://9561109778"
								end
								clone.ItemIcon.Image = var89
								var89 = (var84 / 100)..'%'
								clone.ItemAmount.Text = var89
								var89 = 0 * 10000
								clone.LayoutOrder = var89 - var84 / 100
								clone.Visible = true
								var89 = true
								clone.ItemAmount.Visible = var89
								var89 = 1
								clone.Size = UDim2.new(var89, 0, 0.6, 0)
								clone.Parent = clone_2.Content
								var89 = tbl_upvr[math.floor(0)]
								var89 = Util_upvr.Assets:GetAsset("Colors", (var89 or "Common").."Gradient")
								if var89 then
									var89.Parent = clone
								end
							end
						end
					else
						local clone_3_upvr = clone_2.Content.ItemFrame:Clone()
						var78 = tbl_2_upvr
						local var93 = var78[i_3]
						if var93 then
							var78 = clone_3_upvr.ItemIcon
							var78.Image = var93
						end
						if i_3 == "UGC" then
							var95 = Util_upvr
							function var95() -- Line 166
								--[[ Upvalues[4]:
									[1]: Util_upvr (copied, readonly)
									[2]: clone_3_upvr (readonly)
									[3]: MarketplaceService_upvr (copied, readonly)
									[4]: v_3_upvr (readonly)
								]]
								if not Util_upvr:IsGuiObjectVisible(clone_3_upvr) then
								else
									clone_3_upvr.ItemAmount.Text = Util_upvr.ValueConvertor:AddCommas(MarketplaceService_upvr:GetProductInfo(v_3_upvr, Enum.InfoType.Asset).Remaining or 0).." left!"
									clone_3_upvr.ItemIcon.Image = "rbxthumb://type=Asset&id="..v_3_upvr.."&w=150&h=150"
									clone_3_upvr.ItemAmount.Visible = true
								end
							end
							var78 = any_new_result1:GiveTask
							var78(var95.Thread.Every(5, var95))
						elseif i_3 == "Money" then
							var95 = Util_upvr
							function var95() -- Line 175
								--[[ Upvalues[4]:
									[1]: Util_upvr (copied, readonly)
									[2]: clone_3_upvr (readonly)
									[3]: LocalPlayer_upvr (copied, readonly)
									[4]: v_2_upvr (readonly)
								]]
								if not Util_upvr:IsGuiObjectVisible(clone_3_upvr) then
								else
									clone_3_upvr.ItemAmount.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(Util_upvr.GameMath:GetGoldAmountFromRobuxPrice(LocalPlayer_upvr, v_2_upvr.Money)))
								end
							end
							var78 = any_new_result1:GiveTask
							var78(var95.Thread.Every(3, var95))
							var78 = clone_3_upvr.ItemAmount
							var78.Visible = true
						else
							var78 = 1
							if var78 < v_3_upvr then
								var78 = clone_3_upvr.ItemAmount
								var95 = v_3_upvr
								var78.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(var95))
								var78 = clone_3_upvr.ItemAmount
								var78.Visible = true
							end
						end
						clone_3_upvr.Name = i_3
						var78 = true
						clone_3_upvr.Visible = var78
						var78 = clone_2.Content
						clone_3_upvr.Parent = var78
					end
				end
			end
			tbl_3_upvr[i_2_upvr] = clone_2
			UpdateAwardFrame_upvr(clone_2, arg1_4, i_2_upvr)
			clone_2.Parent = arg1.Container.Rewards
		end
		local var96_upvw = 0
		any_new_result1.BattlePassLevelChanged = any_GetLink_result1_upvr.Changed:On("BattlePassLevel", function(arg1_8) -- Line 197, Named "UpdateBattlePassLevel"
			--[[ Upvalues[7]:
				[1]: arg1 (copied, readonly)
				[2]: UpdateBattlePassXP_upvr (copied, readonly)
				[3]: any_GetRawLink_result1_upvr (copied, readonly)
				[4]: var96_upvw (read and write)
				[5]: tbl_3_upvr (readonly)
				[6]: UpdateAwardFrame_upvr (copied, readonly)
				[7]: arg1_4 (readonly)
			]]
			arg1.Container.BattlePassLevel.LevelFrame.LevelLabel.Text = arg1_8
			UpdateBattlePassXP_upvr(any_GetRawLink_result1_upvr.BattlePassXP)
			for i_6 = 1, math.max(arg1_8, var96_upvw) do
				local var98 = tbl_3_upvr[i_6]
				if var98 then
					UpdateAwardFrame_upvr(var98, arg1_4, i_6)
				end
			end
			var96_upvw = arg1_8
		end)
		local BattlePassLevel = any_GetRawLink_result1_upvr.BattlePassLevel
		arg1.Container.BattlePassLevel.LevelFrame.LevelLabel.Text = BattlePassLevel
		UpdateBattlePassXP_upvr(any_GetRawLink_result1_upvr.BattlePassXP)
		for i_7 = 1, math.max(BattlePassLevel, var96_upvw) do
			local var100 = tbl_3_upvr[i_7]
			if var100 then
				UpdateAwardFrame_upvr(var100, arg1_4, i_7)
			end
		end
		var96_upvw = BattlePassLevel
	end)(any_GetCurrentSeason_result1_2_upvw)
	local SeasonStart_upvr = Util_upvr.Settings.BATTLEPASSINFO.SeasonStart
	local SeasonDuration_upvr = Util_upvr.Settings.BATTLEPASSINFO.SeasonDuration
	any_new_result1_2:GiveTask(Util_upvr.Thread.Every(1, function() -- Line 217
		--[[ Upvalues[5]:
			[1]: SeasonStart_upvr (readonly)
			[2]: any_GetCurrentSeason_result1_2_upvw (read and write)
			[3]: SeasonDuration_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
			[5]: arg1 (readonly)
		]]
		local var105 = SeasonStart_upvr + any_GetCurrentSeason_result1_2_upvw * SeasonDuration_upvr - os.time()
		if not var105 then
		else
			arg1.Container.BattlePassLevel.ResetTimer.Text = "Resetting in:\n"..Util_upvr.ValueConvertor:FormatTimeWithDays(var105)
			local any_GetCurrentSeason_result1 = Util_upvr.BattlePassChallenges:GetCurrentSeason()
			if any_GetCurrentSeason_result1_2_upvw ~= any_GetCurrentSeason_result1 then
				any_GetCurrentSeason_result1_2_upvw = any_GetCurrentSeason_result1
			end
		end
	end))
	return any_new_result1_2
end
return module