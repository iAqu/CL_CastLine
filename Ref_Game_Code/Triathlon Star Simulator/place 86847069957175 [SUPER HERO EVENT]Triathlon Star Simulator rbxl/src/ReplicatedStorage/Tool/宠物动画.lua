-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:36
-- Luau version 6, Types version 3
-- Time taken: 0.002169 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local Players_upvr = game:GetService("Players")
local AnimationModule_upvr = require(ReplicatedStorage.Tool.AnimationModule)
local function _() -- Line 17, Named "EnemyGetHurtAnim"
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: AnimationModule_upvr (readonly)
	]]
	local AtkTarget = Players_upvr.LocalPlayer:FindFirstChild("AtkTarget")
	if AtkTarget and AtkTarget.Value and AtkTarget.Value:FindFirstChildOfClass("Humanoid") then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		AnimationModule_upvr.PlayAnim(InsMgr_upvr.GetIns("Animator", "Animator", AtkTarget.Value:FindFirstChildOfClass("Humanoid")), "被攻击"..math.random(1, 3).."R6")
	end
end
local AnimationPet_upvr = game.ReplicatedStorage.FightSkill.OOP.AnimationPet
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
function GetAnimationPet(arg1, arg2) -- Line 37
	--[[ Upvalues[3]:
		[1]: AnimationPet_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
	]]
	if arg2:FindFirstChild("AnimationPet") == nil then
		local clone = AnimationPet_upvr:Clone()
		clone.Parent = arg2
		clone.Name = "AnimationPet"
		local clone_3 = require(clone)
		local tbl = {}
		local ID_2 = arg2:GetAttribute("ID")
		if ID_2 then
			local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(ID_2, EnumMgr_upvr.ItemType.Hero)
			if any_FindCfgByID_result1 then
				if any_FindCfgByID_result1.RunAction ~= "" then
					tbl.Running = any_FindCfgByID_result1.RunAction
				end
				if any_FindCfgByID_result1.IdleAction ~= "" then
					if any_FindCfgByID_result1.IdleAction == "宠物飞行" then
						tbl.Idle = "飞行待机"
					end
					if any_FindCfgByID_result1.IdleAction == "宠物行走" then
						tbl.Idle = "行走待机"
					end
				end
			end
		end
		clone_3:Init(arg1, tbl)
		return clone_3
	end
	return require(clone_3)
end
function module.PlayIdleAnim(arg1) -- Line 79
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local class_AnimationController_3 = arg1:FindFirstChildOfClass("AnimationController")
	if class_AnimationController_3 then
		local GetAnimationPet_result1_2 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", class_AnimationController_3), arg1)
		GetAnimationPet_result1_2:Play("Idle")
		GetAnimationPet_result1_2:Stop("Run")
		GetAnimationPet_result1_2:Stop("Walk")
	end
end
function module.PlayRunAnim(arg1) -- Line 96
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local class_AnimationController = arg1:FindFirstChildOfClass("AnimationController")
	if class_AnimationController then
		local GetAnimationPet_result1_3 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", class_AnimationController), arg1)
		GetAnimationPet_result1_3:Play("Run")
		GetAnimationPet_result1_3:Stop("Idle")
		GetAnimationPet_result1_3:Stop("Walk")
	end
end
function module.PlayWalkAnim(arg1) -- Line 112
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local class_AnimationController_2 = arg1:FindFirstChildOfClass("AnimationController")
	if class_AnimationController_2 then
		local GetAnimationPet_result1 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", class_AnimationController_2), arg1)
		GetAnimationPet_result1:Play("Walk")
		GetAnimationPet_result1:Stop("Idle")
		GetAnimationPet_result1:Stop("Run")
	end
end
return module