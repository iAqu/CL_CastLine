-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:09
-- Luau version 6, Types version 3
-- Time taken: 0.001956 seconds

local module_upvr = {}
local Players_upvr = game:GetService("Players")
local UserInputService_upvr = game:GetService("UserInputService")
local RayCast_upvr = require(game:GetService("ReplicatedStorage")["特效表现工具"].RayCast)
function module_upvr.GetReleaserMouseHit(arg1, arg2) -- Line 11
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
		[3]: RayCast_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
	do
		return
	end
	-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 3. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 3. Error Block 3 end (CF ANALYSIS FAILED)
end
function module_upvr.TransCloestEnemyPos(arg1) -- Line 98
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
	]]
	local function INLINED() -- Internal function, doesn't exist in bytecode
		local AutoFight = Players_upvr.LocalPlayer:FindFirstChild("AutoFight")
		return AutoFight
	end
	if arg1 == Players_upvr.LocalPlayer and INLINED() and (UserInputService_upvr.TouchEnabled or UserInputService_upvr.GamepadEnabled or AutoFight.Value == 1) then
		local MostCloseEnemy = Players_upvr.LocalPlayer:FindFirstChild("MostCloseEnemy")
		if MostCloseEnemy and MostCloseEnemy.Value then
			return MostCloseEnemy.Value:GetPivot().Position
		end
	end
end
function module_upvr.GetMouseTargetCF(arg1, arg2) -- Line 121
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: RayCast_upvr (readonly)
	]]
	if not arg2 then
	end
	local Releaser = arg1.Releaser
	local var9
	if Releaser == Players_upvr.LocalPlayer then
		var9 = "RightHand"
		local SOME = arg1.Caster:FindFirstChild(var9)
		if not SOME then return end
		local any_GetPivot_result1 = SOME:GetPivot()
		var9 = module_upvr.GetReleaserMouseHit(Releaser)
		local any_GetReleaserMouseHit_result1, any_GetReleaserMouseHit_result2 = module_upvr.GetReleaserMouseHit(Releaser)
		local any_RayToEnemyIgnoreAirWall_result1 = RayCast_upvr.RayToEnemyIgnoreAirWall(any_GetReleaserMouseHit_result2, (any_GetReleaserMouseHit_result1.Position - any_GetReleaserMouseHit_result2.Position).Unit, 1000)
		if any_RayToEnemyIgnoreAirWall_result1 then
			any_GetReleaserMouseHit_result1 = any_GetReleaserMouseHit_result1.Rotation + any_RayToEnemyIgnoreAirWall_result1.Position
		end
		local any_TransCloestEnemyPos_result1 = module_upvr.TransCloestEnemyPos(Releaser)
		if any_TransCloestEnemyPos_result1 then
			any_GetReleaserMouseHit_result1 = any_GetReleaserMouseHit_result1.Rotation + any_TransCloestEnemyPos_result1
		end
		any_GetReleaserMouseHit_result1 = any_GetReleaserMouseHit_result1.Rotation + any_GetPivot_result1.Position + (any_GetReleaserMouseHit_result1.Position - any_GetPivot_result1.Position).Unit * math.clamp((any_GetReleaserMouseHit_result1.Position - any_GetPivot_result1.Position).Magnitude, 0, 100)
		arg1.MouseTargetCF = any_GetReleaserMouseHit_result1
		return any_GetReleaserMouseHit_result1
	end
	return arg1.MouseTargetCF
end
return module_upvr