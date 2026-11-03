-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueFramework = require(ReplicatedStorage.Utility.DialogueSystem.DialogueFramework)
script.Parent.Triggered:Connect(function(p1) --[[ Line: 6 | Upvalues: Players (copy), DialogueFramework (copy) ]]
	if p1 == Players.LocalPlayer then
		script.Parent.Enabled = false
		DialogueFramework.StartConversation(script.Parent.Parent.Parent)
		script.Parent.Enabled = true
	end
end)