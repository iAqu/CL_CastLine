local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local TradeRequestGui = PlayerGUI:WaitForChild("TradeRequestGui")

local MessageLabel = TradeRequestGui.Frame.MessageLabel
local AvatarImage = TradeRequestGui.Frame.AvatarImage
local AcceptButton = TradeRequestGui.Frame.AcceptButton
local CancelButton = TradeRequestGui.Frame.CancelButton

local currentTrader = nil

local TradeRequestGuiController = Knit.CreateController {
    Name = "TradeRequestGuiController",
}

function TradeRequestGuiController:DisplayGui(trader: Player)
    AvatarImage.Image = ""
    currentTrader = trader
    TradeRequestGui.Enabled = true
    GuiAnimation.PushModal(TradeRequestGui, CancelButton, function()
        if TradeRequestGui.Enabled and currentTrader then
            TradeRequestGui.Enabled = false
            GuiAnimation.PopModal(TradeRequestGui)
            Knit.GetService("TradeService").IgnoreTradeRequest:Fire(currentTrader.UserId)
        end
    end)
    MessageLabel.Text = Constants.NOTIFICATION.TRADE_REQUEST_MESSAGE:gsub("#NAME", trader.DisplayName)
    AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(trader.UserId, 100)
end

function TradeRequestGuiController:KnitInit()
end

function TradeRequestGuiController:KnitStart()
    local TradeService = Knit.GetService("TradeService")

    CancelButton.Activated:Connect(function()
        TradeRequestGui.Enabled = false
        GuiAnimation.PopModal(TradeRequestGui)
        TradeService.IgnoreTradeRequest:Fire(currentTrader.UserId)
    end)

    AcceptButton.Activated:Connect(function()
        TradeRequestGui.Enabled = false
        GuiAnimation.PopModal(TradeRequestGui)
        TradeService.AcceptTradeRequest:Fire(currentTrader.UserId)
    end)

    TradeService.TradeRequestReceived:Connect(function(trader: Player)
        self:DisplayGui(trader)
    end)

    TradeService.TradeRequestExpired:Connect(function(requestPlayer: Player)
        if requestPlayer == currentTrader then
            TradeRequestGui.Enabled = false
            GuiAnimation.PopModal(TradeRequestGui)
        end
    end)
end

return TradeRequestGuiController
