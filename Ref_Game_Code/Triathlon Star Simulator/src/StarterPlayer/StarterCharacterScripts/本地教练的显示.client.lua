-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:17
-- Luau version 6, Types version 3
-- Time taken: 0.012978 seconds

local Debris_upvr = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local HumanModule_upvr = require(ReplicatedStorage.Tool.HumanModule)
local LocalPlayer_upvr = game.Players.LocalPlayer
local RunService_upvr = game:GetService("RunService")
local function GetIsShowCoatch_upvr(arg1) -- Line 33, Named "GetIsShowCoatch"
	--[[ Upvalues[1]:
		[1]: EnumMgr_upvr (readonly)
	]]
	if arg1.Character and arg1.Character.PrimaryPart and arg1.Character.PrimaryPart.Position.X < 8.867 then
		return true
	end
	local IsInReadyArea = arg1:FindFirstChild("IsInReadyArea")
	local TrainEquipment = arg1:FindFirstChild("TrainEquipment")
	if IsInReadyArea and TrainEquipment and arg1:FindFirstChild("运动状态") then
		if 0 < TrainEquipment.Value then
			return false
		end
		if IsInReadyArea.Value == true then
			return true
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if arg1:FindFirstChild("运动状态").Value ~= EnumMgr_upvr.AniState.Safe then
			return true
		end
		return false
	end
	return false
end
local tbl_2_upvr = {"你是最棒的!", "再来一个!", "加油加油!", "坚持住!", "你可以做到的!", "不要害怕.这对你很简单!", "你的肌肉是如此的棒!", "动作很完美!"}
local function CheckMovePos_upvr(arg1) -- Line 80, Named "CheckMovePos"
	local var11 = arg1 + Vector3.new(0, 3, 0)
	local RaycastParams_new_result1 = RaycastParams.new()
	RaycastParams_new_result1.IgnoreWater = true
	RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Include
	local tbl = {}
	local ______ = workspace["场景"]
	if ______ then
		table.insert(tbl, ______)
	end
	RaycastParams_new_result1.FilterDescendantsInstances = tbl
	local workspace_Raycast_result1 = workspace:Raycast(var11, Vector3.new(0, -100, 0), RaycastParams_new_result1)
	if workspace_Raycast_result1 then
		return workspace_Raycast_result1.Position
	end
	return var11
