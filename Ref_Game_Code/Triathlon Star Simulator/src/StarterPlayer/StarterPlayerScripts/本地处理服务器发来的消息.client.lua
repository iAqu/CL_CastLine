-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:31
-- Luau version 6, Types version 3
-- Time taken: 0.007111 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris_upvr = game:GetService("Debris")
local LocalPlayer_upvr = game.Players.LocalPlayer
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local var5_upvw
local WorldUtil_upvr = require(ReplicatedStorage.Tool.WorldUtil)
local function CheckMovePos_upvr(arg1, arg2) -- Line 38, Named "CheckMovePos"
	--[[ Upvalues[1]:
		[1]: WorldUtil_upvr (readonly)
	]]
	local RaycastParams_new_result1 = RaycastParams.new()
	RaycastParams_new_result1.IgnoreWater = true
	RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Include
	local tbl_2 = {}
	local SOME = workspace["场景"]:FindFirstChild(WorldUtil_upvr.GetCurWorld())
	if SOME then
		table.insert(tbl_2, SOME)
	end
	RaycastParams_new_result1.FilterDescendantsInstances = tbl_2
	if workspace:Raycast(arg1, Vector3.new(0, -arg2, 0), RaycastParams_new_result1) then
		return true
	end
	return false
end
local function clearGuide_upvr() -- Line 60, Named "clearGuide"
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: var5_upvw (read and write)
	]]
	local any_GetIns_result1 = InsMgr_upvr.GetIns("引导线文件夹", "Folder", workspace)
	for _, v in pairs(any_GetIns_result1:GetChildren()) do
		Debris_upvr:AddItem(v, 0)
	end
	if var5_upvw then
		var5_upvw:Disconnect()
		var5_upvw = nil
	end
	return any_GetIns_result1
