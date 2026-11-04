-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:26
-- Luau version 6, Types version 3
-- Time taken: 0.010978 seconds

local module_upvr = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local MarketplaceService_upvr = game:GetService("MarketplaceService")
local CfgFind_upvr = require(ReplicatedStorage_upvr.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage_upvr.Tool.EnumMgr)
local TipsModule_upvr = require(game.ReplicatedStorage.Tool.TipsModule)
local function _(arg1, arg2) -- Line 24, Named "BuyRobloxItem"
	--[[ Upvalues[1]:
		[1]: MarketplaceService_upvr (readonly)
	]]
	MarketplaceService_upvr:PromptProductPurchase(arg1, arg2)
end
local function _(arg1, arg2) -- Line 30, Named "BuyGamePass"
	--[[ Upvalues[1]:
		[1]: MarketplaceService_upvr (readonly)
	]]
	MarketplaceService_upvr:PromptGamePassPurchase(arg1, arg2)
end
function module_upvr.QBBuy(arg1, arg2) -- Line 39
	--[[ Upvalues[5]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: TipsModule_upvr (readonly)
	]]
	local any_FindCfgByOnlyTag_result1_2 = CfgFind_upvr.FindCfgByOnlyTag(arg2)
	if any_FindCfgByOnlyTag_result1_2 and any_FindCfgByOnlyTag_result1_2.passID and any_FindCfgByOnlyTag_result1_2.price and require(ReplicatedStorage_upvr.System.SystemBag).BuyItemAndDelItem(arg1, EnumMgr_upvr.ItemID.Money, any_FindCfgByOnlyTag_result1_2.price) then
		module_upvr.BuyItemEnd(arg1, arg2)
		TipsModule_upvr.NormalTips(arg1, "购买成功")
		return
	end
end
local TranslationHelper_upvr = require(ReplicatedStorage_upvr.Tool.TranslationHelper)
local showLocalUI_upvr_2 = ReplicatedStorage_upvr.LocalMsg.showLocalUI
local Log_upvr = require(ReplicatedStorage_upvr.Tool.Log)
local RemoteFunction_upvr = ReplicatedStorage_upvr.Msg.RemoteFunction
function module_upvr.BuyRobloxByOnlyTag(arg1, arg2) -- Line 54
	--[[ Upvalues[7]:
		[1]: CfgFind_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: MarketplaceService_upvr (readonly)
		[4]: showLocalUI_upvr_2 (readonly)
		[5]: Log_upvr (readonly)
		[6]: RemoteFunction_upvr (readonly)
		[7]: EnumMgr_upvr (readonly)
	]]
	if not arg1 or not arg2 then
	else
		local any_FindCfgByOnlyTag_result1_upvr = CfgFind_upvr.FindCfgByOnlyTag(arg2)
		if not any_FindCfgByOnlyTag_result1_upvr then return end
		local GiftPlayer = arg1:FindFirstChild("GiftPlayer")
		if GiftPlayer and GiftPlayer.Value ~= nil then
			if any_FindCfgByOnlyTag_result1_upvr.GiftID and tonumber(any_FindCfgByOnlyTag_result1_upvr.GiftID) then
				local tbl = {
					Tips = {"赠送确认", {TranslationHelper_upvr.translateByKey(any_FindCfgByOnlyTag_result1_upvr.ZhName), GiftPlayer.Value.DisplayName}};
				}
				function tbl.func() -- Line 70
					--[[ Upvalues[3]:
						[1]: arg1 (readonly)
						[2]: any_FindCfgByOnlyTag_result1_upvr (readonly)
						[3]: MarketplaceService_upvr (copied, readonly)
					]]
					MarketplaceService_upvr:PromptProductPurchase(arg1, tonumber(any_FindCfgByOnlyTag_result1_upvr.GiftID))
				end
				showLocalUI_upvr_2:Fire("警告弹窗", tbl, true)
			end
			return
		end
		Log_upvr.warn("购买付费项:", arg2)
		local GiftPlayer_2 = arg1:FindFirstChild("GiftPlayer")
		if GiftPlayer_2 and GiftPlayer_2.Value ~= nil then
			RemoteFunction_upvr:InvokeServer("取消赠送")
			Log_upvr.print("购买付费项 发现有GiftPlayer 清理下")
		end
		if any_FindCfgByOnlyTag_result1_upvr.passID and any_FindCfgByOnlyTag_result1_upvr.price then
			if any_FindCfgByOnlyTag_result1_upvr.cost == EnumMgr_upvr.RobuxType.GamePass then
				MarketplaceService_upvr:PromptGamePassPurchase(arg1, any_FindCfgByOnlyTag_result1_upvr.passID)
				return
			end
			if any_FindCfgByOnlyTag_result1_upvr.cost == EnumMgr_upvr.RobuxType.RobuxItem then
				MarketplaceService_upvr:PromptProductPurchase(arg1, any_FindCfgByOnlyTag_result1_upvr.passID)
			end
		end
	end
