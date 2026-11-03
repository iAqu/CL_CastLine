-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:05
-- Luau version 6, Types version 3
-- Time taken: 0.001765 seconds

local module_upvr = {}
function module_upvr.smallVibrate(arg1, arg2, arg3) -- Line 17
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.setSmallVibration(arg1, arg3 or 1) then
		task.delay(arg2 or 0.1, function() -- Line 22
			--[[ Upvalues[2]:
				[1]: module_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			module_upvr.setSmallVibration(arg1, 0)
		end)
	end
end
function module_upvr.setSmallVibration(arg1, arg2) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if type(arg2) ~= "number" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "Bad amplitude")
	var3 = module_upvr
	var3 = arg1
	return var3.setVibrationMotor(var3, Enum.VibrationMotor.Small, arg2)
end
function module_upvr.setLargeVibration(arg1, arg2) -- Line 46
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var4
	if type(arg2) ~= "number" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad amplitude")
	var4 = module_upvr
	var4 = arg1
	return var4.setVibrationMotor(var4, Enum.VibrationMotor.Large, arg2)
end
local HapticService_upvr = game:GetService("HapticService")
function module_upvr.setVibrationMotor(arg1, arg2, arg3, ...) -- Line 60
	--[[ Upvalues[1]:
		[1]: HapticService_upvr (readonly)
	]]
	local var6
	if type(arg3) ~= "number" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad amplitude")
	if not HapticService_upvr:IsVibrationSupported(arg1) then
		return false
	end
	if not HapticService_upvr:IsMotorSupported(arg1, arg2) then
		return false
	end
	HapticService_upvr:SetMotor(arg1, arg2, arg3, ...)
	return true
end
return module_upvr