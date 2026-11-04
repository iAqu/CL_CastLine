-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:47
-- Luau version 6, Types version 3
-- Time taken: 0.002229 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local var4_upvw
local ______ = Parent.Frame["确认"]
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local LocalPlayer_upvr = game.Players.LocalPlayer
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(______.Button, function() -- Line 23
	--[[ Upvalues[5]:
		[1]: var4_upvw (read and write)
		[2]: GetData_upvr (readonly)
		[3]: TipsModule_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	if var4_upvw and var4_upvw.func then
		if var4_upvw.ItemData then
			for i, v in pairs(var4_upvw.ItemData) do
				local any_GetItemCountByIDOnClient_result1 = GetData_upvr.GetItemCountByIDOnClient(i)
				if any_GetItemCountByIDOnClient_result1 < v then
					TipsModule_upvr.TipsNotEnoughItem(LocalPlayer_upvr, i, v, any_GetItemCountByIDOnClient_result1)
					return
				end
			end
			var4_upvw.func()
		else
			var4_upvw.func()
		end
	end
	module_upvr:closeUi()
end, ______)
local ScrollingFrame_upvr = Parent.Frame.ScrollingFrame
local Temp_upvr = ScrollingFrame_upvr.Temp
Temp_upvr.Visible = false
local Debris_upvr = game:GetService("Debris")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
function module_upvr.updateUi(arg1, arg2) -- Line 46
	--[[ Upvalues[7]:
		[1]: var4_upvw (read and write)
		[2]: ScrollingFrame_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: CfgFind_upvr (readonly)
		[5]: Temp_upvr (readonly)
		[6]: UIMgr_upvr (readonly)
		[7]: GradientsMgr_upvr (readonly)
	]]
	var4_upvw = arg2
	local tbl = {}
	for i_2, v_2 in pairs(var4_upvw.AwardID) do
		if tbl[tostring(v_2)] then
			tbl[tostring(v_2)] += tonumber(var4_upvw.Count[i_2])
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			tbl[tostring(v_2)] = tonumber(var4_upvw.Count[i_2])
		end
	end
	for _, v_3 in pairs(ScrollingFrame_upvr:GetChildren()) do
		if v_3:IsA("Frame") and v_3.Name ~= "Temp" then
			Debris_upvr:AddItem(v_3, 0)
		end
	end
	for i_4, v_4 in pairs(tbl) do
		local tonumber_result1 = tonumber(i_4)
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(tonumber_result1)
		local clone = Temp_upvr:Clone()
		clone.Name = i_4
		clone.Visible = true
		clone.Parent = ScrollingFrame_upvr
		UIMgr_upvr.SetAward(clone, tonumber_result1, v_4)
		if any_FindCfgByID_result1 and any_FindCfgByID_result1.xyd then
			GradientsMgr_upvr.AddGradientColor(any_FindCfgByID_result1.xyd, clone:FindFirstChild("itemName"))
			clone.LayoutOrder = 10 - any_FindCfgByID_result1.xyd
		end
	end
	UIMgr_upvr.SetUIlistSize(ScrollingFrame_upvr)
end
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
function module_upvr.openUi(arg1) -- Line 90
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.playSound({
		SoundName = "音效-场景-点击-通用获得";
	})
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 96
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr