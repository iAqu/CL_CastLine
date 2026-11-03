-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeightUI = require(ReplicatedStorage.Modules.UILoader.WeightUI)
local LocalPlayer = game:GetService("Players").LocalPlayer
script.Parent.Touched:Connect(function(p1) --[[ Line: 7 | Upvalues: LocalPlayer (copy), WeightUI (copy) ]]
	if p1.Parent == LocalPlayer.Character then
		WeightUI:OpenUI()
	end
end)