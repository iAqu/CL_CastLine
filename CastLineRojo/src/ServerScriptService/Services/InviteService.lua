local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)

local BOOST_PER_FRIEND = 0.1

local InviteService = Knit.CreateService {
    Name = "InviteService",
    Client = {
        UpdateFriendBoost = Knit.CreateSignal(),
    },
    AllPlayerFriendBoost = {},
}

function InviteService:GetFriendBoost(player: Player) : number
    return self.AllPlayerFriendBoost[player.UserId] or 0
end

function InviteService:UpdateFriendBoost()
    for _, loopPlayer in pairs(Players:GetPlayers()) do
        -- Check if the player is still in the game
        if loopPlayer.Parent ~= game.Players then continue end

        local friendCount = 0
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if loopPlayer == otherPlayer then continue end
            
            -- Check if the player is still in the game
            if otherPlayer.Parent ~= game.Players then continue end

            if otherPlayer:IsFriendsWith(loopPlayer.UserId) then    -- Sovle “No FriendService” error
                friendCount += 1
            end
        end
        if friendCount > 10 then friendCount = 10 end       -- Limit the friend boost count to 10
        local boost = friendCount * BOOST_PER_FRIEND
        self.AllPlayerFriendBoost[loopPlayer.UserId] = boost
        self.Client.UpdateFriendBoost:Fire(loopPlayer, boost)
    end
end

function InviteService:KnitInit()
    LogHelper.Print("InviteService initialized")

    Players.PlayerAdded:Connect(function(player)
        self:UpdateFriendBoost()
    end)
    
    Players.PlayerRemoving:Connect(function(player: Player)
        if self.AllPlayerFriendBoost[player.UserId] then
            self.AllPlayerFriendBoost[player.UserId] = nil
        end
        self:UpdateFriendBoost()
    end)
end

function InviteService:KnitStart()
    LogHelper.Print("InviteService started")

    -- -- when new player joins, update all players' friend number
    -- PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)

    -- end)
end

return InviteService