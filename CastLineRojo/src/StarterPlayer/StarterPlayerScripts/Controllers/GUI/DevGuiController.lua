local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local DevMarkGui = PlayerGui:WaitForChild("DevMarkGui")
DevMarkGui.Enabled = Constants.DEBUG == true

local DevGuiController = Knit.CreateController {
    Name = "DevGuiController",
}

function DevGuiController:KnitInit()
end

function DevGuiController:KnitStart()
end

return DevGuiController