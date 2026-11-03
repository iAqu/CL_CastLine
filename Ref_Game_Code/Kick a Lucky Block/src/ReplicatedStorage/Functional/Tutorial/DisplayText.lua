-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local MessageStyles = require(ReplicatedStorage.Shared.Data.MessageStyles)
Trove.new()
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local TutorialGui = script.TutorialGui
return function(p1, p2) --[[ Line: 15 | Upvalues: TutorialGui (copy), MessageStyles (copy), PlayerGui (copy) ]]
	if p1 then
		TutorialGui.Enabled = true
		TutorialGui.MessageTemplate.MessageLabel.Text = p1
		if TutorialGui.Parent ~= PlayerGui then
			TutorialGui.Parent = PlayerGui
		end
		(MessageStyles[p2] or MessageStyles.Default).Show(TutorialGui.MessageTemplate)
	else
		TutorialGui.Enabled = false
		TutorialGui.Parent = script
	end
end