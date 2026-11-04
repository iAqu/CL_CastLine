-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:59
-- Luau version 6, Types version 3
-- Time taken: 0.000505 seconds

local module = {}
local TweenService_upvr = game:GetService("TweenService")
function module.GetCustomEasingValue(arg1, arg2, arg3, arg4, arg5) -- Line 5
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	return math.clamp((TweenService_upvr:GetValue(arg4 + (arg5 - arg4) * arg1, arg2, arg3)) * (1 / TweenService_upvr:GetValue(arg5, arg2, arg3)), 0, 1)
end
return module