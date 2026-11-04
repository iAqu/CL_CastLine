-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:51
-- Luau version 6, Types version 3
-- Time taken: 0.024077 seconds

local module = {}
local RunService_upvr = game:GetService("RunService")
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Debris_upvr = game:GetService("Debris")
local UserInputService_upvr = game:GetService("UserInputService")
local ParticleUtil_upvr = require(game.ReplicatedStorage.Tool.ParticleUtil)
local SpecialParticle_upvr = require(ReplicatedStorage_upvr.Tool.SpecialParticle)
local Easing_upvr = require(ReplicatedStorage_upvr.Tool.Easing)
local AnimationModule_upvr = require(ReplicatedStorage_upvr.Tool.AnimationModule)
local InsMgr_upvr = require(ReplicatedStorage_upvr.Tool.InsMgr)
local VisibleMgr_upvr = require(ReplicatedStorage_upvr.Tool.VisibleMgr)
local CfgFind_upvr = require(ReplicatedStorage_upvr.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage_upvr.Tool.EnumMgr)
local ModelFind_upvr = require(ReplicatedStorage_upvr.Tool.ModelFind)
local HideScreenGuiModule_upvr = require(ReplicatedStorage_upvr.Tool.HideScreenGuiModule)
local ShowInfoUI_upvr = require(script.ShowInfoUI)
local Viewport_upvr = require(ReplicatedStorage_upvr.Tool.Viewport)
local ObjectPool_upvr = require(ReplicatedStorage_upvr.Tool.ObjectPool)
local PlaySoundModule_upvr = require(ReplicatedStorage_upvr.Tool.PlaySoundModule)
local any_GetIns_result1_5_upvr = InsMgr_upvr.GetIns("是否正在抽蛋", "BoolValue", game.Players.LocalPlayer)
local Gridient_upvr = ReplicatedStorage_upvr.Gridient
local cframe_upvr = CFrame.new(3, 2, 0)
local IsShiftLockOn_upvr = game.Players.LocalPlayer:WaitForChild("IsShiftLockOn", math.huge)
local CurrentCamera_upvr = workspace.CurrentCamera
local function _() -- Line 46, Named "GetGameraPos"
	--[[ Upvalues[3]:
		[1]: IsShiftLockOn_upvr (readonly)
		[2]: CurrentCamera_upvr (readonly)
		[3]: cframe_upvr (readonly)
	]]
	if game:GetService("UserInputService").TouchEnabled then
		if IsShiftLockOn_upvr.Value then
			return CurrentCamera_upvr.CFrame * cframe_upvr
		end
		return CurrentCamera_upvr.CFrame
	end
	return CurrentCamera_upvr.CFrame
end
local function playSoundByXyd_upvr(arg1) -- Line 65, Named "playSoundByXyd"
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr (readonly)
		[2]: PlaySoundModule_upvr (readonly)
	]]
	if arg1 == EnumMgr_upvr.Rare.Normal then
		PlaySoundModule_upvr.playSound({
			SoundName = "抽蛋结果_稀有";
		})
	else
		if arg1 == EnumMgr_upvr.Rare.Rare then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_稀有";
			})
			return
		end
		if arg1 == EnumMgr_upvr.Rare.Epic then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_传说";
			})
			return
		end
		if arg1 == EnumMgr_upvr.Rare.Legendary then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_神秘";
			})
			return
		end
		if arg1 == EnumMgr_upvr.Rare.Mysterious then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_神话";
			})
			return
		end
		if arg1 == EnumMgr_upvr.Rare.Immortal then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_秘密";
			})
			return
		end
		if arg1 == EnumMgr_upvr.Rare.Secret then
			PlaySoundModule_upvr.playSound({
				SoundName = "抽蛋结果_秘密";
			})
		end
	end
