-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:19
-- Luau version 6, Types version 3
-- Time taken: 0.001158 seconds

local LocalPlayer_upvr = game.Players.LocalPlayer
local AutoMatch_upvr = LocalPlayer_upvr:WaitForChild("Setting", math.huge):WaitForChild("AutoMatch", math.huge)
local AddListen = require(game.ReplicatedStorage.Tool.AddListen)
local ON_upvr = script.Parent.ON
local OFF_upvr = script.Parent.OFF
local TipsModule_upvr = require(game.ReplicatedStorage.Tool.TipsModule)
AddListen.NumValueAdd(AutoMatch_upvr, function(arg1) -- Line 9
	--[[ Upvalues[4]:
		[1]: ON_upvr (readonly)
		[2]: OFF_upvr (readonly)
		[3]: TipsModule_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
	]]
	local var8
	if arg1 ~= 1 then
		var8 = false
	else
		var8 = true
	end
	ON_upvr.Visible = var8
	if arg1 ~= 0 then
		var8 = false
	else
		var8 = true
	end
	OFF_upvr.Visible = var8
	if arg1 == 1 then
		var8 = TipsModule_upvr
		var8 = LocalPlayer_upvr
		var8.showTips(var8, "开启自动比赛")
	else
		var8 = TipsModule_upvr
		var8 = LocalPlayer_upvr
		var8.ErrorTips(var8, "关闭自动比赛")
	end
end)
local Setting_upvr = game.ReplicatedStorage.ServerMsg.Setting
AddListen.AddMouseCLick(script.Parent.Button, function() -- Line 20
	--[[ Upvalues[2]:
		[1]: AutoMatch_upvr (readonly)
		[2]: Setting_upvr (readonly)
	]]
	if AutoMatch_upvr.Value == 0 then
		Setting_upvr:InvokeServer("AutoMatch", 1)
	else
		Setting_upvr:InvokeServer("AutoMatch", 0)
	end
end, script.Parent)