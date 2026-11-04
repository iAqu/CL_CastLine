-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:21
-- Luau version 6, Types version 3
-- Time taken: 0.007695 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConfigInstance_upvr = require(ReplicatedStorage.ConfigInstance)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local Copy_upvr = require(ReplicatedStorage.Tool.Copy)
local _
for i, v in pairs(ConfigInstance_upvr) do
	if i ~= "key" then
		for i_2, v_2 in pairs(v) do
			local tbl = {}
			for i_3, v_3 in pairs(v_2) do
				tbl[tostring(ConfigInstance_upvr.key[i][i_3])] = v_3
				local _
			end
			ConfigInstance_upvr[i][i_2] = tbl
		end
	end
end
local itemdataConf_upvr = ConfigInstance_upvr.itemdataConf
local eggdataConf_upvr = ConfigInstance_upvr.eggdataConf
local itemshopdataConf_upvr = ConfigInstance_upvr.itemshopdataConf
local herosConf = ConfigInstance_upvr.herosConf
local dailyawardConf_upvr = ConfigInstance_upvr.dailyawardConf
local gamepassitemConf_upvr = ConfigInstance_upvr.gamepassitemConf
local codeConf = ConfigInstance_upvr.codeConf
local toolConf_upvr = ConfigInstance_upvr.toolConf
local module_upvr_2 = {ConfigInstance_upvr.road_1Conf}
local module_upvr_3 = {ConfigInstance_upvr.roadaward_1Conf}
local module_upvr_4 = {ConfigInstance_upvr.speedconver_1Conf}
local ___________________________ = ReplicatedStorage["游戏全局配置"]["不同阶宠物倍率加成"]
for i_4, _ in pairs(codeConf) do
	codeConf[i_4].code = string.upper(codeConf[i_4].code)
	local _
end
local pairs_result1, pairs_result2_8, pairs_result3 = pairs(herosConf)
for i_5, _ in pairs_result1, pairs_result2_8, pairs_result3 do
	herosConf[i_5].NextGenId = i_5 + 100000
	local var101_upvr
end
local any_deepCopy_result1 = Copy_upvr.deepCopy(var101_upvr)
pairs_result3 = var101_upvr
local any_deepCopy_result1_2 = Copy_upvr.deepCopy(pairs_result3)
pairs_result3 = pairs(any_deepCopy_result1)
local pairs_result1_7, pairs_result2_6, pairs_result3_5 = pairs(any_deepCopy_result1)
for i_6, v_6 in pairs_result1_7, pairs_result2_6, pairs_result3_5 do
	any_deepCopy_result1[i_6].NextGenId = i_6 + 200000
	any_deepCopy_result1[i_6].FuseLv = 2
	any_deepCopy_result1[i_6].PowerAdd = v_6.PowerAdd * ___________________________.Shiny.Value
	any_deepCopy_result1[i_6].ZhName = v_6.ZhName
	var101_upvr[i_6 + 100000] = v_6
	local _
end
pairs_result1_7 = pairs(any_deepCopy_result1_2)
local pairs_result1_10_upvw, pairs_result2_7, pairs_result3_2 = pairs(any_deepCopy_result1_2)
for i_7, v_7 in pairs_result1_10_upvw, pairs_result2_7, pairs_result3_2 do
	any_deepCopy_result1_2[i_7].NextGenId = 0
	any_deepCopy_result1_2[i_7].FuseLv = 3
	any_deepCopy_result1_2[i_7].PowerAdd = v_7.PowerAdd * ___________________________.Rainbow.Value
	any_deepCopy_result1_2[i_7].ZhName = v_7.ZhName
	var101_upvr[i_7 + 200000] = v_7
	local _
end
function pairs_result1_10_upvw() -- Line 101, Named "GetHeroesConf"
	--[[ Upvalues[2]:
		[1]: Copy_upvr (readonly)
		[2]: var101_upvr (readonly)
	]]
	return Copy_upvr.deepCopy(var101_upvr)
end
module_upvr.GetHeroesConf = pairs_result1_10_upvw
local muscleConf_upvr = ConfigInstance_upvr.muscleConf
function pairs_result1_10_upvw(arg1, arg2) -- Line 106, Named "GetMuclePecentBytCfg"
	--[[ Upvalues[1]:
		[1]: muscleConf_upvr (readonly)
	]]
	-- KONSTANTERROR: [21] 19. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.5]
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.4]
	-- KONSTANTERROR: [21] 19. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 12 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.2]
	if nil then
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.10]
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.197506]
		if nil <= arg2 then
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.7]
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [21.8]
			-- KONSTANTWARNING: GOTO [13] #12
		end
		-- KONSTANTWARNING: GOTO [21] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 12 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [22] 20. Error Block 8 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	do
		return nil[nil], nil
	end
	-- KONSTANTERROR: [22] 20. Error Block 8 end (CF ANALYSIS FAILED)
