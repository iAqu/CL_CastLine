-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:36
-- Luau version 6, Types version 3
-- Time taken: 0.001306 seconds

local module_upvr = {
	getConstants = function(arg1, arg2) -- Line 17, Named "getConstants"
		local var2 = arg1 - arg2
		return (var2 * var2 * (var2 + 3 * arg2)) / (arg1 * arg1 * arg1), (var2 * var2 * arg2) / (arg1 * arg1), (arg2 * arg2 * (arg2 + 3 * var2)) / (arg1 * arg1 * arg1), (-arg2 * arg2 * var2) / (arg1 * arg1)
	end;
	getDerivativeConstants = function(arg1, arg2) -- Line 35, Named "getDerivativeConstants"
		local var3 = arg1 - arg2
		return (-6 * var3 * arg2) / (arg1 * arg1 * arg1), (var3 * (var3 - 2 * arg2)) / (arg1 * arg1), (6 * var3 * arg2) / (arg1 * arg1 * arg1), (arg2 * (arg2 - 2 * var3)) / (arg1 * arg1)
	end;
	applyConstants = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 57, Named "applyConstants"
		return arg1 * arg5 + arg2 * arg6 + arg3 * arg7 + arg4 * arg8
	end;
}
function module_upvr.tween(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getConstants_result1, any_getConstants_result2, any_getConstants_result3, any_getConstants_result4 = module_upvr.getConstants(arg5, arg6)
	return any_getConstants_result1 * arg1 + any_getConstants_result2 * arg2 + any_getConstants_result3 * arg3 + any_getConstants_result4 * arg4
end
function module_upvr.getAcceleration(arg1, arg2, arg3, arg4, arg5) -- Line 86
	return (12 * (arg3 - arg1) * (arg3 - arg1) - 12 * arg5 * (arg3 - arg1) * (arg2 + arg4) + 4 * arg5 * arg5 * (arg2 * arg2 + arg2 * arg4 + arg4 * arg4)) / (arg5 * arg5 * arg5)
end
return module_upvr