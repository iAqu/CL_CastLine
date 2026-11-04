local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit) 

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

-- 读取传送数据
local teleportData = TeleportService:GetLocalPlayerTeleportData()

if teleportData and teleportData.currentHealth then
	-- 将玩家的生命值设为传递的值
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Health = teleportData.currentHealth
end