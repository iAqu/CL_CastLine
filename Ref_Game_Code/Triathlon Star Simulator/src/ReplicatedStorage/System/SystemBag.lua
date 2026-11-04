-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:24
-- Luau version 6, Types version 3
-- Time taken: 0.019123 seconds

local module_upvr = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local ServerStorage_upvr = game:GetService("ServerStorage")
local SystemPet_upvr = require(ServerStorage_upvr.System.SystemPet)
local SystemTool_upvr = require(ServerStorage_upvr.System.SystemTool)
local SystemSave_upvr = require(ReplicatedStorage_upvr.System.SystemSave)
local SystemRecordPetTotalNum_upvr = require(ServerStorage_upvr.System.SystemRecordPetTotalNum)
local SystemRecordAuraTotalNum_upvr = require(ServerStorage_upvr.System.SystemRecordAuraTotalNum)
local CfgFind_upvr = require(ReplicatedStorage_upvr.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage_upvr.Tool.EnumMgr)
local Log_upvr = require(ReplicatedStorage_upvr.Tool.Log)
local TipsModule_upvr = require(ReplicatedStorage_upvr.Tool.TipsModule)
local Copy_upvr = require(ReplicatedStorage_upvr.Tool.Copy)
local function _(arg1, arg2) -- Line 35, Named "RecordPetNum"
	--[[ Upvalues[1]:
		[1]: SystemRecordPetTotalNum_upvr (readonly)
	]]
	SystemRecordPetTotalNum_upvr.RecordPetNum(arg1, arg2)
end
local function _(arg1, arg2) -- Line 39, Named "RecordAuraNum"
	--[[ Upvalues[1]:
		[1]: SystemRecordAuraTotalNum_upvr (readonly)
	]]
	SystemRecordAuraTotalNum_upvr.RecordAuraNum(arg1, arg2)
end
local function _(arg1) -- Line 44, Named "GetBagData"
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local any_GetStat_result1_9 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_9 then
		return nil
	end
	return any_GetStat_result1_9.Bag
end
local function _(arg1) -- Line 52, Named "getBagFolder"
	local Bag_2 = arg1:FindFirstChild("Bag")
	if not Bag_2 then
		Bag_2 = Instance.new("Folder", arg1)
		Bag_2.Name = "Bag"
	end
	return Bag_2
end
local function _(arg1) -- Line 62, Named "GetEmailData"
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local any_GetStat_result1_3 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_3 then return end
	local Email = any_GetStat_result1_3.Email
	if not Email then return end
	return Email
