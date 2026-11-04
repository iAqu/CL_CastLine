local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit) 
local button = script.Parent

local player = Players.LocalPlayer

button.MouseButton1Click:Connect(function()  --点击购买100wins

	local indexId = script.Parent.IndexId.Value
	local FishRodIndexService = Knit.GetService("FishRodIndexService")

	FishRodIndexService:GetReward(indexId)
end)