end
local ModelUtil_upvr = require(ReplicatedStorage_upvr.Tool.ModelUtil)
local function Hatch_Box_Effect_upvr(arg1, arg2, arg3) -- Line 97, Named "Hatch_Box_Effect"
	--[[ Upvalues[10]:
		[1]: InsMgr_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: ModelUtil_upvr (readonly)
		[4]: ParticleUtil_upvr (readonly)
		[5]: PlaySoundModule_upvr (readonly)
		[6]: Easing_upvr (readonly)
		[7]: IsShiftLockOn_upvr (readonly)
		[8]: CurrentCamera_upvr (readonly)
		[9]: cframe_upvr (readonly)
		[10]: RunService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 135 start (CF ANALYSIS FAILED)
	local var33
	if not arg3 then
	end
	game.Players.LocalPlayer.CameraMinZoomDistance = 30
	local any_GetIns_result1_2 = InsMgr_upvr.GetIns("Hatch_DepthOfFieldEffect", "DepthOfFieldEffect", game.Lighting)
	any_GetIns_result1_2.Enabled = false
	any_GetIns_result1_2.InFocusRadius = 6
	any_GetIns_result1_2.FocusDistance = 1
	any_GetIns_result1_2.FarIntensity = 0
	local var35 = 1
	var33 = 0
	-- KONSTANTERROR: [0] 1. Error Block 135 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [187] 129. Error Block 219 start (CF ANALYSIS FAILED)
	if var35 == 5 then
		var33 = 3
	else
		var33 = 0
	end
	if var35 == 2 then
	elseif var35 == 3 then
	elseif var35 == 4 then
	elseif var35 == 5 then
	else
	end
	;({})[var35] = 0.PrimaryPart
	;({})[var35] = CFrame.new(var33, 0, 0) * CFrame.Angles(0, math.pi, 0)
	-- KONSTANTERROR: [187] 129. Error Block 219 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [66] 45. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [228.4197284]
	-- KONSTANTERROR: [66] 45. Error Block 4 end (CF ANALYSIS FAILED)
end
local function Show_Reward_Effect_upvr(arg1, arg2, arg3) -- Line 350, Named "Show_Reward_Effect"
	--[[ Upvalues[16]:
		[1]: InsMgr_upvr (readonly)
		[2]: ParticleUtil_upvr (readonly)
		[3]: IsShiftLockOn_upvr (readonly)
		[4]: CurrentCamera_upvr (readonly)
		[5]: cframe_upvr (readonly)
		[6]: VisibleMgr_upvr (readonly)
		[7]: ObjectPool_upvr (readonly)
		[8]: Gridient_upvr (readonly)
		[9]: EnumMgr_upvr (readonly)
		[10]: SpecialParticle_upvr (readonly)
		[11]: Easing_upvr (readonly)
		[12]: RunService_upvr (readonly)
		[13]: Debris_upvr (readonly)
		[14]: UserInputService_upvr (readonly)
		[15]: AnimationModule_upvr (readonly)
		[16]: playSoundByXyd_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 140 start (CF ANALYSIS FAILED)
	if not arg2 then
	end
	local any_GetIns_result1 = InsMgr_upvr.GetIns("Hatch_DepthOfFieldEffect", "DepthOfFieldEffect", game.Lighting)
	any_GetIns_result1.Enabled = false
	any_GetIns_result1.FarIntensity = 1
	game.Players.LocalPlayer.CameraMinZoomDistance = 30
	for _, v in pairs(arg1) do
		if 1 < v:GetAttribute("xyd") then
		end
	end
	local ipairs_result1_3, ipairs_result2_3, ipairs_result3 = ipairs(arg1)
	-- KONSTANTERROR: [0] 1. Error Block 140 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 55. Error Block 10 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 55. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [67] 46. Error Block 198 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [79.2147483650]
	if v:GetAttribute("xyd") == v:GetAttribute("xyd") then
		-- KONSTANTWARNING: GOTO [86] #59
	end
	-- KONSTANTERROR: [67] 46. Error Block 198 end (CF ANALYSIS FAILED)
end
local var48_upvw = 0
local any_GetIns_result1_3_upvr = InsMgr_upvr.GetIns("是否正在展示物品", "BoolValue", game.Players.LocalPlayer)
local function Show_NewWeapon_Reward_Effect_upvr(arg1, arg2) -- Line 670, Named "Show_NewWeapon_Reward_Effect"
	--[[ Upvalues[13]:
		[1]: var48_upvw (read and write)
		[2]: any_GetIns_result1_3_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
		[4]: IsShiftLockOn_upvr (readonly)
		[5]: CurrentCamera_upvr (readonly)
		[6]: cframe_upvr (readonly)
		[7]: VisibleMgr_upvr (readonly)
		[8]: Easing_upvr (readonly)
		[9]: RunService_upvr (readonly)
		[10]: Debris_upvr (readonly)
		[11]: UserInputService_upvr (readonly)
		[12]: AnimationModule_upvr (readonly)
		[13]: playSoundByXyd_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 102 start (CF ANALYSIS FAILED)
	var48_upvw += 1
	any_GetIns_result1_3_upvr.Value = true
	local var54
	if not arg2 then
	end
	var54 = game.Lighting
	local any_GetIns_result1_6 = InsMgr_upvr.GetIns("Hatch_DepthOfFieldEffect", "DepthOfFieldEffect", var54)
	any_GetIns_result1_6.Enabled = false
	any_GetIns_result1_6.FarIntensity = 1
	var54 = game
	var54.Players.LocalPlayer.CameraMinZoomDistance = 30
	var54 = game
	var54 = 1
	for _, v_2 in pairs(arg1) do
		if var54 < v_2:GetAttribute("xyd") then
			var54 = v_2:GetAttribute("xyd")
		end
	end
	local ipairs_result1, ipairs_result2_2, ipairs_result3_2 = ipairs(arg1)
	-- KONSTANTERROR: [0] 1. Error Block 102 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [94] 69. Error Block 10 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [94] 69. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [82] 60. Error Block 143 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [94.2147483650]
	if v_2:GetAttribute("xyd") == var54 then
		-- KONSTANTWARNING: GOTO [101] #73
	end
	-- KONSTANTERROR: [82] 60. Error Block 143 end (CF ANALYSIS FAILED)
end
local Players_upvr = game:GetService("Players")
local function Show_Item_Effect_upvr(arg1, arg2, arg3) -- Line 969, Named "Show_Item_Effect"
	--[[ Upvalues[16]:
		[1]: InsMgr_upvr (readonly)
		[2]: ParticleUtil_upvr (readonly)
		[3]: IsShiftLockOn_upvr (readonly)
		[4]: CurrentCamera_upvr (readonly)
		[5]: cframe_upvr (readonly)
		[6]: VisibleMgr_upvr (readonly)
		[7]: ObjectPool_upvr (readonly)
		[8]: Gridient_upvr (readonly)
		[9]: SpecialParticle_upvr (readonly)
		[10]: PlaySoundModule_upvr (readonly)
		[11]: Easing_upvr (readonly)
		[12]: Players_upvr (readonly)
		[13]: RunService_upvr (readonly)
		[14]: Debris_upvr (readonly)
		[15]: UserInputService_upvr (readonly)
		[16]: AnimationModule_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 128 start (CF ANALYSIS FAILED)
	if not arg2 then
	end
	local any_GetIns_result1_4 = InsMgr_upvr.GetIns("Hatch_DepthOfFieldEffect", "DepthOfFieldEffect", game.Lighting)
	any_GetIns_result1_4.Enabled = false
	any_GetIns_result1_4.FarIntensity = 1
	for _, v_3 in pairs(arg1) do
		if 1 < v_3:GetAttribute("xyd") then
		end
	end
	local ipairs_result1_2, ipairs_result2, ipairs_result3_3 = ipairs(arg1)
	-- KONSTANTERROR: [0] 1. Error Block 128 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [70] 50. Error Block 10 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [70] 50. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [58] 41. Error Block 177 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [70.2147483650]
	if v_3:GetAttribute("xyd") == v_3:GetAttribute("xyd") then
		-- KONSTANTWARNING: GOTO [77] #54
	end
	-- KONSTANTERROR: [58] 41. Error Block 177 end (CF ANALYSIS FAILED)
end
function module.ShowHatchEffect(arg1, arg2, arg3, arg4) -- Line 1304
	--[[ Upvalues[11]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
		[5]: HideScreenGuiModule_upvr (readonly)
		[6]: PlaySoundModule_upvr (readonly)
		[7]: any_GetIns_result1_5_upvr (readonly)
		[8]: Hatch_Box_Effect_upvr (readonly)
		[9]: Viewport_upvr (readonly)
		[10]: ShowInfoUI_upvr (readonly)
		[11]: Show_Reward_Effect_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var98
	local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(arg1, EnumMgr_upvr.ItemType.Egg)
	if any_FindCfgByID_result1_4 then
		var98 = ReplicatedStorage_upvr.ModelRes.Egg[any_FindCfgByID_result1_4.Model]:Clone()
	else
		var98 = ReplicatedStorage_upvr.ModelRes.Egg["宠物蛋1"]:Clone()
	end
	if not var98 then
		warn("缺少宝箱模型")
	end
	VisibleMgr_upvr.DisableParticle(var98)
	VisibleMgr_upvr.CloseShade(var98)
	HideScreenGuiModule_upvr.HideScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 0.3, 1)
	any_GetIns_result1_5_upvr.Value = true
	Hatch_Box_Effect_upvr(var98, 1, arg3)
	local tbl = {}
	for _, v_4 in pairs(arg2) do
		local any_FindCfgByID_result1_15 = CfgFind_upvr.FindCfgByID(v_4, EnumMgr_upvr.ItemType.Hero)
		local var105
		if any_FindCfgByID_result1_15 and any_FindCfgByID_result1_15.Model then
			var105 = Viewport_upvr.getPetModel(v_4)
			if any_FindCfgByID_result1_15.FuseLv == 2 then
				table.insert(tbl, Viewport_upvr.AddFuseLvAddGoldHighLight(var105))
			elseif any_FindCfgByID_result1_15.FuseLv == 3 then
				table.insert(tbl, Viewport_upvr.AddFuseLvAddRainbowHighLight(var105))
			end
		end
		if not var105 then
			warn(v_4, "缺少模型")
		else
			VisibleMgr_upvr.DisableTrail(var105)
			VisibleMgr_upvr.AnchoredAll(var105)
			VisibleMgr_upvr.UnCollideAll(var105)
			VisibleMgr_upvr.UnTouchAll(var105)
			VisibleMgr_upvr.UnQueryAll(var105)
			var105:SetAttribute("xyd", any_FindCfgByID_result1_15.xyd)
			var105:SetAttribute("idle", any_FindCfgByID_result1_15.NormalIdleName)
			table.insert({}, var105)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_5, v_5 in pairs({}) do
		local _ = {arg2[i_5]}
		ShowInfoUI_upvr.ShowUI(arg3, 1)
		Show_Reward_Effect_upvr({v_5}, arg3, arg4)
		ShowInfoUI_upvr.HideUI(arg3, 1)
		task.wait(0.6)
	end
	for i_6, _ in pairs(tbl) do
		tbl[i_6]:Disconnect()
		tbl[i_6] = nil
		local _
	end
	task.wait(0.6)
	any_GetIns_result1_5_upvr.Value = false
	HideScreenGuiModule_upvr.ShowScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 1, 1)
end
function module.ShowHatchEffect_3X(arg1, arg2, arg3, arg4) -- Line 1425
	--[[ Upvalues[10]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: any_GetIns_result1_5_upvr (readonly)
		[5]: VisibleMgr_upvr (readonly)
		[6]: HideScreenGuiModule_upvr (readonly)
		[7]: Hatch_Box_Effect_upvr (readonly)
		[8]: Viewport_upvr (readonly)
		[9]: ShowInfoUI_upvr (readonly)
		[10]: Show_Reward_Effect_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var131
	local any_FindCfgByID_result1_5 = CfgFind_upvr.FindCfgByID(arg1, EnumMgr_upvr.ItemType.Egg)
	if any_FindCfgByID_result1_5 then
		var131 = ReplicatedStorage_upvr.ModelRes.Egg[any_FindCfgByID_result1_5.Model]:Clone()
	else
		var131 = ReplicatedStorage_upvr.ModelRes.Egg["宠物蛋1"]:Clone()
	end
	if not var131 then
		warn("缺少宝箱模型")
	else
		any_GetIns_result1_5_upvr.Value = true
		local clamped_2 = math.clamp(#arg2, 1, 3)
		VisibleMgr_upvr.DisableParticle(var131)
		VisibleMgr_upvr.CloseShade(var131)
		HideScreenGuiModule_upvr.HideScreenGui()
		HideScreenGuiModule_upvr.UpdateBlurVisible()
		Hatch_Box_Effect_upvr(var131, clamped_2, arg3)
		local tbl_2 = {}
		table.sort(arg2, function(arg1_2, arg2_2) -- Line 1462
			--[[ Upvalues[2]:
				[1]: CfgFind_upvr (copied, readonly)
				[2]: EnumMgr_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local any_FindCfgByID_result1_12 = CfgFind_upvr.FindCfgByID(arg1_2)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [41] 27. Error Block 13 start (CF ANALYSIS FAILED)
			if CfgFind_upvr.FindCfgByID(arg2_2).FuseLv <= any_FindCfgByID_result1_12.FuseLv then
				return true
			end
			do
				return false
			end
			do
				return
			end
			-- KONSTANTERROR: [41] 27. Error Block 13 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [52] 35. Error Block 10 start (CF ANALYSIS FAILED)
			do
				return true
			end
			-- KONSTANTERROR: [52] 35. Error Block 10 end (CF ANALYSIS FAILED)
		end)
		for _, v_14 in pairs(arg2) do
			local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(v_14)
			local var141
			if any_FindCfgByID_result1 and any_FindCfgByID_result1.Model then
				var141 = Viewport_upvr.getPetModel(v_14)
				if any_FindCfgByID_result1.FuseLv == 2 then
					table.insert(tbl_2, Viewport_upvr.AddFuseLvAddGoldHighLight(var141))
				elseif any_FindCfgByID_result1.FuseLv == 3 then
					table.insert(tbl_2, Viewport_upvr.AddFuseLvAddRainbowHighLight(var141))
				end
			end
			if not var141 then
				warn(v_14, "缺少模型")
			else
				if 1 < any_FindCfgByID_result1.xyd then
				end
				if any_FindCfgByID_result1.FuseLv and 1 < any_FindCfgByID_result1.FuseLv then
				end
				VisibleMgr_upvr.DisableTrail(var141)
				VisibleMgr_upvr.AnchoredAll(var141)
				var141:SetAttribute("xyd", any_FindCfgByID_result1.xyd)
				var141:SetAttribute("fuseLv", any_FindCfgByID_result1.FuseLv)
				table.insert({}, var141)
			end
		end
		ShowInfoUI_upvr.ShowUI(arg3, clamped_2)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		Show_Reward_Effect_upvr({}, arg3, arg4)
		ShowInfoUI_upvr.HideUI(arg3, clamped_2)
		for i_16, _ in pairs(tbl_2) do
			tbl_2[i_16]:Disconnect()
			tbl_2[i_16] = nil
			local _
		end
		task.wait(0.6)
		any_GetIns_result1_5_upvr.Value = false
		HideScreenGuiModule_upvr.ShowScreenGui()
	end
end
function module.ShowHatchEffect_5X(arg1, arg2, arg3, arg4) -- Line 1550
	--[[ Upvalues[10]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: any_GetIns_result1_5_upvr (readonly)
		[5]: VisibleMgr_upvr (readonly)
		[6]: HideScreenGuiModule_upvr (readonly)
		[7]: Hatch_Box_Effect_upvr (readonly)
		[8]: Viewport_upvr (readonly)
		[9]: ShowInfoUI_upvr (readonly)
		[10]: Show_Reward_Effect_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var166
	for i_7 = 1, #arg2, var166 do
		if 5 < i_7 then
			arg2[i_7] = nil
		end
	end
	var166 = CfgFind_upvr
	var166 = arg1
	var166 = nil
	local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(arg1, EnumMgr_upvr.ItemType.Egg)
	if any_FindCfgByID_result1_3 then
		var166 = ReplicatedStorage_upvr.ModelRes.Egg[any_FindCfgByID_result1_3.Model]:Clone()
	else
		var166 = ReplicatedStorage_upvr.ModelRes.Egg["宠物蛋1"]:Clone()
	end
	if not var166 then
		warn("缺少宝箱模型")
	else
		any_GetIns_result1_5_upvr.Value = true
		local clamped = math.clamp(#arg2, 1, 5)
		VisibleMgr_upvr.DisableParticle(var166)
		VisibleMgr_upvr.CloseShade(var166)
		HideScreenGuiModule_upvr.HideScreenGui()
		HideScreenGuiModule_upvr.UpdateBlurVisible()
		Hatch_Box_Effect_upvr(var166, clamped, arg3)
		local tbl_3 = {}
		table.sort(arg2, function(arg1_3, arg2_3) -- Line 1592
			--[[ Upvalues[2]:
				[1]: CfgFind_upvr (copied, readonly)
				[2]: EnumMgr_upvr (copied, readonly)
			]]
			local any_FindCfgByID_result1_9 = CfgFind_upvr.FindCfgByID(arg1_3)
			local any_FindCfgByID_result1_8 = CfgFind_upvr.FindCfgByID(arg2_3)
			local var173
			if not any_FindCfgByID_result1_9 or not any_FindCfgByID_result1_8 then
				var173 = false
				return var173
			end
			var173 = any_FindCfgByID_result1_9.tp
			if var173 == EnumMgr_upvr.ItemType.Hero then
				var173 = any_FindCfgByID_result1_9.xyd
				if var173 ~= any_FindCfgByID_result1_8.xyd then
					if any_FindCfgByID_result1_8.xyd >= any_FindCfgByID_result1_9.xyd then
						var173 = false
					else
						var173 = true
					end
					return var173
				end
				if any_FindCfgByID_result1_8.FuseLv >= any_FindCfgByID_result1_9.FuseLv then
					var173 = false
				else
					var173 = true
				end
				return var173
			end
			if any_FindCfgByID_result1_9.tp == EnumMgr_upvr.ItemType.Hero then
			else
			end
			return true
		end)
		for _, v_16 in pairs(arg2) do
			local any_FindCfgByID_result1_7 = CfgFind_upvr.FindCfgByID(v_16)
			local var178
			if any_FindCfgByID_result1_7 and any_FindCfgByID_result1_7.Model then
				var178 = Viewport_upvr.getPetModel(v_16)
				if any_FindCfgByID_result1_7.FuseLv == 2 then
					table.insert(tbl_3, Viewport_upvr.AddFuseLvAddGoldHighLight(var178))
				elseif any_FindCfgByID_result1_7.FuseLv == 3 then
					table.insert(tbl_3, Viewport_upvr.AddFuseLvAddRainbowHighLight(var178))
				end
			end
			if not var178 then
				warn(v_16, "缺少模型")
			else
				if 1 < any_FindCfgByID_result1_7.xyd then
				end
				if any_FindCfgByID_result1_7.FuseLv and 1 < any_FindCfgByID_result1_7.FuseLv then
				end
				VisibleMgr_upvr.DisableTrail(var178)
				VisibleMgr_upvr.AnchoredAll(var178)
				var178:SetAttribute("xyd", any_FindCfgByID_result1_7.xyd)
				var178:SetAttribute("fuseLv", any_FindCfgByID_result1_7.FuseLv)
				table.insert({}, var178)
			end
		end
		ShowInfoUI_upvr.ShowUI(arg3, clamped)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		Show_Reward_Effect_upvr({}, arg3, arg4)
		ShowInfoUI_upvr.HideUI(arg3, clamped)
		for i_18, _ in pairs(tbl_3) do
			tbl_3[i_18]:Disconnect()
			tbl_3[i_18] = nil
			local _
		end
		task.wait(0.6)
		any_GetIns_result1_5_upvr.Value = false
		HideScreenGuiModule_upvr.ShowScreenGui()
	end
end
function module.ShowItemEffect(arg1, arg2) -- Line 1674
	--[[ Upvalues[8]:
		[1]: PlaySoundModule_upvr (readonly)
		[2]: HideScreenGuiModule_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: ModelFind_upvr (readonly)
		[6]: VisibleMgr_upvr (readonly)
		[7]: ShowInfoUI_upvr (readonly)
		[8]: Show_Reward_Effect_upvr (readonly)
	]]
	if not arg2 then
	end
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 0.3, 1)
	HideScreenGuiModule_upvr.HideScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	for _, v_7 in pairs(arg1) do
		local any_FindCfgByID_result1_14 = CfgFind_upvr.FindCfgByID(v_7)
		local var191
		if any_FindCfgByID_result1_14 and any_FindCfgByID_result1_14.Model then
			if any_FindCfgByID_result1_14.tp == EnumMgr_upvr.ItemType.Hero then
				var191 = ModelFind_upvr.GetModelCloneByModelName(any_FindCfgByID_result1_14.Model, EnumMgr_upvr.ModelType.Hero)
			end
			if any_FindCfgByID_result1_14.tp == EnumMgr_upvr.ItemType.Weapon then
				var191 = ModelFind_upvr.GetModelCloneByModelName(any_FindCfgByID_result1_14.Model, EnumMgr_upvr.ModelType.Weapon)
			end
		end
		if not var191 then
			warn(v_7, "缺少模型")
		else
			VisibleMgr_upvr.DisableTrail(var191)
			VisibleMgr_upvr.AnchoredAll(var191)
			VisibleMgr_upvr.UnCollideAll(var191)
			VisibleMgr_upvr.UnQueryAll(var191)
			VisibleMgr_upvr.UnTouchAll(var191)
			local _ = {v_7}
			ShowInfoUI_upvr.ShowUI(1, 1)
			var191:SetAttribute("xyd", any_FindCfgByID_result1_14.xyd)
			Show_Reward_Effect_upvr({var191}, 1, false)
			ShowInfoUI_upvr.HideUI(1, 1)
			task.wait(0.6)
		end
	end
	HideScreenGuiModule_upvr.ShowScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 1, 1)
end
function module.ShowItemEffect_NewWeapon(arg1) -- Line 1734
	--[[ Upvalues[8]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: ModelFind_upvr (readonly)
		[4]: PlaySoundModule_upvr (readonly)
		[5]: HideScreenGuiModule_upvr (readonly)
		[6]: VisibleMgr_upvr (readonly)
		[7]: ShowInfoUI_upvr (readonly)
		[8]: Show_NewWeapon_Reward_Effect_upvr (readonly)
	]]
	for _, v_8 in pairs(arg1) do
		local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(tonumber(v_8))
		local var202
		if any_FindCfgByID_result1_2 and any_FindCfgByID_result1_2.Model then
			if any_FindCfgByID_result1_2.tp == EnumMgr_upvr.ItemType.Hero then
				var202 = ModelFind_upvr.GetModelCloneByModelName(any_FindCfgByID_result1_2.Model, EnumMgr_upvr.ModelType.Hero)
			end
			if any_FindCfgByID_result1_2.tp == EnumMgr_upvr.ItemType.Weapon then
				var202 = ModelFind_upvr.GetModelCloneByModelName(any_FindCfgByID_result1_2.Model, EnumMgr_upvr.ModelType.Weapon)
			end
		end
		if not var202 then
			warn(v_8, "缺少模型")
		else
			PlaySoundModule_upvr.setSoundGroupVolume("BGM", 0.3, 1)
			HideScreenGuiModule_upvr.HideScreenGui()
			HideScreenGuiModule_upvr.UpdateBlurVisible()
			VisibleMgr_upvr.DisableTrail(var202)
			VisibleMgr_upvr.AnchoredAll(var202)
			VisibleMgr_upvr.UnCollideAll(var202)
			VisibleMgr_upvr.UnQueryAll(var202)
			VisibleMgr_upvr.UnTouchAll(var202)
			local _ = {v_8}
			ShowInfoUI_upvr.ShowUI(1, 1)
			var202:SetAttribute("xyd", any_FindCfgByID_result1_2.xyd)
			if Show_NewWeapon_Reward_Effect_upvr({var202}, 1) == true then
				ShowInfoUI_upvr.HideUI(1, 1)
			end
			task.wait(0.6)
			HideScreenGuiModule_upvr.ShowScreenGui()
			HideScreenGuiModule_upvr.UpdateBlurVisible()
			PlaySoundModule_upvr.setSoundGroupVolume("BGM", 1, 1)
		end
	end
end
function module.ShowGetItemEffect(arg1) -- Line 1795
	--[[ Upvalues[9]:
		[1]: PlaySoundModule_upvr (readonly)
		[2]: HideScreenGuiModule_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: ModelFind_upvr (readonly)
		[6]: ReplicatedStorage_upvr (readonly)
		[7]: VisibleMgr_upvr (readonly)
		[8]: ShowInfoUI_upvr (readonly)
		[9]: Show_Item_Effect_upvr (readonly)
	]]
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 0.3, 1)
	HideScreenGuiModule_upvr.HideScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	for _, v_9 in pairs(arg1) do
		local any_FindCfgByID_result1_13 = CfgFind_upvr.FindCfgByID(v_9)
		local var224
		if any_FindCfgByID_result1_13 and any_FindCfgByID_result1_13.Model then
			if any_FindCfgByID_result1_13.tp == EnumMgr_upvr.ItemType.Hero then
				var224 = ModelFind_upvr.GetModelCloneByModelName(any_FindCfgByID_result1_13.Model, EnumMgr_upvr.ModelType.Hero)
			end
			if any_FindCfgByID_result1_13.tp == EnumMgr_upvr.ItemType.Item then
				var224 = ReplicatedStorage_upvr.ModelRes:FindFirstChild(any_FindCfgByID_result1_13.Model)
				if var224 then
					var224 = var224:Clone()
				end
			end
		end
		if not var224 then
			warn(v_9, "缺少模型")
		else
			VisibleMgr_upvr.DisableProximityPrompt(var224)
			VisibleMgr_upvr.DisableTrail(var224)
			VisibleMgr_upvr.AnchoredAll(var224)
			local _ = {v_9}
			ShowInfoUI_upvr.ShowUI(1, 1)
			if not any_FindCfgByID_result1_13.xyd then
				var224:SetAttribute("xyd", EnumMgr_upvr.Rare.Legendary)
			else
				var224:SetAttribute("xyd", tonumber(any_FindCfgByID_result1_13.xyd))
			end
			Show_Item_Effect_upvr({var224}, 1)
			ShowInfoUI_upvr.HideUI(1, 1)
			task.wait(0.6)
		end
	end
	HideScreenGuiModule_upvr.ShowScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	PlaySoundModule_upvr.setSoundGroupVolume("BGM", 1, 1)
end
function module.ShowHatchEffect_Tool(arg1) -- Line 1859
	--[[ Upvalues[9]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: any_GetIns_result1_5_upvr (readonly)
		[3]: VisibleMgr_upvr (readonly)
		[4]: HideScreenGuiModule_upvr (readonly)
		[5]: Hatch_Box_Effect_upvr (readonly)
		[6]: CfgFind_upvr (readonly)
		[7]: Viewport_upvr (readonly)
		[8]: ShowInfoUI_upvr (readonly)
		[9]: Show_Reward_Effect_upvr (readonly)
	]]
	local clone = ReplicatedStorage_upvr.ModelRes.Egg["装备箱子"]:Clone()
	any_GetIns_result1_5_upvr.Value = true
	VisibleMgr_upvr.DisableParticle(clone)
	VisibleMgr_upvr.CloseShade(clone)
	HideScreenGuiModule_upvr.HideScreenGui()
	HideScreenGuiModule_upvr.UpdateBlurVisible()
	Hatch_Box_Effect_upvr(clone, 1, 1)
	for _, v_10 in pairs(arg1) do
		local any_FindCfgByID_result1_11 = CfgFind_upvr.FindCfgByID(v_10)
		local var240
		if any_FindCfgByID_result1_11 and any_FindCfgByID_result1_11.Model then
			var240 = Viewport_upvr.getToolModel(v_10)
		end
		if not var240 then
			warn(v_10, "缺少模型")
		else
			if 1 < any_FindCfgByID_result1_11.xyd then
			end
			VisibleMgr_upvr.DisableTrail(var240)
			VisibleMgr_upvr.AnchoredAll(var240)
			var240:SetAttribute("xyd", any_FindCfgByID_result1_11.xyd)
			table.insert({}, var240)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_12, v_11 in pairs({}) do
		local _ = {arg1[i_12]}
		ShowInfoUI_upvr.ShowUI(1, 1)
		Show_Reward_Effect_upvr({v_11}, 1, false)
		ShowInfoUI_upvr.HideUI(1, 1)
		task.wait(1)
	end
	any_GetIns_result1_5_upvr.Value = false
	HideScreenGuiModule_upvr.ShowScreenGui()
end
function module.ShowHatchEffect_ToolNoEgg(arg1) -- Line 1931
	--[[ Upvalues[7]:
		[1]: any_GetIns_result1_5_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: Viewport_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
		[5]: ShowInfoUI_upvr (readonly)
		[6]: Show_Reward_Effect_upvr (readonly)
		[7]: HideScreenGuiModule_upvr (readonly)
	]]
	any_GetIns_result1_5_upvr.Value = true
	for _, v_12 in pairs(arg1) do
		local any_FindCfgByID_result1_6 = CfgFind_upvr.FindCfgByID(v_12)
		local var258
		if any_FindCfgByID_result1_6 and any_FindCfgByID_result1_6.Model then
			var258 = Viewport_upvr.getToolModel(v_12)
		end
		if not var258 then
			warn(v_12, "缺少模型")
		else
			if 1 < any_FindCfgByID_result1_6.xyd then
			end
			VisibleMgr_upvr.DisableTrail(var258)
			VisibleMgr_upvr.AnchoredAll(var258)
			var258:SetAttribute("xyd", any_FindCfgByID_result1_6.xyd)
			table.insert({}, var258)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_14, v_13 in pairs({}) do
		local _ = {arg1[i_14]}
		ShowInfoUI_upvr.ShowUI(1, 1)
		Show_Reward_Effect_upvr({v_13}, 1, false)
		ShowInfoUI_upvr.HideUI(1, 1)
		task.wait(1)
	end
	any_GetIns_result1_5_upvr.Value = false
	HideScreenGuiModule_upvr.ShowScreenGui()
end
return module