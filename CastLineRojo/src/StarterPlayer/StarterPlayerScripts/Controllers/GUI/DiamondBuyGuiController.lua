local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Template = require(ReplicatedStorage.PlayerData.Template)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
-- local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local DiamondBuyGui = PlayerGui:WaitForChild("DiamondBuyGui")
local CloseButton = DiamondBuyGui.Frame.CloseButton
local DoubleBlocksButton = DiamondBuyGui.Frame.DoubleDiamondsButton

local DiamondBuyGuiController = Knit.CreateController {
    Name = "DiamondBuyGuiController",
}

function DiamondBuyGuiController:OpenGui()
    GuiAnimation.OpenGui(DiamondBuyGui)
end

function DiamondBuyGuiController:CloseGui()
    GuiAnimation.CloseGui(DiamondBuyGui)
end

function DiamondBuyGuiController:IsOpen()
    return DiamondBuyGui.Enabled
end

function DiamondBuyGuiController:InitDiamondData()
    for _, button in pairs(DiamondBuyGui.Frame:GetChildren()) do
        if not button:IsA("TextButton") then continue end
        local purchaseId = button.Name
        if not PurchaseDataHelper.GetData(purchaseId) then continue end
        -- button.NameLabel.Text = PurchaseDataHelper.GetName(purchaseId)
        button.BuyNumLabel.Text = "+" .. PurchaseDataHelper.GetBuyNum(purchaseId)
        button.Frame.BuyButton.PriceLabel.Text = PurchaseDataHelper.GetPrice(purchaseId)

        button.Activated:Connect(function()
            -- local productId = PurchaseDataHelper.GetGiftProductId(purchaseId)
            -- MarketplaceService:PromptProductPurchase(localPlayer, productId)
            Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId)
        end)
    end
end

function DiamondBuyGuiController:KnitInit()
end

function DiamondBuyGuiController:KnitStart()
    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(DiamondBuyGui)
    end)

    if DoubleBlocksButton and DoubleBlocksButton:IsA("GuiObject") then
        DoubleBlocksButton.Visible = false
    end

    self:InitDiamondData()
end

return DiamondBuyGuiController