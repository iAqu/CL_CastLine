-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:45
-- Luau version 6, Types version 3
-- Time taken: 0.001893 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local isGetGroupAward1_upvr = game.Players.LocalPlayer:WaitForChild("isGetGroupAward1", math.huge)
local Parent = script.Parent
local Frame = Parent.Frame
local ConfirmBtn_upvr = Frame.ConfirmBtn
local List = Frame.AwardFrame.List
local Temp = List.Temp
Temp.Visible = false
local ____________ = ReplicatedStorage["游戏全局配置"]["群组设置"]
Frame.ImageLabel["游戏名字"].Text = ____________["游戏名字"].Value
Frame.ImageLabel["游戏谁制作"].Text = ____________["群组名字"].Value
for _, v in pairs(____________["群组奖励"]:GetChildren()) do
	local tonumber_result1 = tonumber(v.Name)
	local any_FindCfgByID_result1 = require(ReplicatedStorage.Tool.CfgFind).FindCfgByID(tonumber_result1)
	local clone = Temp:Clone()
	clone.Visible = true
	clone.Name = v.Name
	clone.LayoutOrder = tonumber_result1
	clone.Parent = List
	local Count = clone.Count
	if any_FindCfgByID_result1.xyd then
		require(ReplicatedStorage.Tool.GradientsMgr).ChangeClolr(clone.BG.BG, any_FindCfgByID_result1.xyd)
	else
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
		require(ReplicatedStorage.Tool.GradientsMgr).ChangeClolr(clone.BG.BG, 2)
	end
	if any_FindCfgByID_result1.tp == require(ReplicatedStorage.Tool.EnumMgr).ItemType.Hero then
		clone.Icon.Visible = false
		Count.Visible = true
		clone.View.Visible = true
		require(ReplicatedStorage.Tool.Viewport).createViewPort(clone.View, tonumber_result1)
		Count.Text = 'x'..require(ReplicatedStorage.Tool.MathMgr).getNumStr(v.Value)
	else
		clone.Icon.Visible = true
		Count.Visible = true
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		clone.View.Visible = false
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		Count.Text = 'x'..require(ReplicatedStorage.Tool.MathMgr).getNumStr(v.Value)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		clone.Icon.Image = "rbxassetid://"..any_FindCfgByID_result1.Icon
	end
end
AddListen.AddMouseCLick(Parent.BG.Exit.Button, function() -- Line 76
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent.BG.Exit.Frame, "音效-场景-点击-通用返回")
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
AddListen.AddMouseCLick(ConfirmBtn_upvr.Button, function() -- Line 80
	--[[ Upvalues[3]:
		[1]: isGetGroupAward1_upvr (readonly)
		[2]: RemoteFunction_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if isGetGroupAward1_upvr.Value == 1 then
	elseif RemoteFunction_upvr:InvokeServer("领取群组奖励") then
		module_upvr:closeUi()
		return
	end
end, ConfirmBtn_upvr.Frame)
AddListen.NumValueAdd(isGetGroupAward1_upvr, function(arg1) -- Line 90
	--[[ Upvalues[1]:
		[1]: ConfirmBtn_upvr (readonly)
	]]
	if arg1 == 1 then
		ConfirmBtn_upvr.Frame.Open.Visible = false
		ConfirmBtn_upvr.Frame.Close.Visible = true
	else
		ConfirmBtn_upvr.Frame.Open.Visible = true
		ConfirmBtn_upvr.Frame.Close.Visible = false
	end
end)
function module_upvr.updateUi(arg1, arg2) -- Line 101
end
function module_upvr.openUi(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: UIMgr_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 108
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr