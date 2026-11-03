-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:07
-- Luau version 6, Types version 3
-- Time taken: 0.019637 seconds

local module_upvr_2 = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local floor_upvr = math.floor
function module_upvr_2.CalculateNormalStat(arg1, arg2, arg3) -- Line 8
	--[[ Upvalues[1]:
		[1]: floor_upvr (readonly)
	]]
	return floor_upvr(floor_upvr(0.01 * (2 * arg3 + 0.25) * arg2) + 5)
end
function module_upvr_2.GetKickPowerValue(arg1, arg2, arg3) -- Line 13
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local ceiled_2 = math.ceil(arg2 + 6)
	local var5
	local function INLINED() -- Internal function, doesn't exist in bytecode
		local _, any_GetEnchantmentData_result2_4 = Util_upvr.Enchantments:GetEnchantmentData(arg3)
		return any_GetEnchantmentData_result2_4 == "Strength"
	end
	if arg3 and (INLINED() or any_GetEnchantmentData_result2_4 == "Weakness") then
		var5 = Util_upvr
		local any_GetEnchantmentValue_result1 = var5.Enchantments:GetEnchantmentValue(arg3)
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var5 = ceiled_2 * any_GetEnchantmentValue_result1
			return var5
		end
		if not any_GetEnchantmentValue_result1 or not INLINED_2() then
			var5 = 1
		end
		return var5
	end
	return ceiled_2
end
function module_upvr_2.GetKickPowerPrice(arg1, arg2) -- Line 24
	return math.ceil(2.9 ^ (1 + arg2 / 7) + 15)
end
function module_upvr_2.GetBallSellPrice(arg1, arg2, arg3) -- Line 29
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	for _, v in pairs(Util_upvr.ReplicatedStorage.Assets.Chests:GetChildren()) do
		if v:FindFirstChild(arg2) then
			local var17 = Util_upvr.ChestStands[v.Name]
			if var17 then
				var17 = Util_upvr.ChestStands[v.Name]:GetAttribute("Price")
			end
			if not var17 then
				return 0
			end
			return math.ceil(var17 * 0.1 + var17 * 0.2 * math.clamp((arg3 - 1) / 300, 0, 1))
		end
	end
	return 0
end
function module_upvr_2.GetStarSellPrice(arg1, arg2) -- Line 43
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local var19
	local function INLINED_3() -- Internal function, doesn't exist in bytecode
		var19 = Util_upvr.ReplicatedStorage.Assets.Stars:FindFirstChild(arg2):GetAttribute("SellPrice")
		return var19
	end
	if not Util_upvr.ReplicatedStorage.Assets.Stars:FindFirstChild(arg2) or not INLINED_3() then
		var19 = 0
	end
	return var19
end
function module_upvr_2.GetKickAccuracyValue(arg1, arg2, arg3) -- Line 49
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local ceiled = math.ceil(arg2 / 1.15 + 5)
	local var21
	local function INLINED_4() -- Internal function, doesn't exist in bytecode
		local _, any_GetEnchantmentData_result2 = Util_upvr.Enchantments:GetEnchantmentData(arg3)
		return any_GetEnchantmentData_result2 == "Dizzy"
	end
	if arg3 and (INLINED_4() or any_GetEnchantmentData_result2 == "Sharpness") then
		var21 = Util_upvr
		local any_GetEnchantmentValue_result1_2 = var21.Enchantments:GetEnchantmentValue(arg3)
		local function INLINED_5() -- Internal function, doesn't exist in bytecode
			var21 = ceiled * any_GetEnchantmentValue_result1_2
			return var21
		end
		if not any_GetEnchantmentValue_result1_2 or not INLINED_5() then
			var21 = 1
		end
		return var21
	end
	return ceiled
end
function module_upvr_2.GetKickAccuracyPrice(arg1, arg2) -- Line 62
	return math.ceil(2.9 ^ (1 + arg2 / 8) + 10)
