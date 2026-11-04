-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:22
-- Luau version 6, Types version 3
-- Time taken: 0.005967 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local any_GetCfgByName_result1_upvr_2 = CfgFind_upvr.GetCfgByName("worldConf")
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local Parent = script.Parent
local EggScroll_upvr = Parent.Frame.EggScroll
local EggTemp_upvr = EggScroll_upvr.EggTemp
local WorldTemp = EggScroll_upvr.WorldTemp
local PetFrame = Parent.Frame.PetFrame
local PetScroll_upvr = PetFrame.PetScroll
local PetTemp_upvr = PetScroll_upvr.PetTemp
local FuseTag_upvr = PetFrame.FuseTag
local AwardFrame = PetFrame.AwardFrame
EggTemp_upvr.Visible = false
WorldTemp.Visible = false
PetTemp_upvr.Visible = false
local CurEgg_upvr = Parent.CurEgg
local CurFuseLv_upvr = Parent.CurFuseLv
local CurWorld_upvr = Parent.CurWorld
AddListen_upvr.AddMouseCLick(Parent.BG.Exit.Button, function() -- Line 57
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent.BG.Exit.Frame)
for i, v in pairs(any_GetCfgByName_result1_upvr_2) do
	if v.IsPublic ~= 0 then
		local clone_3_upvr = WorldTemp:Clone()
		clone_3_upvr.Visible = true
		clone_3_upvr.Name = i
		clone_3_upvr.LayoutOrder = i * 10
		clone_3_upvr:SetAttribute("type", "world")
		clone_3_upvr.Parent = EggScroll_upvr
		TranslationHelper_upvr.SetText(clone_3_upvr.Frame.WorldName, v.ZhName)
		clone_3_upvr.Frame.Icon.Image = "rbxassetid://"..v.IndexIcon
		AddListen_upvr.AddMouseCLick(clone_3_upvr.Button, function() -- Line 76
			--[[ Upvalues[2]:
				[1]: CurWorld_upvr (readonly)
				[2]: clone_3_upvr (readonly)
			]]
			CurWorld_upvr.Value = tonumber(clone_3_upvr.Name)
		end, clone_3_upvr.Frame)
	end
end
for _, v_2_upvr in pairs(FuseTag_upvr:GetChildren()) do
	clone_3_upvr = tonumber(v_2_upvr.Name)
	if clone_3_upvr then
		AddListen_upvr.AddMouseCLick(v_2_upvr.Button, function() -- Line 87
			--[[ Upvalues[2]:
				[1]: CurFuseLv_upvr (readonly)
				[2]: v_2_upvr (readonly)
			]]
			CurFuseLv_upvr.Value = tonumber(v_2_upvr.Name)
		end, v_2_upvr.Frame)
	end
end
UIMgr_upvr.SetUIlistSize(EggScroll_upvr)
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local function refreshPetInfo_upvr() -- Line 94, Named "refreshPetInfo"
	--[[ Upvalues[12]:
		[1]: PetScroll_upvr (readonly)
		[2]: any_GetCfgByName_result1_upvr_2 (readonly)
		[3]: CurWorld_upvr (readonly)
		[4]: CfgFind_upvr (readonly)
		[5]: CurEgg_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: LocalData_upvr (readonly)
		[8]: CurFuseLv_upvr (readonly)
		[9]: PetTemp_upvr (readonly)
		[10]: Viewport_upvr (readonly)
		[11]: TranslationHelper_upvr (readonly)
		[12]: GradientsMgr_upvr (readonly)
	]]
	for _, v_3 in pairs(PetScroll_upvr:GetChildren()) do
		if tonumber(v_3.Name) then
			v_3:Destroy()
		end
	end
	local var47 = any_GetCfgByName_result1_upvr_2[CurWorld_upvr.Value]
	if not var47 then
	else
		local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(var47.EggVts[CurEgg_upvr.Value], EnumMgr_upvr.ItemType.Egg)
		if not any_FindCfgByID_result1_2 then return end
		for i_9, _ in pairs(LocalData_upvr:GetLocalData().Record) do
			local tonumber_result1 = tonumber(i_9)
			if tonumber_result1 and CfgFind_upvr.FindCfgByID(tonumber_result1, EnumMgr_upvr.ItemType.Hero) then
				({})[tonumber_result1] = 1
			end
		end
		for i_10, v_10 in pairs(any_FindCfgByID_result1_2.ItemIDVt) do
			local var56 = v_10 + 100000 * (CurFuseLv_upvr.Value - 1)
			local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(var56, EnumMgr_upvr.ItemType.Hero)
			if any_FindCfgByID_result1_4 then
				local clone = PetTemp_upvr:Clone()
				clone.Visible = true
				clone.Name = i_10
				clone.LayoutOrder = i_10
				clone.Parent = PetScroll_upvr
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if ({})[var56] == 1 then
					local BG = clone.BG.BG
					clone.ViewportFrame.Visible = true
					clone.Lock.Visible = false
					clone.ZhName.Visible = true
					Viewport_upvr.createViewPort(clone.ViewportFrame, var56)
					TranslationHelper_upvr.SetText(clone.ZhName, any_FindCfgByID_result1_4.ZhName)
					BG.BackgroundColor3 = Color3.fromHex("#ffffff")
					GradientsMgr_upvr.ChangeClolr(BG, any_FindCfgByID_result1_4.xyd)
				else
					clone.BG.BG.BackgroundColor3 = Color3.fromHex("#5d5d5d")
					clone.ViewportFrame.Visible = false
					clone.Lock.Visible = true
					clone.ZhName.Visible = false
				end
			end
		end
	end
