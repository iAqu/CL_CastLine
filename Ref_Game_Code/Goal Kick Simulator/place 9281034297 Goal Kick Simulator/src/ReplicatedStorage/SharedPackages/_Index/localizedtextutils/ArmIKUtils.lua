-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:01
-- Luau version 6, Types version 3
-- Time taken: 0.000992 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("RagdollConstants")
local any_load_result1_result1_upvr = any_load_result1("RxR15Utils")
function module.ensureMotorAnimated(arg1, arg2) -- Line 13
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local any_new_result1 = var1_result1_upvr_2.new()
	local function disable(arg1_2) -- Line 16
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		if arg1_2:IsDead() then
		else
			local any_GetValue_result1_upvr = arg1_2:GetValue()
			any_GetValue_result1_upvr:SetAttribute(var1_result1_upvr.IS_MOTOR_ANIMATED_ATTRIBUTE, true)
			arg1_2:ToMaid():GiveTask(function() -- Line 25
				--[[ Upvalues[2]:
					[1]: any_GetValue_result1_upvr (readonly)
					[2]: var1_result1_upvr (copied, readonly)
				]]
				any_GetValue_result1_upvr:SetAttribute(var1_result1_upvr.IS_MOTOR_ANIMATED_ATTRIBUTE, false)
			end)
		end
	end
	any_new_result1:GiveTask(any_load_result1_result1_upvr.observeRigMotorBrio(arg1, arg2.."UpperArm", arg2.."Shoulder"):Subscribe(disable))
	any_new_result1:GiveTask(any_load_result1_result1_upvr.observeRigMotorBrio(arg1, arg2.."LowerArm", arg2.."Elbow"):Subscribe(disable))
	any_new_result1:GiveTask(any_load_result1_result1_upvr.observeRigMotorBrio(arg1, arg2.."Hand", arg2.."Wrist"):Subscribe(disable))
	return any_new_result1
end
return module