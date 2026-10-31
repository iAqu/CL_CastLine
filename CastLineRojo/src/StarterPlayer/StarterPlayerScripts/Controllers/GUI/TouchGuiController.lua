local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
-- local WeaponsDataLeft = require(ReplicatedFirst.Data.WeaponsDataLeft)
-- local WeaponsDataRight = require(ReplicatedFirst.Data.WeaponsDataRight)
local Template = require(ReplicatedStorage.PlayerData.Template)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local TouchGuiController = Knit.CreateController {
    Name = "TouchGuiController",
}

function TouchGuiController:KnitInit()
end

function TouchGuiController:KnitStart()

    repeat task.wait() until game:IsLoaded()

    -- warn("TouchGuiController:KnitStart")

    if PlayerGUI:FindFirstChild('TouchGui') then
        
        -- warn("TouchGui found, move jump button")

        -- PlayerGUI.TouchGui.TouchControlFrame.JumpButton.Position = UDim2.fromScale(0.85, 0.65)
        -- default position is {1, -130},{1, -90}
        -- PlayerGUI.TouchGui.TouchControlFrame.JumpButton.Position = UDim2.new(1, -150, 1, -90)

        -- local jumpButton = PlayerGUI.TouchGui.TouchControlFrame.JumpButton
        local jumpButton = PlayerGUI.TouchGui.TouchControlFrame:WaitForChild("JumpButton", 3)
        if not jumpButton then warn("No jump button found!") return end
        
        local jumpButtonOriginalPosition = jumpButton.Position

        jumpButton.Position = UDim2.new(jumpButton.Position.X.Scale, jumpButton.Position.X.Offset - 80, jumpButton.Position.Y.Scale, jumpButton.Position.Y.Offset)
    end
end

return TouchGuiController