end
local any_GetCfgByName_result1_upvr = CfgFind_upvr.GetCfgByName("indexrewardConf")
local LocalPlayer_upvr = game.Players.LocalPlayer
local Bar_upvr = AwardFrame.Right.BarFrame.BarBG.Bar
local CountStr_upvr = AwardFrame.Right.BarFrame.BarBG.CountStr
local AwardDes_upvr = AwardFrame.Right.AwardDes
local Award_upvr = AwardFrame.Award
function module_upvr.updateUi(arg1, arg2) -- Line 162
	--[[ Upvalues[11]:
		[1]: refreshPetInfo_upvr (readonly)
		[2]: any_GetCfgByName_result1_upvr (readonly)
		[3]: LocalData_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
		[5]: Bar_upvr (readonly)
		[6]: TranslationHelper_upvr (readonly)
		[7]: CountStr_upvr (readonly)
		[8]: CfgFind_upvr (readonly)
		[9]: AwardDes_upvr (readonly)
		[10]: UIMgr_upvr (readonly)
		[11]: Award_upvr (readonly)
	]]
	refreshPetInfo_upvr()
	local IndexClaimed = LocalData_upvr:GetLocalData().IndexClaimed
	local var71
	if not IndexClaimed then
	else
		local UnLockHeroNum = LocalPlayer_upvr:FindFirstChild("UnLockHeroNum")
		if not UnLockHeroNum then return end
		for i_11, v_11 in pairs(any_GetCfgByName_result1_upvr) do
			if UnLockHeroNum.Value < v_11.Need and IndexClaimed[i_11] ~= 1 then
				var71 = math.min(var71, i_11)
			end
		end
		local var76 = any_GetCfgByName_result1_upvr[var71]
		if not var76 then return end
		Bar_upvr.Size = UDim2.new(math.clamp(UnLockHeroNum.Value / var76.Need, 0, 1), 0, 1, 0)
		TranslationHelper_upvr.SetText_UnTrans(CountStr_upvr, UnLockHeroNum.Value..'/'..var76.Need)
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(var76.Award)
		if not any_FindCfgByID_result1 then return end
		TranslationHelper_upvr.SetText(AwardDes_upvr, "收集多少只解锁啥", {var76.Need, any_FindCfgByID_result1.ZhName})
		UIMgr_upvr.SetAward(Award_upvr, var76.Award, var76.Count)
	end
