-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:18
-- Luau version 6, Types version 3
-- Time taken: 0.011159 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local HumanModule_upvr = require(ReplicatedStorage.Tool.HumanModule)
local Debris_upvr = game:GetService("Debris")
local LocalPlayer_upvr = game.Players.LocalPlayer
local tbl_upvr_2 = {}
local tbl_upvr = {}
local function _(arg1) -- Line 36, Named "CheckMovePos"
	local var9 = arg1 + Vector3.new(0, 3, 0)
	local RaycastParams_new_result1 = RaycastParams.new()
	RaycastParams_new_result1.IgnoreWater = true
	RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Include
	local tbl = {}
	local ______ = workspace["场景"]
	if ______ then
		table.insert(tbl, ______)
	end
	RaycastParams_new_result1.FilterDescendantsInstances = tbl
	local workspace_Raycast_result1 = workspace:Raycast(var9, Vector3.new(0, -100, 0), RaycastParams_new_result1)
	if workspace_Raycast_result1 then
		return workspace_Raycast_result1.Position
	end
	return var9
end
local function _(arg1) -- Line 58, Named "getPetFolder"
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	return InsMgr_upvr.GetIns(arg1.UserId, "Folder", workspace["玩家随从"])
end
local function DestoryPet_upvr(arg1) -- Line 63, Named "DestoryPet"
	--[[ Upvalues[3]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
		[3]: Debris_upvr (readonly)
	]]
	if tbl_upvr[arg1] then
		for i, _ in pairs(tbl_upvr[arg1]) do
			tbl_upvr[arg1][i]:Disconnect()
			tbl_upvr[arg1][i] = nil
		end
		tbl_upvr[arg1] = nil
	end
	if tbl_upvr_2[arg1] then
		tbl_upvr_2[arg1]:Disconnect()
		tbl_upvr_2[arg1] = nil
	end
	Debris_upvr:AddItem(arg1, 0)
end
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local ModelUtil_upvr = require(ReplicatedStorage.Tool.ModelUtil)
local ParticleUtil_upvr = require(ReplicatedStorage.Tool.ParticleUtil)
local _____________upvr = ReplicatedStorage.ModelRes["宠物骨架"]
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local 宠物动画_upvr = require(ReplicatedStorage.Tool["宠物动画"])
local function showPet_upvr(arg1, arg2, arg3, arg4) -- Line 85, Named "showPet"
	--[[ Upvalues[14]:
		[1]: HumanModule_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: DestoryPet_upvr (readonly)
		[4]: CfgFind_upvr (readonly)
		[5]: EnumMgr_upvr (readonly)
		[6]: Viewport_upvr (readonly)
		[7]: ModelUtil_upvr (readonly)
		[8]: ParticleUtil_upvr (readonly)
		[9]: _____________upvr (readonly)
		[10]: tbl_upvr_2 (readonly)
		[11]: VisibleMgr_upvr (readonly)
		[12]: tbl_upvr (readonly)
		[13]: AddListen_upvr (readonly)
		[14]: 宠物动画_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_GetCharacter_result1_4 = HumanModule_upvr.GetCharacter(arg1)
	if not any_GetCharacter_result1_4 then
	else
		local any_GetIns_result1_3 = InsMgr_upvr.GetIns(arg1.UserId, "Folder", workspace["玩家随从"])
		local SOME = any_GetIns_result1_3:FindFirstChild(tostring(arg3))
		if SOME then
			if arg2 == nil then
				DestoryPet_upvr(SOME)
				return
			end
			local OwnerObj_2 = SOME:FindFirstChild("OwnerObj")
			if not OwnerObj_2 or not OwnerObj_2.Value or OwnerObj_2.Value.Parent == nil then
				DestoryPet_upvr(SOME)
				return
			end
			if tonumber(SOME:GetAttribute("ID")) ~= tonumber(arg2) then
				DestoryPet_upvr(SOME)
				return
			end
			if tonumber(SOME:GetAttribute("ID")) == tonumber(arg2) then
				return SOME
			end
		end
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg2, EnumMgr_upvr.ItemType.Hero)
		if any_FindCfgByID_result1 and any_FindCfgByID_result1.Model then
			local any_getPetModel_result1 = Viewport_upvr.getPetModel(arg2)
			if any_getPetModel_result1 then
				local var74
				if any_FindCfgByID_result1.Size and tonumber(any_FindCfgByID_result1.Size) then
					var74 = tonumber(any_FindCfgByID_result1.Size) * 0.01
				end
				if var74 ~= 1 then
					any_getPetModel_result1 = ModelUtil_upvr.ResizeModel(any_getPetModel_result1, var74)
					for _, v_6 in pairs(any_getPetModel_result1:GetDescendants()) do
						if v_6:IsA("ParticleEmitter") then
							ParticleUtil_upvr.ReSizeParticleAll(v_6, var74)
						end
					end
				end
				local clone_upvr_2 = _____________upvr:Clone()
				clone_upvr_2.PrimaryPart.Size = any_getPetModel_result1.PrimaryPart.Size
				clone_upvr_2.Body.Size = any_getPetModel_result1.PrimaryPart.Size
				clone_upvr_2:PivotTo(any_getPetModel_result1:GetPivot())
				local Motor6D_2 = Instance.new("Motor6D", clone_upvr_2.Body)
				Motor6D_2.Part0 = any_getPetModel_result1.PrimaryPart
				Motor6D_2.Part1 = clone_upvr_2.Body
				any_getPetModel_result1.Parent = clone_upvr_2
				if any_FindCfgByID_result1.FuseLv == 2 then
					local _ = Viewport_upvr.AddFuseLvAddGoldHighLight(clone_upvr_2)
				elseif any_FindCfgByID_result1.FuseLv == 3 then
				end
				if Viewport_upvr.AddFuseLvAddRainbowHighLight(clone_upvr_2) then
					if tbl_upvr_2[clone_upvr_2] then
						tbl_upvr_2[clone_upvr_2]:Disconnect()
						tbl_upvr_2[clone_upvr_2] = nil
					end
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					tbl_upvr_2[clone_upvr_2] = Viewport_upvr.AddFuseLvAddRainbowHighLight(clone_upvr_2)
				end
				VisibleMgr_upvr.UnAnchoredAll(clone_upvr_2)
				clone_upvr_2.Parent = any_GetIns_result1_3
				clone_upvr_2.Name = arg3
				InsMgr_upvr.GetIns("OwnerObj", "ObjectValue", clone_upvr_2).Value = any_GetCharacter_result1_4
				local any_GetIns_result1_4 = InsMgr_upvr.GetIns("AnimState", "NumberValue", clone_upvr_2)
				any_GetIns_result1_4.Value = EnumMgr_upvr.HeroState.Idle
				VisibleMgr_upvr.UnTouchAll(clone_upvr_2)
				VisibleMgr_upvr.SetPetMass(clone_upvr_2)
				VisibleMgr_upvr.UnCollideAll(clone_upvr_2)
				VisibleMgr_upvr.SetPetCollideID(clone_upvr_2)
				clone_upvr_2:SetAttribute("ID", arg2)
				clone_upvr_2:SetAttribute("Index", arg3)
				clone_upvr_2:SetAttribute("Size", arg4)
				clone_upvr_2.Body.Transparency = 1
				local any_GetHumanoidRootPart_result1_2 = HumanModule_upvr.GetHumanoidRootPart(arg1)
				if any_GetHumanoidRootPart_result1_2 then
					local SOME_5 = any_GetHumanoidRootPart_result1_2:FindFirstChild("PetAttach"..arg3)
					if clone_upvr_2.PrimaryPart then
						local var84 = clone_upvr_2.PrimaryPart.Size.Y / 2
						SOME_5.Position = Vector3.new(0, var84, 0)
						local Pos = SOME_5:FindFirstChild("Pos")
						if Pos then
							SOME_5.Position += Pos.Value
						end
						SOME_5:SetAttribute("PetHeight", var84)
						clone_upvr_2:PivotTo(SOME_5.WorldCFrame)
						local WeldConstraint_2 = Instance.new("WeldConstraint", clone_upvr_2.PrimaryPart)
						WeldConstraint_2.Part0 = clone_upvr_2.PrimaryPart
						WeldConstraint_2.Part1 = any_GetHumanoidRootPart_result1_2
					end
				end
				local Humanoid_2 = any_GetCharacter_result1_4:FindFirstChild("Humanoid")
				if Humanoid_2 then
					local any_GetIns_result1_5_upvr = InsMgr_upvr.GetIns("当前速度", "NumberValue", arg1)
					if not tbl_upvr[clone_upvr_2] then
						tbl_upvr[clone_upvr_2] = {}
					end
					local EquipmentName_2 = arg1:FindFirstChild("EquipmentName")
					if EquipmentName_2 then
						table.insert(tbl_upvr[clone_upvr_2], EquipmentName_2.Changed:Connect(function(arg1_5) -- Line 241
							--[[ Upvalues[1]:
								[1]: any_GetIns_result1_5_upvr (readonly)
							]]
							if arg1_5 ~= "" then
								any_GetIns_result1_5_upvr.Value = 0
							end
						end))
					end
					table.insert(tbl_upvr[clone_upvr_2], Humanoid_2.Running:Connect(function(arg1_6) -- Line 249
						--[[ Upvalues[1]:
							[1]: any_GetIns_result1_5_upvr (readonly)
						]]
						any_GetIns_result1_5_upvr.Value = arg1_6
					end))
					table.insert(tbl_upvr[clone_upvr_2], AddListen_upvr.NumValueAdd(any_GetIns_result1_4, function(arg1_7) -- Line 253
						--[[ Upvalues[3]:
							[1]: EnumMgr_upvr (copied, readonly)
							[2]: 宠物动画_upvr (copied, readonly)
							[3]: clone_upvr_2 (readonly)
						]]
						if arg1_7 == EnumMgr_upvr.PetState.Idle then
							宠物动画_upvr.PlayIdleAnim(clone_upvr_2)
						end
						if arg1_7 == EnumMgr_upvr.PetState.Running then
							宠物动画_upvr.PlayRunAnim(clone_upvr_2)
						end
					end))
				end
				any_GetIns_result1_5_upvr = clone_upvr_2.PrimaryPart
				return clone_upvr_2
			end
			clone_upvr_2 = "没有这个宠物的模型:"..any_FindCfgByID_result1.Model
			warn(clone_upvr_2)
		end
	end
end
local FindPlayerByID_upvr = require(ReplicatedStorage.Tool.FindPlayerByID)
local ShowOtherPet_upvr = LocalPlayer_upvr:WaitForChild("Setting", math.huge):WaitForChild("ShowOtherPet", math.huge)
local function updateAllPet_upvr(arg1) -- Line 279, Named "updateAllPet"
	--[[ Upvalues[8]:
		[1]: HumanModule_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: FindPlayerByID_upvr (readonly)
		[4]: DestoryPet_upvr (readonly)
		[5]: Debris_upvr (readonly)
		[6]: ShowOtherPet_upvr (readonly)
		[7]: showPet_upvr (readonly)
		[8]: EnumMgr_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 62 start (CF ANALYSIS FAILED)
	local ____________ = workspace["玩家随从"]
	local any_GetCharacter_result1_2 = HumanModule_upvr.GetCharacter(LocalPlayer_upvr)
	if not any_GetCharacter_result1_2 then return end
	for i_2, v_2 in pairs(____________:GetChildren()) do
		local any_getPlayerByID_result1 = FindPlayerByID_upvr.getPlayerByID(tonumber(v_2.Name))
		if not FindPlayerByID_upvr.getPlayerByID(tonumber(v_2.Name)) then
			for _, v_3 in pairs(v_2:GetChildren()) do
				DestoryPet_upvr(v_3)
			end
			Debris_upvr:AddItem(v_2, 0)
		else
			local any_GetCharacter_result1_3 = HumanModule_upvr.GetCharacter(any_getPlayerByID_result1)
			if any_GetCharacter_result1_3 and any_getPlayerByID_result1.UserId ~= LocalPlayer_upvr.UserId and 100 <= LocalPlayer_upvr:DistanceFromCharacter(any_GetCharacter_result1_3:GetPivot().Position) then
				for _, v_4 in pairs(v_2:GetChildren()) do
					DestoryPet_upvr(v_4)
				end
				Debris_upvr:AddItem(v_2, 0)
			end
		end
	end
	if not any_GetCharacter_result1_2 or LocalPlayer_upvr:GetAttribute("Die") == true then
		i_2 = LocalPlayer_upvr
		local SOME_2 = ____________:FindFirstChild(i_2.UserId)
		if SOME_2 then
			local pairs_result1_3, pairs_result2_5, pairs_result3_4 = pairs(SOME_2:GetChildren())
			for _, v_5 in pairs_result1_3, pairs_result2_5, pairs_result3_4 do
				DestoryPet_upvr(v_5)
			end
			pairs_result3_4 = SOME_2
			Debris_upvr:AddItem(pairs_result3_4, 0)
		end
		return
	end
	local pairs_result1_6, pairs_result2_4, pairs_result3 = pairs(game.Players:GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 62 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [291] 211. Error Block 51 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [291] 211. Error Block 51 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [148] 109. Error Block 25 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [148] 109. Error Block 25 end (CF ANALYSIS FAILED)
end
local var125_upvw = 0
game:GetService("RunService").Heartbeat:Connect(function(arg1) -- Line 395
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