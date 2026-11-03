-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:02
-- Luau version 6, Types version 3
-- Time taken: 0.001165 seconds

local module_upvr = {}
local Workspace_upvr = game:GetService("Workspace")
local UserGameSettings_upvr = UserSettings():GetService("UserGameSettings")
function module_upvr.getPanBy(arg1, arg2) -- Line 10
	--[[ Upvalues[3]:
		[1]: Workspace_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: UserGameSettings_upvr (readonly)
	]]
	local var4
	if module_upvr.isPortraitMode(module_upvr.getCappedAspectRatio(Workspace_upvr.CurrentCamera.ViewportSize)) then
		var4 = module_upvr.invertSensitivity(var4)
	end
	return module_upvr.getInversionVector(UserGameSettings_upvr) * var4 * arg1
end
function module_upvr.convertToPanDelta(arg1) -- Line 22
	return Vector2.new(arg1.x, arg1.y)
end
function module_upvr.getInversionVector(arg1) -- Line 26
	return Vector2.new(1, arg1:GetCameraYInvertValue())
end
function module_upvr.invertSensitivity(arg1) -- Line 30
	return Vector2.new(arg1.y, arg1.x)
end
function module_upvr.isPortraitMode(arg1) -- Line 34
	if arg1 < 1 then
		return true
	end
	return false
end
function module_upvr.getCappedAspectRatio(arg1) -- Line 42
	return math.clamp(arg1.x, 0, 1920) / math.clamp(arg1.y, 0, 1080)
end
return module_upvr