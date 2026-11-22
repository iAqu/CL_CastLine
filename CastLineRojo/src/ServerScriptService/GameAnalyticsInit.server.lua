local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameAnalytics = require(ReplicatedStorage:WaitForChild("GameAnalytics"))
local GAME_KEY = "e1dea1e9bd2ca75a79834f8d55ed6600"
local SECRET_KEY = "5aedfb294c2b3e2bd090583ddd8060a76cb2d20c"

GameAnalytics:initServer(GAME_KEY, SECRET_KEY)
