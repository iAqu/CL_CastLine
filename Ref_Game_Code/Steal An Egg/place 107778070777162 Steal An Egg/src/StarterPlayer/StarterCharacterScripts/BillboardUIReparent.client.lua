-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HumanoidRootPart = script.Parent:WaitForChild("HumanoidRootPart")
local clone = ReplicatedStorage.Assets.Billboards.Billboard_UI:Clone()

clone.Adornee = HumanoidRootPart
clone.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
