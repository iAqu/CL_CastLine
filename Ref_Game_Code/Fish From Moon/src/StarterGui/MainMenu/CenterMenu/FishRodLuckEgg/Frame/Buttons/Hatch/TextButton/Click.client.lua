local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local AllUse = require(game.ReplicatedStorage.QuanJu.AllUse)

local button = script.Parent

button.MouseButton1Down:Connect(function()
	local FishRodLuckController = Knit.GetController("FishRodLuckController")
	local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value
	if fishRodPoolId ~= nil then
		if fishRodPoolId ~= "" then
			FishRodLuckController:LuckOnce(fishRodPoolId)
		end
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
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible==true then
				if player:GetAttribute("BuyFishRod") then
					AllUse.isCanLuckEgg=false
					return
				end
				--print("按了E，可以按，在抽蛋范围")
				local FishRodLuckController = Knit.GetController("FishRodLuckController")

				local fishRodPoolId = script.Parent.Parent.Parent.Parent.fishRodPoolId.Value

				if fishRodPoolId ~= nil then
					if fishRodPoolId ~= "" then
						FishRodLuckController:LuckOnce(fishRodPoolId)
						AllUse.isCanLuckEgg=false
					end
				end
			else
				AllUse.isCanLuckEgg=false
			end
		end
	end
end

UserInputService.InputBegan:Connect(Input)