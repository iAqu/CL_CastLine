-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:12
-- Luau version 6, Types version 3
-- Time taken: 0.028054 seconds

local module_5 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players_upvr = game:GetService("Players")
local TeleportService_upvr = game:GetService("TeleportService")
local module_3_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawModule"))
local module_2_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("MathMgr"))
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local CheckGamePass_upvr = require(ReplicatedStorage.Tool.CheckGamePass)
local eggdataConf_upvr = require(ReplicatedStorage:WaitForChild("ConfigInstance")).eggdataConf
local _ = ReplicatedStorage["游戏全局配置"]["群组设置"]
local LocalPlayer_3_upvr = Players_upvr.LocalPlayer
local any_GetIns_result1_upvr = require(ReplicatedStorage.Tool.InsMgr).GetIns("IsAutoHatch", "BoolValue", LocalPlayer_3_upvr)
any_GetIns_result1_upvr.Value = false
local any_WaitBagNumberValue_result1_upvr = GetData_upvr.WaitBagNumberValue(LocalPlayer_3_upvr, EnumMgr_upvr.ItemID.Money)
local IsNewPlayer_upvr = LocalPlayer_3_upvr:WaitForChild("IsNewPlayer", math.huge)
local Legendary_upvr = EnumMgr_upvr.Rare.Legendary
local Parent_upvr = script.Parent
local function _() -- Line 55, Named "GetHatchNum"
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: CheckGamePass_upvr (readonly)
	]]
	local LocalPlayer_4 = Players_upvr.LocalPlayer
	local var26
	if CheckGamePass_upvr.IsHasPass(LocalPlayer_4, "Triple-Hatch") then
		var26 += 2
	end
	if CheckGamePass_upvr.IsHasPass(LocalPlayer_4, "Hatch+5") then
		var26 += 4
	end
	return var26
end
local function _() -- Line 69, Named "GetHatchSpd"
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: CheckGamePass_upvr (readonly)
	]]
	if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
		return 0.5
	end
	return 1
end
local function _() -- Line 77, Named "BuyTriple"
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: CheckGamePass_upvr (readonly)
		[3]: SystemBuyRoblox_upvr (readonly)
	]]
	local LocalPlayer_2 = Players_upvr.LocalPlayer
	local var28
	if CheckGamePass_upvr.IsHasPass(LocalPlayer_2, "Triple-Hatch") then
		var28 += 2
	end
	if CheckGamePass_upvr.IsHasPass(LocalPlayer_2, "Hatch+5") then
		var28 += 4
	end
	if 3 <= var28 then
		return true
	end
	var28 = Players_upvr
	var28 = SystemBuyRoblox_upvr.BuyRobloxByOnlyTag
	var28(var28.LocalPlayer, "Triple-Hatch")
	var28 = false
	return var28
end
local function _(arg1, arg2) -- Line 90, Named "RunserviceBind"
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local Scale = Players_upvr.LocalPlayer.PlayerGui:WaitForChild("ScreenGui").UIScale.Scale
	local any_WorldToScreenPoint_result1, any_WorldToScreenPoint_result2 = workspace.CurrentCamera:WorldToScreenPoint(arg2.Position)
	if any_WorldToScreenPoint_result2 then
		arg1.Position = UDim2.new(0, any_WorldToScreenPoint_result1.X / Scale, 0, any_WorldToScreenPoint_result1.Y / Scale)
		arg1.Visible = true
	else
		arg1.Visible = false
	end
end
local function _(arg1, arg2) -- Line 103, Named "GetWeightAfterBuff"
	--[[ Upvalues[1]:
		[1]: GetData_upvr (readonly)
	]]
	return GetData_upvr.GetPetHatchLuck(arg1) * arg2
end
local function GetChance_upvr(arg1, arg2) -- Line 108, Named "GetChance"
	--[[ Upvalues[5]:
		[1]: CfgFind_upvr (readonly)
		[2]: Legendary_upvr (readonly)
		[3]: LocalPlayer_3_upvr (readonly)
		[4]: GetData_upvr (readonly)
		[5]: module_2_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local module = {}
	local var52
	for i, v in pairs(arg1) do
		local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(arg2[i])
		if any_FindCfgByID_result1_4 then
			if Legendary_upvr <= any_FindCfgByID_result1_4.xyd then
				local var54 = GetData_upvr.GetPetHatchLuck(LocalPlayer_3_upvr) * v
				if v < var54 then
				end
				var52 += var54
			end
			if any_FindCfgByID_result1_4.xyd < Legendary_upvr then
				var52 += v
			end
		end
	end
	for i_2, v_2 in pairs(arg1) do
		local any_FindCfgByID_result1_6 = CfgFind_upvr.FindCfgByID(arg2[i_2])
		if any_FindCfgByID_result1_6 then
			if Legendary_upvr <= any_FindCfgByID_result1_6.xyd then
				table.insert(module, module_2_upvr.GetChanceStr(GetData_upvr.GetPetHatchLuck(LocalPlayer_3_upvr) * v_2, var52))
			end
			if any_FindCfgByID_result1_6.xyd < Legendary_upvr then
				table.insert(module, module_2_upvr.GetChanceStr(v_2, var52))
			end
		end
	end
	return module, true
end
local function _() -- Line 154, Named "ShowStopBt"
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local PlayerGui_8 = Players_upvr.LocalPlayer:FindFirstChild("PlayerGui")
	if PlayerGui_8 then
		local UIAnimGui_4 = PlayerGui_8:FindFirstChild("UIAnimGui")
		if UIAnimGui_4 then
			local DrawMaskGui_5 = UIAnimGui_4:FindFirstChild("DrawMaskGui")
			if DrawMaskGui_5 then
				local Stop_2 = DrawMaskGui_5:FindFirstChild("Stop")
				if Stop_2 then
					Stop_2.Visible = true
				end
			end
		end
	end
end
local var70_upvw = 0
local var71_upvw
local tbl_upvw_2 = {}
local tbl_upvw = {}
local function bindClickEvent_upvr(arg1, arg2) -- Line 179, Named "bindClickEvent"
	--[[ Upvalues[6]:
		[1]: Parent_upvr (readonly)
		[2]: AddListen_upvr (readonly)
		[3]: RemoteEvent_upvr (readonly)
		[4]: tbl_upvw (read and write)
		[5]: LocalPlayer_3_upvr (readonly)
		[6]: tbl_upvw_2 (read and write)
	]]
	if arg1 and arg1:FindFirstChild("BtnAutoDelete") then
		table.insert(tbl_upvw, AddListen_upvr.AddMouseCLick(arg1.BtnAutoDelete, function() -- Line 185
			--[[ Upvalues[2]:
				[1]: RemoteEvent_upvr (copied, readonly)
				[2]: arg2 (readonly)
			]]
			RemoteEvent_upvr:FireServer("自动删除", arg2)
		end, arg1))
		local AutoDelete_2 = LocalPlayer_3_upvr:FindFirstChild("AutoDelete")
		if AutoDelete_2 then
			local SOME_8 = AutoDelete_2:FindFirstChild(arg2)
			if SOME_8 then
				table.insert(tbl_upvw_2, AddListen_upvr.NumValueAdd(SOME_8, function(arg1_4) -- Line 194
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					if arg1 then
						local AutoDelete_3 = arg1:FindFirstChild("AutoDelete")
						local var91
						if AutoDelete_3 then
							if arg1_4 ~= 1 then
								var91 = false
							else
								var91 = true
							end
							AutoDelete_3.Visible = var91
						end
					end
				end))
			end
		end
	end
end
local var92_upvw
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local module_4_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("Viewport"))
local function UpdatePetInfo_upvr(arg1) -- Line 209, Named "UpdatePetInfo"
	--[[ Upvalues[16]:
		[1]: Parent_upvr (readonly)
		[2]: var92_upvw (read and write)
		[3]: tbl_upvw_2 (read and write)
		[4]: tbl_upvw (read and write)
		[5]: AddListen_upvr (readonly)
		[6]: LocalData_upvr (readonly)
		[7]: eggdataConf_upvr (readonly)
		[8]: CfgFind_upvr (readonly)
		[9]: EnumMgr_upvr (readonly)
		[10]: var70_upvw (read and write)
		[11]: GradientsMgr_upvr (readonly)
		[12]: TranslationHelper_upvr (readonly)
		[13]: module_4_upvr (readonly)
		[14]: GetChance_upvr (readonly)
		[15]: Legendary_upvr (readonly)
		[16]: bindClickEvent_upvr (readonly)
	]]
	local Content = Parent_upvr:WaitForChild("Frame"):WaitForChild("Content")
	if var92_upvw ~= arg1 then
	end
	for i_3, _ in pairs(tbl_upvw_2) do
		tbl_upvw_2[i_3]:Disconnect()
		tbl_upvw_2[i_3] = nil
	end
	tbl_upvw_2 = {}
	for _, v_4 in pairs(tbl_upvw) do
		AddListen_upvr.RemoveMouseClick(v_4)
	end
	tbl_upvw = {}
	if var92_upvw ~= arg1 then
		var92_upvw = arg1
		for _, v_5 in pairs(Content:GetChildren()) do
			if v_5:IsA("Frame") and v_5.Name ~= "Template" then
				v_5:Destroy()
			end
		end
	end
	local Template = Content:WaitForChild("Template")
	Template.Visible = false
	for i_6, v_6 in pairs(eggdataConf_upvr[arg1].ItemIDVt) do
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(v_6)
		if any_FindCfgByID_result1 and (any_FindCfgByID_result1.xyd ~= EnumMgr_upvr.Rare.Secret or var70_upvw == 0) then
			local var128
			if not Content:FindFirstChild(v_6) then
				var128 = Template:Clone()
				var128.Visible = true
				var128.Name = v_6
			else
				var128 = Content:FindFirstChild(v_6)
			end
			GradientsMgr_upvr.ChangeClolr(var128.Frame, any_FindCfgByID_result1.xyd)
			var128.Parent = Content
			local Frame = var128.Frame
			if any_FindCfgByID_result1.tp == EnumMgr_upvr.ItemType.Hero then
				Frame.ViewportFrame.Visible = true
				TranslationHelper_upvr.SetText(Frame.Rarity, any_FindCfgByID_result1.ZhName)
				Frame.ViewportFrame:ClearAllChildren()
				Frame.ViewportFrame:SetAttribute("itemID", nil)
				module_4_upvr.createViewPort_Pet(Frame.ViewportFrame, v_6)
				GradientsMgr_upvr.ChangeClolr(Frame.BG, any_FindCfgByID_result1.xyd)
				Frame.Unknow.Visible = false
			end
			local GetChance_upvr_result1, GetChance_result2 = GetChance_upvr(eggdataConf_upvr[arg1].ItemWeight, eggdataConf_upvr[arg1].ItemIDVt)
			Frame:WaitForChild("Chance").Text = GetChance_upvr_result1[i_6]
			if any_FindCfgByID_result1.xyd and Legendary_upvr <= any_FindCfgByID_result1.xyd then
				if GetChance_result2 == true then
					Frame.Chance.LuckAdd.Visible = true
				else
					Frame.Chance.LuckAdd.Visible = false
				end
			else
				Frame.Chance.LuckAdd.Visible = false
			end
			if var70_upvw ~= 0 then
				bindClickEvent_upvr(Frame, v_6)
			end
		end
	end
end
local ______ = Parent_upvr.Frame.Buttons["孵化"]
local _____________2 = Parent_upvr.Frame.Buttons["自动孵化"]
local ____________ = Parent_upvr.Frame.Buttons["三倍孵化"]
local function _() -- Line 339, Named "HatchAEgg"
	--[[ Upvalues[8]:
		[1]: var70_upvw (read and write)
		[2]: module_3_upvr (readonly)
		[3]: var71_upvw (read and write)
		[4]: Players_upvr (readonly)
		[5]: CheckGamePass_upvr (readonly)
		[6]: CfgFind_upvr (readonly)
		[7]: SystemBuyRoblox_upvr (readonly)
		[8]: LocalPlayer_3_upvr (readonly)
	]]
	local var138
	if var70_upvw ~= 0 then
		if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
			var138 = 0.5
		else
			var138 = 1
		end
		module_3_upvr:DrawHero(var71_upvw, 1, var138, false)
	else
		local any_FindCfgByEggId_result1_11 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
		if any_FindCfgByEggId_result1_11 then
			local OnlyTag = any_FindCfgByEggId_result1_11.OnlyTag
			if OnlyTag then
				var138 = OnlyTag
				SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, var138)
			end
		end
	end
end
local function _() -- Line 353, Named "Buy3RobuxEgg"
	--[[ Upvalues[4]:
		[1]: CfgFind_upvr (readonly)
		[2]: var71_upvw (read and write)
		[3]: SystemBuyRoblox_upvr (readonly)
		[4]: LocalPlayer_3_upvr (readonly)
	]]
	local any_FindCfgByEggId_result1_7 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
	if any_FindCfgByEggId_result1_7 then
		local OnlyTag_9 = any_FindCfgByEggId_result1_7.OnlyTag
		if OnlyTag_9 then
			SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, OnlyTag_9.."x3")
		end
	end
end
local function _() -- Line 363, Named "Buy10RobuxEgg"
	--[[ Upvalues[4]:
		[1]: CfgFind_upvr (readonly)
		[2]: var71_upvw (read and write)
		[3]: SystemBuyRoblox_upvr (readonly)
		[4]: LocalPlayer_3_upvr (readonly)
	]]
	local any_FindCfgByEggId_result1_10 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
	if any_FindCfgByEggId_result1_10 then
		local OnlyTag_8 = any_FindCfgByEggId_result1_10.OnlyTag
		if OnlyTag_8 then
			SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, OnlyTag_8.."x10")
		end
	end
end
local function SingleHatch_upvr() -- Line 373, Named "SingleHatch"
	--[[ Upvalues[13]:
		[1]: any_GetIns_result1_upvr (readonly)
		[2]: var70_upvw (read and write)
		[3]: module_3_upvr (readonly)
		[4]: var71_upvw (read and write)
		[5]: Players_upvr (readonly)
		[6]: CheckGamePass_upvr (readonly)
		[7]: CfgFind_upvr (readonly)
		[8]: SystemBuyRoblox_upvr (readonly)
		[9]: LocalPlayer_3_upvr (readonly)
		[10]: EnumMgr_upvr (readonly)
		[11]: any_WaitBagNumberValue_result1_upvr (readonly)
		[12]: TipsModule_upvr (readonly)
		[13]: TeleportService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var160 = any_GetIns_result1_upvr
	local var161
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [38] 31. Error Block 10 start (CF ANALYSIS FAILED)
	SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, var160)
	do
		return
	end
	-- KONSTANTERROR: [38] 31. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [45] 37. Error Block 37 start (CF ANALYSIS FAILED)
	local any_FindCfgByID_result1_8 = CfgFind_upvr.FindCfgByID(var71_upvw, EnumMgr_upvr.ItemType.Egg)
	if not any_FindCfgByID_result1_8 then return end
	if any_WaitBagNumberValue_result1_upvr.Value < any_FindCfgByID_result1_8.Price then
		TipsModule_upvr.ErrorTips(LocalPlayer_3_upvr, "金钱不够")
		return
	end
	local PlayerGui_6 = Players_upvr.LocalPlayer:FindFirstChild("PlayerGui")
	if PlayerGui_6 then
		local UIAnimGui_7 = PlayerGui_6:FindFirstChild("UIAnimGui")
		if UIAnimGui_7 then
			var161 = "DrawMaskGui"
			local SOME_3 = UIAnimGui_7:FindFirstChild(var161)
			if SOME_3 then
				local Stop_4 = SOME_3:FindFirstChild("Stop")
				if Stop_4 then
					var161 = true
					Stop_4.Visible = var161
				end
			end
		end
	end
	if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
		var161 = 0.5
	else
		var161 = 1
	end
	module_3_upvr:DrawHero(var71_upvw, 1, var161, true)
	TeleportService_upvr:SetTeleportSetting("hatchingID", var71_upvw)
	-- KONSTANTERROR: [45] 37. Error Block 37 end (CF ANALYSIS FAILED)
end
local function TripleHatch_upvr() -- Line 392, Named "TripleHatch"
	--[[ Upvalues[13]:
		[1]: var70_upvw (read and write)
		[2]: Players_upvr (readonly)
		[3]: CheckGamePass_upvr (readonly)
		[4]: SystemBuyRoblox_upvr (readonly)
		[5]: any_GetIns_result1_upvr (readonly)
		[6]: module_3_upvr (readonly)
		[7]: var71_upvw (read and write)
		[8]: CfgFind_upvr (readonly)
		[9]: EnumMgr_upvr (readonly)
		[10]: any_WaitBagNumberValue_result1_upvr (readonly)
		[11]: TipsModule_upvr (readonly)
		[12]: LocalPlayer_3_upvr (readonly)
		[13]: TeleportService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var175
	if var70_upvw == 0 then
	else
		var175 = Players_upvr
		local LocalPlayer_8 = var175.LocalPlayer
		var175 = 1
		if CheckGamePass_upvr.IsHasPass(LocalPlayer_8, "Triple-Hatch") then
			var175 += 2
		end
		if CheckGamePass_upvr.IsHasPass(LocalPlayer_8, "Hatch+5") then
			var175 += 4
		end
		if 3 <= var175 then
		else
			var175 = Players_upvr
			var175 = SystemBuyRoblox_upvr.BuyRobloxByOnlyTag
			var175(var175.LocalPlayer, "Triple-Hatch")
		end
		if false then
			local var177
			if any_GetIns_result1_upvr.Value == false then
				var177 = Players_upvr
				local LocalPlayer_7 = var177.LocalPlayer
				var177 = 1
				if CheckGamePass_upvr.IsHasPass(LocalPlayer_7, "Triple-Hatch") then
					var177 += 2
				end
				if CheckGamePass_upvr.IsHasPass(LocalPlayer_7, "Hatch+5") then
					var177 += 4
				end
				var175 = var177
				var177 = Players_upvr.LocalPlayer
				if CheckGamePass_upvr.IsHasPass(var177, "Fast-Hatch") then
				else
				end
				var177 = false
				module_3_upvr:DrawHero(var71_upvw, var175, 1, var177)
				return
			end
			var175 = EnumMgr_upvr.ItemType
			local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(var71_upvw, var175.Egg)
			if not any_FindCfgByID_result1_2 then return end
			var175 = any_WaitBagNumberValue_result1_upvr
			if var175.Value < any_FindCfgByID_result1_2.Price then
				var175 = "金钱不够"
				TipsModule_upvr.ErrorTips(LocalPlayer_3_upvr, var175)
				return
			end
			var175 = "PlayerGui"
			local SOME_4 = Players_upvr.LocalPlayer:FindFirstChild(var175)
			if SOME_4 then
				if SOME_4:FindFirstChild("UIAnimGui") then
					var177 = "DrawMaskGui"
					var175 = SOME_4:FindFirstChild("UIAnimGui"):FindFirstChild(var177)
					if var175 then
						local Stop_5 = var175:FindFirstChild("Stop")
						if Stop_5 then
							var177 = true
							Stop_5.Visible = var177
						end
					end
				end
			end
			var175 = var71_upvw
			local LocalPlayer_10 = Players_upvr.LocalPlayer
			if CheckGamePass_upvr.IsHasPass(LocalPlayer_10, "Triple-Hatch") then
			end
			if CheckGamePass_upvr.IsHasPass(LocalPlayer_10, "Hatch+5") then
			end
			if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
			else
			end
			module_3_upvr:DrawHero(var175, 1 + 2 + 4, 1, true)
			var175 = "hatchingID"
			TeleportService_upvr:SetTeleportSetting(var175, var71_upvw)
		end
	end
end
local function _() -- Line 418, Named "StartHatch"
	--[[ Upvalues[4]:
		[1]: CheckGamePass_upvr (readonly)
		[2]: LocalPlayer_3_upvr (readonly)
		[3]: TripleHatch_upvr (readonly)
		[4]: SingleHatch_upvr (readonly)
	]]
	if CheckGamePass_upvr.IsHasPass(LocalPlayer_3_upvr, "Triple-Hatch") then
		TripleHatch_upvr()
	else
		SingleHatch_upvr()
	end
end
AddListen_upvr.AddMouseCLick(______.Button, function() -- Line 428
	--[[ Upvalues[1]:
		[1]: SingleHatch_upvr (readonly)
	]]
	SingleHatch_upvr()
end, ______.Frame)
AddListen_upvr.AddMouseCLick(_____________2.Button, function() -- Line 432
	--[[ Upvalues[7]:
		[1]: var70_upvw (read and write)
		[2]: any_GetIns_result1_upvr (readonly)
		[3]: CheckGamePass_upvr (readonly)
		[4]: LocalPlayer_3_upvr (readonly)
		[5]: TripleHatch_upvr (readonly)
		[6]: SingleHatch_upvr (readonly)
		[7]: module_3_upvr (readonly)
	]]
	if var70_upvw == 0 then
	else
		if any_GetIns_result1_upvr.Value == false then
			any_GetIns_result1_upvr.Value = true
			if CheckGamePass_upvr.IsHasPass(LocalPlayer_3_upvr, "Triple-Hatch") then
				TripleHatch_upvr()
			else
				SingleHatch_upvr()
			end
		end
		any_GetIns_result1_upvr.Value = false
		module_3_upvr.StopContinueDraw()
	end
end, _____________2.Frame)
function module_5.TeleHatch(arg1) -- Line 448
	--[[ Upvalues[4]:
		[1]: eggdataConf_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: module_3_upvr (readonly)
		[4]: CheckGamePass_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var191
	if eggdataConf_upvr[arg1].cost == 0 then
	else
		local PlayerGui_3 = Players_upvr.LocalPlayer:FindFirstChild("PlayerGui")
		if PlayerGui_3 then
			local UIAnimGui_2 = PlayerGui_3:FindFirstChild("UIAnimGui")
			if UIAnimGui_2 then
				local DrawMaskGui_3 = UIAnimGui_2:FindFirstChild("DrawMaskGui")
				if DrawMaskGui_3 then
					var191 = "Stop"
					local SOME_2 = DrawMaskGui_3:FindFirstChild(var191)
					if SOME_2 then
						SOME_2.Visible = true
					end
				end
			end
		end
		var191 = Players_upvr
		local LocalPlayer_5 = var191.LocalPlayer
		var191 = 1
		if CheckGamePass_upvr.IsHasPass(LocalPlayer_5, "Triple-Hatch") then
			var191 += 2
		end
		if CheckGamePass_upvr.IsHasPass(LocalPlayer_5, "Hatch+5") then
			var191 += 4
		end
		var191 = Players_upvr.LocalPlayer
		if CheckGamePass_upvr.IsHasPass(var191, "Fast-Hatch") then
		else
		end
		var191 = true
		module_3_upvr:DrawHero(arg1, var191, 1, var191)
	end
end
AddListen_upvr.AddMouseCLick(____________.Button, function() -- Line 457
	--[[ Upvalues[1]:
		[1]: TripleHatch_upvr (readonly)
	]]
	TripleHatch_upvr()
end, ____________.Frame)
game:GetService("UserInputService").InputBegan:Connect(function(arg1) -- Line 462
	--[[ Upvalues[9]:
		[1]: Parent_upvr (readonly)
		[2]: var70_upvw (read and write)
		[3]: module_3_upvr (readonly)
		[4]: var71_upvw (read and write)
		[5]: Players_upvr (readonly)
		[6]: CheckGamePass_upvr (readonly)
		[7]: CfgFind_upvr (readonly)
		[8]: SystemBuyRoblox_upvr (readonly)
		[9]: LocalPlayer_3_upvr (readonly)
	]]
	if Parent_upvr.Visible and arg1.KeyCode == Enum.KeyCode.E then
		local var206
		if var70_upvw ~= 0 then
			if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
				var206 = 0.5
			else
				var206 = 1
			end
			module_3_upvr:DrawHero(var71_upvw, 1, var206, false)
		else
			local any_FindCfgByEggId_result1_4 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
			if any_FindCfgByEggId_result1_4 then
				local OnlyTag_4 = any_FindCfgByEggId_result1_4.OnlyTag
				if OnlyTag_4 then
					var206 = OnlyTag_4
					SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, var206)
				end
			end
		end
	end
	if Parent_upvr.Visible and arg1.KeyCode == Enum.KeyCode.T and var70_upvw == 0 then
	else
		if Parent_upvr.Visible and arg1.KeyCode == Enum.KeyCode.R then
			if var70_upvw == 0 then
				local any_FindCfgByEggId_result1_3 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
				if any_FindCfgByEggId_result1_3 then
					local OnlyTag_3 = any_FindCfgByEggId_result1_3.OnlyTag
					if OnlyTag_3 then
						var206 = OnlyTag_3.."x3"
						SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, var206)
					end
				end
				return
			end
			if CheckGamePass_upvr.IsHasPass(Players_upvr.LocalPlayer, "Fast-Hatch") then
				var206 = 0.5
			else
				var206 = 1
			end
			module_3_upvr:DrawHero(var71_upvw, 3, var206, false)
		end
		if Parent_upvr.Visible and arg1.KeyCode == Enum.KeyCode.Y and var70_upvw == 0 then
			local any_FindCfgByEggId_result1_2 = CfgFind_upvr.FindCfgByEggId(var71_upvw)
			if any_FindCfgByEggId_result1_2 then
				local OnlyTag_2 = any_FindCfgByEggId_result1_2.OnlyTag
				if OnlyTag_2 then
					var206 = OnlyTag_2.."x10"
					SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_3_upvr, var206)
				end
			end
			return
		end
	end
end)
local function _(arg1) -- Line 490, Named "updateUiInfo"
	--[[ Upvalues[5]:
		[1]: var71_upvw (read and write)
		[2]: Parent_upvr (readonly)
		[3]: var70_upvw (read and write)
		[4]: eggdataConf_upvr (readonly)
		[5]: module_2_upvr (readonly)
	]]
	var71_upvw = arg1
	local Label_2 = Parent_upvr.Frame["奖杯"].Label
	var70_upvw = eggdataConf_upvr[arg1].cost
	Parent_upvr.Frame.Buttons.Visible = true
	Label_2.Visible = true
	Label_2.Text = module_2_upvr.getNumStr(eggdataConf_upvr[arg1].Price)
end
function module_5.updateUi(arg1, arg2) -- Line 508
	--[[ Upvalues[6]:
		[1]: var71_upvw (read and write)
		[2]: Parent_upvr (readonly)
		[3]: var70_upvw (read and write)
		[4]: eggdataConf_upvr (readonly)
		[5]: module_2_upvr (readonly)
		[6]: UpdatePetInfo_upvr (readonly)
	]]
	var71_upvw = arg2
	local Label = Parent_upvr.Frame["奖杯"].Label
	var70_upvw = eggdataConf_upvr[arg2].cost
	Parent_upvr.Frame.Buttons.Visible = true
	Label.Visible = true
	Label.Text = module_2_upvr.getNumStr(eggdataConf_upvr[arg2].Price)
	UpdatePetInfo_upvr(arg2)
end
function module_5.openUi(arg1) -- Line 513
	--[[ Upvalues[3]:
		[1]: UIMgr_upvr (readonly)
		[2]: IsNewPlayer_upvr (readonly)
		[3]: RemoteEvent_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible()
	if IsNewPlayer_upvr then
		if IsNewPlayer_upvr.Value == true then
			RemoteEvent_upvr:FireServer("开启引导", "宠物引导")
		end
	end
end
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("UIanima"))
function module_5.closeUi(arg1) -- Line 521
	--[[ Upvalues[4]:
		[1]: UIMgr_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: IsNewPlayer_upvr (readonly)
		[4]: RemoteEvent_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible()
	module_upvr.PopBack(script.Parent)
	if IsNewPlayer_upvr.Value == true then
		RemoteEvent_upvr:FireServer("完成引导", "宠物引导")
	end
end
return module_5