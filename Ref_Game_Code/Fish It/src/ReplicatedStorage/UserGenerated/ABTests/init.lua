-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
require(ReplicatedStorage.UserGenerated.ABTests.SharedABTests)
if RunService:IsServer() then
	return require(ServerScriptService.UserGenerated.Server.ServerABTests)
else
	return require(ReplicatedStorage.UserGenerated.Client.ClientABTests)
end