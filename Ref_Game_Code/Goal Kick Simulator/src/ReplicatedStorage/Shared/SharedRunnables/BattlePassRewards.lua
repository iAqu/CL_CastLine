-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:10
-- Luau version 6, Types version 3
-- Time taken: 0.003257 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local tbl_upvr_2 = {"Big", "Stadium Pack"}
local module = {}
local tbl_upvr = {{
	Money = 20;
}, {
	NoBattlePass = true;
	Gems = 30000;
}, {
	Money = 20;
}, {
	Pack = 1;
}, {
	NoBattlePass = true;
	Money = 30;
}, {
	NoBattlePass = true;
	Gems = 40000;
}, {
	NoBattlePass = true;
	Gems = 50000;
}, {
	Pack = 1;
}, {
	Gems = 50000;
}, {
	NoBattlePass = true;
	Gems = 50000;
}, {
	Gems = 60000;
}, {
	Gems = 70000;
}, {
	Money = 50;
}, {
	Pack = 1;
}, {
	NoBattlePass = true;
	Pack = 1;
}}
function module.GetLevelCap(arg1) -- Line 75
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	return #tbl_upvr
end
local RunService_upvr = game:GetService("RunService")
function module.IsRewardAvailable(arg1, arg2, arg3, arg4) -- Line 79
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: tbl_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var21
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var21 = Util_upvr.Link:GetRawLink()
		return var21
	end
	if not RunService_upvr:IsClient() or not INLINED() then
		var21 = Util_upvr.Link:GetRawLink(arg2)
	end
	if var21.BoughtBattlePassSeason ~= arg3 then
	else
	end
	local var22 = tbl_upvr[arg4]
	if var22 then
		local NoBattlePass = var22.NoBattlePass
		local var24
	end
	if true or NoBattlePass then
		if var21.BattlePassLevel < arg4 then
			var24 = "Reach Level "
			if var21.BattlePassOwnedRewards[tostring(arg4)] then
				var24 = true
			else
				var24 = false
			end
			return false, var24..arg4.." to unlock this reward!", var24, NoBattlePass
		end
		if var21.BattlePassOwnedRewards[tostring(arg4)] then
		else
		end
		return var22, nil, false, NoBattlePass
	end
	return false, "You need to own the battle pass to unlock this reward!", nil, NoBattlePass
end
function module.GetRewards(arg1, arg2, arg3) -- Line 97
	--[[ Upvalues[3]:
		[1]: tbl_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: tbl_upvr_2 (readonly)
	]]
	local module_2 = {}
	for _, v in pairs(tbl_upvr) do
		local any_Copy_result1 = Util_upvr.Table.Copy(v)
		if any_Copy_result1.Pack then
			any_Copy_result1.Pack = tbl_upvr_2[Random.new(arg3 or 0):NextInteger(1, #tbl_upvr_2)]
		end
		module_2[#module_2 + 1] = any_Copy_result1
	end
	return module_2
end
Util_upvr.BattlePassRewards = module
return module