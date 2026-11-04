-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:31
-- Luau version 6, Types version 3
-- Time taken: 0.002639 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local any_GetCfgByName_result1_upvr = require(ReplicatedStorage.Tool.CfgFind).GetCfgByName("upgradeConf")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local Parent = script.Parent
local ScrollingFrame_upvr = Parent.Frame.ScrollingFrame
local Temp = ScrollingFrame_upvr.Temp
local Content = Parent.Frame.Content
local ContentFrame_upvr = Content.ContentFrame
local ContentTemp_upvr = ContentFrame_upvr.ContentTemp
Temp.Visible = false
ContentTemp_upvr.Visible = false
local Choose_upvr = Parent.Choose
AddListen.AddMouseCLick(Parent.BG.Exit.Button, function() -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent.BG.Exit.Frame)
local var19_upvw = 0
for i, v in pairs(any_GetCfgByName_result1_upvr) do
	local clone_2_upvr = Temp:Clone()
	clone_2_upvr.Visible = true
	clone_2_upvr.Name = i
	clone_2_upvr.LayoutOrder = -i
	clone_2_upvr.Parent = ScrollingFrame_upvr
	TranslationHelper_upvr.SetText(clone_2_upvr.Frame.VerName, v.Tittle)
	AddListen.AddMouseCLick(clone_2_upvr.Button, function() -- Line 53
		--[[ Upvalues[2]:
			[1]: Choose_upvr (readonly)
			[2]: clone_2_upvr (readonly)
		]]
		Choose_upvr.Value = tonumber(clone_2_upvr.Name)
	end, clone_2_upvr.Frame)
	var19_upvw = math.max(var19_upvw, i)
end
UIMgr_upvr.SetUIlistSize(ScrollingFrame_upvr)
function module_upvr.updateUi(arg1, arg2) -- Line 62
end
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
function module_upvr.openUi(arg1) -- Line 66
	--[[ Upvalues[7]:
		[1]: UIMgr_upvr (readonly)
		[2]: LocalData_upvr (readonly)
		[3]: ScrollingFrame_upvr (readonly)
		[4]: any_GetCfgByName_result1_upvr (readonly)
		[5]: TranslationHelper_upvr (readonly)
		[6]: Choose_upvr (readonly)
		[7]: var19_upvw (read and write)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
	for _, v_2 in pairs(ScrollingFrame_upvr:GetChildren()) do
		local tonumber_result1 = tonumber(v_2.Name)
		if tonumber_result1 then
			local floored = math.floor((LocalData_upvr:GetSerVerTime() - any_GetCfgByName_result1_upvr[tonumber_result1].UpgradeTime) / 86400)
			if floored <= 0 then
				TranslationHelper_upvr.SetText(v_2.Frame.UpgradeName, "最新的更新公告")
			else
				TranslationHelper_upvr.SetText(v_2.Frame.UpgradeName, "几天前更新", {floored})
			end
		end
	end
	Choose_upvr.Value = var19_upvw
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 89
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
local ContentTittle_upvr = Content.ContentTittle
AddListen.NumValueAdd(Choose_upvr, function(arg1) -- Line 94
	--[[ Upvalues[6]:
		[1]: ScrollingFrame_upvr (readonly)
		[2]: ContentFrame_upvr (readonly)
		[3]: any_GetCfgByName_result1_upvr (readonly)
		[4]: TranslationHelper_upvr (readonly)
		[5]: ContentTittle_upvr (readonly)
		[6]: ContentTemp_upvr (readonly)
	]]
	for _, v_3 in pairs(ScrollingFrame_upvr:GetChildren()) do
		local tonumber_result1_2 = tonumber(v_3.Name)
		if tonumber_result1_2 then
			if tonumber_result1_2 == arg1 then
				v_3.Frame.Choose.Visible = true
			else
				v_3.Frame.Choose.Visible = false
			end
		end
	end
	for _, v_4 in pairs(ContentFrame_upvr:GetChildren()) do
		if tonumber(v_4.Name) then
			v_4:Destroy()
		end
	end
	local var50 = any_GetCfgByName_result1_upvr[arg1]
	if not var50 then
	else
		TranslationHelper_upvr.SetText(ContentTittle_upvr, var50.Tittle)
		for i_5, v_5 in pairs(var50.Content) do
			local clone = ContentTemp_upvr:Clone()
			clone.Visible = true
			clone.Name = i_5
			clone.LayoutOrder = i_5
			clone.Parent = ContentFrame_upvr
			TranslationHelper_upvr.SetText(clone, v_5)
		end
	end
end)
return module_upvr