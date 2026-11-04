-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:11
-- Luau version 6, Types version 3
-- Time taken: 0.002061 seconds

local module = {}
local 获取玩家操作数据_upvr = require(game.ReplicatedStorage["特效表现工具"]["获取玩家操作数据"])
local RayCast_upvr = require(game.ReplicatedStorage["特效表现工具"].RayCast)
function module.GetAimPosition(arg1, arg2) -- Line 10
	--[[ Upvalues[2]:
		[1]: 获取玩家操作数据_upvr (readonly)
		[2]: RayCast_upvr (readonly)
	]]
	if not arg2 then
		local const_number = 100
	end
	local Releaser_2 = arg1.Releaser
	if Releaser_2 == game.Players.LocalPlayer then
		local any_GetReleaserMouseHit_result1, any_GetReleaserMouseHit_result2_2 = 获取玩家操作数据_upvr.GetReleaserMouseHit(Releaser_2, const_number)
		local any_RayToEnemyIgnoreAirWall_result1 = RayCast_upvr.RayToEnemyIgnoreAirWall(any_GetReleaserMouseHit_result2_2, (any_GetReleaserMouseHit_result1.Position - any_GetReleaserMouseHit_result2_2.Position).Unit, const_number)
		if any_RayToEnemyIgnoreAirWall_result1 then
			any_GetReleaserMouseHit_result1 = any_GetReleaserMouseHit_result1.Rotation + any_RayToEnemyIgnoreAirWall_result1.Position
		end
		arg1.AtkCF = any_GetReleaserMouseHit_result1
	end
end
function module.GetAimPosition_Land(arg1, arg2) -- Line 32
	--[[ Upvalues[2]:
		[1]: 获取玩家操作数据_upvr (readonly)
		[2]: RayCast_upvr (readonly)
	]]
	if not arg2 then
		local const_number_2 = 100
	end
	local Releaser = arg1.Releaser
	local var11
	if Releaser == var11 then
		var11 = 获取玩家操作数据_upvr.GetReleaserMouseHit(Releaser, const_number_2)
		local any_GetReleaserMouseHit_result1_2, any_GetReleaserMouseHit_result2 = 获取玩家操作数据_upvr.GetReleaserMouseHit(Releaser, const_number_2)
		local any_RayToEnemyIgnoreAirWall_result1_2 = RayCast_upvr.RayToEnemyIgnoreAirWall(any_GetReleaserMouseHit_result2, (any_GetReleaserMouseHit_result1_2.Position - any_GetReleaserMouseHit_result2.Position).Unit, const_number_2)
		if any_RayToEnemyIgnoreAirWall_result1_2 then
			any_GetReleaserMouseHit_result1_2 = any_GetReleaserMouseHit_result1_2.Rotation + any_RayToEnemyIgnoreAirWall_result1_2.Position
		end
		local any_RayToLand_result1 = RayCast_upvr.RayToLand(any_GetReleaserMouseHit_result1_2.Position)
		if any_RayToLand_result1 then
		end
		arg1.AtkCF = any_GetReleaserMouseHit_result1_2.Rotation + any_RayToLand_result1.Position
	end
end
function module.Robot_GetAimPosition(arg1, arg2) -- Line 61
	--[[ Upvalues[1]:
		[1]: RayCast_upvr (readonly)
	]]
	if not arg2 then
	end
	local Caster = arg1.Caster
	if not Caster then
	else
		arg1.AtkCF = Caster:GetPivot():ToWorldSpace(CFrame.new(0, 0, -5))
		if arg1.playerData and arg1.playerData.character then
			local any_GetPivot_result1_2 = arg1.playerData.character:GetPivot()
			local any_GetPivot_result1 = Caster:GetPivot()
			local any_RayToDir_result1 = RayCast_upvr.RayToDir(any_GetPivot_result1, (any_GetPivot_result1_2.Position - any_GetPivot_result1.Position).Unit, math.min(100, (any_GetPivot_result1_2.Position - any_GetPivot_result1.Position).Magnitude))
			if any_RayToDir_result1 then
				any_GetPivot_result1_2 = any_GetPivot_result1_2.Rotation + any_RayToDir_result1.Position
			end
			arg1.AtkCF = any_GetPivot_result1_2
		end
		local any_RayToDir_result1_2 = RayCast_upvr.RayToDir(arg1.AtkCF, Vector3.new(0, -1, 0), 1000)
		if any_RayToDir_result1_2 then
			arg1.AtkCF = arg1.AtkCF.Rotation + any_RayToDir_result1_2.Position
		end
	end
end
return module