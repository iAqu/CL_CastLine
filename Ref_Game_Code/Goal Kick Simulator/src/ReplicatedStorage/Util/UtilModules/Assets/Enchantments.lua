-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:19
-- Luau version 6, Types version 3
-- Time taken: 0.004458 seconds

local module_upvr = {
	Positive = {
		Strength = {
			Value = {1.1, 1.25, 1.3, 1.4, 1.5};
			Description = "%s your Strength by %s";
			Icon = "rbxassetid://9561097362";
		};
		Experienced = {
			Value = {1.1, 1.2, 1.3, 1.4, 1.5};
			Description = "%s your Ball XP by %s";
			Icon = "rbxassetid://9561146447";
		};
		Sharpness = {
			Value = {1.1, 1.2, 1.3, 1.4, 1.5};
			Description = "%s your Accuracy by %s";
			Icon = "rbxassetid://9561127236";
		};
		Prestige = {
			Value = {1.1, 1.25, 1.4, 1.65, 2};
			Description = "%s your Multiplier by %s";
			Icon = "rbxassetid://9561107401";
		};
	};
	Negative = {
		Weakness = {
			ForcedTierIcon = 0;
			Value = {0.85, 0.7, 0.6, 0.5, 0.4};
			Description = "%s your Strength by %s";
			Icon = "rbxassetid://9561152618";
		};
		Slow = {
			ForcedTierIcon = 0;
			Value = {0.85, 0.75, 0.65, 0.5, 0.4};
			Description = "%s your Ball XP by %s";
			Icon = "rbxassetid://9561127443";
		};
		Dizzy = {
			ForcedTierIcon = 0;
			Value = {0.9, 0.8, 0.7, 0.6, 0.5};
			Description = "%s your Accuracy by %s";
			Icon = "rbxassetid://9561122023";
		};
		Ruined = {
			ForcedTierIcon = 0;
			Value = {0.9, 0.8, 0.75, 0.6, 0.5};
			Description = "%s your Multiplier by %s";
			Icon = "rbxassetid://9561115030";
		};
	};
}
local tbl_upvr = {
	ForcedTierIcon = 1;
	Description = "MISSING";
	Icon = "";
}
function module_upvr.GetEnchantmentData(arg1, arg2) -- Line 59
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	if not arg2 then return end
	local unpack_result1_4, unpack_result2_2 = unpack(string.split(arg2, '_'))
	local var26 = module_upvr.Positive[unpack_result1_4]
	if not var26 then
		var26 = module_upvr.Negative[unpack_result1_4]
		if not var26 then
			var26 = tbl_upvr
		end
	end
	return var26, unpack_result1_4, unpack_result2_2
end
local function NumberToRoman_upvr(arg1) -- Line 65, Named "NumberToRoman"
	local var27 = arg1
	if var27 then
		var27 = tonumber(arg1)
	end
	local var28 = var27
	if not var28 or var28 < 1 then
		return ""
	end
	return ({'I', "II", "III", "IV", 'V', "VI", "VII", "VIII", "IX", 'X'})[var28] or ""
end
function module_upvr.GetDisplayText(arg1, arg2) -- Line 71
	--[[ Upvalues[1]:
		[1]: NumberToRoman_upvr (readonly)
	]]
	local unpack_result1_5, unpack_result2_6 = unpack(string.split(arg2, '_'))
	return unpack_result1_5..' '..NumberToRoman_upvr(unpack_result2_6)
end
function module_upvr.GetEnchantmentValue(arg1, arg2) -- Line 76
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local unpack_result1, unpack_result2_3 = unpack(string.split(arg2, '_'))
	local var38 = module_upvr.Positive[unpack_result1]
	if not var38 then
		var38 = module_upvr.Negative[unpack_result1]
		if not var38 then
			var38 = tbl_upvr
		end
	end
	local var39 = var38.Value[tonumber(unpack_result2_3) or 1]
	if not var39 then
		var39 = var38.Value[1]
	end
	return var39
end
function module_upvr.GetEnchantmentDescription(arg1, arg2) -- Line 82
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local unpack_result1_2, unpack_result2_5 = unpack(string.split(arg2, '_'))
	local var42 = module_upvr.Positive[unpack_result1_2]
	if not var42 then
		var42 = module_upvr.Negative[unpack_result1_2]
		if not var42 then
			var42 = tbl_upvr
		end
	end
	local var43 = var42.Value[tonumber(unpack_result2_5) or 1]
	if not var43 then
		var43 = var42.Value[1]
	end
	local var44
	local var45
	if 1 < var43 then
		var44 = "Increases"
		var45 = (math.floor((var43 - 1) * 1000 + 0.05) / 10)..'%'
	else
		var44 = "Decreases"
		var45 = (math.floor((1 - var43) * 1000 + 0.05) / 10)..'%'
	end
	return var42.Description:format(var44, var45)
end
return module_upvr