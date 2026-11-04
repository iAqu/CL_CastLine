--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local Knit = require(ReplicatedStorage.Packages.Knit)

local BoardController = Knit.CreateController { Name = "BoardController" }

function BoardController:KnitInit()
end

function BoardController:KnitStart()
end

return BoardController