end
module_upvr.GetMuclePecentBytCfg = pairs_result1_10_upvw
local coachConf_upvr = ConfigInstance_upvr.coachConf
function pairs_result1_10_upvw(arg1, arg2) -- Line 136, Named "FindCfgByID"
	--[[ Upvalues[7]:
		[1]: itemdataConf_upvr (readonly)
		[2]: var101_upvr (readonly)
		[3]: eggdataConf_upvr (readonly)
		[4]: coachConf_upvr (readonly)
		[5]: gamepassitemConf_upvr (readonly)
		[6]: toolConf_upvr (readonly)
		[7]: EnumMgr_upvr (readonly)
	]]
	local tonumber_result1_2 = tonumber(arg1)
	if not tonumber_result1_2 then
		do
			return
		end
		local var115
	end
	if arg2 == nil then
		var115 = itemdataConf_upvr[tonumber_result1_2]
		if not var115 then
			var115 = var101_upvr[tonumber_result1_2]
		end
		if not var115 then
		end
		if not eggdataConf_upvr[tonumber_result1_2] then
		end
		if not coachConf_upvr[tonumber_result1_2] then
		end
		if not gamepassitemConf_upvr[tonumber_result1_2] then
		end
		return toolConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Item or arg2 == EnumMgr_upvr.ItemType.UseItem then
		return itemdataConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.GamePass then
		return gamepassitemConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Hero then
		return var101_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Egg then
		return eggdataConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Coach then
		return coachConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Tool then
		return toolConf_upvr[tonumber_result1_2]
	end
	if arg2 == EnumMgr_upvr.ItemType.Box then
		return nil
	end
end
module_upvr.FindCfgByID = pairs_result1_10_upvw
function pairs_result1_10_upvw(arg1) -- Line 186, Named "GetCfgByName"
	--[[ Upvalues[1]:
		[1]: ConfigInstance_upvr (readonly)
	]]
	if ConfigInstance_upvr[arg1] then
		return ConfigInstance_upvr[arg1]
	end
end
module_upvr.GetCfgByName = pairs_result1_10_upvw
function pairs_result1_10_upvw(arg1, arg2) -- Line 192, Named "GetCfgByNameAndID"
	--[[ Upvalues[1]:
		[1]: ConfigInstance_upvr (readonly)
	]]
	if ConfigInstance_upvr[arg1] then
		return ConfigInstance_upvr[arg1][tonumber(arg2)]
	end
end
module_upvr.GetCfgByNameAndID = pairs_result1_10_upvw
function pairs_result1_10_upvw(arg1) -- Line 199, Named "FindCfgByOnlyTag"
	--[[ Upvalues[1]:
		[1]: itemshopdataConf_upvr (readonly)
	]]
	for _, v_8 in pairs(itemshopdataConf_upvr) do
		if v_8.OnlyTag == tostring(arg1) then
			return v_8
		end
	end
end
module_upvr.FindCfgByOnlyTag = pairs_result1_10_upvw
local explvConf_upvr = ConfigInstance_upvr.explvConf
function pairs_result1_10_upvw(arg1) -- Line 211, Named "GetTotalPowerByLv"
	--[[ Upvalues[1]:
		[1]: explvConf_upvr (readonly)
	]]
	local var124 = 0
	for i_9 = 1, arg1 do
		var124 += explvConf_upvr[i_9].NeedExp
	end
	return var124
end
module_upvr.GetTotalPowerByLv = pairs_result1_10_upvw
local taskConf_upvr = ConfigInstance_upvr.taskConf
function pairs_result1_10_upvw(arg1) -- Line 221, Named "GetTaskCfg"
	--[[ Upvalues[1]:
		[1]: taskConf_upvr (readonly)
	]]
	for i_10, v_9 in pairs(taskConf_upvr) do
		if v_9.onlyTag == arg1 then
			return v_9, i_10
		end
	end
end
module_upvr.GetTaskCfg = pairs_result1_10_upvw
function pairs_result1_10_upvw(arg1) -- Line 229, Named "GetAllCfgByTp"
	--[[ Upvalues[5]:
		[1]: EnumMgr_upvr (readonly)
		[2]: itemdataConf_upvr (readonly)
		[3]: var101_upvr (readonly)
		[4]: gamepassitemConf_upvr (readonly)
		[5]: toolConf_upvr (readonly)
	]]
	if arg1 == EnumMgr_upvr.ItemType.Item or arg1 == EnumMgr_upvr.ItemType.UseItem then
		return itemdataConf_upvr
	end
	if arg1 == EnumMgr_upvr.ItemType.Hero then
		return var101_upvr
	end
	if arg1 == EnumMgr_upvr.ItemType.GamePass then
		return gamepassitemConf_upvr
	end
	if arg1 == EnumMgr_upvr.ItemType.Tool then
		return toolConf_upvr
	end
end
module_upvr.GetAllCfgByTp = pairs_result1_10_upvw
pairs_result1_10_upvw = 1
for _, v_10 in pairs(dailyawardConf_upvr) do
	if pairs_result1_10_upvw <= v_10.week then
		pairs_result1_10_upvw = v_10.week
	end
