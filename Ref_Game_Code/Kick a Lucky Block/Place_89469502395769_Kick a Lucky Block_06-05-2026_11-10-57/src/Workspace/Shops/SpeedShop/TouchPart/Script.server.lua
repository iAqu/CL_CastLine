-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedUpgrades = require(ReplicatedStorage.Modules.UILoader.SpeedUpgrades)
local LocalPlayer = game:GetService("Players").LocalPlayer
script.Parent.Touched:Connect(function(p1) --[[ Line: 6 | Upvalues: LocalPlayer (copy), SpeedUpgrades (copy) ]]
	if p1.Parent == LocalPlayer.Character then
		SpeedUpgrades:OpenFrame()
	end
end)