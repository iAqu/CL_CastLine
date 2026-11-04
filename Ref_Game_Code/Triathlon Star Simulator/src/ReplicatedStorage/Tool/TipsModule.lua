-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:25
-- Luau version 6, Types version 3
-- Time taken: 0.001682 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local Log_upvr = require(ReplicatedStorage.Tool.Log)
local RunService_upvr = game:GetService("RunService")
local showTips_2_upvr = ReplicatedStorage.LocalMsg.showTips
local showTips_3_upvr = ReplicatedStorage.ServerMsg.showTips
function module_upvr.showTips(arg1, arg2, arg3, arg4, arg5) -- Line 18
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: Log_upvr (readonly)
		[3]: showTips_2_upvr (readonly)
		[4]: showTips_3_upvr (readonly)
	]]
	if RunService_upvr:IsClient() then
		Log_upvr.print(arg2)
		showTips_2_upvr:Fire(arg2, arg3, arg4, arg5)
	else
		Log_upvr.print(arg2)
		showTips_3_upvr:FireClient(arg1, arg2, arg3, arg4, arg5)
	end
end
local showTips_2key_upvr = ReplicatedStorage.LocalMsg.showTips_2key
local showTips_2key_upvr_2 = ReplicatedStorage.ServerMsg.showTips_2key
function module_upvr.showTips_2Key(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 29
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: Log_upvr (readonly)
		[3]: showTips_2key_upvr (readonly)
		[4]: showTips_2key_upvr_2 (readonly)
	]]
	if RunService_upvr:IsClient() then
		Log_upvr.print(arg2, arg3)
		showTips_2key_upvr:Fire(arg2, arg3, arg4, arg5, arg6)
	else
		Log_upvr.print(arg2, arg3)
		showTips_2key_upvr_2:FireClient(arg1, arg2, arg3, arg4, arg5, arg6)
	end
end
local function _(arg1, arg2, arg3, arg4) -- Line 41, Named "ShowTipsByKey"
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.showTips(arg1, arg3, arg4, arg2)
end
function module_upvr.NormalTips(arg1, arg2, arg3) -- Line 45
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	module_upvr.showTips(arg1, arg2, arg3, EnumMgr_upvr.TipTp.Normal)
end
function module_upvr.ErrorTips(arg1, arg2, arg3) -- Line 49
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	module_upvr.showTips(arg1, arg2, arg3, EnumMgr_upvr.TipTp.Error)
end
function module_upvr.NormalTips_2Key(arg1, arg2, arg3, arg4) -- Line 53
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
	]]
	module_upvr.showTips_2Key(arg1, arg2, arg3, arg4, EnumMgr_upvr.TipTp.Normal)
end
function module_upvr.ErrorTips_2Key(arg1, arg2, arg3, arg4) -- Line 57
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
	]]
	module_upvr.showTips_2Key(arg1, arg2, arg3, arg4, EnumMgr_upvr.TipTp.Error)
end
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
function module_upvr.TipsNotEnoughItem(arg1, arg2, arg3, arg4) -- Line 61
	--[[ Upvalues[3]:
		[1]: MathMgr_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg2)
	if not any_FindCfgByID_result1 then
	else
		local ZhName = any_FindCfgByID_result1.ZhName
		if not ZhName then return end
		module_upvr.ErrorTips(arg1, "还差多少道具", {MathMgr_upvr.getNumStr(arg3 - arg4), ZhName})
	end
end
return module_upvr