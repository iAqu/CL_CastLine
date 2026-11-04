--获取服务
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")    

local LocalPlayer = Players.LocalPlayer    

--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local AllUse = require(game.ReplicatedStorage.QuanJu.AllUse)
local Monetization = require(ReplicatedStorage.Config.Monetization)

local button = script.Parent

local isCoolDown = false

button.MouseButton1Down:Connect(function()
	local GamePassService = Knit.GetService("GamePassService")
	GamePassService:IsPlayerHaveGamePass("TripleOpen"):andThen(function(result)
		if result then
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value
			if fishRodPoolId ~= nil then
				if fishRodPoolId ~= "" then
					FishRodLuckController:LuckThreeTimes(fishRodPoolId)
				end
			end
		else
			if not isCoolDown then
				isCoolDown = true
				MarketplaceService:PromptGamePassPurchase(LocalPlayer,Monetization.Gamepasses.TripleOpen.Id)
				task.wait(1)
				isCoolDown = false
			end
		end
	end)
end)

local R = Enum.KeyCode.R

-- 返回是否按下了 R 键
local function IsRKeyDown()
	return UserInputService:IsKeyDown(R)
end

-- 根据 R 键是否
local function Input(input, gameProcessedEvent)
	--没有按
	if not IsRKeyDown() then
		--print("没有按R")
	else
		--按了
		if not AllUse.isCanLuckEgg then
			AllUse.isCanLuckEgg = true
			--处于抽奖状态
			if LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
				if LocalPlayer:GetAttribute("BuyFishRod") then
					AllUse.isCanLuckEgg=false
					return
				end
				--print("按了R，可以按，在抽蛋范围")
				local GamePassService = Knit.GetService("GamePassService")
				GamePassService:IsPlayerHaveGamePass("TripleOpen"):andThen(function(result)
					if result then
						local FishRodLuckController = Knit.GetController("FishRodLuckController")
						local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value

						if fishRodPoolId ~= nil then
							if fishRodPoolId ~= "" then
								FishRodLuckController:LuckThreeTimes(fishRodPoolId)
								AllUse.isCanLuckEgg=false
							end
						end
					else
						MarketplaceService:PromptGamePassPurchase(LocalPlayer,Monetization.Gamepasses.TripleOpen.Id)
						AllUse.isCanLuckEgg=false
					end
				end)
			else
				AllUse.isCanLuckEgg=false
			end
		end
	end
end

UserInputService.InputBegan:Connect(Input)