-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:36
-- Luau version 6, Types version 3
-- Time taken: 0.000856 seconds

local module_upvr = {
	getCubeoidDiameter = function(arg1) -- Line 31, Named "getCubeoidDiameter"
		return math.sqrt(arg1.x ^ 2 + arg1.y ^ 2 + arg1.z ^ 2)
	end;
}
function module_upvr.fitBoundingBoxToCamera(arg1, arg2, arg3) -- Line 44
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.fitSphereToCamera(module_upvr.getCubeoidDiameter(arg1) / 2, arg2, arg3)
end
function module_upvr.fitSphereToCamera(arg1, arg2, arg3) -- Line 58
	local var2 = math.rad(arg2) * 0.5
	if arg3 < 1 then
		var2 = math.atan(arg3 * math.tan(var2))
	end
	return arg1 / math.sin(var2)
end
function module_upvr.isOnScreen(arg1, arg2) -- Line 74
	local any_WorldToScreenPoint_result1, any_WorldToScreenPoint_result2 = arg1:WorldToScreenPoint(arg2)
	return any_WorldToScreenPoint_result2
end
return module_upvr