end
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
function module_upvr.openUi(arg1) -- Line 201
	--[[ Upvalues[5]:
		[1]: UIMgr_upvr (readonly)
		[2]: CurWorld_upvr (readonly)
		[3]: CurEgg_upvr (readonly)
		[4]: CurFuseLv_upvr (readonly)
		[5]: RemoteEvent_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
	CurWorld_upvr.Value = 1
	CurEgg_upvr.Value = 1
	CurFuseLv_upvr.Value = 1
	RemoteEvent_upvr:FireServer("领取图鉴奖励")
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 211
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
local tbl_upvr = {}
AddListen_upvr.NumValueAdd(CurWorld_upvr, function(arg1) -- Line 216
	--[[ Upvalues[12]:
		[1]: EggScroll_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: AddListen_upvr (readonly)
		[4]: any_GetCfgByName_result1_upvr_2 (readonly)
		[5]: CfgFind_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: EggTemp_upvr (readonly)
		[8]: CurWorld_upvr (readonly)
		[9]: TranslationHelper_upvr (readonly)
		[10]: CurEgg_upvr (readonly)
		[11]: UIMgr_upvr (readonly)
		[12]: refreshPetInfo_upvr (readonly)
	]]
	for _, v_4 in pairs(EggScroll_upvr:GetChildren()) do
		if v_4:GetAttribute("type") == "world" then
			if tonumber(v_4.Name) == arg1 then
				v_4.Frame.Choose.Visible = true
			else
				v_4.Frame.Choose.Visible = false
			end
		end
	end
	for _, v_5 in pairs(tbl_upvr) do
		if v_5 then
			AddListen_upvr.RemoveMouseClick(v_5)
		end
	end
	for _, v_6 in pairs(EggScroll_upvr:GetChildren()) do
		if v_6:GetAttribute("type") == "egg" then
			v_6:Destroy()
		end
	end
	local var100 = any_GetCfgByName_result1_upvr_2[arg1]
	if not var100 then
	else
		for i_12, v_12 in pairs(var100.EggVts) do
			local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(v_12, EnumMgr_upvr.ItemType.Egg)
			if any_FindCfgByID_result1_3 then
				local clone_2_upvr = EggTemp_upvr:Clone()
				clone_2_upvr.Visible = true
				clone_2_upvr.Name = i_12
				clone_2_upvr.LayoutOrder = CurWorld_upvr.Value * 10 + i_12
				clone_2_upvr:SetAttribute("type", "egg")
				clone_2_upvr.Parent = EggScroll_upvr
				clone_2_upvr.Frame.Choose.Visible = false
				TranslationHelper_upvr.SetText(clone_2_upvr.Frame.EggName, any_FindCfgByID_result1_3.ZhName)
				tbl_upvr[v_12] = AddListen_upvr.AddMouseCLick(clone_2_upvr.Button, function() -- Line 262
					--[[ Upvalues[2]:
						[1]: CurEgg_upvr (copied, readonly)
						[2]: clone_2_upvr (readonly)
					]]
					CurEgg_upvr.Value = tonumber(clone_2_upvr.Name)
				end, clone_2_upvr.Frame)
			end
		end
		UIMgr_upvr.SetUIlistSize(EggScroll_upvr)
		CurEgg_upvr.Value = 1
		refreshPetInfo_upvr()
	end
end)
AddListen_upvr.NumValueAdd(CurEgg_upvr, function(arg1) -- Line 273
	--[[ Upvalues[2]:
		[1]: EggScroll_upvr (readonly)
		[2]: refreshPetInfo_upvr (readonly)
	]]
	for _, v_7 in pairs(EggScroll_upvr:GetChildren()) do
		if v_7:GetAttribute("type") == "egg" then
			if tonumber(v_7.Name) == arg1 then
				v_7.Frame.Choose.Visible = true
			else
				v_7.Frame.Choose.Visible = false
			end
		end
	end
	refreshPetInfo_upvr()
end)
AddListen_upvr.NumValueAdd(CurFuseLv_upvr, function(arg1) -- Line 289
	--[[ Upvalues[2]:
		[1]: FuseTag_upvr (readonly)
		[2]: refreshPetInfo_upvr (readonly)
	]]
	for _, v_8 in pairs(FuseTag_upvr:GetChildren()) do
		local tonumber_result1_2 = tonumber(v_8.Name)
		if tonumber_result1_2 then
			if tonumber_result1_2 == arg1 then
				v_8.Frame.Close.Visible = false
				v_8.Frame.Open.Visible = true
			else
				v_8.Frame.Close.Visible = true
				v_8.Frame.Open.Visible = false
			end
		end
	end
	refreshPetInfo_upvr()
end)
return module_upvr