end
local function _(arg1) -- Line 102, Named "getPetFolder"
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	return InsMgr_upvr.GetIns(arg1.UserId, "Folder", workspace["玩家教练"])
end
local tbl_upvr = {}
local tbl_upvr_2 = {}
local function _(arg1, arg2) -- Line 111, Named "DestoryPet"
	--[[ Upvalues[3]:
		[1]: tbl_upvr_2 (readonly)
		[2]: tbl_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	if tbl_upvr_2[arg1] then
		tbl_upvr_2[arg1]:Disconnect()
		tbl_upvr_2[arg1] = nil
	end
	if tbl_upvr[arg1] then
		tbl_upvr[arg1]:Disconnect()
		tbl_upvr[arg1] = nil
	end
	Debris_upvr:AddItem(arg2, 0)
end
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local 教练动画_upvr = require(ReplicatedStorage.Tool["教练动画"])
local NowWorld_upvr = LocalPlayer_upvr:WaitForChild("NowWorld", math.huge)
local TranslationHelper_upvr = require(game.ReplicatedStorage.Tool.TranslationHelper)
local function showPet_upvr(arg1, arg2, arg3, arg4) -- Line 124, Named "showPet"
	--[[ Upvalues[18]:
		[1]: HumanModule_upvr (readonly)
		[2]: GetIsShowCoatch_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: tbl_upvr (readonly)
		[6]: Debris_upvr (readonly)
		[7]: CfgFind_upvr (readonly)
		[8]: EnumMgr_upvr (readonly)
		[9]: Viewport_upvr (readonly)
		[10]: VisibleMgr_upvr (readonly)
		[11]: AddListen_upvr (readonly)
		[12]: 教练动画_upvr (readonly)
		[13]: NowWorld_upvr (readonly)
		[14]: CheckMovePos_upvr (readonly)
		[15]: LocalPlayer_upvr (readonly)
		[16]: RunService_upvr (readonly)
		[17]: TranslationHelper_upvr (readonly)
		[18]: tbl_2_upvr (readonly)
	]]
	local any_GetCharacter_result1_upvr_2 = HumanModule_upvr.GetCharacter(arg1)
	if not any_GetCharacter_result1_upvr_2 then
	else
		local var58 = not GetIsShowCoatch_upvr(arg1)
		local any_GetIns_result1 = InsMgr_upvr.GetIns(arg1.UserId, "Folder", workspace["玩家教练"])
		local SOME = any_GetIns_result1:FindFirstChild(tostring(arg3))
		if SOME then
			if not var58 then
				local UserId_7 = arg1.UserId
				if tbl_upvr_2[UserId_7] then
					tbl_upvr_2[UserId_7]:Disconnect()
					tbl_upvr_2[UserId_7] = nil
				end
				if tbl_upvr[UserId_7] then
					tbl_upvr[UserId_7]:Disconnect()
					tbl_upvr[UserId_7] = nil
				end
				Debris_upvr:AddItem(SOME, 0)
				return
			end
			if arg2 == nil then
				local UserId = arg1.UserId
				if tbl_upvr_2[UserId] then
					tbl_upvr_2[UserId]:Disconnect()
					tbl_upvr_2[UserId] = nil
				end
				if tbl_upvr[UserId] then
					tbl_upvr[UserId]:Disconnect()
					tbl_upvr[UserId] = nil
				end
				Debris_upvr:AddItem(SOME, 0)
				return
			end
			local OwnerObj = SOME:FindFirstChild("OwnerObj")
			if not OwnerObj or not OwnerObj.Value or OwnerObj.Value.Parent == nil then
				local UserId_3 = arg1.UserId
				if tbl_upvr_2[UserId_3] then
					tbl_upvr_2[UserId_3]:Disconnect()
					tbl_upvr_2[UserId_3] = nil
				end
				if tbl_upvr[UserId_3] then
					tbl_upvr[UserId_3]:Disconnect()
					tbl_upvr[UserId_3] = nil
				end
				Debris_upvr:AddItem(SOME, 0)
				return
			end
			if tonumber(SOME:GetAttribute("ID")) ~= tonumber(arg2) then
				local UserId_4 = arg1.UserId
				if tbl_upvr_2[UserId_4] then
					tbl_upvr_2[UserId_4]:Disconnect()
					tbl_upvr_2[UserId_4] = nil
				end
				if tbl_upvr[UserId_4] then
					tbl_upvr[UserId_4]:Disconnect()
					tbl_upvr[UserId_4] = nil
				end
				Debris_upvr:AddItem(SOME, 0)
				return
			end
			if tonumber(SOME:GetAttribute("ID")) == tonumber(arg2) then
				return SOME
			end
		end
		if not var58 then return end
		local EquipmentName_2 = arg1:FindFirstChild("EquipmentName")
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg2, EnumMgr_upvr.ItemType.Coach)
		if any_FindCfgByID_result1 and any_FindCfgByID_result1.Model and EquipmentName_2 then
			local any_getCoachModel_result1_upvr_2 = Viewport_upvr.getCoachModel(arg2)
			if any_getCoachModel_result1_upvr_2 then
				any_getCoachModel_result1_upvr_2.Parent = any_GetIns_result1
				any_getCoachModel_result1_upvr_2.Name = arg3
				InsMgr_upvr.GetIns("OwnerObj", "ObjectValue", any_getCoachModel_result1_upvr_2).Value = any_GetCharacter_result1_upvr_2
				local any_GetIns_result1_6 = InsMgr_upvr.GetIns("AnimState", "NumberValue", any_getCoachModel_result1_upvr_2)
				any_GetIns_result1_6.Value = EnumMgr_upvr.HeroState.Idle
				VisibleMgr_upvr.UnAnchoredAll(any_getCoachModel_result1_upvr_2)
				VisibleMgr_upvr.UnTouchAll(any_getCoachModel_result1_upvr_2)
				VisibleMgr_upvr.SetPetMass(any_getCoachModel_result1_upvr_2)
				VisibleMgr_upvr.UnCollideAll(any_getCoachModel_result1_upvr_2)
				VisibleMgr_upvr.SetPetCollideID(any_getCoachModel_result1_upvr_2)
				any_getCoachModel_result1_upvr_2:SetAttribute("ID", arg2)
				any_getCoachModel_result1_upvr_2:SetAttribute("Index", arg3)
				any_getCoachModel_result1_upvr_2:SetAttribute("Size", arg4)
				any_getCoachModel_result1_upvr_2.PrimaryPart.Anchored = true
				local any_GetHumanoidRootPart_result1_upvr = HumanModule_upvr.GetHumanoidRootPart(arg1)
				if any_GetHumanoidRootPart_result1_upvr then
					local SOME_6 = any_GetHumanoidRootPart_result1_upvr:FindFirstChild("CoachAttach"..arg3)
					if SOME_6 and any_getCoachModel_result1_upvr_2.PrimaryPart then
						local var72 = any_getCoachModel_result1_upvr_2.PrimaryPart.Size.Y / 2
						if any_getCoachModel_result1_upvr_2:FindFirstChildOfClass("Humanoid") then
							var72 += any_getCoachModel_result1_upvr_2:FindFirstChildOfClass("Humanoid").HipHeight
						end
						local var73 = Vector3.new(0, 0, 0)
						local Pos = SOME_6:FindFirstChild("Pos")
						if Pos then
							var73 += Pos.Value
						end
						SOME_6.Position = var73 + Vector3.new(0, var72, 0)
						SOME_6:SetAttribute("PetHeight", var72)
						any_getCoachModel_result1_upvr_2:PivotTo(SOME_6.WorldCFrame)
					end
				end
				local Humanoid_2 = any_GetCharacter_result1_upvr_2:FindFirstChild("Humanoid")
				if Humanoid_2 then
					local any_GetIns_result1_3_upvr = InsMgr_upvr.GetIns("当前速度", "NumberValue", arg1)
					Humanoid_2.Running:Connect(function(arg1_7) -- Line 240
						--[[ Upvalues[1]:
							[1]: any_GetIns_result1_3_upvr (readonly)
						]]
						any_GetIns_result1_3_upvr.Value = arg1_7
					end)
					AddListen_upvr.NumValueAdd(any_GetIns_result1_6, function(arg1_8) -- Line 244
						--[[ Upvalues[4]:
							[1]: EnumMgr_upvr (copied, readonly)
							[2]: 教练动画_upvr (copied, readonly)
							[3]: any_getCoachModel_result1_upvr_2 (readonly)
							[4]: arg2 (readonly)
						]]
						if arg1_8 == EnumMgr_upvr.CoachState.Idle then
							教练动画_upvr.PlayIdleAnim(any_getCoachModel_result1_upvr_2)
						end
						if arg1_8 == EnumMgr_upvr.CoachState.Walk then
							教练动画_upvr.PlayWalkAnim(any_getCoachModel_result1_upvr_2)
						end
						if arg1_8 == EnumMgr_upvr.CoachState.Running then
							教练动画_upvr.PlayRunAnim(any_getCoachModel_result1_upvr_2)
						end
						if arg1_8 == EnumMgr_upvr.CoachState.Encourage then
							教练动画_upvr.PlayEncourageAnim(any_getCoachModel_result1_upvr_2, arg2)
						end
					end)
				end
				any_GetIns_result1_3_upvr = tbl_upvr_2[arg1.UserId]
				if any_GetIns_result1_3_upvr then
					any_GetIns_result1_3_upvr = tbl_upvr_2[arg1.UserId]:Disconnect
					any_GetIns_result1_3_upvr()
					any_GetIns_result1_3_upvr = tbl_upvr_2
					any_GetIns_result1_3_upvr[arg1.UserId] = nil
				end
				any_GetIns_result1_3_upvr = tbl_upvr[arg1.UserId]
				if any_GetIns_result1_3_upvr then
					any_GetIns_result1_3_upvr = tbl_upvr[arg1.UserId]:Disconnect
					any_GetIns_result1_3_upvr()
					any_GetIns_result1_3_upvr = tbl_upvr
					any_GetIns_result1_3_upvr[arg1.UserId] = nil
				end
				function any_GetIns_result1_3_upvr(arg1_9) -- Line 276, Named "GoToTrain"
					--[[ Upvalues[14]:
						[1]: any_GetIns_result1_7_upvr (readonly)
						[2]: EnumMgr_upvr (copied, readonly)
						[3]: tbl_upvr_2 (copied, readonly)
						[4]: arg1 (readonly)
						[5]: any_GetCharacter_result1_upvr_2 (readonly)
						[6]: any_getCoachModel_result1_upvr_2 (readonly)
						[7]: class_Humanoid_upvr (readonly)
						[8]: NowWorld_upvr (copied, readonly)
						[9]: CheckMovePos_upvr (copied, readonly)
						[10]: any_GetHumanoidRootPart_result1_upvr (readonly)
						[11]: LocalPlayer_upvr (copied, readonly)
						[12]: RunService_upvr (copied, readonly)
						[13]: TranslationHelper_upvr (copied, readonly)
						[14]: tbl_2_upvr (copied, readonly)
					]]
					-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [16] 12. Error Block 3 start (CF ANALYSIS FAILED)
					tbl_upvr_2[arg1.UserId]:Disconnect()
					tbl_upvr_2[arg1.UserId] = nil
					do
						return
					end
					-- KONSTANTERROR: [16] 12. Error Block 3 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [31] 24. Error Block 21 start (CF ANALYSIS FAILED)
					any_GetIns_result1_7_upvr.Value = EnumMgr_upvr.CoachState.Encourage
					local _ = any_GetCharacter_result1_upvr_2:GetPivot():ToWorldSpace(CFrame.new(4, 5, -5))
					if class_Humanoid_upvr then
					end
					local SOME_5 = workspace["场景"][tostring(NowWorld_upvr.Value)]["训练器械"]:FindFirstChild(arg1_9)
					if SOME_5 then
						local pos_2 = SOME_5:FindFirstChild("pos")
						if pos_2 then
							local var85 = (SOME_5:GetPivot().Rotation) + (CheckMovePos_upvr(pos_2.Value:ToWorldSpace(CFrame.new(6, 5, -3)).Position) + Vector3.new(0, any_getCoachModel_result1_upvr_2.PrimaryPart.Size.Y / 2 + class_Humanoid_upvr.HipHeight, 0))
							-- KONSTANTWARNING: GOTO [140] #104
						end
					else
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					end
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					any_getCoachModel_result1_upvr_2:PivotTo(CFrame.lookAt(((var85.Rotation) + (CheckMovePos_upvr(var85.Position) + Vector3.new(0, any_getCoachModel_result1_upvr_2.PrimaryPart.Size.Y / 2 + class_Humanoid_upvr.HipHeight, 0))).Position, Vector3.new(any_GetHumanoidRootPart_result1_upvr.Position.X, ((var85.Rotation) + (CheckMovePos_upvr(var85.Position) + Vector3.new(0, any_getCoachModel_result1_upvr_2.PrimaryPart.Size.Y / 2 + class_Humanoid_upvr.HipHeight, 0))).Position.Y, any_GetHumanoidRootPart_result1_upvr.Position.Z)))
					if arg1.UserId == LocalPlayer_upvr.UserId then
						local var87_upvw = 20
						tbl_upvr_2[arg1.UserId] = RunService_upvr.Heartbeat:Connect(function(arg1_10) -- Line 327
							--[[ Upvalues[4]:
								[1]: var87_upvw (read and write)
								[2]: any_getCoachModel_result1_upvr_2 (copied, readonly)
								[3]: TranslationHelper_upvr (copied, readonly)
								[4]: tbl_2_upvr (copied, readonly)
							]]
							local var88
							if 20 <= var88 then
								var88 = any_getCoachModel_result1_upvr_2:FindFirstChild("Chat")
								if not var88 then
									var88 = any_getCoachModel_result1_upvr_2:FindFirstChild("Head")
								end
								if var88 then
									game.Chat:Chat(var88, TranslationHelper_upvr.translateByKey(tbl_2_upvr[math.random(1, #tbl_2_upvr)]), Enum.ChatColor.Blue)
								end
								var87_upvw = 0
							end
							var87_upvw += arg1_10
						end)
					end
					-- KONSTANTERROR: [31] 24. Error Block 21 end (CF ANALYSIS FAILED)
				end
				local any_GetIns_result1_7_upvr = InsMgr_upvr.GetIns("宠物状态", "NumberValue", any_getCoachModel_result1_upvr_2)
				local class_Humanoid_upvr = any_getCoachModel_result1_upvr_2:FindFirstChildOfClass("Humanoid")
				local var79_upvr = any_GetIns_result1_3_upvr
				var79_upvr(EquipmentName_2.Value)
				tbl_upvr[arg1.UserId] = EquipmentName_2.Changed:Connect(function(arg1_11) -- Line 354
					--[[ Upvalues[1]:
						[1]: var79_upvr (readonly)
					]]
					var79_upvr(arg1_11)
				end)
				return any_getCoachModel_result1_upvr_2
			end
			any_GetIns_result1_7_upvr = "没有这个宠物的模型:"
			warn(any_GetIns_result1_7_upvr..any_FindCfgByID_result1.Model)
		end
	end
end
local FindPlayerByID_upvr = require(ReplicatedStorage.Tool.FindPlayerByID)
local ShowOtherCoach_upvr = LocalPlayer_upvr:WaitForChild("Setting", math.huge):WaitForChild("ShowOtherCoach", math.huge)
local PetMove_upvr = require(ReplicatedStorage.Tool.PetMove)
local function updateAllPet_upvr(arg1) -- Line 371, Named "updateAllPet"
	--[[ Upvalues[11]:
		[1]: HumanModule_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: FindPlayerByID_upvr (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: tbl_upvr (readonly)
		[6]: Debris_upvr (readonly)
		[7]: ShowOtherCoach_upvr (readonly)
		[8]: showPet_upvr (readonly)
		[9]: EnumMgr_upvr (readonly)
		[10]: CheckMovePos_upvr (readonly)
		[11]: PetMove_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 97 start (CF ANALYSIS FAILED)
	local ____________ = workspace["玩家教练"]
	local any_GetCharacter_result1 = HumanModule_upvr.GetCharacter(LocalPlayer_upvr)
	if not any_GetCharacter_result1 then return end
	for i, v in pairs(____________:GetChildren()) do
		local any_getPlayerByID_result1 = FindPlayerByID_upvr.getPlayerByID(tonumber(v.Name))
		if not FindPlayerByID_upvr.getPlayerByID(tonumber(v.Name)) then
			for _, v_2 in pairs(v:GetChildren()) do
				local tonumber_result1 = tonumber(v.Name)
				if tbl_upvr_2[tonumber_result1] then
					tbl_upvr_2[tonumber_result1]:Disconnect()
					tbl_upvr_2[tonumber_result1] = nil
				end
				if tbl_upvr[tonumber_result1] then
					tbl_upvr[tonumber_result1]:Disconnect()
					tbl_upvr[tonumber_result1] = nil
				end
				Debris_upvr:AddItem(v_2, 0)
			end
			Debris_upvr:AddItem(v, 0)
		else
			local any_GetCharacter_result1_2 = HumanModule_upvr.GetCharacter(any_getPlayerByID_result1)
			if any_GetCharacter_result1_2 and any_getPlayerByID_result1.UserId ~= LocalPlayer_upvr.UserId and 1000 <= LocalPlayer_upvr:DistanceFromCharacter(any_GetCharacter_result1_2:GetPivot().Position) then
				for _, v_3 in pairs(v:GetChildren()) do
					local UserId_2 = any_getPlayerByID_result1.UserId
					if tbl_upvr_2[UserId_2] then
						tbl_upvr_2[UserId_2]:Disconnect()
						tbl_upvr_2[UserId_2] = nil
					end
					if tbl_upvr[UserId_2] then
						tbl_upvr[UserId_2]:Disconnect()
						tbl_upvr[UserId_2] = nil
					end
					Debris_upvr:AddItem(v_3, 0)
				end
				Debris_upvr:AddItem(v, 0)
			end
		end
	end
	if not any_GetCharacter_result1 or LocalPlayer_upvr:GetAttribute("Die") == true then
		i = LocalPlayer_upvr
		local SOME_2 = ____________:FindFirstChild(i.UserId)
		if SOME_2 then
			local pairs_result1_2, pairs_result2_3, pairs_result3_2 = pairs(SOME_2:GetChildren())
			for _, v_4 in pairs_result1_2, pairs_result2_3, pairs_result3_2 do
				local UserId_8 = LocalPlayer_upvr.UserId
				if tbl_upvr_2[UserId_8] then
					tbl_upvr_2[UserId_8]:Disconnect()
					tbl_upvr_2[UserId_8] = nil
				end
				if tbl_upvr[UserId_8] then
					tbl_upvr[UserId_8]:Disconnect()
					tbl_upvr[UserId_8] = nil
				end
				Debris_upvr:AddItem(v_4, 0)
			end
			pairs_result3_2 = SOME_2
			Debris_upvr:AddItem(pairs_result3_2)
		end
		return
	end
	local pairs_result1_4, pairs_result2_2, pairs_result3 = pairs(game.Players:GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 97 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [476] 354. Error Block 75 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [476] 354. Error Block 75 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [233] 181. Error Block 37 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [233] 181. Error Block 37 end (CF ANALYSIS FAILED)
end
local var125_upvw = 0
RunService_upvr.Heartbeat:Connect(function(arg1) -- Line 523
	--[[ Upvalues[2]:
		[1]: var125_upvw (read and write)
		[2]: updateAllPet_upvr (readonly)
	]]
	var125_upvw += arg1
	if 0.1 <= var125_upvw then
		var125_upvw = 0
	end
	updateAllPet_upvr(arg1)
end)