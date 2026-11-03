-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:33
-- Luau version 6, Types version 3
-- Time taken: 0.001149 seconds

local module_upvr = {
	fovToHeight = function(arg1) -- Line 17, Named "fovToHeight"
		return math.tan(math.rad(arg1) / 2) * 2
	end;
	heightToFov = function(arg1) -- Line 26, Named "heightToFov"
		return math.deg(math.atan(arg1 / 2)) * 2
	end;
	safeLog = function(arg1, arg2) -- Line 36, Named "safeLog"
		if arg1 < arg2 then
			return 1 / arg2 * (arg1 - arg2) + math.log(arg2)
		end
		return math.log(arg1)
	end;
	safeExp = function(arg1, arg2) -- Line 52, Named "safeExp"
		local math_log_result1 = math.log(arg2)
		if arg1 <= math_log_result1 then
			return arg2 * (arg1 - math_log_result1) + arg2
		end
		return math.exp(arg1)
	end;
}
local var3_upvr = require(script.Parent.loader).load(script)("Math")
function module_upvr.lerpInHeightSpace(arg1, arg2, arg3) -- Line 69
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var3_upvr (readonly)
	]]
	local any_fovToHeight_result1 = module_upvr.fovToHeight(1)
	return module_upvr.heightToFov(module_upvr.safeExp(var3_upvr.lerp(module_upvr.safeLog(module_upvr.fovToHeight(arg1), any_fovToHeight_result1), module_upvr.safeLog(module_upvr.fovToHeight(arg2), any_fovToHeight_result1), arg3), any_fovToHeight_result1))
end
return module_upvr