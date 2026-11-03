-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:12
-- Luau version 6, Types version 3
-- Time taken: 0.001431 seconds

local var1 = require(script.Parent.loader).load(script)("IKUtils")
local module = {}
local any_getDampenedAngleClamp_result1_upvr_3 = var1.getDampenedAngleClamp(0.3490658503988659, 0.17453292519943295)
local any_getDampenedAngleClamp_result1_upvr = var1.getDampenedAngleClamp(0.7853981633974483, 0.2617993877991494)
local any_getDampenedAngleClamp_result1_upvr_2 = var1.getDampenedAngleClamp(0.3490658503988659, 0.17453292519943295)
local any_getDampenedAngleClamp_result1_upvr_4 = var1.getDampenedAngleClamp(0.7853981633974483, 0.2617993877991494)
function module.getTargetAngles(arg1, arg2) -- Line 26
	--[[ Upvalues[4]:
		[1]: any_getDampenedAngleClamp_result1_upvr_3 (readonly)
		[2]: any_getDampenedAngleClamp_result1_upvr (readonly)
		[3]: any_getDampenedAngleClamp_result1_upvr_2 (readonly)
		[4]: any_getDampenedAngleClamp_result1_upvr_4 (readonly)
	]]
	local var7 = arg1.CFrame * CFrame.new(0, 0.5, 0)
	local any_pointToObjectSpace_result1_2 = var7:pointToObjectSpace(arg2)
	local any_getDampenedAngleClamp_result1_upvr_3_result1 = any_getDampenedAngleClamp_result1_upvr_3(math.atan2(-any_pointToObjectSpace_result1_2.X, -any_pointToObjectSpace_result1_2.Z))
	local var10 = var7 * CFrame.Angles(0, any_getDampenedAngleClamp_result1_upvr_3_result1, 0)
	local any_pointToObjectSpace_result1 = var10:pointToObjectSpace(arg2)
	local any_getDampenedAngleClamp_result1_upvr_result1 = any_getDampenedAngleClamp_result1_upvr(math.atan2(-any_pointToObjectSpace_result1.X, -any_pointToObjectSpace_result1.Z))
	local var13 = var10 * CFrame.Angles(0, any_getDampenedAngleClamp_result1_upvr_result1, 0)
	local any_pointToObjectSpace_result1_4 = var13:pointToObjectSpace(arg2)
	local any_getDampenedAngleClamp_result1_upvr_2_result1 = any_getDampenedAngleClamp_result1_upvr_2(math.atan2(any_pointToObjectSpace_result1_4.Y, -any_pointToObjectSpace_result1_4.Z))
	local any_pointToObjectSpace_result1_3 = var13 * CFrame.Angles(0, 0, any_getDampenedAngleClamp_result1_upvr_2_result1):pointToObjectSpace(arg2)
	return any_getDampenedAngleClamp_result1_upvr_3_result1, any_getDampenedAngleClamp_result1_upvr_result1, any_getDampenedAngleClamp_result1_upvr_2_result1, any_getDampenedAngleClamp_result1_upvr_4(math.atan2(any_pointToObjectSpace_result1_3.Y, -any_pointToObjectSpace_result1_3.Z))
end
return module