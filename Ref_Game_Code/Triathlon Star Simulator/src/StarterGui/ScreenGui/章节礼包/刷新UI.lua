-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:05
-- Luau version 6, Types version 3
-- Time taken: 0.003081 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent_upvr = script.Parent
local LocalPlayer_upvr = game.Players.LocalPlayer
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local Exit = Parent_upvr.Exit
AddListen_upvr.AddMouseCLick(Exit.Button, function() -- Line 31
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Exit, "音效-场景-点击-通用返回")
local tbl_upvr_2 = {}
local function UnbindEvent_upvr() -- Line 40, Named "UnbindEvent"
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	for i, v in pairs(tbl_upvr_2) do
		for i_2, _ in pairs(v) do
			tbl_upvr_2[i][i_2]:Disconnect()
			tbl_upvr_2[i][i_2] = nil
		end
	end
end
local tbl_upvr = {"rbxassetid://80782175738730"}
local NowWorld_upvr = LocalPlayer_upvr:WaitForChild("NowWorld", math.huge)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local ScrollingFrame_upvr_2 = Parent_upvr.Frame.ScrollingFrame
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local ScrollingFrame_upvr = Parent_upvr.Frame.ScrollingFrame
local _______upvr = Parent_upvr.Frame["购买"]
local Record_upvr = LocalPlayer_upvr:WaitForChild("Record", math.huge)
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
local function UpdateUI_upvr() -- Line 60, Named "UpdateUI"
	--[[ Upvalues[18]:
		[1]: UnbindEvent_upvr (readonly)
		[2]: NowWorld_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: ScrollingFrame_upvr_2 (readonly)
		[5]: Viewport_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: tbl_upvr (readonly)
		[8]: TranslationHelper_upvr (readonly)
		[9]: GradientsMgr_upvr (readonly)
		[10]: UIMgr_upvr (readonly)
		[11]: ScrollingFrame_upvr (readonly)
		[12]: _______upvr (readonly)
		[13]: Parent_upvr (readonly)
		[14]: tbl_upvr_2 (readonly)
		[15]: AddListen_upvr (readonly)
		[16]: Record_upvr (readonly)
		[17]: SystemBuyRoblox_upvr (readonly)
		[18]: LocalPlayer_upvr (readonly)
	]]
	UnbindEvent_upvr()
	local var36_upvr = "WorldPack"..NowWorld_upvr.Value
	local any_FindCfgByOnlyTag_result1 = CfgFind_upvr.FindCfgByOnlyTag(var36_upvr)
	if any_FindCfgByOnlyTag_result1 then
		local const_number = 1
		for i_3, v_3 in pairs(any_FindCfgByOnlyTag_result1.itemID) do
			local tonumber_result1 = tonumber(v_3)
			local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(tonumber_result1)
			local var44
			if 1 < const_number then
				var44 = ScrollingFrame_upvr_2[tostring(const_number)]
			end
			if any_FindCfgByID_result1 and any_FindCfgByID_result1.Icon then
				var44.Icon.Visible = true
				var44.Icon.Image = "rbxassetid://"..any_FindCfgByID_result1.Icon
			else
				var44.Icon.Visible = false
				Viewport_upvr.createViewPort(var44.ViewportFrame, tonumber_result1)
			end
			if any_FindCfgByID_result1.tp == EnumMgr_upvr.ItemType.Coach then
				var44.Icon.Image = tbl_upvr[1]
			end
			local itemName = var44:FindFirstChild("itemName")
			local Count = var44:FindFirstChild("Count")
			if Count then
				Count.Text = 'x'..any_FindCfgByOnlyTag_result1.itemCount[i_3]
			end
			if itemName then
				TranslationHelper_upvr.SetText(itemName, any_FindCfgByID_result1.ZhName)
			end
			if const_number == 1 then
				GradientsMgr_upvr.AddGradientColor(any_FindCfgByOnlyTag_result1.ColorStr, itemName, false)
			end
			var44.Visible = true
		end
		UIMgr_upvr.SetUIlistSize(ScrollingFrame_upvr)
		_______upvr["价格"].Text = any_FindCfgByOnlyTag_result1.price
		_______upvr["价格"].Sell.Text = any_FindCfgByOnlyTag_result1.oriPrice
		TranslationHelper_upvr.SetText(Parent_upvr.Frame["礼包名"], any_FindCfgByOnlyTag_result1.ZhName)
		table.insert(tbl_upvr_2, AddListen_upvr.AddMouseCLick(_______upvr.Button, function() -- Line 139
			--[[ Upvalues[4]:
				[1]: Record_upvr (copied, readonly)
				[2]: var36_upvr (readonly)
				[3]: SystemBuyRoblox_upvr (copied, readonly)
				[4]: LocalPlayer_upvr (copied, readonly)
			]]
			local SOME = Record_upvr:FindFirstChild(var36_upvr)
			if SOME and SOME.Value == 0 then
				SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, var36_upvr)
			end
		end, _______upvr, "音效-场景-点击-通用购买"))
	end
end
function module_upvr.updateUi(arg1) -- Line 152
	--[[ Upvalues[1]:
		[1]: UpdateUI_upvr (readonly)
	]]
	UpdateUI_upvr()
end
function module_upvr.openUi(arg1) -- Line 158
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 162
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr