-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:03
-- Luau version 6, Types version 3
-- Time taken: 0.002563 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind = require(ReplicatedStorage.Tool.CfgFind)
local MathMgr = require(ReplicatedStorage.Tool.MathMgr)
local EnumMgr = require(ReplicatedStorage.Tool.EnumMgr)
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local Button = script.Parent.BG.Exit.Button
AddListen.AddMouseCLick(Button, function() -- Line 27
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button.Parent)
function module_upvr.updateUi(arg1, arg2) -- Line 31
end
for _, v in pairs(script.Parent.Frame.Window:GetChildren()) do
	local var28
	if v:IsA("Frame") then
		var28 = v.EggID.Value
		local any_FindCfgByID_result1 = CfgFind.FindCfgByID(var28, EnumMgr.ItemType.Egg)
		var28 = 0
		for _, v_2 in pairs(any_FindCfgByID_result1.ItemWeight) do
			var28 += v_2
		end
		for i_3, v_3 in pairs(any_FindCfgByID_result1.ItemIDVt) do
			local SOME = v.Frame["宠物展示"]:FindFirstChild(i_3)
			SOME.Visible = true
			SOME.Name = v_3
			SOME.Rate.Text = MathMgr.GetChanceStr(any_FindCfgByID_result1.ItemWeight[i_3], var28)
			local any_FindCfgByID_result1_2 = CfgFind.FindCfgByID(v_3, EnumMgr.ItemType.Hero)
			if any_FindCfgByID_result1_2 then
				SOME.AddValue.Text = 'x'..MathMgr.getNumStr_1(any_FindCfgByID_result1_2.PowerAdd)
			end
		end
		for _, v_4 in pairs(v.Frame["购买按钮"]:GetChildren()) do
			if v_4:IsA("Frame") then
				local OnlyTag_upvr = v_4:FindFirstChild("OnlyTag")
				local any_FindCfgByOnlyTag_result1_upvr = CfgFind.FindCfgByOnlyTag(OnlyTag_upvr.Value)
				v_4.PriceBG.Price.Text = any_FindCfgByOnlyTag_result1_upvr.price
				local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
				local LocalPlayer_upvr = game.Players.LocalPlayer
				local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
				local CheckGamePass_upvr = require(ReplicatedStorage.Tool.CheckGamePass)
				local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
				AddListen.AddMouseCLick(v_4.Button, function() -- Line 74
					--[[ Upvalues[7]:
						[1]: GetData_upvr (readonly)
						[2]: LocalPlayer_upvr (readonly)
						[3]: any_FindCfgByOnlyTag_result1_upvr (readonly)
						[4]: TipsModule_upvr (readonly)
						[5]: CheckGamePass_upvr (readonly)
						[6]: OnlyTag_upvr (readonly)
						[7]: SystemBuyRoblox_upvr (readonly)
					]]
					if not GetData_upvr.GetIsCanBuyPayEgg(LocalPlayer_upvr, any_FindCfgByOnlyTag_result1_upvr.itemCount[1]) then
						TipsModule_upvr.ErrorTips(LocalPlayer_upvr, "宠物背包已满")
					elseif CheckGamePass_upvr.IsHasPass(LocalPlayer_upvr, OnlyTag_upvr.Value) == false then
						SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, OnlyTag_upvr.Value)
					end
				end, v_4, "音效-场景-点击-通用购买")
			end
		end
	end
end
function module_upvr.openUi(arg1) -- Line 95
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 98
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr