-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:26
-- Luau version 6, Types version 3
-- Time taken: 0.010202 seconds

local module_upvr_2 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module_upvr_4 = require(ReplicatedStorage:WaitForChild("System"):WaitForChild("SystemBag"))
local module_upvr_3 = require(ReplicatedStorage:WaitForChild("System"):WaitForChild("SystemSave"))
local CheckGamePass_upvr = require(ReplicatedStorage.Tool.CheckGamePass)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local SystemPet_upvr = require(game.ServerStorage.System.SystemPet)
local __________________ = ReplicatedStorage["游戏全局配置"]
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local any_GetCfgByName_result1_upvr = CfgFind_upvr.GetCfgByName("eggdataConf")
local module_upvr_5 = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("GradientsMgr"))
local function SendLuckyHatchMes_upvr(arg1, arg2, arg3) -- Line 34, Named "SendLuckyHatchMes"
	--[[ Upvalues[5]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: any_GetCfgByName_result1_upvr (readonly)
		[4]: module_upvr_5 (readonly)
		[5]: RemoteEvent_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 32 start (CF ANALYSIS FAILED)
	local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(arg2)
	local var15
	if not any_FindCfgByID_result1_2 then
	else
		local xyd = any_FindCfgByID_result1_2.xyd
		if not xyd then return end
		var15 = EnumMgr_upvr
		if xyd < var15.Rare.Mysterious then return end
		local var17 = any_GetCfgByName_result1_upvr[arg3]
		if not var17 then return end
		var15 = '['..var17.emoji.."🥚] "..arg1.DisplayName.." Hatched a "
		if xyd == EnumMgr_upvr.Rare.Mysterious then
			var15 = var15.."<font color='#ff0000'>"..module_upvr_5.getXydName(any_FindCfgByID_result1_2.xyd).."</font>".." Pet ".."<font color='#ff0000'>"..any_FindCfgByID_result1_2.ZhName.."</font>"..'!'
			-- KONSTANTWARNING: GOTO [131] #101
		end
		if xyd == EnumMgr_upvr.Rare.Legendary then
		elseif xyd == EnumMgr_upvr.Rare.Immortal then
		elseif xyd == EnumMgr_upvr.Rare.Secret then
		end
		-- KONSTANTERROR: [0] 1. Error Block 32 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [131] 101. Error Block 20 start (CF ANALYSIS FAILED)
		RemoteEvent_upvr:FireAllClients("抽蛋提示", var15.."<font color='#ffaa00'>"..module_upvr_5.getXydName(any_FindCfgByID_result1_2.xyd).."</font>".." Pet ".."<font color='#ffaa00'>"..any_FindCfgByID_result1_2.ZhName.."</font>"..'!'.."<font color='#ff00ff'>"..module_upvr_5.getXydName(any_FindCfgByID_result1_2.xyd).."</font>".." Pet ".."<font color='#ff00ff'>"..any_FindCfgByID_result1_2.ZhName.."</font>"..'!'.."<font color='#ed20f7'>"..module_upvr_5.getXydName(any_FindCfgByID_result1_2.xyd).."</font>".." Pet ".."<font color='#ed20f7'>"..any_FindCfgByID_result1_2.ZhName.."</font>"..'!')
		-- KONSTANTERROR: [131] 101. Error Block 20 end (CF ANALYSIS FAILED)
	end
end
local function IsMoneyEnough_upvr(arg1, arg2, arg3, arg4) -- Line 76, Named "IsMoneyEnough"
	--[[ Upvalues[1]:
		[1]: module_upvr_4 (readonly)
	]]
	local cost = arg4[arg2].cost
	local Price = arg4[arg2].Price
	if not arg1:FindFirstChild("Bag") then return end
	local any_GetItemCountByID_result1 = module_upvr_4.GetItemCountByID(arg1, cost)
	if cost == 0 then
		return 1
	end
	if any_GetItemCountByID_result1 < Price then
		return false
	end
	if Price == 0 then
		return arg3
	end
	return math.min(math.floor(any_GetItemCountByID_result1 / Price), arg3)
end
local function _(arg1, arg2, arg3, arg4) -- Line 101, Named "IsPetFull"
	--[[ Upvalues[1]:
		[1]: SystemPet_upvr (readonly)
	]]
	if arg4[arg3].cost == 0 then
		return true
	end
	local var21 = arg1
	if arg2 > SystemPet_upvr.GetBagLessNum(var21) then
		var21 = false
	else
		var21 = true
	end
	return var21
end
local function _(arg1, arg2) -- Line 111, Named "GetWeightAfterBuff"
	--[[ Upvalues[1]:
		[1]: GetData_upvr (readonly)
	]]
	return GetData_upvr.GetPetHatchLuck(arg1) * arg2
end
local function _(arg1, arg2) -- Line 116, Named "GetWeightSecretLuck"
	return arg2
end
local function RollPet_upvr(arg1, arg2, arg3, arg4) -- Line 122, Named "RollPet"
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: GetData_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var26 = arg3[arg2]
	local tbl_3 = {}
	local var31
	for i, _ in ipairs(var26.ItemWeight) do
		local var32
		if 4 <= CfgFind_upvr.FindCfgByID(var26.ItemIDVt[i]).xyd and not arg4 then
			var32 = GetData_upvr.GetPetHatchLuck(arg1) * var32
			local var33 = var32
		end
		var31 += var33
		tbl_3[i] = var33
	end
	local ipairs_result1_2, ipairs_result2, ipairs_result3 = ipairs(tbl_3)
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [53] 41. Error Block 9 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [53] 41. Error Block 9 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [46] 36. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [53.2147483650]
	-- KONSTANTERROR: [46] 36. Error Block 7 end (CF ANALYSIS FAILED)
end
local function _(arg1, arg2, arg3, arg4) -- Line 158, Named "PayForEggs"
	--[[ Upvalues[1]:
		[1]: module_upvr_4 (readonly)
	]]
	module_upvr_4.DelItemByIDCount(arg1, arg4[arg2].cost, arg4[arg2].Price * arg3)
end
local function _(arg1) -- Line 164, Named "GetHatchNum"
	--[[ Upvalues[1]:
		[1]: CheckGamePass_upvr (readonly)
	]]
	local var37 = 1
	if CheckGamePass_upvr.IsHasPass(arg1, "Triple-Hatch") then
		var37 += 2
	end
	return var37
end
local Value_upvr = __________________["魔法孵化变化率"]["彩虹"].Value
local Value_upvr_2 = __________________["魔法孵化变化率"]["闪耀"].Value
local function CheckUpdatePet_upvr(arg1, arg2) -- Line 176, Named "CheckUpdatePet"
	--[[ Upvalues[4]:
		[1]: module_upvr_3 (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: Value_upvr (readonly)
		[4]: Value_upvr_2 (readonly)
	]]
	if module_upvr_3.GetIsPass(arg1, "MagicHatch") and CfgFind_upvr.FindCfgByOnlyTag("MagicHatch") then
		local var45 = Value_upvr
		if var45 and math.random() * 100 <= var45 and CfgFind_upvr.GetPetRainBowLv(arg2) then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return CfgFind_upvr.GetPetRainBowLv(arg2)
		end
		local var46 = Value_upvr_2
		if var46 then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if math.random() * 100 <= var46 then
				local any_GetPetShinyLv_result1_2 = CfgFind_upvr.GetPetShinyLv(arg2)
				if any_GetPetShinyLv_result1_2 then
					return any_GetPetShinyLv_result1_2
				end
			end
		end
	end
	return arg2
end
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local SystemRecord_upvr = require(game.ServerStorage.System.SystemRecord)
local 保底机制_upvr = require(ReplicatedStorage.Tool["保底机制"])
local SystemAutoDelete_upvr = require(game.ServerStorage.System.SystemAutoDelete)
local function DrawItem_upvr(arg1, arg2, arg3, arg4) -- Line 212, Named "DrawItem"
	--[[ Upvalues[14]:
		[1]: CheckGamePass_upvr (readonly)
		[2]: IsMoneyEnough_upvr (readonly)
		[3]: TipsModule_upvr (readonly)
		[4]: SystemPet_upvr (readonly)
		[5]: RemoteEvent_upvr (readonly)
		[6]: SystemRecord_upvr (readonly)
		[7]: RollPet_upvr (readonly)
		[8]: 保底机制_upvr (readonly)
		[9]: SystemAutoDelete_upvr (readonly)
		[10]: EnumMgr_upvr (readonly)
		[11]: CheckUpdatePet_upvr (readonly)
		[12]: SendLuckyHatchMes_upvr (readonly)
		[13]: module_upvr_4 (readonly)
		[14]: module_upvr_3 (readonly)
	]]
	local var100 = 1
	local var101
	if CheckGamePass_upvr.IsHasPass(arg1, "Triple-Hatch") then
		var100 += 2
	end
	var101 = var100
	local minimum_2 = math.min(arg3, var101)
	var101 = arg2
	local IsMoneyEnough_upvr_result1_2 = IsMoneyEnough_upvr(arg1, var101, minimum_2, arg4)
	local var104 = false
	var101 = arg4[arg2]
	if var101 then
		var101 = arg4[arg2].cost
		if var101 then
			var101 = arg4[arg2].cost
			if var101 == 0 then
				IsMoneyEnough_upvr_result1_2 = arg3
				var104 = true
			end
		end
	end
	if not IsMoneyEnough_upvr_result1_2 then
		var101 = TipsModule_upvr.ErrorTips
		var101(arg1, "金钱不够")
		var101 = false
		return var101
	end
	if arg4[arg2].cost == 0 then
		var101 = true
	elseif IsMoneyEnough_upvr_result1_2 > SystemPet_upvr.GetBagLessNum(arg1) then
		var101 = false
	else
		var101 = true
	end
	if not var101 then
		var101 = TipsModule_upvr.ErrorTips
		var101(arg1, "宠物背包已满")
		var101 = RemoteEvent_upvr:FireClient
		var101(arg1, "购买额外背包容量")
		var101 = false
		return var101
	end
	var101 = SystemRecord_upvr.RecordAdd
	var101(arg1, "开启宠物蛋次数", minimum_2)
	var101 = {}
	for i_2 = 1, IsMoneyEnough_upvr_result1_2 do
		local RollPet_result1_2 = RollPet_upvr(arg1, arg2, arg4, var104)
		if RollPet_result1_2 then
			table.insert(var101, RollPet_result1_2)
		end
	end
	if 0 < arg4[arg2].JingLenth then
		i_2 = arg2
		var101 = 保底机制_upvr.Amend(arg1, i_2, var101)
	end
	for i_3, v_2 in pairs(var101) do
		if var104 == true or not SystemAutoDelete_upvr.getIsAutoDel(arg1, v_2) then
			local SystemCoachEvent_upvr = require(game.ServerStorage.System.SystemCoachEvent)
			spawn(function() -- Line 261
				--[[ Upvalues[3]:
					[1]: SystemCoachEvent_upvr (readonly)
					[2]: arg1 (readonly)
					[3]: EnumMgr_upvr (copied, readonly)
				]]
				SystemCoachEvent_upvr.AddEventTask(arg1, EnumMgr_upvr.SeasonTask.HeroHatch, 1)
			end)
			local var111_upvw = var101[i_3]
			if var104 == false then
				var111_upvw = CheckUpdatePet_upvr(arg1, v_2)
				var101[i_3] = var111_upvw
			end
			spawn(function() -- Line 271
				--[[ Upvalues[4]:
					[1]: SendLuckyHatchMes_upvr (copied, readonly)
					[2]: arg1 (readonly)
					[3]: var111_upvw (read and write)
					[4]: arg2 (readonly)
				]]
				SendLuckyHatchMes_upvr(arg1, var111_upvw, arg2)
			end)
			module_upvr_4.KillEnemyPutInBag(arg1, {var111_upvw}, {1})
		end
	end
	module_upvr_3.UpdateLocalData(arg1)
	for _, _ in pairs(var101) do
		local var118
	end
	module_upvr_4.DelItemByIDCount(arg1, arg4[arg2].cost, arg4[arg2].Price * var118)
	if arg1:FindFirstChild("IsNewPlayer").Value == true then
		require(game.ServerStorage.System.SystemGuide).CompleteGuide(arg1, "宠物引导")
	end
	return var101
end
local drawSpecialEgg_upvr = ReplicatedStorage:WaitForChild("ServerMsg"):WaitForChild("drawSpecialEgg")
function module_upvr_2.DrawSpecialEgg(arg1, arg2, arg3) -- Line 298
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: drawSpecialEgg_upvr (readonly)
	]]
	drawSpecialEgg_upvr:FireClient(arg1, arg2, module_upvr_2.DrawPet(arg1, arg2, arg3))
end
function module_upvr_2.DrawPet(arg1, arg2, arg3) -- Line 303
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: DrawItem_upvr (readonly)
	]]
	return DrawItem_upvr(arg1, arg2, arg3, CfgFind_upvr.GetCfgByName("eggdataConf"))
end
local Debris_upvr = game:GetService("Debris")
function module_upvr_2.DrawHero(arg1, arg2, arg3) -- Line 312
	--[[ Upvalues[4]:
		[1]: any_GetCfgByName_result1_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: DrawItem_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_5, pairs_result2_2, pairs_result3 = pairs(any_GetCfgByName_result1_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 9. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 9. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 6. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 6. Error Block 2 end (CF ANALYSIS FAILED)
end
local module_upvr = require(ReplicatedStorage:WaitForChild("ConfigInstance"))
function module_upvr_2.Test(arg1, arg2, arg3) -- Line 343
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: DrawItem_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
	]]
	local tbl = {}
	for _, v_4 in pairs(DrawItem_upvr(arg1, arg2, arg3, module_upvr.eggdataConf)) do
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(v_4)
		if any_FindCfgByID_result1 then
			if not tbl[any_FindCfgByID_result1.xyd] then
				tbl[any_FindCfgByID_result1.xyd] = 0
			end
			local xyd_2 = any_FindCfgByID_result1.xyd
			tbl[xyd_2] += 1
		end
	end
end
return module_upvr_2