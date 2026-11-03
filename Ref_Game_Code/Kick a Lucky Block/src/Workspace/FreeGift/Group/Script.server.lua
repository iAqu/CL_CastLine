-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local JoinGroupUI = require(ReplicatedStorage.Modules.UILoader.JoinGroupUI)
local LocalPlayer = game:GetService("Players").LocalPlayer
script.Parent.Touched:Connect(function(p1) --[[ Line: 6 | Upvalues: LocalPlayer (copy), JoinGroupUI (copy) ]]
	if p1.Parent == LocalPlayer.Character then
		JoinGroupUI:OpenFrame()
	end
end)