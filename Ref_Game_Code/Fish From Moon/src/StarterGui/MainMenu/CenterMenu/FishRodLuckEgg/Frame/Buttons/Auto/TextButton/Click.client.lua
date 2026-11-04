local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")   

local LocalPlayer = Players.LocalPlayer   

local Knit = require(ReplicatedStorage.Packages.Knit)
local Monetization = require(ReplicatedStorage.Config.Monetization)

local button = script.Parent

button.MouseButton1Down:Connect(function()
	local GamePassService = Knit.GetService("GamePassService")
	GamePassService:IsPlayerHaveGamePass("AutoChest"):andThen(function(result)
		if result then
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value
			if fishRodPoolId ~= nil then
				if fishRodPoolId ~= "" then
					FishRodLuckController:AutoLuck(fishRodPoolId)
				end
			end
		else
			MarketplaceService:PromptGamePassPurchase(LocalPlayer,Monetization.Gamepasses.AutoChest.Id)
		end
	end)
end)

local T = Enum.KeyCode.T

-- 返回是否按下了 T 键
local function IsTKeyDown()
	return UserInputService:IsKeyDown(T)
end

-- 根据 T 键是否
local function Input(input,gameProcessedEvent)
	--没有按
	if not IsTKeyDown() then
	else
		--处于抽奖状态
		if LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
			if LocalPlayer.PlayerGui:WaitForChild("AutoSummon").T.Value then
			else
				if LocalPlayer:GetAttribute("BuyFishRod") then
					return
				end
				local GamePassService = Knit.GetService("GamePassService")
				GamePassService:IsPlayerHaveGamePass("AutoChest"):andThen(function(result)
					if result then
						local FishRodLuckController = Knit.GetController("FishRodLuckController")
						local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value

						if fishRodPoolId ~= nil then
							if fishRodPoolId ~= "" then
								FishRodLuckController:AutoLuck(fishRodPoolId)
							end
						end
					else
						MarketplaceService:PromptGamePassPurchase(LocalPlayer,Monetization.Gamepasses.AutoChest.Id)
					end
				end)
			end
		end
	end
end

UserInputService.InputBegan:Connect(Input)