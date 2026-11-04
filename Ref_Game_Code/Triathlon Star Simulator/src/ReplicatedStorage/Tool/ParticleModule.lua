-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:47
-- Luau version 6, Types version 3
-- Time taken: 0.002222 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local ObjectPool_upvr = require(ReplicatedStorage_upvr.Tool.ObjectPool)
local ParticleUtil_upvr = require(ReplicatedStorage_upvr.Tool.ParticleUtil)
function module.BossKillEffect(arg1) -- Line 11
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr_3 = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.Effect.DeathEffect)
	any_GetFromPool_result1_upvr_3.Parent = workspace
	any_GetFromPool_result1_upvr_3.Anchored = true
	any_GetFromPool_result1_upvr_3.Position = arg1
	delay(1, function() -- Line 21
		--[[ Upvalues[2]:
			[1]: ObjectPool_upvr (copied, readonly)
			[2]: any_GetFromPool_result1_upvr_3 (readonly)
		]]
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr_3)
	end)
	for _, v in pairs(any_GetFromPool_result1_upvr_3.Attachment:GetChildren()) do
		v.Enabled = false
		v:Emit(1)
	end
end
function module.WeaponHitEffect(arg1, arg2) -- Line 35
	--[[ Upvalues[3]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
		[3]: ParticleUtil_upvr (readonly)
	]]
	if not arg2 then
	end
	local any_ReSizeParticle_result1_upvw_2 = ParticleUtil_upvr.ReSizeParticle(ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.Effect["造成伤害"]), 1)
	any_ReSizeParticle_result1_upvw_2.Parent = workspace
	any_ReSizeParticle_result1_upvw_2.Anchored = true
	any_ReSizeParticle_result1_upvw_2.Position = arg1
	delay(1, function() -- Line 51
		--[[ Upvalues[2]:
			[1]: ObjectPool_upvr (copied, readonly)
			[2]: any_ReSizeParticle_result1_upvw_2 (read and write)
		]]
		ObjectPool_upvr.BackToPool(any_ReSizeParticle_result1_upvw_2)
	end)
	any_ReSizeParticle_result1_upvw_2.Attachment["闪光1"]:Emit(1)
	any_ReSizeParticle_result1_upvw_2.Attachment["能量波"]:Emit(1)
	any_ReSizeParticle_result1_upvw_2.Attachment["爆炸"]:Emit(1)
end
function module.WeaponHitEffect2(arg1, arg2) -- Line 61
	--[[ Upvalues[3]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
		[3]: ParticleUtil_upvr (readonly)
	]]
	if not arg2 then
	end
	local any_ReSizeParticle_result1_upvw = ParticleUtil_upvr.ReSizeParticle(ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.Effect["造成伤害2"]), 1)
	any_ReSizeParticle_result1_upvw.Parent = workspace
	any_ReSizeParticle_result1_upvw.Anchored = true
	any_ReSizeParticle_result1_upvw.Position = arg1
	delay(1, function() -- Line 78
		--[[ Upvalues[2]:
			[1]: ObjectPool_upvr (copied, readonly)
			[2]: any_ReSizeParticle_result1_upvw (read and write)
		]]
		ObjectPool_upvr.BackToPool(any_ReSizeParticle_result1_upvw)
	end)
	any_ReSizeParticle_result1_upvw.Attachment["闪光1"]:Emit(1)
	any_ReSizeParticle_result1_upvw.Attachment["电光"]:Emit(20)
end
function module.HitAirEffect(arg1) -- Line 87
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr_2 = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.Effect["空气伤害"])
	any_GetFromPool_result1_upvr_2.Parent = workspace
	any_GetFromPool_result1_upvr_2.Anchored = true
	any_GetFromPool_result1_upvr_2.Position = arg1
	delay(1, function() -- Line 95
		--[[ Upvalues[2]:
			[1]: ObjectPool_upvr (copied, readonly)
			[2]: any_GetFromPool_result1_upvr_2 (readonly)
		]]
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr_2)
	end)
	any_GetFromPool_result1_upvr_2.Attachment["能量波"]:Emit(1)
	any_GetFromPool_result1_upvr_2.Attachment["小闪光1"]:Emit(1)
end
function module.PetHitEffect(arg1) -- Line 103
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.Effect["随从伤害"])
	any_GetFromPool_result1_upvr.Parent = workspace
	any_GetFromPool_result1_upvr.Anchored = true
	any_GetFromPool_result1_upvr.Position = arg1
	delay(1, function() -- Line 112
		--[[ Upvalues[2]:
			[1]: ObjectPool_upvr (copied, readonly)
			[2]: any_GetFromPool_result1_upvr (readonly)
		]]
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr)
	end)
	any_GetFromPool_result1_upvr.Attachment["能量波"]:Emit(1)
end
return module