end
function module_upvr.GetDailyAward(arg1, arg2) -- Line 251
	--[[ Upvalues[2]:
		[1]: pairs_result1_10_upvw (read and write)
		[2]: dailyawardConf_upvr (readonly)
	]]
	local var138
	if pairs_result1_10_upvw < var138 then
		var138 = pairs_result1_10_upvw
	end
	for _, v_11 in pairs(dailyawardConf_upvr) do
		if var138 == v_11.week and arg2 == v_11.index then
			return v_11
		end
	end
end
function module_upvr.FindCfgByPassID_Gift(arg1) -- Line 264
	--[[ Upvalues[1]:
		[1]: itemshopdataConf_upvr (readonly)
	]]
	local tonumber_result1_3 = tonumber(arg1)
	if not tonumber_result1_3 then
	else
		for _, v_13 in pairs(itemshopdataConf_upvr) do
			if tonumber(v_13.GiftID) == tonumber_result1_3 then
				return v_13
			end
		end
	end
end
function module_upvr.FindCfgByPassID(arg1) -- Line 278
	--[[ Upvalues[1]:
		[1]: itemshopdataConf_upvr (readonly)
	]]
	local tonumber_result1 = tonumber(arg1)
	if not tonumber_result1 then
	else
		for _, v_14 in pairs(itemshopdataConf_upvr) do
			if v_14.passID == tonumber_result1 then
				return v_14
			end
		end
	end
end
local buffdataConf_upvr = ConfigInstance_upvr.buffdataConf
function module_upvr.GetBuffcfgByID(arg1) -- Line 292
	--[[ Upvalues[1]:
		[1]: buffdataConf_upvr (readonly)
	]]
	return buffdataConf_upvr[tonumber(arg1)]
end
function module_upvr.FindEggCfgById(arg1) -- Line 296
	--[[ Upvalues[1]:
		[1]: eggdataConf_upvr (readonly)
	]]
	return eggdataConf_upvr[arg1]
end
function module_upvr.FindCfgByEggId(arg1) -- Line 300
	--[[ Upvalues[1]:
		[1]: itemshopdataConf_upvr (readonly)
	]]
	local tonumber_result1_4 = tonumber(arg1)
	if not tonumber_result1_4 then
	else
		for _, v_15 in pairs(itemshopdataConf_upvr) do
			if v_15.itemID[1] == tonumber_result1_4 then
				return v_15
			end
		end
	end
end
function module_upvr.GetGamePassItemIDByOnlyID(arg1) -- Line 313
	--[[ Upvalues[1]:
		[1]: itemshopdataConf_upvr (readonly)
	]]
	for _, v_12 in pairs(itemshopdataConf_upvr) do
		if v_12.OnlyTag == arg1 and v_12.gamePassItemID ~= "" then
			return v_12.gamePassItemID
		end
	end
end
function module_upvr.GetPetShinyLv(arg1) -- Line 325
	--[[ Upvalues[1]:
		[1]: var101_upvr (readonly)
	]]
	if not arg1 then return end
	local var166 = var101_upvr[arg1]
	if not var166 then return end
	return var166.NextGenId
end
function module_upvr.GetPetRainBowLv(arg1) -- Line 336
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var101_upvr (readonly)
	]]
	if not arg1 then return end
	local any_GetPetShinyLv_result1 = module_upvr.GetPetShinyLv(arg1)
	if not any_GetPetShinyLv_result1 then return end
	local var168 = var101_upvr[any_GetPetShinyLv_result1]
	if not var168 then return end
	return var168.NextGenId
end
local any_GetCurWorld_result1_upvr = require(ReplicatedStorage.Tool.WorldUtil).GetCurWorld()
function module_upvr.GetRoadCfg() -- Line 355
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: any_GetCurWorld_result1_upvr (readonly)
	]]
	return module_upvr_2[any_GetCurWorld_result1_upvr]
end
function module_upvr.GetRoadAwardCfg() -- Line 361
	--[[ Upvalues[2]:
		[1]: module_upvr_3 (readonly)
		[2]: any_GetCurWorld_result1_upvr (readonly)
	]]
	return module_upvr_3[any_GetCurWorld_result1_upvr]
end
function module_upvr.GetRoadAwardCfgByRoadID(arg1) -- Line 366
	--[[ Upvalues[2]:
		[1]: module_upvr_3 (readonly)
		[2]: any_GetCurWorld_result1_upvr (readonly)
	]]
	return module_upvr_3[any_GetCurWorld_result1_upvr][arg1]
end
function module_upvr.GetSpeedCfg() -- Line 370
	--[[ Upvalues[2]:
		[1]: module_upvr_4 (readonly)
		[2]: any_GetCurWorld_result1_upvr (readonly)
	]]
	return module_upvr_4[any_GetCurWorld_result1_upvr]
end
return module_upvr