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
local StoreGiftMenuGui = PlayerGUI:WaitForChild("StoreGiftMenuGui")
local CloseButton = StoreGiftMenuGui.Frame:WaitForChild("CloseButton")

local ScrollingFrame = StoreGiftMenuGui.Frame.ScrollingFrame
local PlayerTemplate = ScrollingFrame.Template

local StoreGiftMenuGuiController = Knit.CreateController {
    Name = "StoreGiftMenuGuiController",
}

local isUpdating = false

function StoreGiftMenuGuiController:InitGui()
    for _, Template in pairs(ScrollingFrame:GetChildren()) do
        if Template:IsA("Frame") then
            Template.Visible = false
        end
    end
end

function StoreGiftMenuGuiController:OpenGui()
    for _, menuItem in pairs(ScrollingFrame:GetChildren()) do
        if menuItem:IsA("Frame") and not menuItem.Name:match("Template") then
            menuItem:Destroy()
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        self:GeneratePlayer(player)
    end

    GuiAnimation.OpenGui(StoreGiftMenuGui)
end

function StoreGiftMenuGuiController:GeneratePlayer(player: Player)
    if player == localPlayer then return end    -- Comment this line to test trade with yourself

    local clone = PlayerTemplate:Clone()
    clone.Parent = ScrollingFrame
    clone.Name = player.UserId
    clone.Button.DisplayNameLabel.Text = player.DisplayName
    clone.Button.UserNameLabel.Text = "@" .. player.Name
    clone.Button.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(player.UserId, 48)
    clone.Visible = true

    ButtonAnimation.SetUp(clone:WaitForChild("Button"), 1.05)

    clone.Button.Activated:Connect(function()
        local purchaseService = Knit.GetService("PurchaseService")
        purchaseService:SelectGiftedPlayer(player):andThen(function(isSuccess: boolean, message: string)
            if isSuccess then
                GuiAnimation.CloseGui(StoreGiftMenuGui)
                Knit.GetController("StoreGuiController"):OpenGuiFromGift(player)
            else
                NotificationClient.RedNotify(message)
            end
        end)
    end)
end

function StoreGiftMenuGuiController:KnitInit()
    self:InitGui()

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(StoreGiftMenuGui)
        Knit.GetController("StoreGuiController"):OpenGui()
    end)
end

function StoreGiftMenuGuiController:KnitStart()

    GuiUtil.AutoResizeScrollingFrame(StoreGiftMenuGui)
end

return StoreGiftMenuGuiController
