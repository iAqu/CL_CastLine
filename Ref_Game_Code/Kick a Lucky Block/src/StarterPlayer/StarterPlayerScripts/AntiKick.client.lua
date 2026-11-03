-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:Connect(function(p1) --[[ Line: 7 | Upvalues: TeleportService (copy), LocalPlayer (copy) ]]
	if p1 > 1020 then
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end
end)