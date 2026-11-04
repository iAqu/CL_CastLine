-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:36
-- Luau version 6, Types version 3
-- Time taken: 0.002954 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local Log_upvr = require(ReplicatedStorage.Tool.Log)
module_upvr.minLuckAddXyd = 3
local Copy_upvr = require(ReplicatedStorage.Tool.Copy)
local function GetPetByJing_upvr(arg1, arg2, arg3) -- Line 20, Named "GetPetByJing"
	--[[ Upvalues[3]:
		[1]: CfgFind_upvr (readonly)
		[2]: Copy_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 30 start (CF ANALYSIS FAILED)
	local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(arg2)
	local var15
	if not any_FindCfgByID_result1_3 then
		warn("缺少配置")
		return
	end
	var15 = Copy_upvr
	var15 = any_FindCfgByID_result1_3.ItemWeight
	local any_deepCopy_result1 = var15.deepCopy(var15)
	var15 = 0
	for i, v in pairs(Copy_upvr.deepCopy(any_FindCfgByID_result1_3.ItemIDVt)) do
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(v)
		local pairs_result1_2, pairs_result2_3, pairs_result3_3 = pairs(arg3)
		for _, v_2 in pairs_result1_2, pairs_result2_3, pairs_result3_3 do
			if v_2 == any_FindCfgByID_result1.xyd then
				table.insert({}, i)
				if module_upvr.minLuckAddXyd <= any_FindCfgByID_result1.xyd then
					var15 = any_deepCopy_result1[i]
				end
				if any_FindCfgByID_result1.xyd < module_upvr.minLuckAddXyd then
					var15 += any_deepCopy_result1[i]
				end
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	local pairs_result1_5, pairs_result2_5, pairs_result3_2 = pairs({})
	-- KONSTANTERROR: [0] 1. Error Block 30 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [110] 79. Error Block 20 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [110] 79. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [84] 61. Error Block 13 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [84] 61. Error Block 13 end (CF ANALYSIS FAILED)
end
local function _(arg1, arg2) -- Line 98, Named "HasData"
	for _, v_3 in pairs(arg1) do
		if v_3.id == arg2 then
			return true
		end
	end
	return false
end
local function GetJingLenth_upvr(arg1, arg2) -- Line 108, Named "GetJingLenth"
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: Log_upvr (readonly)
	]]
	local var37 = 2
	local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(arg2)
	local var39
	if any_FindCfgByID_result1_2 then
		var39 = 0
		for i_4, v_4 in pairs(any_FindCfgByID_result1_2.ItemIDVt) do
			local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(v_4)
			if any_FindCfgByID_result1_4 then
				local var44
				if any_FindCfgByID_result1_4.xyd and any_FindCfgByID_result1_2.JingProtect < any_FindCfgByID_result1_4.xyd then
					local var45 = any_FindCfgByID_result1_2.ItemWeight[i_4] * 1
					var39 += var45
					var44 += var45
				end
				if any_FindCfgByID_result1_4.xyd and any_FindCfgByID_result1_4.xyd <= any_FindCfgByID_result1_2.JingProtect then
					var44 += any_FindCfgByID_result1_2.ItemWeight[i_4]
					local var46 = var44
				end
			end
		end
		if var39 <= 0 then
			return var37
		end
		var37 = math.round(var46 / var39)
		Log_upvr.print("总长度:", var46, "稀有长度:", var39, "保底组长度:", var37)
	end
	return var37
end
local SystemSave_upvr = require(ReplicatedStorage.System.SystemSave)
function module_upvr.Amend(arg1, arg2, arg3) -- Line 155
	--[[ Upvalues[5]:
		[1]: SystemSave_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: GetJingLenth_upvr (readonly)
		[4]: GetPetByJing_upvr (readonly)
		[5]: Log_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 51 start (CF ANALYSIS FAILED)
	local any_GetStat_result1 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1 then
		return arg3
	end
	local pairs_result1_3, pairs_result2, pairs_result3_4 = pairs(arg3)
	for _, _ in pairs_result1_3, pairs_result2, pairs_result3_4 do
		local var56
	end
	pairs_result1_3 = any_GetStat_result1.JingData
	local var57 = pairs_result1_3
	if not var57 then
		var57 = {}
	end
	if not CfgFind_upvr.FindCfgByID(arg2) then
		return arg3
	end
	local pairs_result1, pairs_result2_2, pairs_result3 = pairs(var57)
	-- KONSTANTERROR: [0] 1. Error Block 51 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 32. Error Block 12 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 32. Error Block 12 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [34] 28. Error Block 63 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [40.14]
	if nil == arg2 then
		-- KONSTANTWARNING: GOTO [43] #34
	end
	-- KONSTANTERROR: [34] 28. Error Block 63 end (CF ANALYSIS FAILED)
end
return module_upvr