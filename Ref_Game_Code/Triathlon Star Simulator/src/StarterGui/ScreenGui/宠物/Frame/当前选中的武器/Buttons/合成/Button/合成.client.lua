-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:51
-- Luau version 6, Types version 3
-- Time taken: 0.001032 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnlyID_upvr = script.Parent.Parent.Parent.Parent:FindFirstChild("OnlyID")
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local ___________________upvr = ReplicatedStorage["游戏全局配置"]["宠物合成数量"]
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local LocalPlayer_upvr = game.Players.LocalPlayer
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 13
	--[[ Upvalues[9]:
		[1]: OnlyID_upvr (readonly)
		[2]: GetData_upvr (readonly)
		[3]: LocalData_upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: ___________________upvr (readonly)
		[6]: TipsModule_upvr (readonly)
		[7]: LocalPlayer_upvr (readonly)
		[8]: RemoteEvent_upvr (readonly)
		[9]: ShowDetail_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local Value = OnlyID_upvr.Value
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 4. Error Block 21 start (CF ANALYSIS FAILED)
	local any_getDataAndCfg_result1, any_getDataAndCfg_result2 = GetData_upvr.getDataAndCfg(Value)
	for _, v in pairs(LocalData_upvr:GetLocalData().Bag) do
		if v.tp == EnumMgr_upvr.ItemType.Hero and (v.lock or 0) == 0 and v.id == any_getDataAndCfg_result1.id and v.onlyID ~= any_getDataAndCfg_result1.onlyID then
		end
	end
	-- KONSTANTERROR: [4] 4. Error Block 21 end (CF ANALYSIS FAILED)
end, script.Parent.Parent)