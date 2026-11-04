-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:30
-- Luau version 6, Types version 3
-- Time taken: 0.001893 seconds

local module_upvr = {}
local ReplicatedStorage = game.ReplicatedStorage
local rebirthConf_upvr = require(ReplicatedStorage.ConfigInstance).rebirthConf
function module_upvr.GetRebirthCount(arg1) -- Line 13
	local var4 = 0
	local rebirthCount = arg1:FindFirstChild("rebirthCount")
	if rebirthCount then
		var4 = rebirthCount.Value
	end
	return var4
end
function module_upvr.GetRebirthCfg(arg1) -- Line 23
	--[[ Upvalues[1]:
		[1]: rebirthConf_upvr (readonly)
	]]
	return rebirthConf_upvr[arg1]
end
function module_upvr.GetRebirthAdd(arg1) -- Line 28
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: rebirthConf_upvr (readonly)
	]]
	local var6 = rebirthConf_upvr[module_upvr.GetRebirthCount(arg1)]
	if var6 then
		return var6.rate
	end
	return 0
end
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
function module_upvr.IsCanRebirth(arg1) -- Line 41
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
	]]
	local any_GetRebirthCfg_result1 = module_upvr.GetRebirthCfg(module_upvr.GetRebirthCount(arg1) + 1)
	if not any_GetRebirthCfg_result1 then
		return false
	end
	for i, v in pairs(any_GetRebirthCfg_result1.need) do
		if arg1:FindFirstChild("Bag"):FindFirstChild((EnumMgr_upvr.ItemID.Attr_1) + (i - 1)).Value < v then
			return false
		end
	end
	return true
end
function module_upvr.GetNextRebirthAdd(arg1) -- Line 64
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_GetRebirthCfg_result1_3 = module_upvr.GetRebirthCfg(module_upvr.GetRebirthCount(arg1) + 1)
	if any_GetRebirthCfg_result1_3 then
		return any_GetRebirthCfg_result1_3.rate
	end
	return 1
end
function module_upvr.GetRebirhTitle(arg1) -- Line 76
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_GetRebirthCfg_result1_2 = module_upvr.GetRebirthCfg(arg1)
	if any_GetRebirthCfg_result1_2 then
		return any_GetRebirthCfg_result1_2.title
	end
	return "????"
end
function module_upvr.GetIsMaxRebirth(arg1) -- Line 86
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.GetRebirthCfg(arg1) then
		return true
	end
	return false
end
return module_upvr