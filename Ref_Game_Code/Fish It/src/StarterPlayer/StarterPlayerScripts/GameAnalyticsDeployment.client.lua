-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
if not require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then
	local GameAnalytics = require(ReplicatedStorage.Modules.GameAnalytics)
	local Gamebeast = require(ReplicatedStorage.Modules.Gamebeast)
	GameAnalytics:initClient()
	Gamebeast:Setup()
end