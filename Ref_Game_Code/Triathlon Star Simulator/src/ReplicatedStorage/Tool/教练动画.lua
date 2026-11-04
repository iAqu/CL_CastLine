-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:07
-- Luau version 6, Types version 3
-- Time taken: 0.003029 seconds

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
local AnimationCoach_upvr = game.ReplicatedStorage.FightSkill.OOP.AnimationCoach
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
function GetAnimationPet(arg1, arg2) -- Line 37
	--[[ Upvalues[3]:
		[1]: AnimationCoach_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 5. Error Block 16 start (CF ANALYSIS FAILED)
	local clone_2 = AnimationCoach_upvr:Clone()
	clone_2.Parent = arg2
	clone_2.Name = "AnimationCoach"
	if arg2:GetAttribute("FriendCoach") then
		local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(arg2:GetAttribute("Buff"), EnumMgr_upvr.ItemType.FriendCoachBuff)
		if any_FindCfgByID_result1_2 then
			({}).EncourageAction = any_FindCfgByID_result1_2.FriendCoachAction
			-- KONSTANTWARNING: GOTO [71] #50
		end
	else
		local ID = arg2:GetAttribute("ID")
		if ID then
			local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(ID, EnumMgr_upvr.ItemType.Coach)
			if any_FindCfgByID_result1_3 and any_FindCfgByID_result1_3.NormalIdleName ~= "" then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				;({}).EncourageAction = any_FindCfgByID_result1_3.EncourageAction
			end
		end
	end
	-- KONSTANTERROR: [6] 5. Error Block 16 end (CF ANALYSIS FAILED)
end
function module.PlayEncourageAnim(arg1, arg2) -- Line 82
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local Humanoid = arg1:FindFirstChild("Humanoid")
	if Humanoid then
		local GetAnimationPet_result1_2 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", Humanoid), arg1)
		GetAnimationPet_result1_2:Play("Encourage")
		GetAnimationPet_result1_2:Stop("Run")
		GetAnimationPet_result1_2:Stop("Walk")
		GetAnimationPet_result1_2:Stop("Idle")
	end
end
function module.PlayIdleAnim(arg1) -- Line 96
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local Humanoid_4 = arg1:FindFirstChild("Humanoid")
	if Humanoid_4 then
		local GetAnimationPet_result1_3 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", Humanoid_4), arg1)
		GetAnimationPet_result1_3:Play("Idle")
		GetAnimationPet_result1_3:Stop("Run")
		GetAnimationPet_result1_3:Stop("Walk")
		GetAnimationPet_result1_3:Stop("Encourage")
	end
end
function module.PlayRunAnim(arg1) -- Line 114
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local Humanoid_2 = arg1:FindFirstChild("Humanoid")
	if Humanoid_2 then
		local GetAnimationPet_result1_4 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", Humanoid_2), arg1)
		GetAnimationPet_result1_4:Play("Run")
		GetAnimationPet_result1_4:Stop("Idle")
		GetAnimationPet_result1_4:Stop("Walk")
		GetAnimationPet_result1_4:Stop("Encourage")
	end
end
function module.PlayWalkAnim(arg1) -- Line 131
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local Humanoid_3 = arg1:FindFirstChild("Humanoid")
	if Humanoid_3 then
		local GetAnimationPet_result1 = GetAnimationPet(InsMgr_upvr.GetIns("Animator", "Animator", Humanoid_3), arg1)
		GetAnimationPet_result1:Play("Walk")
		GetAnimationPet_result1:Stop("Idle")
		GetAnimationPet_result1:Stop("Run")
		GetAnimationPet_result1:Stop("Encourage")
	end
end
return module