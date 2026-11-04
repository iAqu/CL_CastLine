-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:05
-- Luau version 6, Types version 3
-- Time taken: 0.001090 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local BtnSpin = script.Parent.Frame.BtnFrame.BtnSpin
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local SpinValue_upvr = BtnSpin.Frame.SpinValue
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(LocalPlayer:WaitForChild("Bag", math.huge):WaitForChild(require(ReplicatedStorage.Tool.EnumMgr).ItemID.DailyToken), function(arg1) -- Line 23
	--[[ Upvalues[2]:
		[1]: TranslationHelper_upvr (readonly)
		[2]: SpinValue_upvr (readonly)
	]]
	local tbl = {}
	tbl[1] = arg1
	TranslationHelper_upvr.SetText(SpinValue_upvr, "转盘剩余", tbl)
end)
local LastDailySpinRefreshTime_upvr = LocalPlayer:WaitForChild("LastDailySpinRefreshTime", math.huge)
local var10_upvr = ReplicatedStorage["游戏全局配置"]["每日转盘"]["每日转盘次数刷新CD小时"].Value * 3600
local Des_upvr = BtnSpin.Frame.Des
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local TimeTransfer_upvr = require(ReplicatedStorage.Tool.TimeTransfer)
spawn(function() -- Line 28
	--[[ Upvalues[5]:
		[1]: LastDailySpinRefreshTime_upvr (readonly)
		[2]: var10_upvr (readonly)
		[3]: Des_upvr (readonly)
		[4]: RemoteEvent_upvr (readonly)
		[5]: TimeTransfer_upvr (readonly)
	]]
	while wait(1) do
		local var14 = os.time() - LastDailySpinRefreshTime_upvr.Value - var10_upvr
		if 0 <= var14 then
			Des_upvr.Text = ""
			RemoteEvent_upvr:FireServer("更新转盘")
		else
			Des_upvr.Text = TimeTransfer_upvr.FormatTime(math.abs(var14))
		end
	end
end)