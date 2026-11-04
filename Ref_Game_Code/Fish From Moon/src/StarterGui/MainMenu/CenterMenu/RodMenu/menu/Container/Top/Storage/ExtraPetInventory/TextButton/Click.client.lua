--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players=game:GetService("Players")

local LocalPlayer=Players.LocalPlayer

local Monetization = require(ReplicatedStorage.Config.Monetization)

local button = script.Parent

local isCoolDown = false

button.MouseButton1Down:Connect(function()
	if not isCoolDown then
		isCoolDown = true
		MarketplaceService:PromptGamePassPurchase(LocalPlayer,button.Item.Value)
		task.wait(1)
		isCoolDown = false
	end
end)