end
function module_upvr_2.GetSpeedValue(arg1, arg2) -- Line 67
	return math.ceil((arg2 + 1) ^ 0.8 * 3)
end
function module_upvr_2.GetSpeedPrice(arg1, arg2) -- Line 70
	return math.ceil(4 ^ (1 + arg2 / 4) + 5)
end
function module_upvr_2.GetMinKickDistance(arg1, arg2, arg3, arg4) -- Line 76
	return arg2 * (1 + (arg3) * ((arg4 or 1) * 0.9))
end
function module_upvr_2.GetMaxKickDistance(arg1, arg2, arg3, arg4) -- Line 81
	return arg2 * (1 + arg3 * ((arg4 or 1) * 0.9 + 0.1))
end
function module_upvr_2.GetKickDistance(arg1, arg2, arg3, arg4) -- Line 86
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local any_GetMinKickDistance_result1 = module_upvr_2:GetMinKickDistance(arg2, arg3, arg4)
	return any_GetMinKickDistance_result1 + (module_upvr_2:GetMaxKickDistance(arg2, arg3, arg4) - any_GetMinKickDistance_result1) * math.random()
end
function module_upvr_2.GetCompanionKickAccuracyValue(arg1, arg2, arg3) -- Line 93
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	local any_GetAsset_result1_2 = Util_upvr.Assets:GetAsset("Stars", arg2)
	if not any_GetAsset_result1_2 then
		return 0
	end
	local KickAccuracy = any_GetAsset_result1_2:GetAttribute("KickAccuracy")
	if not KickAccuracy then
		return 0
	end
	return math.ceil(module_upvr_2:GetKickAccuracyValue(KickAccuracy * arg3 / 40)) + 25
end
function module_upvr_2.GetCompanionKickPowerValue(arg1, arg2, arg3) -- Line 101
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	local any_GetAsset_result1_3 = Util_upvr.Assets:GetAsset("Stars", arg2)
	if not any_GetAsset_result1_3 then
		return 0
	end
	local KickPower = any_GetAsset_result1_3:GetAttribute("KickPower")
	if not KickPower then
		return 0
	end
	return math.ceil(module_upvr_2:GetKickPowerValue(KickPower * arg3 / 40)) + 25
end
function module_upvr_2.GetCompanionMultiValue(arg1, arg2, arg3) -- Line 109
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_GetAsset_result1_5 = Util_upvr.Assets:GetAsset("Stars", arg2)
	if not any_GetAsset_result1_5 then
		return 1
	end
	return (any_GetAsset_result1_5:GetAttribute("Multi") or 1) * (1 + (math.clamp(arg3 or 1, 1, 100) - 1) / 99 * 3)
end
function module_upvr_2.GetCompanionKickValues(arg1, arg2, arg3) -- Line 117
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	return module_upvr_2:GetCompanionKickPowerValue(arg2, arg3), module_upvr_2:GetCompanionKickAccuracyValue(arg2, arg3), module_upvr_2:GetCompanionMultiValue(arg2, arg3)
end
function module_upvr_2.GetLuck(arg1, arg2) -- Line 122
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 44 start (CF ANALYSIS FAILED)
	local var31 = 1 + Util_upvr.UGCBonusProvider:GetUGCBonuses(arg2.UserId)
	local var32
	local function INLINED_6() -- Internal function, doesn't exist in bytecode
		var32 = Util_upvr.WorldBoosts:GetWorldBoost("Luck")
		return var32
	end
	if not Util_upvr.WorldBoosts or not INLINED_6() then
		var32 = 0
	end
	var32 = Util_upvr.AwardService:IsBoostActive(arg2, "Luck")
	if var32 then
	else
	end
	var32 = Util_upvr
	if var32.AwardService:IsBoostActive(arg2, "SuperLuck") then
		-- KONSTANTWARNING: GOTO [49] #40
	end
	-- KONSTANTERROR: [0] 1. Error Block 44 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [48] 39. Error Block 49 start (CF ANALYSIS FAILED)
	var32 = arg2
	if Util_upvr.AwardService:IsBoostActive(var32, "LegendaryLuck") then
		-- KONSTANTWARNING: GOTO [62] #51
	end
	-- KONSTANTERROR: [48] 39. Error Block 49 end (CF ANALYSIS FAILED)
