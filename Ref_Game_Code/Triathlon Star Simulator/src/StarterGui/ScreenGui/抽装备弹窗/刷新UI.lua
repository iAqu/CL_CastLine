-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:36
-- Luau version 6, Types version 3
-- Time taken: 0.005478 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local HatchEffect_upvr = require(ReplicatedStorage.Tool.HatchEffect)
local any_GetCfgByName_result1_upvr = CfgFind_upvr.GetCfgByName("eggdataConf")
local var16_upvw = 0
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
local Parent = script.Parent
local Frame_upvr = Parent.Frame
local Exit = Parent.BG.Exit
GradientsMgr_upvr.setXydLabel(Frame_upvr['1'].Left.Frame["秘密稀有度"], EnumMgr_upvr.Rare.Secret)
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local function refreshShowPet_upvr() -- Line 48, Named "refreshShowPet"
	--[[ Upvalues[9]:
		[1]: any_GetCfgByName_result1_upvr (readonly)
		[2]: var16_upvw (read and write)
		[3]: CfgFind_upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: MathMgr_upvr (readonly)
		[6]: Frame_upvr (readonly)
		[7]: Viewport_upvr (readonly)
		[8]: TranslationHelper_upvr (readonly)
		[9]: GradientsMgr_upvr (readonly)
	]]
	local var47 = any_GetCfgByName_result1_upvr[var16_upvw]
	if not var47 then
	else
		for _, v_3 in pairs(var47.ItemIDVt) do
			local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(v_3, EnumMgr_upvr.ItemType.Tool)
			if any_FindCfgByID_result1_2 then
				if any_FindCfgByID_result1_2.xyd ~= EnumMgr_upvr.Rare.Secret then
					table.insert({}, v_3)
				else
					table.insert({}, v_3)
				end
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local any_Table_Rand_result1_2 = MathMgr_upvr.Table_Rand({})
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		any_Table_Rand_result1_2[4] = MathMgr_upvr.Table_Rand({})[1]
		for _, v_4 in pairs(Frame_upvr:GetChildren()) do
			local Left_2 = v_4.Left
			for i_5 = 1, 4 do
				local tbl = {
					id = any_Table_Rand_result1_2[i_5];
					count = 1;
					tp = EnumMgr_upvr.ItemType.Tool;
				}
				local ViewportFrame = ({Left_2.Frame["跑鞋"], Left_2.Frame["脚蹼"], Left_2.Frame["自行车"], Left_2.Frame["秘密"]})[i_5].Frame:FindFirstChild("ViewportFrame")
				if ViewportFrame then
					Viewport_upvr.createViewPort(ViewportFrame, tbl.id, i_5)
				end
				local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(tbl.id, EnumMgr_upvr.ItemType.Tool)
				if any_FindCfgByID_result1 then
					TranslationHelper_upvr.SetText(Left_2.Frame["Name"..i_5], any_FindCfgByID_result1.ZhName)
					if i_5 ~= 4 then
						GradientsMgr_upvr.AddGradientColor(any_FindCfgByID_result1.xyd, Left_2.Frame["Name"..i_5])
					end
				end
			end
		end
	end
end
for _, v in pairs(Frame_upvr:GetChildren()) do
	local BuyOne = v.BuyOne
	local BuyTen = v.BuyTen
	AddListen.AddMouseCLick(BuyOne.Button, function() -- Line 122
		--[[ Upvalues[3]:
			[1]: RemoteFunction_upvr (readonly)
			[2]: var16_upvw (read and write)
			[3]: HatchEffect_upvr (readonly)
		]]
		local any_InvokeServer_result1 = RemoteFunction_upvr:InvokeServer("抽装备x1", var16_upvw)
		if any_InvokeServer_result1 then
			HatchEffect_upvr.ShowHatchEffect_Tool(any_InvokeServer_result1)
		end
	end, BuyOne)
	AddListen.AddMouseCLick(BuyTen.Button, function() -- Line 132
		--[[ Upvalues[3]:
			[1]: RemoteFunction_upvr (readonly)
			[2]: var16_upvw (read and write)
			[3]: HatchEffect_upvr (readonly)
		]]
		local any_InvokeServer_result1_2 = RemoteFunction_upvr:InvokeServer("抽装备x10", var16_upvw)
		if any_InvokeServer_result1_2 then
			HatchEffect_upvr.ShowHatchEffect_Tool(any_InvokeServer_result1_2)
		end
	end, BuyTen)
end
AddListen.AddMouseCLick(Exit.Button, function() -- Line 147
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Exit, "音效-场景-点击-通用返回")
local Debris_upvr = game:GetService("Debris")
function module_upvr.updateUi(arg1, arg2) -- Line 151
	--[[ Upvalues[8]:
		[1]: var16_upvw (read and write)
		[2]: Frame_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: any_GetCfgByName_result1_upvr (readonly)
		[5]: CfgFind_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: UIMgr_upvr (readonly)
		[8]: MathMgr_upvr (readonly)
	]]
	if not arg2 then
		var16_upvw = 0
	end
	if tonumber(arg2) then
		var16_upvw = tonumber(arg2)
	end
	local Scroll = Frame_upvr['1'].Right.Scroll
	local Temp = Scroll.Temp
	Temp.Visible = false
	for _, v_2 in pairs(Scroll:GetChildren()) do
		if v_2:IsA("Frame") and v_2.Name ~= "Temp" then
			Debris_upvr:AddItem(v_2, 0)
		end
	end
	local var89 = any_GetCfgByName_result1_upvr[var16_upvw]
	if not var89 then
	else
		local tbl_2 = {}
		for i_6, v_5 in pairs(var89.ItemIDVt) do
			table.insert(tbl_2, {
				id = v_5;
				rate = var89.ItemWeight[i_6];
			})
			local _
		end
		table.sort(tbl_2, function(arg1_2, arg2_2) -- Line 185
			local var97
			if arg1_2.rate >= arg2_2.rate then
				var97 = false
			else
				var97 = true
			end
			return var97
		end)
		for i_7, v_6 in pairs(tbl_2) do
			local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(v_6.id, EnumMgr_upvr.ItemType.Tool)
			if any_FindCfgByID_result1_3 and any_FindCfgByID_result1_3.xyd ~= EnumMgr_upvr.Rare.Secret then
				local clone = Temp:Clone()
				clone.Visible = true
				clone.LayoutOrder = i_7
				clone.Name = i_7
				clone.Parent = Scroll
				clone:SetAttribute("ToolTp", any_FindCfgByID_result1_3.ToolTp)
				UIMgr_upvr.SetToolUI(clone, {
					id = v_6.id;
					count = 1;
					tp = any_FindCfgByID_result1_3.tp;
				})
				clone.LayoutOrder = v_6.rate
				clone.Frame.Rate.Text = MathMgr_upvr.GetPercentStr(v_6.rate / (0 + var89.ItemWeight[i_6]) * 100)
				clone.Frame.Rate.LuckAdd.Visible = false
			end
		end
		UIMgr_upvr.SetUIGridLayoutSize(Scroll)
	end
end
function module_upvr.openUi(arg1) -- Line 221
	--[[ Upvalues[3]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: refreshShowPet_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
	ShowDetail_upvr.HideAllDetail()
	refreshShowPet_upvr()
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 228
	--[[ Upvalues[3]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	ShowDetail_upvr.HideAllDetail()
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr