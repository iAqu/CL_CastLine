-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:33
-- Luau version 6, Types version 3
-- Time taken: 0.003030 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathMgr = require(ReplicatedStorage.Tool.MathMgr)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local Parent_upvr = script.Parent
local Frame = Parent_upvr.Frame
local onlinerewardsConf_upvr = require(ReplicatedStorage.ConfigInstance).onlinerewardsConf
local tbl_upvr = {}
for i_upvr, v in pairs(onlinerewardsConf_upvr) do
	local var16_upvw
	if i_upvr == #onlinerewardsConf_upvr then
		var16_upvw = Frame.Frame.Temp:Clone()
	else
		var16_upvw = Frame.Frame.Temp:Clone()
	end
	var16_upvw.Visible = true
	var16_upvw.LayoutOrder = i_upvr
	var16_upvw.Name = i_upvr
	var16_upvw.Parent = Frame.Frame
	local Icon = var16_upvw.Icon
	local Count = var16_upvw.Count
	local TrainAdd = var16_upvw.TrainAdd
	local any_FindCfgByID_result1 = require(ReplicatedStorage.Tool.CfgFind).FindCfgByID(v.ItemID[1])
	if any_FindCfgByID_result1 then
		require(ReplicatedStorage.Tool.GradientsMgr).AddGradientColor(v.Color, var16_upvw.BG.BG)
		Icon.Visible = true
		Count.Visible = true
		var16_upvw.NameStr.Visible = false
		Count.Text = 'x'..MathMgr.getNumStr(v.ItemNumber[1])
		if any_FindCfgByID_result1.Icon then
			Icon.Image = "rbxassetid://"..any_FindCfgByID_result1.Icon
		end
		if any_FindCfgByID_result1.tp == require(ReplicatedStorage.Tool.EnumMgr).ItemType.Hero then
			local ViewportFrame = var16_upvw.Frame:FindFirstChild("ViewportFrame")
			if ViewportFrame then
				if require(ReplicatedStorage.Tool.Viewport).createViewPort_Pet(ViewportFrame, v.ItemID[1]) then
					ViewportFrame.Visible = true
				else
					ViewportFrame.Visible = false
				end
			end
			Icon.Visible = false
			Count.Visible = false
			TrainAdd.Visible = true
			require(ReplicatedStorage.Tool.TranslationHelper).SetText_UnTrans(TrainAdd, 'x'..MathMgr.getNumStr_1(any_FindCfgByID_result1.PowerAdd))
		else
			Count.Visible = true
			TrainAdd.Visible = false
			var16_upvw.Frame.ViewportFrame.Visible = false
		end
		local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
		require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(var16_upvw, function() -- Line 86
			--[[ Upvalues[3]:
				[1]: RemoteFunction_upvr (readonly)
				[2]: i_upvr (readonly)
				[3]: var16_upvw (read and write)
			]]
			if RemoteFunction_upvr:InvokeServer("领取在线奖励", i_upvr) then
				var16_upvw["领取"].Visible = false
				var16_upvw["已领取"].Visible = true
				var16_upvw["倒计时"].Visible = false
				var16_upvw.Claimed.Visible = true
			end
		end, var16_upvw)
	end
	table.insert(tbl_upvr, var16_upvw)
end
Frame.Frame.Temp:Destroy()
-- KONSTANTERROR: Expression was reused, decompilation is incorrect
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(Parent_upvr.BG.Exit.Button, function() -- Line 102
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent_upvr.BG.Exit, "音效-场景-点击-通用返回")
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local LocalPlayer_upvr = game.Players.LocalPlayer
local TimeTransfer_upvr = require(ReplicatedStorage.Tool.TimeTransfer)
function module_upvr.updateUi(arg1) -- Line 106
	--[[ Upvalues[5]:
		[1]: LocalData_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: onlinerewardsConf_upvr (readonly)
		[5]: TimeTransfer_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 21 start (CF ANALYSIS FAILED)
	if not LocalPlayer_upvr:FindFirstChild("OnlineTime") then return end
	local pairs_result1, pairs_result2, pairs_result3_2 = pairs(tbl_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [90] 64. Error Block 18 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [90] 64. Error Block 18 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [19] 16. Error Block 30 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [90.11]
	if nil == 1 then
		-- KONSTANTWARNING: GOTO [90] #64
	end
	-- KONSTANTERROR: [19] 16. Error Block 30 end (CF ANALYSIS FAILED)
end
function module_upvr.openUi(arg1) -- Line 157
	--[[ Upvalues[1]:
		[1]: UIMgr_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
end
spawn(function() -- Line 161
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	while wait(1) do
		if Parent_upvr.Visible == true then
			module_upvr:updateUi()
		end
	end
end)
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 170
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr