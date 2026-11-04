
-- Module requires
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Service refs
local Players = game:GetService("Players")

-- Constants

-- Variables

-- Module definition
local JoinService = Knit.CreateService{ 
	Name = "JoinService";
	Client = {};
}

-- Module code
local function PlayerAdded(player)
	-- Loaded
	player:SetAttribute("Loaded", true)
end

function JoinService:KnitInit()
end

function JoinService:KnitStart()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerAdded)(player)
	end

	Players.PlayerAdded:Connect(function(player)
		PlayerAdded(player)
	end)
end

-- Return module
return JoinService