end
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local EffectUtil_upvr = require(ReplicatedStorage.Tool.EffectUtil)
local SoundModule_upvr = require(ReplicatedStorage.Tool.SoundModule)
local HatchEffect_upvr = require(ReplicatedStorage.Tool.HatchEffect)
local CollectionVFX_upvr = require(ReplicatedStorage.Tool.CollectionVFX)
local HumanModule_upvr = require(ReplicatedStorage.Tool.HumanModule)
local 获取距离_upvr = require(ReplicatedStorage.Tool["获取距离"])
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
local RankUpLocal_upvr = require(ReplicatedStorage.Tool.RankUpLocal)
local _____________upvr = ReplicatedStorage.ModelRes["新手引导"]
local RunService_upvr = game:GetService("RunService")
local var31_upvw = 0
ReplicatedStorage.Msg.RemoteEvent.OnClientEvent:Connect(function(arg1, arg2) -- Line 76
	--[[ Upvalues[20]:
		[1]: CfgFind_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: TipsModule_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
		[5]: EffectUtil_upvr (readonly)
		[6]: SoundModule_upvr (readonly)
		[7]: HatchEffect_upvr (readonly)
		[8]: CollectionVFX_upvr (readonly)
		[9]: HumanModule_upvr (readonly)
		[10]: Debris_upvr (readonly)
		[11]: 获取距离_upvr (readonly)
		[12]: CheckMovePos_upvr (readonly)
		[13]: RemoteFunction_upvr (readonly)
		[14]: SystemBuyRoblox_upvr (readonly)
		[15]: RankUpLocal_upvr (readonly)
		[16]: clearGuide_upvr (readonly)
		[17]: _____________upvr (readonly)
		[18]: var5_upvw (read and write)
		[19]: RunService_upvr (readonly)
		[20]: var31_upvw (read and write)
	]]
	if arg1 == "击杀信息" and arg2 then
		require(script["击杀信息"]).AddKillInfo(arg2[1], arg2[2])
	else
		if arg1 == "本地奖励提示" and arg2 then
			local var50 = ""
			local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg2.ID)
			if any_FindCfgByID_result1 then
				var50 = any_FindCfgByID_result1.ZhName
			end
			TipsModule_upvr.NormalTips(LocalPlayer_upvr, arg2.key, {TranslationHelper_upvr.translateByKey(var50), arg2.Number})
			return
		end
		if arg1 == "玩家传送特效" and arg2 then
			if LocalPlayer_upvr.Character then
				EffectUtil_upvr.PlayEffect("出生特效", arg2, 0.5, 1)
				SoundModule_upvr:PlaySoundLocal("音效-事件-角色及敌人出生", 1, nil, arg2.Position, nil, nil, 3)
			end
			return
		end
		if arg1 == "宝箱受击特效" and arg2 then
			if LocalPlayer_upvr.Character then
				EffectUtil_upvr.PlayEffect("宝箱爆炸", arg2, 0.5, 3)
			end
			return
		end
		if arg1 == "播放获得英雄动画" and arg2 then
			HatchEffect_upvr.ShowItemEffect(arg2, false)
			return
		end
		if arg1 == "播放获得装备动画" and arg2 then
			HatchEffect_upvr.ShowHatchEffect_ToolNoEgg(arg2)
			return
		end
		if arg1 == "播放获取道具动画" then
			CollectionVFX_upvr.PlayerGainCollection(LocalPlayer_upvr)
			return
		end
		if arg1 == "重置摄像头" then
			local CurrentCamera_2 = game.Workspace.CurrentCamera
			local any_GetHumanoidRootPart_result1_6 = HumanModule_upvr.GetHumanoidRootPart(LocalPlayer_upvr)
			if any_GetHumanoidRootPart_result1_6 and CurrentCamera_2 then
				local CFrame_2 = any_GetHumanoidRootPart_result1_6.CFrame
				CurrentCamera_2.CFrame = CFrame.new(CFrame_2.Position - CFrame_2.LookVector * 30 + Vector3.new(0, 20, 0), CFrame_2.Position)
			end
			return
		end
		if arg1 == "传送" and arg2 then
			local pos_2 = arg2.pos
			local iscreatelocalPart = arg2.iscreatelocalPart
			if iscreatelocalPart and iscreatelocalPart == true then
				local Part_upvr = Instance.new("Part", workspace)
				Part_upvr.Size = Vector3.new(6, 1, 6)
				Part_upvr.CFrame = pos_2 + Vector3.new(0, -10.5, 0)
				Part_upvr.Anchored = true
				Part_upvr.Transparency = 1
				delay(10, function() -- Line 163
					--[[ Upvalues[2]:
						[1]: Debris_upvr (copied, readonly)
						[2]: Part_upvr (readonly)
					]]
					Debris_upvr:AddItem(Part_upvr, 0)
				end)
			end
			Part_upvr = HumanModule_upvr
			Part_upvr = LocalPlayer_upvr
			local any_GetCharacter_result1 = Part_upvr.GetCharacter(Part_upvr)
			if any_GetCharacter_result1 then
				Part_upvr = 获取距离_upvr.GetDistance(any_GetCharacter_result1:GetPivot().Position, pos_2.Position)
				if 1000 < Part_upvr then
					any_GetCharacter_result1:PivotTo(pos_2)
				end
			end
			while true do
				Part_upvr = wait(0.5)
				if not Part_upvr then break end
				Part_upvr = CheckMovePos_upvr(pos_2.Position, arg2.rayY)
				if Part_upvr then
					Part_upvr = RemoteFunction_upvr:InvokeServer
					Part_upvr("解除锚固")
					return
				end
			end
			return
		end
		if arg1 == "客户端购买付费项" and arg2 then
			SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, arg2)
			return
		end
		if arg1 == "重生特效" then
			RankUpLocal_upvr.ShowRankUp(arg2)
			return
		end
		if arg1 == "引导线" then
			if not arg2 then
				clearGuide_upvr()
			else
				local clone_upvr = _____________upvr:Clone()
				clone_upvr.Parent = clearGuide_upvr()
				local ZhName = arg2.ZhName
				Part_upvr = arg2.ArriveDel
				clone_upvr:PivotTo(CFrame.new(arg2.Pos))
				local any_GetHumanoidRootPart_result1 = HumanModule_upvr.GetHumanoidRootPart(LocalPlayer_upvr)
				local var64
				if any_GetHumanoidRootPart_result1 and any_GetHumanoidRootPart_result1:FindFirstChild("RootRigAttachment") then
					clone_upvr["引导终点"].Beam.Attachment1 = any_GetHumanoidRootPart_result1:FindFirstChild("RootRigAttachment")
				end
				if var64 == nil then
					var64 = true
				end
				if ZhName then
					clone_upvr.Name = ZhName
				end
				if var64 == true and ZhName == nil then
					var5_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_3) -- Line 232
						--[[ Upvalues[6]:
							[1]: var31_upvw (copied, read and write)
							[2]: HumanModule_upvr (copied, readonly)
							[3]: LocalPlayer_upvr (copied, readonly)
							[4]: 获取距离_upvr (copied, readonly)
							[5]: clone_upvr (readonly)
							[6]: clearGuide_upvr (copied, readonly)
						]]
						var31_upvw += arg1_3
						if 0 < var31_upvw then
							var31_upvw = 0
							local any_GetHumanoidRootPart_result1_4 = HumanModule_upvr.GetHumanoidRootPart(LocalPlayer_upvr)
							local var67
							if any_GetHumanoidRootPart_result1_4 and 获取距离_upvr.GetDistance(any_GetHumanoidRootPart_result1_4.Position, clone_upvr:GetPivot().Position) < 20 then
								var67 = true
							else
								var67 = false
							end
							if var67 then
								clearGuide_upvr()
							end
						end
					end)
				end
			end
		end
	end
end)
InsMgr_upvr.GetIns("本地脚本加载完成", "BoolValue", LocalPlayer_upvr).Value = true