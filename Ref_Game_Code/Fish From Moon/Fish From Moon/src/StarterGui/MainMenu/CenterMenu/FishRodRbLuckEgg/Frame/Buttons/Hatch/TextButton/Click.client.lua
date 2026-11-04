local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local AllUse = require(game.ReplicatedStorage.QuanJu.AllUse)
local Monetization = require(game.ReplicatedStorage.Config.Monetization)

local button = script.Parent

local isCoolDown = false

button.MouseButton1Down:Connect(function()
	if not isCoolDown then
		isCoolDown = true
		MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts.RBEgg1.Id)
		task.wait(1)
		isCoolDown = false
	end
end)

local UserInputService = game:GetService("UserInputService")

local Q = Enum.KeyCode.Q

-- 返回是否按下了Q 键
local function IsQKeyDown()
	return UserInputService:IsKeyDown(Q)
end

-- 根据 Q 键是否
local function Input(input, gameProcessedEvent)
	--没有按
	if not IsQKeyDown() then
		--print("没有按Q")
	else
		--按了
		if not AllUse.isCanLuckEgg then
			AllUse.isCanLuckEgg = true
			--处于抽奖状态
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodRbLuckEgg.Visible==true then
				if player:GetAttribute("BuyFishRod") then
					AllUse.isCanLuckEgg=false
					return
				end
				--print("按了E，可以按，在抽蛋范围")
				MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts.RBEgg1.Id)
				AllUse.isCanLuckEgg=false
			else
				AllUse.isCanLuckEgg=false
			end
		end
	end
end

UserInputService.InputBegan:Connect(Input)