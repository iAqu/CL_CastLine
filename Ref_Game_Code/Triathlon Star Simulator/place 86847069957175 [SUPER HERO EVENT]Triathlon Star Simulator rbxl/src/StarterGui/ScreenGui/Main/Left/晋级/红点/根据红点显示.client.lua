-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:09
-- Luau version 6, Types version 3
-- Time taken: 0.001299 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EnumMgr = require(ReplicatedStorage.Tool.EnumMgr)
local LocalPlayer = game.Players.LocalPlayer
local AddListen = require(game.ReplicatedStorage.Tool.AddListen)
local GetData = require(game.ReplicatedStorage.Tool.GetData)
local any_WaitBagNumberValue_result1_upvr_2 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Attr_1)
local any_WaitBagNumberValue_result1_upvr_3 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Attr_2)
local any_WaitBagNumberValue_result1_upvr = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Attr_3)
local any_WaitBagNumberValue_result1_upvr_4 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Money)
local rebirthCount_upvr = LocalPlayer:WaitForChild("rebirthCount", math.huge)
local Value_upvr = ReplicatedStorage["游戏全局配置"]["最大晋级等级"].Value
local RebirthData_upvr = require(ReplicatedStorage.Tool.RebirthData)
local IsNewPlayer_upvr = LocalPlayer:WaitForChild("IsNewPlayer", math.huge)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local function updateRed() -- Line 21
	--[[ Upvalues[9]:
		[1]: rebirthCount_upvr (readonly)
		[2]: Value_upvr (readonly)
		[3]: RebirthData_upvr (readonly)
		[4]: IsNewPlayer_upvr (readonly)
		[5]: any_WaitBagNumberValue_result1_upvr_2 (readonly)
		[6]: any_WaitBagNumberValue_result1_upvr_3 (readonly)
		[7]: any_WaitBagNumberValue_result1_upvr (readonly)
		[8]: RemoteEvent_upvr (readonly)
		[9]: any_WaitBagNumberValue_result1_upvr_4 (readonly)
	]]
	if Value_upvr <= rebirthCount_upvr.Value then
		script.Parent.Visible = false
	else
		local any_GetRebirthCfg_result1 = RebirthData_upvr.GetRebirthCfg(rebirthCount_upvr.Value + 1)
		if not any_GetRebirthCfg_result1 then
			script.Parent.Visible = false
			return
		end
		if IsNewPlayer_upvr.Value == true and 10 < any_WaitBagNumberValue_result1_upvr_2.Value and 10 < any_WaitBagNumberValue_result1_upvr_3.Value and 10 < any_WaitBagNumberValue_result1_upvr.Value then
			RemoteEvent_upvr:FireServer("开启引导", "比赛引导")
		end
		if any_WaitBagNumberValue_result1_upvr_2.Value < any_GetRebirthCfg_result1.need[1] then
			script.Parent.Visible = false
			return
		end
		if any_WaitBagNumberValue_result1_upvr_3.Value < any_GetRebirthCfg_result1.need[2] then
			script.Parent.Visible = false
			return
		end
		if any_WaitBagNumberValue_result1_upvr.Value < any_GetRebirthCfg_result1.need[3] then
			script.Parent.Visible = false
			return
		end
		if any_WaitBagNumberValue_result1_upvr_4.Value < any_GetRebirthCfg_result1.money then
			script.Parent.Visible = false
			return
		end
		script.Parent.Visible = true
	end
end
AddListen.NumValueAdd(any_WaitBagNumberValue_result1_upvr_2, updateRed)
AddListen.NumValueAdd(any_WaitBagNumberValue_result1_upvr_3, updateRed)
AddListen.NumValueAdd(any_WaitBagNumberValue_result1_upvr, updateRed)
AddListen.NumValueAdd(any_WaitBagNumberValue_result1_upvr_4, updateRed)
AddListen.NumValueAdd(rebirthCount_upvr, updateRed)