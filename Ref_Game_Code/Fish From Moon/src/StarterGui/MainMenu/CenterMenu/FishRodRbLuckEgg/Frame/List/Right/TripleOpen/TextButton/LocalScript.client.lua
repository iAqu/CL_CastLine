local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit) 
local Monetization = require(ReplicatedStorage.Config.Monetization)

local player = Players.LocalPlayer

local button = script.Parent

local cd=false

button.MouseButton1Click:Connect(function()
	if not cd then
		cd=true
		task.delay(1,function()
			cd = false
		end)
		if not player then
			return
		end
		if not player.Character then
			return
		end
		local GamePassService = Knit.GetService("GamePassService")
		GamePassService:IsPlayerHaveGamePass("TripleOpen"):andThen(function(result)
			print(result)
			if result then
				local MainGuiController = Knit.GetController("MainGuiController")
				MainGuiController:ShowMessage("You already have the pass.")
			else
				MarketplaceService:PromptGamePassPurchase(player,Monetization.Gamepasses.TripleOpen.Id)
			end
		end)
	end
end)