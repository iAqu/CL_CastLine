-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:25
-- Luau version 6, Types version 3
-- Time taken: 0.001829 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local any_GetCfgByName_result1_upvr = require(ReplicatedStorage.Tool.CfgFind).GetCfgByName("settingConf")
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local Button = script.Parent.BG.Exit.Button
AddListen.AddMouseCLick(Button, function() -- Line 18
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button.Parent)
local ScrollingFrame = script.Parent.Frame.ScrollingFrame
local Temp = ScrollingFrame.Temp
Temp.Visible = false
local Setting_upvr = ReplicatedStorage.ServerMsg.Setting
for i_upvr, v in pairs(any_GetCfgByName_result1_upvr) do
	if v.isShow == 1 and v.isBar == 0 then
		local clone = Temp:Clone()
		clone.Visible = true
		clone.Parent = ScrollingFrame
		clone.Name = any_GetCfgByName_result1_upvr[i_upvr].ShowName
		require(ReplicatedStorage.Tool.TranslationHelper).SetText(clone.Title, any_GetCfgByName_result1_upvr[i_upvr].ZhName)
		local OFF_upvr = clone.State.OFF
		local ON_upvr = clone.State.ON
		AddListen.AddMouseCLick(OFF_upvr.Button, function() -- Line 57
			--[[ Upvalues[3]:
				[1]: Setting_upvr (readonly)
				[2]: any_GetCfgByName_result1_upvr (readonly)
				[3]: i_upvr (readonly)
			]]
			Setting_upvr:InvokeServer(any_GetCfgByName_result1_upvr[i_upvr].ShowName, 1)
		end, OFF_upvr.Frame)
		AddListen.AddMouseCLick(ON_upvr.Button, function() -- Line 61
			--[[ Upvalues[3]:
				[1]: Setting_upvr (readonly)
				[2]: any_GetCfgByName_result1_upvr (readonly)
				[3]: i_upvr (readonly)
			]]
			Setting_upvr:InvokeServer(any_GetCfgByName_result1_upvr[i_upvr].ShowName, 0)
		end, ON_upvr.Frame)
		AddListen.NumValueAdd(game.Players.LocalPlayer:WaitForChild("Setting", math.huge):WaitForChild(any_GetCfgByName_result1_upvr[i_upvr].ShowName), function(arg1) -- Line 66
			--[[ Upvalues[2]:
				[1]: OFF_upvr (readonly)
				[2]: ON_upvr (readonly)
			]]
			local var22
			if arg1 ~= 0 then
				var22 = false
			else
				var22 = true
			end
			OFF_upvr.Visible = var22
			if arg1 ~= 1 then
				var22 = false
			else
				var22 = true
			end
			ON_upvr.Visible = var22
		end)
	end
end
UIMgr_upvr.SetUIlistSize(ScrollingFrame)
function module_upvr.updateUi(arg1) -- Line 77
end
function module_upvr.openUi(arg1) -- Line 80
	--[[ Upvalues[1]:
		[1]: UIMgr_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 84
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr