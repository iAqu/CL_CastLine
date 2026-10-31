local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)

local BOOST_PREMIUM = 0.2

local PremiumService = Knit.CreateService {
    Name = "PremiumService",
    Client = {
        -- Server -> Client
        UpdatePremiumStatus = Knit.CreateSignal(),
    },
    PremeiumPlayers = {},       -- player : true
}

function PremiumService:GetPremiumBoost(player: Player): number
    if self.PremeiumPlayers[player] then
        return BOOST_PREMIUM
    else
        return 0
    end
end

function PremiumService:KnitInit()
    Players.PlayerRemoving:Connect(function(player: Player)
        self.PremeiumPlayers[player] = nil
    end)
end

function PremiumService:KnitStart()
    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        local success, ownsPremium = pcall(function()
			return player.MembershipType == Enum.MembershipType.Premium
		end)
        if success then
			if ownsPremium then
                self.PremeiumPlayers[player] = true
            end
        end
    end)

    Players.PlayerMembershipChanged:Connect(function(player)
        local success, ownsPremium = pcall(function()
			return player.MembershipType == Enum.MembershipType.Premium
		end)
        if success then
			if ownsPremium then
                self.PremeiumPlayers[player] = true
                self.Client.UpdatePremiumStatus:Fire(player, true)
            end
        end
    end)
end

return PremiumService