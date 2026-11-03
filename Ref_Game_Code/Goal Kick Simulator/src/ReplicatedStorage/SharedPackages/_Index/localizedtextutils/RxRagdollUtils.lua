-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:09
-- Luau version 6, Types version 3
-- Time taken: 0.004115 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("RxInstanceUtils")
local var1_result1_upvr = any_load_result1("RxR15Utils")
local module_upvr = {
	observeRigType = function(arg1) -- Line 21, Named "observeRigType"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_2 (readonly)
		]]
		return var1_result1_upvr_2.observeProperty(arg1, "RigType")
	end;
	observeCharacterBrio = function(arg1) -- Line 25, Named "observeCharacterBrio"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_2 (readonly)
		]]
		return var1_result1_upvr_2.observePropertyBrio(arg1, "Parent", function(arg1_2) -- Line 26
			if arg1_2 == nil then
			else
			end
			return true
		end)
	end;
	suppressRootPartCollision = function(arg1) -- Line 31, Named "suppressRootPartCollision"
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_3 (readonly)
			[2]: var1_result1_upvr (readonly)
		]]
		local var7 = false
		if typeof(arg1) == "Instance" then
			var7 = arg1:IsA("Model")
		end
		assert(var7, "Bad character")
		local any_new_result1_3 = var1_result1_upvr_3.new()
		any_new_result1_3:GiveTask(var1_result1_upvr.observeCharacterPartBrio(arg1, "HumanoidRootPart"):Subscribe(function(arg1_3) -- Line 36
			if arg1_3:IsDead() then
			else
				local any_GetValue_result1_upvr = arg1_3:GetValue()
				local CustomPhysicalProperties_upvr = any_GetValue_result1_upvr.CustomPhysicalProperties
				local var12 = CustomPhysicalProperties_upvr
				if not var12 then
					var12 = PhysicalProperties.new(any_GetValue_result1_upvr.Material)
				end
				any_GetValue_result1_upvr.CustomPhysicalProperties = PhysicalProperties.new(0.01, var12.Friction, var12.Elasticity, var12.FrictionWeight, var12.ElasticityWeight)
				any_GetValue_result1_upvr.CanCollide = false
				arg1_3:ToMaid():GiveTask(function() -- Line 55
					--[[ Upvalues[2]:
						[1]: any_GetValue_result1_upvr (readonly)
						[2]: CustomPhysicalProperties_upvr (readonly)
					]]
					any_GetValue_result1_upvr.CustomPhysicalProperties = CustomPhysicalProperties_upvr
					any_GetValue_result1_upvr.CanCollide = true
				end)
			end
		end))
		return any_new_result1_3
	end;
	enforceHeadCollision = function(arg1) -- Line 64, Named "enforceHeadCollision"
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_3 (readonly)
			[2]: var1_result1_upvr (readonly)
		]]
		local var14 = false
		if typeof(arg1) == "Instance" then
			var14 = arg1:IsA("Model")
		end
		assert(var14, "Bad character")
		local any_new_result1 = var1_result1_upvr_3.new()
		any_new_result1:GiveTask(var1_result1_upvr.observeCharacterPartBrio(arg1, "Head"):Subscribe(function(arg1_4) -- Line 69
			if arg1_4:IsDead() then
			else
				local any_GetValue_result1_upvr_2 = arg1_4:GetValue()
				any_GetValue_result1_upvr_2.CanCollide = true
				arg1_4:ToMaid():GiveTask(function() -- Line 79
					--[[ Upvalues[1]:
						[1]: any_GetValue_result1_upvr_2 (readonly)
					]]
					any_GetValue_result1_upvr_2.CanCollide = false
				end)
			end
		end))
		return any_new_result1
	end;
}
local var1_result1_upvr_5 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr = any_load_result1("CharacterUtils")
local RunService_upvr = game:GetService("RunService")
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_4 = any_load_result1("RagdollMotorUtils")
function module_upvr.runLocal(arg1) -- Line 88
	--[[ Upvalues[7]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: module_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: RunService_upvr (readonly)
		[6]: Players_upvr (readonly)
		[7]: var1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr_3.new()
	any_new_result1_2_upvr:GiveTask(var1_result1_upvr_5.flatCombineLatest({
		character = module_upvr.observeCharacterBrio(arg1);
		rigType = module_upvr.observeRigType(arg1);
	}):Subscribe(function(arg1_5) -- Line 94
		--[[ Upvalues[8]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: RunService_upvr (copied, readonly)
			[5]: Players_upvr (copied, readonly)
			[6]: var1_result1_upvr_4 (copied, readonly)
			[7]: module_upvr (copied, readonly)
			[8]: any_new_result1_2_upvr (readonly)
		]]
		if arg1_5.character and arg1_5.rigType then
			local character_upvr = arg1_5.character
			local rigType_upvr = arg1_5.rigType
			local any_new_result1_upvr = var1_result1_upvr_3.new()
			if RunService_upvr:IsServer() or any_load_result1_result1_upvr.getPlayerFromCharacter(arg1) == Players_upvr.LocalPlayer then
				any_new_result1_upvr:GivePromise(var1_result1_upvr_4.promiseVelocityRecordings(character_upvr, rigType_upvr)):Then(function(arg1_6) -- Line 106
					--[[ Upvalues[6]:
						[1]: any_new_result1_upvr (readonly)
						[2]: module_upvr (copied, readonly)
						[3]: character_upvr (readonly)
						[4]: rigType_upvr (readonly)
						[5]: var1_result1_upvr_4 (copied, readonly)
						[6]: arg1 (copied, readonly)
					]]
					debug.profilebegin("initragdoll")
					any_new_result1_upvr:GiveTask(module_upvr.suppressRootPartCollision(character_upvr, rigType_upvr))
					any_new_result1_upvr:GiveTask(module_upvr.enforceHeadCollision(character_upvr))
					any_new_result1_upvr:GiveTask(var1_result1_upvr_4.suppressMotors(character_upvr, rigType_upvr, arg1_6))
					arg1:ChangeState(Enum.HumanoidStateType.Physics)
					any_new_result1_upvr:GiveTask(function() -- Line 116
						--[[ Upvalues[1]:
							[1]: arg1 (copied, readonly)
						]]
						arg1:ChangeState(Enum.HumanoidStateType.GettingUp)
					end)
					debug.profileend()
				end)
			else
				debug.profilebegin("initragdoll_nonowner")
				any_new_result1_upvr:GiveTask(var1_result1_upvr_4.suppressJustRootPart(character_upvr, rigType_upvr))
				debug.profileend()
			end
			any_new_result1_2_upvr._current = any_new_result1_upvr
		else
			character_upvr = any_new_result1_2_upvr
			rigType_upvr = nil
			character_upvr._current = rigType_upvr
		end
	end))
	return any_new_result1_2_upvr
end
return module_upvr