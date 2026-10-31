local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local GameAnalytics = require(ReplicatedStorage.GameAnalytics)

GameAnalytics:initClient()

local function getCustomUserId()
    return player.DisplayName
end
