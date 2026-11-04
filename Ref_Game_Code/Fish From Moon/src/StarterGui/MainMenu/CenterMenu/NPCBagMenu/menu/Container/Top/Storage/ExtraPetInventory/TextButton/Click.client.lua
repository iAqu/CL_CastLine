--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketService = game:GetService("MarketplaceService")

local Monetization = require(ReplicatedStorage.Config.Monetization)

local button = script.Parent

local player=game:GetService("Players").LocalPlayer

button.MouseButton1Down:Connect(function()
	MarketService:PromptGamePassPurchase(player,Monetization.Gamepasses["+50Storage"].Id)
end)