end
local tbl_upvr = {
	StarterPack = 1;
	PowerPotion = 1;
	HeartPotion = 1;
	ComptitionPotion = 1;
}
local tbl_upvr_2 = {"WorldPack1", "WorldPack2", "WorldPack3", "WorldPack4", "WorldPack5"}
local ServerStorage_upvr = game:GetService("ServerStorage")
local showLocalUI_upvr = ReplicatedStorage_upvr.ServerMsg.showLocalUI
local CheckLimitedCoach_upvr = game.ReplicatedStorage.ServerMsg.CheckLimitedCoach
local RemoteEvent_upvr = ReplicatedStorage_upvr.Msg.RemoteEvent
local showItems_upvr = ReplicatedStorage_upvr.ServerMsg.showItems
function module_upvr.BuyItemEnd(arg1, arg2) -- Line 122
	--[[ Upvalues[11]:
		[1]: ServerStorage_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: TipsModule_upvr (readonly)
		[5]: ReplicatedStorage_upvr (readonly)
		[6]: tbl_upvr_2 (readonly)
		[7]: showLocalUI_upvr (readonly)
		[8]: CheckLimitedCoach_upvr (readonly)
		[9]: RemoteEvent_upvr (readonly)
		[10]: showItems_upvr (readonly)
		[11]: tbl_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if string.find(arg2, "DailyDiscount") then
		require(ServerStorage_upvr.System.SystemRecord).RecordAdd(arg1, "转盘每日折扣", 1)
	end
	print("购买完", arg2)
	local any_FindCfgByOnlyTag_result1 = CfgFind_upvr.FindCfgByOnlyTag(arg2)
	if not any_FindCfgByOnlyTag_result1 then
		error("没有这个商品ID的配置表"..arg2)
		return true
	end
	if any_FindCfgByOnlyTag_result1.BuyLimitNum ~= "" then
		require(game.ReplicatedStorage.System.SystemBuyLimit).RecordItemNum(arg2, 1)
	end
	if any_FindCfgByOnlyTag_result1.cost == EnumMgr_upvr.RobuxType.GamePass then
		require(game.ServerStorage.System.SystemShop).BuyGamePassSuc(arg1, any_FindCfgByOnlyTag_result1.passID)
		TipsModule_upvr.NormalTips(arg1, "获得GamePass", any_FindCfgByOnlyTag_result1.ZhName)
		require(ReplicatedStorage_upvr.System.SystemSave).UpdateLocalData(arg1)
		return true
	end
	if arg2 == "LuckyPotion" then
		require(game.ServerStorage.System.SystemBUFF).AddBUFF(arg1, 101, 30)
	end
	if arg2 == "SuperLuckyPotion" then
		require(game.ServerStorage.System.SystemBUFF).AddBUFF(arg1, 102, 30)
	end
	if arg2 == "StarterPack" then
		local SystemRecord = require(game.ServerStorage.System.SystemRecord)
		if 0 < SystemRecord.GetDataByID(arg1, "StarterPack") then
			return true
		end
		SystemRecord.RecordCover(arg1, "StarterPack", 1)
	end
	if arg2 == "EventTaskSkip" then
		require(ServerStorage_upvr.System.SystemCoachEvent).PaySkipTaskEnd(arg1)
	end
	if any_FindCfgByOnlyTag_result1.itemID and #any_FindCfgByOnlyTag_result1.itemID == 1 and CfgFind_upvr.FindCfgByID(any_FindCfgByOnlyTag_result1.itemID[1], EnumMgr_upvr.ItemType.Egg) then
		require(ReplicatedStorage_upvr.Tool.DrawUp).DrawSpecialEgg(arg1, any_FindCfgByOnlyTag_result1.itemID[1], any_FindCfgByOnlyTag_result1.itemCount[1])
		return true
	end
	for _, v in pairs(tbl_upvr_2) do
		if v == arg2 then
			require(game.ServerStorage.System.SystemRecord).RecordCover(arg1, arg2, 1)
			showLocalUI_upvr:FireClient(arg1, "章节礼包", nil, false)
		end
	end
	for i_2, v_2 in pairs(any_FindCfgByOnlyTag_result1.itemID) do
		if v_2 ~= 0 then
			local var65 = any_FindCfgByOnlyTag_result1.itemCount[i_2]
			local _ = {v_2}
			local _ = {var65}
			local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(v_2)
			if any_FindCfgByID_result1 then
				if any_FindCfgByID_result1.tp == EnumMgr_upvr.ItemType.Hero then
					table.insert({}, v_2)
				end
				if any_FindCfgByID_result1.tp == EnumMgr_upvr.ItemType.Coach then
					require(ServerStorage_upvr.System.SystemCoach).UpdateCoachNum(arg1)
					CheckLimitedCoach_upvr:FireClient(arg1, arg2)
				end
			end
			RemoteEvent_upvr:FireClient(arg1, "本地奖励提示", {
				key = "获得转盘奖励";
				ID = v_2;
				Number = var65;
			})
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for _, v_3 in pairs({}) do
		table.insert({}, v_3)
		local var74
	end
	for i_4, v_4 in pairs({}) do
		table.insert(var74, v_4)
		local var78
	end
	if 0 < #var78 then
		i_4 = var78
		showItems_upvr:FireClient(arg1, i_4)
	end
	if tbl_upvr[any_FindCfgByOnlyTag_result1.OnlyTag] then
		i_4 = arg1
		v_4 = "奖励领取弹窗无文字"
		showLocalUI_upvr:FireClient(i_4, v_4, {
			AwardID = any_FindCfgByOnlyTag_result1.itemID;
			Count = any_FindCfgByOnlyTag_result1.itemCount;
		}, true)
	end
	require(ReplicatedStorage_upvr.System.SystemSave).UpdateLocalData(arg1)
	return true
end
return module_upvr