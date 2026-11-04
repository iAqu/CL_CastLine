-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:19
-- Luau version 6, Types version 3
-- Time taken: 0.002101 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local Frame = script.Parent.Frame
local Button = script.Parent.BG.Exit.Button
AddListen.AddMouseCLick(Button, function() -- Line 16
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button.Parent)
local LocalPlayer_upvr = game.Players.LocalPlayer
local Box_upvr = Frame.Code.Input.Box
local Button_upvr = Frame.Code.Button
local Waiting_upvr = Frame.Code.Waiting
Button_upvr.Visible = true
Waiting_upvr.Visible = false
local _______upvr = Frame.Code.Input["字数"]
local function refreshFind_upvr() -- Line 34, Named "refreshFind"
	--[[ Upvalues[2]:
		[1]: Box_upvr (readonly)
		[2]: _______upvr (readonly)
	]]
	_______upvr.Text = '('..string.len(Box_upvr.Text)..'/'..256..')'
	local string_len_result1 = string.len(Box_upvr.Text)
	if string_len_result1 < 20 or 256 < string_len_result1 then
		_______upvr.TextColor3 = Color3.new(1, 0, 0)
	else
		_______upvr.TextColor3 = Color3.new(0, 1, 0)
	end
end
Box_upvr.InputEnded:Connect(function() -- Line 46
	--[[ Upvalues[1]:
		[1]: refreshFind_upvr (readonly)
	]]
	refreshFind_upvr()
end)
Box_upvr.FocusLost:Connect(function(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: refreshFind_upvr (readonly)
	]]
	refreshFind_upvr()
end)
function sendComment(arg1) -- Line 54
	return game.ReplicatedStorage.Msg["玩家反馈"]:InvokeServer(arg1)
end
local reportTime_upvr = LocalPlayer_upvr:WaitForChild("reportTime", math.huge)
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local Log_upvr = require(game.ReplicatedStorage.Tool.Log)
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local var21_upvw = false
AddListen.AddMouseCLick(Frame.Code.Button, function() -- Line 67
	--[[ Upvalues[9]:
		[1]: reportTime_upvr (readonly)
		[2]: MathMgr_upvr (readonly)
		[3]: Log_upvr (readonly)
		[4]: TipsModule_upvr (readonly)
		[5]: LocalPlayer_upvr (readonly)
		[6]: Box_upvr (readonly)
		[7]: Waiting_upvr (readonly)
		[8]: Button_upvr (readonly)
		[9]: var21_upvw (read and write)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var22 = workspace:GetServerTimeNow() - reportTime_upvr.Value - 7200
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [13] 10. Error Block 2 start (CF ANALYSIS FAILED)
	local any_getNumStr_0_result1 = MathMgr_upvr.getNumStr_0(math.abs(var22 / 60))
	Log_upvr.print("再过多少秒可以 重新反馈", any_getNumStr_0_result1)
	TipsModule_upvr.showTips(LocalPlayer_upvr, "反馈CD中", {any_getNumStr_0_result1})
	do
		return
	end
	-- KONSTANTERROR: [13] 10. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 31. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 31. Error Block 3 end (CF ANALYSIS FAILED)
end, Frame.Code.Button)
function module_upvr.updateUi(arg1) -- Line 121
end
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
function module_upvr.openUi(arg1) -- Line 124
	--[[ Upvalues[3]:
		[1]: UIMgr_upvr (readonly)
		[2]: Box_upvr (readonly)
		[3]: TranslationHelper_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	Box_upvr.PlaceholderText = TranslationHelper_upvr.translateByKey("请在这输入反馈")
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 131
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr