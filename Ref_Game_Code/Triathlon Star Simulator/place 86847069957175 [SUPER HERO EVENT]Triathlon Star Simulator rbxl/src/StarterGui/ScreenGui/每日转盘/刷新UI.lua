-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:03
-- Luau version 6, Types version 3
-- Time taken: 0.006001 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local LocalPlayer_upvr = game.Players.LocalPlayer
local dailylotteryConf_upvr = require(ReplicatedStorage.ConfigInstance).dailylotteryConf
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
local Center_upvr = Parent.Center
local Exit = Parent.Exit
local var21_upvw
local var22_upvw = false
local var23_upvw = 0
for _, v in pairs(dailylotteryConf_upvr) do
	var23_upvw += v.Rate
end
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local function updateAwardUI_upvr() -- Line 50, Named "updateAwardUI"
	--[[ Upvalues[12]:
		[1]: dailylotteryConf_upvr (readonly)
		[2]: Center_upvr (readonly)
		[3]: LocalData_upvr (readonly)
		[4]: CfgFind_upvr (readonly)
		[5]: MathMgr_upvr (readonly)
		[6]: var23_upvw (read and write)
		[7]: EnumMgr_upvr (readonly)
		[8]: UIMgr_upvr (readonly)
		[9]: TranslationHelper_upvr (readonly)
		[10]: Viewport_upvr (readonly)
		[11]: LocalPlayer_upvr (readonly)
		[12]: AddListen_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_2, pairs_result2_2, pairs_result3 = pairs(dailylotteryConf_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [355] 258. Error Block 51 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [355] 258. Error Block 51 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [355.5]
	-- KONSTANTERROR: [5] 5. Error Block 2 end (CF ANALYSIS FAILED)
end
local tbl_8_upvr = {65, 5, -55, -115, -175, -235}
local BtnSpin_upvr = Parent.Frame.BtnFrame.BtnSpin
local var34_upvw
local var35_upvw
local var36_upvw
local HatchEffect_upvr = require(ReplicatedStorage.Tool.HatchEffect)
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
local function ShowGetNew_upvr() -- Line 199, Named "ShowGetNew"
	--[[ Upvalues[13]:
		[1]: PlaySoundModule_upvr (readonly)
		[2]: dailylotteryConf_upvr (readonly)
		[3]: var36_upvw (read and write)
		[4]: var34_upvw (read and write)
		[5]: var35_upvw (read and write)
		[6]: CfgFind_upvr (readonly)
		[7]: EnumMgr_upvr (readonly)
		[8]: HatchEffect_upvr (readonly)
		[9]: showLocalUI_upvr (readonly)
		[10]: MathMgr_upvr (readonly)
		[11]: LocalPlayer_upvr (readonly)
		[12]: TranslationHelper_upvr (readonly)
		[13]: TipsModule_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 25 start (CF ANALYSIS FAILED)
	PlaySoundModule_upvr.playSound({
		SoundName = "音效-场景-点击-通用获得";
	})
	if 0 < dailylotteryConf_upvr[var36_upvw].IsPublicShow then
		if var34_upvw and var35_upvw then
			if CfgFind_upvr.FindCfgByID(var34_upvw).tp == EnumMgr_upvr.ItemType.Hero then
				HatchEffect_upvr.ShowItemEffect({var34_upvw}, false)
			end
			showLocalUI_upvr:Fire("奖励领取弹窗无文字", {
				AwardID = {var34_upvw};
				Count = {var35_upvw};
			})
			-- KONSTANTWARNING: GOTO [142] #103
		end
	else
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(var34_upvw)
		if any_FindCfgByID_result1 and any_FindCfgByID_result1.ZhName then
			local any_getNumStr_result1 = MathMgr_upvr.getNumStr(var35_upvw)
			if var34_upvw == EnumMgr_upvr.ItemID.PowerBag then
				local NoAreaAddExp_2 = LocalPlayer_upvr:FindFirstChild("NoAreaAddExp")
				if NoAreaAddExp_2 then
					any_getNumStr_result1 = MathMgr_upvr.getNumStr(var35_upvw * NoAreaAddExp_2.Value)
				end
			end
			TipsModule_upvr.NormalTips(LocalPlayer_upvr, "获得转盘奖励", {TranslationHelper_upvr.translateByKey(any_FindCfgByID_result1.ZhName), any_getNumStr_result1})
			if any_FindCfgByID_result1.tp == EnumMgr_upvr.ItemType.Hero then
				HatchEffect_upvr.ShowItemEffect({var34_upvw}, false)
			end
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 25 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [142] 103. Error Block 15 start (CF ANALYSIS FAILED)
	var34_upvw = nil
	var35_upvw = nil
	-- KONSTANTERROR: [142] 103. Error Block 15 end (CF ANALYSIS FAILED)
end
local var59_upvw = 0
local Spin_upvr = ReplicatedStorage.ServerMsg.Spin
local TweenService_upvr = game:GetService("TweenService")
local TweenInfo_new_result1_upvr = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
local function StartSPin_upvr() -- Line 250, Named "StartSPin"
	--[[ Upvalues[17]:
		[1]: Spin_upvr (readonly)
		[2]: var34_upvw (read and write)
		[3]: var35_upvw (read and write)
		[4]: var36_upvw (read and write)
		[5]: BtnSpin_upvr (readonly)
		[6]: var22_upvw (read and write)
		[7]: var59_upvw (read and write)
		[8]: tbl_8_upvr (readonly)
		[9]: Center_upvr (readonly)
		[10]: var21_upvw (read and write)
		[11]: TweenService_upvr (readonly)
		[12]: TweenInfo_new_result1_upvr (readonly)
		[13]: ShowGetNew_upvr (readonly)
		[14]: dailylotteryConf_upvr (readonly)
		[15]: LocalData_upvr (readonly)
		[16]: updateAwardUI_upvr (readonly)
		[17]: PlaySoundModule_upvr (readonly)
	]]
	local any_InvokeServer_result1, any_InvokeServer_result2, any_InvokeServer_result3 = Spin_upvr:InvokeServer()
	if not any_InvokeServer_result1 or not any_InvokeServer_result2 or not any_InvokeServer_result3 then
	else
		var34_upvw = any_InvokeServer_result2
		var35_upvw = any_InvokeServer_result3
		var36_upvw = any_InvokeServer_result1
		BtnSpin_upvr.Frame.SpinValue.Visible = false
		BtnSpin_upvr.Frame["转盘跳过"].Visible = true
		var22_upvw = true
		var59_upvw = tbl_8_upvr[var36_upvw]
		var59_upvw += 3600
		Center_upvr.Rotation = 0
		var21_upvw = TweenService_upvr:Create(Center_upvr, TweenInfo_new_result1_upvr, {
			Rotation = var59_upvw;
		})
		var21_upvw.Completed:Connect(function() -- Line 274
			--[[ Upvalues[8]:
				[1]: BtnSpin_upvr (copied, readonly)
				[2]: var22_upvw (copied, read and write)
				[3]: var21_upvw (copied, read and write)
				[4]: ShowGetNew_upvr (copied, readonly)
				[5]: dailylotteryConf_upvr (copied, readonly)
				[6]: var36_upvw (copied, read and write)
				[7]: LocalData_upvr (copied, readonly)
				[8]: updateAwardUI_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			BtnSpin_upvr.Frame.SpinValue.Visible = true
			BtnSpin_upvr.Frame["转盘跳过"].Visible = false
			var22_upvw = false
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [20] 15. Error Block 2 start (CF ANALYSIS FAILED)
			var21_upvw:Destroy()
			var21_upvw = nil
			ShowGetNew_upvr()
			-- KONSTANTERROR: [20] 15. Error Block 2 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [28] 22. Error Block 3 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [28] 22. Error Block 3 end (CF ANALYSIS FAILED)
		end)
		var21_upvw:Play()
		PlaySoundModule_upvr.playSound({
			SoundName = "音效-场景-转盘";
		})
	end
end
local function _() -- Line 324, Named "getLotteryTimes"
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
	]]
	local Bag_2 = LocalPlayer_upvr:FindFirstChild("Bag")
	if not Bag_2 then return end
	local SOME = Bag_2:FindFirstChild(EnumMgr_upvr.ItemID.DailyToken)
	local var71 = SOME
	if var71 then
		var71 = SOME.Value
	end
	return var71
end
local function spinClick_upvr() -- Line 335, Named "spinClick"
	--[[ Upvalues[8]:
		[1]: var21_upvw (read and write)
		[2]: ShowGetNew_upvr (readonly)
		[3]: Center_upvr (readonly)
		[4]: var59_upvw (read and write)
		[5]: LocalPlayer_upvr (readonly)
		[6]: EnumMgr_upvr (readonly)
		[7]: TipsModule_upvr (readonly)
		[8]: StartSPin_upvr (readonly)
	]]
	local var72
	if var72 then
		var72 = var21_upvw:Cancel
		var72()
		var72 = var21_upvw
		if var72 then
			var72 = var21_upvw:Destroy
			var72()
			var72 = nil
			var21_upvw = var72
			var72 = ShowGetNew_upvr
			var72()
		end
		var72 = Center_upvr
		var72.Rotation = var59_upvw
		return
	end
	local Bag = LocalPlayer_upvr:FindFirstChild("Bag")
	if not Bag then
		var72 = nil
	else
		local SOME_2 = Bag:FindFirstChild(EnumMgr_upvr.ItemID.DailyToken)
		var72 = SOME_2
		if var72 then
			var72 = SOME_2.Value
		end
	end
	if not var72 or var72 <= 0 then
		TipsModule_upvr.ErrorTips(LocalPlayer_upvr, "转盘抽取次数不够")
		return
	end
	StartSPin_upvr()
	return true
end
AddListen_upvr.AddMouseCLick(BtnSpin_upvr.Button, function() -- Line 359
	--[[ Upvalues[1]:
		[1]: spinClick_upvr (readonly)
	]]
	spinClick_upvr()
end, BtnSpin_upvr.Frame)
AddListen_upvr.AddMouseCLick(Exit.Button, function() -- Line 363
	--[[ Upvalues[2]:
		[1]: var22_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	if var22_upvw == false then
		module_upvr:closeUi()
	end
end, Exit, "音效-场景-点击-通用返回")
function module_upvr.updateUi(arg1) -- Line 369
end
function module_upvr.openUi(arg1) -- Line 375
	--[[ Upvalues[6]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: var34_upvw (read and write)
		[4]: var35_upvw (read and write)
		[5]: updateAwardUI_upvr (readonly)
		[6]: BtnSpin_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
	ShowDetail_upvr.HideAllDetail()
	var34_upvw = nil
	var35_upvw = nil
	updateAwardUI_upvr()
	BtnSpin_upvr.Frame.SpinValue.Visible = true
	BtnSpin_upvr.Frame["转盘跳过"].Visible = false
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
function module_upvr.closeUi(arg1) -- Line 386
	--[[ Upvalues[4]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: UIanima_upvr (readonly)
		[4]: RemoteEvent_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	ShowDetail_upvr.HideAllDetail()
	UIanima_upvr.PopBack(script.Parent)
	RemoteEvent_upvr:FireServer("取消赠送")
end
return module_upvr