end
function module_upvr_2.GetValueOf(arg1, arg2, arg3, ...) -- Line 135
	if arg2 == "KickPower" then
		return arg1:GetKickPowerValue(arg3, ...)
	end
	if arg2 == "KickAccuracy" then
		return arg1:GetKickAccuracyValue(arg3, ...)
	end
	if arg2 == "Speed" then
		return arg1:GetSpeedValue(arg3, ...)
	end
	return 0
end
function module_upvr_2.GetPriceOf(arg1, arg2, arg3, arg4) -- Line 147
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var33 = Util_upvr.ZonesData[arg4]
	local var34
	if arg2 == "KickPower" then
		if not var33 or not var33.StatsPriceOffset then
		end
		local _ = arg1:GetKickPowerPrice(arg3 + 0)
	elseif arg2 == "KickAccuracy" then
		if not var33 or not var33.StatsPriceOffset then
		end
	elseif arg2 == "Speed" then
		if not var33 or not var33.StatsPriceOffset then
		end
	end
	if not var33 or not var33.StatsPriceMultiplier or not (var33.StatsPriceMultiplier * arg1:GetSpeedPrice(arg3 + 0)) then
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return arg1:GetSpeedPrice(arg3 + 0)
end
function module_upvr_2.GetInventoryValue(arg1, arg2) -- Line 160
	local var40 = 0
	for i_2, v_2 in pairs(arg2) do
		var40 += arg1:GetOreValue(i_2, v_2)
	end
	return var40
end
function module_upvr_2.IsInsidePowerArea(arg1, arg2, arg3) -- Line 169
	if math.abs(arg2.Y - arg3.Y) < 10 and (Vector3.new(arg2.X, arg3.Y, arg2.Z) - arg3).Magnitude < 8 then
		return true
	end
end
local function _(arg1) -- Line 175, Named "getMultiplier"
	return 1.4 ^ arg1 ^ 1.2