end
local any_GetCfgByName_result1_upvr = CfgFind_upvr.GetCfgByName("itemdataConf")
function module_upvr.Init(arg1, arg2) -- Line 75
	--[[ Upvalues[2]:
		[1]: any_GetCfgByName_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local Bag = arg1:FindFirstChild("Bag")
	if not Bag then
		Bag = Instance.new("Folder", arg1)
		Bag.Name = "Bag"
	end
	for i, v in pairs(any_GetCfgByName_result1_upvr) do
		if v.isShow == 1 and v.hasCount == 1 then
			local NumberValue = Instance.new("NumberValue", Bag)
			NumberValue.Name = i
			NumberValue.Value = 0
		end
	end
	module_upvr.updateValue(arg1)
	if arg2 then
		for i_2, v_2 in pairs(any_GetCfgByName_result1_upvr) do
			if tonumber(v_2.init) and 0 < tonumber(v_2.init) then
				module_upvr.KillEnemyPutInBag(arg1, {i_2}, {tonumber(v_2.init)})
			end
		end
	end
end
function module_upvr.updateValue(arg1) -- Line 96
	--[[ Upvalues[3]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
	]]
	local any_GetStat_result1_17 = SystemSave_upvr.GetStat(arg1)
	local var66
	if not any_GetStat_result1_17 then
		var66 = nil
	else
		var66 = any_GetStat_result1_17.Bag
	end
	if not var66 then
	else
		local Bag_3 = arg1:FindFirstChild("Bag")
		if not Bag_3 then
			Bag_3 = Instance.new("Folder", arg1)
			Bag_3.Name = "Bag"
		end
		local var68 = Bag_3
		for _, v_10 in pairs(var68:GetChildren()) do
			v_10.Value = 0
		end
		for _, v_11 in pairs(var66) do
			local SOME = var68:FindFirstChild(tostring(v_11.id))
			if SOME and SOME.ClassName ~= "Folder" then
				SOME.Value = v_11.count
			end
			if v_11 and v_11.count and 0 < v_11.count then
				local any_FindCfgByID_result1_5 = CfgFind_upvr.FindCfgByID(v_11.id, EnumMgr_upvr.ItemType.GamePass)
				if any_FindCfgByID_result1_5 and any_FindCfgByID_result1_5.OnlyTag and arg1:FindFirstChild("GamePass"):FindFirstChild(any_FindCfgByID_result1_5.OnlyTag) then
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					arg1:FindFirstChild("GamePass"):FindFirstChild(any_FindCfgByID_result1_5.OnlyTag).Value = 1
				end
			end
		end
	end
end
local function _(arg1) -- Line 129, Named "getOnlyID"
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local var77 = (SystemSave_upvr.GetStat(arg1).onlyID or 1000) + 1
	SystemSave_upvr.ChangeStat(arg1, "onlyID", var77, false)
	return var77
end
local function _(arg1) -- Line 137, Named "getIsCount"
	--[[ Upvalues[1]:
		[1]: EnumMgr_upvr (readonly)
	]]
	if arg1.tp and arg1.tp == EnumMgr_upvr.ItemType.Skill then
		return 1
	end
	local hasCount = arg1.hasCount
	if not hasCount then
		hasCount = 0
	end
	return hasCount
end
function module_upvr.PutDataInBag(arg1, arg2) -- Line 152
	--[[ Upvalues[3]:
		[1]: SystemSave_upvr (readonly)
		[2]: Copy_upvr (readonly)
		[3]: Log_upvr (readonly)
	]]
	if not arg1 or not arg2 then
	else
		local any_GetStat_result1_8 = SystemSave_upvr.GetStat(arg1)
		if not any_GetStat_result1_8 then return end
		local Bag_4 = any_GetStat_result1_8.Bag
		if Bag_4 then
			local var81 = (SystemSave_upvr.GetStat(arg1).onlyID or 1000) + 1
			SystemSave_upvr.ChangeStat(arg1, "onlyID", var81, false)
			arg2.onlyID = var81
			table.insert(Bag_4, Copy_upvr.deepCopy(arg2))
			SystemSave_upvr.ChangeStat(arg1, "Bag", Bag_4, true)
			Log_upvr.print("直接存数据进背包:"..arg1.DisplayName, arg2.id)
		end
	end
end
local showLocalUI_upvr = ReplicatedStorage_upvr.ServerMsg.showLocalUI
function module_upvr.ShowAwardPop(arg1, arg2, arg3) -- Line 177
	--[[ Upvalues[1]:
		[1]: showLocalUI_upvr (readonly)
	]]
	if type(arg2) ~= "table" then
		warn("奖励领取弹窗 传入类型不对 不是table")
	else
		if type(arg3) ~= "table" then
			warn("奖励领取弹窗 传入类型不对 不是table")
			return
		end
		local tbl_2 = {}
		tbl_2.AwardID = arg2
		tbl_2.Count = arg3
		showLocalUI_upvr:FireClient(arg1, "奖励领取弹窗无文字", tbl_2, true)
	end
end
local SystemRecord_upvr = require(ServerStorage_upvr.System.SystemRecord)
local SystemRedPoint_upvr = require(ReplicatedStorage_upvr.System.SystemRedPoint)
local function PutItemInBag_upvr(arg1, arg2, arg3, arg4) -- Line 197, Named "PutItemInBag"
	--[[ Upvalues[11]:
		[1]: CfgFind_upvr (readonly)
		[2]: SystemRecord_upvr (readonly)
		[3]: SystemSave_upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: module_upvr (readonly)
		[6]: SystemPet_upvr (readonly)
		[7]: SystemRecordPetTotalNum_upvr (readonly)
		[8]: SystemRecordAuraTotalNum_upvr (readonly)
		[9]: SystemTool_upvr (readonly)
		[10]: SystemRedPoint_upvr (readonly)
		[11]: ServerStorage_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 88 start (CF ANALYSIS FAILED)
	local var93
	if var93 == nil then
		var93 = 1
	end
	local tonumber_result1 = tonumber(arg2)
	var93 = tonumber(var93)
	if not arg1 or not tonumber_result1 or tonumber_result1 == 0 then return end
	local any_FindCfgByID_result1_6 = CfgFind_upvr.FindCfgByID(tonumber_result1)
	if not any_FindCfgByID_result1_6 then
		warn("没有这个物品的配置表"..tonumber_result1)
		return
	end
	local RecordGetBagItem = SystemRecord_upvr.RecordGetBagItem
	RecordGetBagItem(arg1, tonumber_result1, var93)
	local any_GetStat_result1_4 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_4 then
		RecordGetBagItem = nil
	else
		RecordGetBagItem = any_GetStat_result1_4.Bag
	end
	if not RecordGetBagItem then return end
	if any_FindCfgByID_result1_6.UnlockInf then
	end
	if any_FindCfgByID_result1_6.tp then
		if any_FindCfgByID_result1_6.tp == EnumMgr_upvr.ItemType.Skill then
			-- KONSTANTWARNING: GOTO [79] #63
		end
	end
	if not any_FindCfgByID_result1_6.hasCount then
	end
	-- KONSTANTERROR: [0] 1. Error Block 88 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 63. Error Block 24 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 63. Error Block 24 end (CF ANALYSIS FAILED)
end
function module_upvr.DelItemByOnlyID(arg1, arg2, arg3) -- Line 326
	--[[ Upvalues[4]:
		[1]: SystemSave_upvr (readonly)
		[2]: Copy_upvr (readonly)
		[3]: Log_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	local any_GetStat_result1_5 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_5 then
		local _
	else
	end
	if not any_GetStat_result1_5.Bag then
		return false
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_3, v_3 in pairs(any_GetStat_result1_5.Bag) do
		if v_3.onlyID == arg2 then
			if arg3 == nil or arg3 == false then
				if v_3.lock and v_3.lock == 1 then
					return false
				end
			end
			if v_3.using and v_3.using == 1 then
				return false
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			Log_upvr.print("DelItemByOnlyID 数据删除:", any_GetStat_result1_5.Bag[i_3].id)
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.remove(any_GetStat_result1_5.Bag, i_3)
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			SystemSave_upvr.ChangeStat(arg1, "Bag", any_GetStat_result1_5.Bag, false)
			module_upvr.updateValue(arg1)
			return Copy_upvr.deepCopy(v_3)
		end
	end
	return false
end
function module_upvr.BuyItemAndDelItem(arg1, arg2, arg3) -- Line 366
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg3 <= module_upvr.GetItemCountByID(arg1, arg2) then
		if module_upvr.DelItemByIDCount(arg1, arg2, arg3) then
			return true
		end
		return false
	end
	return false
end
function module_upvr.BuyItemAndDelItemVt(arg1, arg2, arg3) -- Line 379
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	for i_4, v_4 in pairs(arg2) do
		if module_upvr.GetItemCountByID(arg1, v_4) < arg3[i_4] then
			return false
		end
	end
	for i_5, v_5 in pairs(arg2) do
		module_upvr.DelItemByIDCount(arg1, v_5, arg3[i_5])
	end
	return true
end
function module_upvr.DelItemByIDCount(arg1, arg2, arg3) -- Line 398
	--[[ Upvalues[4]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 58 start (CF ANALYSIS FAILED)
	local tonumber_result1_6 = tonumber(arg2)
	local var128
	if not arg1 or not tonumber_result1_6 or tonumber_result1_6 == 0 then
		var128 = false
		return var128
	end
	if tonumber(arg3) == nil then
	end
	local any_GetStat_result1 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1 then
		var128 = nil
	else
		var128 = any_GetStat_result1.Bag
	end
	if not var128 then
		return false
	end
	local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(tonumber_result1_6)
	if any_FindCfgByID_result1_4.tp then
		if any_FindCfgByID_result1_4.tp == EnumMgr_upvr.ItemType.Skill then
			-- KONSTANTWARNING: GOTO [58] #46
		end
	end
	if not any_FindCfgByID_result1_4.hasCount then
	end
	-- KONSTANTERROR: [0] 1. Error Block 58 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [58] 46. Error Block 20 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [58] 46. Error Block 20 end (CF ANALYSIS FAILED)
end
function module_upvr.LockItemByID(arg1, arg2, arg3) -- Line 457
	--[[ Upvalues[2]:
		[1]: SystemSave_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	local any_GetStat_result1_19 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_19 then
		local _
	else
	end
	if not any_GetStat_result1_19.Bag then
		return false
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_6, v_6 in pairs(any_GetStat_result1_19.Bag) do
		if v_6.onlyID == arg2 then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			any_GetStat_result1_19.Bag[i_6].lock = arg3
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	SystemSave_upvr.ChangeStat(arg1, "Bag", any_GetStat_result1_19.Bag, true)
	module_upvr.updateValue(arg1)
	return true
end
function module_upvr.DelItemByID(arg1, arg2) -- Line 479
	--[[ Upvalues[5]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: Log_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 50 start (CF ANALYSIS FAILED)
	if not arg1 or not arg2 or arg2 == 0 then
		return false
	end
	local any_GetStat_result1_13 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_13 then
	else
	end
	if not any_GetStat_result1_13.Bag then
		return false
	end
	local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(arg2)
	if any_FindCfgByID_result1_2.tp then
		if any_FindCfgByID_result1_2.tp == EnumMgr_upvr.ItemType.Skill then
			-- KONSTANTWARNING: GOTO [43] #34
		end
	end
	if not any_FindCfgByID_result1_2.hasCount then
	end
	-- KONSTANTERROR: [0] 1. Error Block 50 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [43] 34. Error Block 18 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [43] 34. Error Block 18 end (CF ANALYSIS FAILED)
end
function module_upvr.GetItemByOnlyID(arg1, arg2) -- Line 523
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	if not arg1 or not arg2 or arg2 == 0 then
	else
		local any_GetStat_result1_2 = SystemSave_upvr.GetStat(arg1)
		if not any_GetStat_result1_2 then
			local _
		else
		end
		if not any_GetStat_result1_2.Bag then return end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		for _, v_12 in pairs(any_GetStat_result1_2.Bag) do
			if v_12.onlyID == tonumber(arg2) then
				return v_12
			end
		end
	end
end
function module_upvr.GetItemByItemID(arg1, arg2) -- Line 543
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	if not arg1 or not arg2 or arg2 == 0 then
	else
		local any_GetStat_result1_20 = SystemSave_upvr.GetStat(arg1)
		if not any_GetStat_result1_20 then
			local _
		else
		end
		if not any_GetStat_result1_20.Bag then return end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		for _, v_13 in pairs(any_GetStat_result1_20.Bag) do
			if v_13.id == arg2 then
				return v_13
			end
		end
	end
end
function module_upvr.GetItemCountByID(arg1, arg2) -- Line 562
	--[[ Upvalues[3]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 59 start (CF ANALYSIS FAILED)
	if not arg2 or not tonumber(arg2) then
		return 0
	end
	local tonumber_result1_7 = tonumber(arg2)
	if not arg1 or tonumber_result1_7 == 0 then
		return 0
	end
	local any_GetStat_result1_18 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_18 then
	else
	end
	if not any_GetStat_result1_18.Bag then
		return 0
	end
	local any_FindCfgByID_result1_11 = CfgFind_upvr.FindCfgByID(tonumber_result1_7)
	if not any_FindCfgByID_result1_11 then
		warn("没有这个物品的配置表:"..tonumber_result1_7)
		return 0
	end
	if any_FindCfgByID_result1_11.tp then
		if any_FindCfgByID_result1_11.tp == EnumMgr_upvr.ItemType.Skill then
			-- KONSTANTWARNING: GOTO [66] #54
		end
	end
	if not any_FindCfgByID_result1_11.hasCount then
	end
	-- KONSTANTERROR: [0] 1. Error Block 59 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [66] 54. Error Block 23 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [66] 54. Error Block 23 end (CF ANALYSIS FAILED)
end
function module_upvr.PutItemVtsInBag(arg1, arg2, arg3) -- Line 611
	--[[ Upvalues[5]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: SystemPet_upvr (readonly)
		[4]: TipsModule_upvr (readonly)
		[5]: PutItemInBag_upvr (readonly)
	]]
	for _, v_7 in pairs(arg2) do
		if CfgFind_upvr.FindCfgByID(v_7).tp == EnumMgr_upvr.ItemType.Hero and SystemPet_upvr.GetBagLessNum(arg1) <= 0 then
			TipsModule_upvr.ErrorTips(arg1, "宠物背包已满")
			return false
		end
	end
	for i_8, v_8 in pairs(arg2) do
		PutItemInBag_upvr(arg1, v_8, arg3[i_8])
	end
	return true
end
function module_upvr.GivePlrEmailAward(arg1, arg2) -- Line 636
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 14 start (CF ANALYSIS FAILED)
	local any_GetStat_result1_16 = SystemSave_upvr.GetStat(arg1)
	local var194
	if not any_GetStat_result1_16 then
		var194 = nil
		-- KONSTANTWARNING: GOTO [14] #13
	end
	-- KONSTANTERROR: [0] 1. Error Block 14 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [8] 8. Error Block 15 start (CF ANALYSIS FAILED)
	local Email_2 = any_GetStat_result1_16.Email
	if not Email_2 then
		var194 = nil
	else
		var194 = Email_2
	end
	if var194 then
		table.insert(var194, arg2)
		SystemSave_upvr.ChangeStat(arg1, "Email", var194)
	end
	-- KONSTANTERROR: [8] 8. Error Block 15 end (CF ANALYSIS FAILED)
end
function module_upvr.GiveAwardByEmail(arg1, arg2, arg3, arg4) -- Line 647
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local tbl = {}
	tbl.RewardID = arg2
	tbl.RewardCount = arg3
	tbl.UserID = arg1.UserId
	tbl.Des = arg4
	module_upvr.GivePlrEmailAward(arg1, tbl)
end
local SystemEmail_upvr = require(ServerStorage_upvr.System.SystemEmail)
local Value_upvr = ReplicatedStorage_upvr["游戏全局配置"]["邮件最大数量"].Value
function module_upvr.KillEnemyPutInBag(arg1, arg2, arg3, arg4, arg5) -- Line 658
	--[[ Upvalues[11]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: SystemPet_upvr (readonly)
		[4]: TipsModule_upvr (readonly)
		[5]: SystemTool_upvr (readonly)
		[6]: module_upvr (readonly)
		[7]: Log_upvr (readonly)
		[8]: PutItemInBag_upvr (readonly)
		[9]: SystemEmail_upvr (readonly)
		[10]: Value_upvr (readonly)
		[11]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_6, pairs_result2_8, pairs_result3 = pairs(arg2)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [119] 90. Error Block 16 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [119] 90. Error Block 16 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 8. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [119.14]
	-- KONSTANTERROR: [10] 8. Error Block 2 end (CF ANALYSIS FAILED)
end
function module_upvr.UseItem(arg1, arg2) -- Line 735
	--[[ Upvalues[5]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: ReplicatedStorage_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	for _, v_9 in pairs(SystemSave_upvr.GetStat(arg1).Bag) do
		if v_9.onlyID == tonumber(arg2) and 1 <= v_9.count then
			local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(v_9.id, EnumMgr_upvr.ItemType.UseItem)
			if any_FindCfgByID_result1_3 then
				local SOME_3 = ReplicatedStorage_upvr.ItemScript:FindFirstChild(any_FindCfgByID_result1_3.UseScript)
				if SOME_3 and 1 <= v_9.count then
					module_upvr.DelItemByIDCount(arg1, v_9.id, 1)
					require(SOME_3).Use(arg1, any_FindCfgByID_result1_3.parms)
				end
			end
			return
		end
	end
end
function module_upvr.DelWeaponByIDLv(arg1, arg2, arg3, arg4, arg5) -- Line 760
	--[[ Upvalues[4]:
		[1]: SystemSave_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: Log_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
	if not arg1 then
		return false
	end
	local any_GetStat_result1_15 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_15 then
		local _
	else
	end
	if not any_GetStat_result1_15.Bag then
		return false
	end
	-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [20] 19. Error Block 9 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	local _, _, _ = pairs(any_GetStat_result1_15.Bag)
	-- KONSTANTERROR: [20] 19. Error Block 9 end (CF ANALYSIS FAILED)
end
function module_upvr.GetExpAfterBuff(arg1, arg2) -- Line 794
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: Log_upvr (readonly)
	]]
	local PetEnergyAdd = arg1:FindFirstChild("PetEnergyAdd")
	local var224 = 0
	if PetEnergyAdd then
		var224 = PetEnergyAdd.Value * 0.01
	end
	local var225 = math.floor(arg2 * (1 + var224)) * 1 * 1
	module_upvr.KillEnemyPutInBag(arg1, {EnumMgr_upvr.ItemID.Exp}, {var225})
	Log_upvr.print("获得经验:", arg2, "加成后：", var225)
end
function module_upvr.TradeItemByOnlyIDAndDel(arg1, arg2, arg3) -- Line 817
	--[[ Upvalues[5]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: Copy_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	local tonumber_result1_5 = tonumber(arg2)
	local tonumber_result1_3 = tonumber(arg3)
	local var234 = tonumber_result1_3
	if not arg1 or not tonumber_result1_5 or tonumber_result1_5 == 0 then
	else
		local any_GetStat_result1_6 = SystemSave_upvr.GetStat(arg1)
		if not any_GetStat_result1_6 then
			tonumber_result1_3 = nil
		else
			tonumber_result1_3 = any_GetStat_result1_6.Bag
		end
		if not tonumber_result1_3 then return end
		for i_14, v_14 in pairs(tonumber_result1_3) do
			if v_14.onlyID == tonumber_result1_5 then
				if not CfgFind_upvr.FindCfgByID(v_14.id, EnumMgr_upvr.ItemType.Hero) then return end
				if tonumber_result1_3[i_14].count < 1 then return end
				local var239 = tonumber_result1_3[i_14].count - var234
				if var239 <= 0 then
					local any_deepCopy_result1 = Copy_upvr.deepCopy(v_14)
					any_deepCopy_result1.count = var234
					table.remove(tonumber_result1_3, i_14)
					SystemSave_upvr.ChangeStat(arg1, "Bag", tonumber_result1_3)
					module_upvr.updateValue(arg1)
					return any_deepCopy_result1
				end
				local any_deepCopy_result1_2 = Copy_upvr.deepCopy(v_14)
				any_deepCopy_result1_2.count = var234
				tonumber_result1_3[i_14].count = var239
				SystemSave_upvr.ChangeStat(arg1, "Bag", tonumber_result1_3)
				module_upvr.updateValue(arg1)
				return any_deepCopy_result1_2
			end
		end
	end
end
function module_upvr.TradeInBag(arg1, arg2) -- Line 877
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: PutItemInBag_upvr (readonly)
	]]
	if not arg1 or not arg2 then
	else
		local id = arg2.id
		if not id then return end
		local count = arg2.count
		if not count then return end
		if not CfgFind_upvr.FindCfgByID(id) then return end
		PutItemInBag_upvr(arg1, id, count)
	end
end
return module_upvr