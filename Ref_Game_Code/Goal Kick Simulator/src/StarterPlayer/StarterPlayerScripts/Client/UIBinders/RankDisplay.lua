-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:09
-- Luau version 6, Types version 3
-- Time taken: 0.002449 seconds

local module = {}
local tbl_upvr = {"1264261889", "1264261955", "1264262002", "1264262135", "1264262166", "1264262244", "1264262301", "1264262357", "1264264190", "1267588798", "1267588843", "1267588897", "1267588966"}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 8
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function UpdateProgress_upvr(arg1_2) -- Line 13, Named "UpdateProgress"
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		if Util_upvr.GameMath:CanRankUp(any_GetLink_result1_upvr.Rank) then
			local var8 = arg1_2 / Util_upvr.GameMath:GetPlayerRankXP(any_GetLink_result1_upvr.Rank or 1 or 1)
			arg1.ProgressBar.SubText.Text = math.floor(var8 * 100)..'%'
			arg1.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(var8, 0.025)
		else
			arg1.ProgressBar.SubText.Text = "MAX"
			arg1.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(1, 0.025)
		end
	end
	local function UpdateTitle_upvr(arg1_3) -- Line 27, Named "UpdateTitle"
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		local var9 = Util_upvr.Settings.RANK_TITLES[arg1_3]
		if not var9 then
			var9 = Util_upvr.Settings.RANK_TITLES[#Util_upvr.Settings.RANK_TITLES]
		end
		arg1.Title.Text = var9
		local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("RankColors", Util_upvr.ValueConvertor:AddNumberPadding(arg1_3, 3)..'_'..var9)
		if any_GetAsset_result1 then
			local clone = any_GetAsset_result1:Clone()
			clone.Parent = arg1.Title
			any_new_result1_upvr.CurrentGradient = clone
		else
			any_new_result1_upvr.CurrentGradient = nil
		end
	end
	local Rank = any_GetLink_result1_upvr.Rank
	if tbl_upvr[Rank] then
		Rank = true
	else
		Rank = false
	end
	arg1.More.Visible = Rank
	any_GetLink_result1_upvr.Changed:On("Rank", function(arg1_4) -- Line 42, Named "PromptProduct"
		--[[ Upvalues[3]:
			[1]: tbl_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		local var12 = arg1
		if tbl_upvr[any_GetLink_result1_upvr.Rank] then
			var12 = true
		else
			var12 = false
		end
		var12.More.Visible = var12
	end)
	any_new_result1_upvr.Upgrade = arg1.More.MouseButton1Click:Connect(function() -- Line 49
		--[[ Upvalues[4]:
			[1]: tbl_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: LocalPlayer_upvr (copied, readonly)
		]]
		local var15 = tbl_upvr[any_GetLink_result1_upvr.Rank]
		if var15 then
			Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, var15)
		end
	end)
	any_new_result1_upvr.RankChanged = any_GetLink_result1_upvr.Changed:On("Rank", function(arg1_5) -- Line 55
		--[[ Upvalues[3]:
			[1]: UpdateProgress_upvr (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: UpdateTitle_upvr (readonly)
		]]
		UpdateProgress_upvr(any_GetLink_result1_upvr.RankXP)
		UpdateTitle_upvr(arg1_5)
	end)
	any_new_result1_upvr.RankXPChanged = any_GetLink_result1_upvr.Changed:On("RankXP", UpdateProgress_upvr)
	UpdateProgress_upvr(any_GetLink_result1_upvr.RankXP)
	UpdateTitle_upvr(any_GetLink_result1_upvr.Rank)
	return any_new_result1_upvr
end
return module