end
local module_upvr_3 = {1.4, 2.1662773975390395, 3.516483998822406, 5.9056594024552655, 10.187929382175806}
function module_upvr_2.GetBallMulti(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 190
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr_3 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var53
	local function INLINED_9() -- Internal function, doesn't exist in bytecode
		var53 = Util_upvr.Assets:GetAsset("Balls", arg2):GetAttribute("PowerYield")
		return var53
	end
	if not Util_upvr.Assets:GetAsset("Balls", arg2) or not INLINED_9() then
		var53 = 1
	end
	local function INLINED_10() -- Internal function, doesn't exist in bytecode
		local _, any_GetEnchantmentData_result2_3, _ = Util_upvr.Enchantments:GetEnchantmentData(arg4)
		return any_GetEnchantmentData_result2_3 == "Prestige"
	end
	if arg4 and (INLINED_10() or any_GetEnchantmentData_result2_3 == "Ruined") then
	end
	if arg5 then
		local any_GetAsset_result1_4 = Util_upvr.Assets:GetAsset("Trails", arg5)
		if any_GetAsset_result1_4 then
		end
	end
	if arg6 then
	end
	return math.ceil(((math.log(arg3 ^ 20) * var53) * ((arg3 - 1) / 2250) + var53) * Util_upvr.Enchantments:GetEnchantmentValue(arg4) * (any_GetAsset_result1_4:GetAttribute("Multi") or 1) * (module_upvr_3[arg6] or 1) * 10) / 10
end
local RunService_upvr = game:GetService("RunService")
function module_upvr_2.GetEquippedBallData(arg1, arg2) -- Line 217
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: module_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 17 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 17 end (CF ANALYSIS FAILED)
end
function module_upvr_2.GetGoldAmountFromRobuxPrice(arg1, arg2, arg3) -- Line 233
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local _, any_GetEquippedBallData_result2 = module_upvr_2:GetEquippedBallData(arg2)
	return (arg3 * 1.1) ^ 1.25 * (any_GetEquippedBallData_result2 * 1.35) ^ 1.7 + 4000
end
function module_upvr_2.IsPositionValid(arg1, arg2, arg3) -- Line 239
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local RaycastParams_new_result1 = RaycastParams.new()
	RaycastParams_new_result1.CollisionGroup = "Humanoids"
	RaycastParams_new_result1.FilterDescendantsInstances = {workspace.Ignore}
	RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Blacklist
	return Util_upvr.Vector.Raycast2(arg2, Vector3.new(0, -arg3, 0), RaycastParams_new_result1, function(arg1_2) -- Line 247
		local var64
		if arg1_2.CanCollide ~= false then
			var64 = false
		else
			var64 = true
		end
		return var64
	end)
end
function module_upvr_2.CanRankUp(arg1, arg2) -- Line 252
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local var65
	if arg2 >= #Util_upvr.Settings.RANK_TITLES then
		var65 = false
	else
		var65 = true
	end
	return var65
end
function module_upvr_2.GetPlayerRankXP(arg1, arg2) -- Line 255
	--[[ Upvalues[1]:
		[1]: floor_upvr (readonly)
	]]
	local var66 = arg2 * 10
	return (floor_upvr(var66 / 2) + 32) / 50 * var66 ^ 3 * 20
end
function module_upvr_2.GetStarLevelXP(arg1, arg2) -- Line 260
	return math.ceil((arg2 * 1.65) ^ 2.5)
end
local module_upvr = {
	CoinMulti = {{
		Cost = 2;
		Value = 1.5;
	}, {
		Cost = 3;
		Value = 2;
	}, {
		Cost = 3;
		Value = 3;
	}, {
		Cost = 5;
		Value = 4;
	}, {
		Cost = 5;
		Value = 5;
	}, {
		Cost = 6;
		Value = 7;
	}, {
		Cost = 8;
		Value = 9;
	}};
	XPMulti = {{
		Cost = 4;
		Value = 1.5;
	}, {
		Cost = 4;
		Value = 2;
	}, {
		Cost = 4;
		Value = 3;
	}, {
		Cost = 5;
		Value = 4;
	}, {
		Cost = 5;
		Value = 5;
	}};
	StarSlots = {{
		Cost = 4;
		Value = 1;
	}, {
		Cost = 8;
		Value = 2;
	}};
	Luck = {{
		Cost = 4;
		Value = 1;
	}, {
		Cost = 5;
		Value = 2;
	}, {
		Cost = 10;
		Value = 3;
	}, {
		Cost = 12;
		Value = 4;
	}, {
		Cost = 12;
		Value = 5;
	}};
}
if Util_upvr.RunService:IsServer() then
	local function GetRebirthUpgradeValue(arg1, arg2, arg3) -- Line 354
		--[[ Upvalues[2]:
			[1]: Util_upvr (readonly)
			[2]: module_upvr (readonly)
		]]
		local any_GetRawLink_result1_2 = Util_upvr.Link:GetRawLink(arg2)
		local var92
		if not any_GetRawLink_result1_2 then return end
		var92 = any_GetRawLink_result1_2.RebirthUpgrades
		local var93 = var92[arg3]
		if not var93 then return end
		var92 = module_upvr[arg3]
		if var92 then
			var92 = module_upvr[arg3][var93]
		end
		local var94 = var92
		if var94 then
			var94 = var92.Value
		end
		return var94
	end
	module_upvr_2.GetRebirthUpgradeValue = GetRebirthUpgradeValue
else
	module_upvr_2.GetRebirthUpgradeValue = function(arg1, arg2) -- Line 363, Named "GetRebirthUpgradeValue"
		--[[ Upvalues[2]:
			[1]: Util_upvr (readonly)
			[2]: module_upvr (readonly)
		]]
		local any_GetRawLink_result1 = Util_upvr.Link:GetRawLink()
		local var96
		if not any_GetRawLink_result1 then return end
		var96 = any_GetRawLink_result1.RebirthUpgrades
		local var97 = var96[arg2]
		if not var97 then return end
		var96 = module_upvr[arg2]
		if var96 then
			var96 = module_upvr[arg2][var97]
		end
		local var98 = var96
		if var98 then
			var98 = var96.Value
		end
		return var98
	end
end
function module_upvr_2.GetRebirthUpgradeData(arg1, arg2) -- Line 372
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr[arg2]
end
function module_upvr_2.GetRebirthPrice(arg1, arg2) -- Line 376
	local var99 = arg2 or 0
	return 1500000 * var99 ^ 2 * var99 ^ 2.9 + 1500000
end
function module_upvr_2.GetRebirthMulti(arg1, arg2) -- Line 381
	return math.ceil(2 ^ (arg2 / 4) * 10) / 10
end
local tbl_upvr = {
	Fast = function(arg1) -- Line 388, Named "Fast"
		return 0.8 * arg1 ^ 3
	end;
	MediumFast = function(arg1) -- Line 391, Named "MediumFast"
		return arg1 ^ 3
	end;
	MediumSlow = function(arg1) -- Line 394, Named "MediumSlow"
		return 1.2 * arg1 ^ 3
	end;
	Slow = function(arg1) -- Line 397, Named "Slow"
		return 1.25 * arg1 ^ 3
	end;
	Fluctuating = function(arg1) -- Line 400, Named "Fluctuating"
		--[[ Upvalues[1]:
			[1]: floor_upvr (readonly)
		]]
		if arg1 < 15 then
			return (floor_upvr((arg1 + 1) / 3) + 24) / 50 * arg1 ^ 3
		end
		if arg1 < 36 then
			return (arg1 + 14) / 50 * arg1 ^ 3
		end
		return (floor_upvr(arg1 / 2) + 32) / 50 * arg1 ^ 3
	end;
	Erratic = function(arg1) -- Line 409, Named "Erratic"
		--[[ Upvalues[1]:
			[1]: floor_upvr (readonly)
		]]
		if arg1 < 50 then
			return arg1 ^ 3 * (100 - arg1) / 50
		end
		if arg1 < 68 then
			return arg1 ^ 3 * (150 - arg1) / 100
		end
		if arg1 <= 98 then
			return arg1 ^ 3 * floor_upvr((1911 - arg1 * 10) / 3) / 500
		end
		return arg1 ^ 3 * math.clamp(160 - arg1, 60, 160) / 100
	end;
}
local tbl_upvr_2 = {
	Common = "Erratic";
	Uncommon = "Fast";
	Rare = "MediumFast";
	Epic = "MediumSlow";
	Legendary = "Slow";
	Mythic = "Slow";
	Secret = "Fluctuating";
}
function module_upvr_2.CalculateLevelExperience(arg1, arg2, arg3) -- Line 432
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	assert(arg3, "Level was not given!")
	local var102 = arg2
	if var102 then
		var102 = tbl_upvr[arg2]
	end
	assert(var102, "ExperienceType is invalid!")
	return math.ceil(var102(arg3))
end
function module_upvr_2.GetExperienceNeeded(arg1, arg2, arg3) -- Line 439
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	return module_upvr_2:CalculateLevelExperience(arg2, arg3 + 1) - module_upvr_2:CalculateLevelExperience(arg2, arg3)
end
function module_upvr_2.GetExperienceNeededFromRarity(arg1, arg2, arg3) -- Line 445
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	local var103 = tbl_upvr_2[arg2]
	assert(var103, "Rarity is invalid: "..arg2)
	return module_upvr_2:GetExperienceNeeded(var103, arg3)
end
Util_upvr.GameMath = module_upvr_2
return module_upvr_2