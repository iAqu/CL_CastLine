-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:48
-- Luau version 6, Types version 3
-- Time taken: 0.000699 seconds

local module = {}
local Players_upvr = game:GetService("Players")
function module.getPlayerGui() -- Line 9
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local LocalPlayer = Players_upvr.LocalPlayer
	if not LocalPlayer then
		error("No localPlayer")
	end
	local class_PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not class_PlayerGui then
		class_PlayerGui = error("No PlayerGui")
	end
	return class_PlayerGui
end
return module