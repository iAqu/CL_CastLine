-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:15
-- Luau version 6, Types version 3
-- Time taken: 0.000600 seconds

local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
LocalPlayer_upvr:WaitForChild("PlayerGui")
local function _() -- Line 8, Named "LoadFramework"
	--[[ Upvalues[1]:
		[1]: LocalPlayer_upvr (readonly)
	]]
	return require(LocalPlayer_upvr.PlayerScripts:WaitForChild("Client"):WaitForChild("MoonLightClient"))
end
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
if not game:IsLoaded() then
	game.Loaded:Wait()
end
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
print("-✅Preloader | Client has loaded!")