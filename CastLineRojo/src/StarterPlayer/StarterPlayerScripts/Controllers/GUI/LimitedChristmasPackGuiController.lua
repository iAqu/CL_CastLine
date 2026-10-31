local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local DistanceUtil = require(ReplicatedStorage.Modules.DistanceUtil)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local Template = require(ReplicatedStorage.PlayerData.Template)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local LimitedChristmasPackGui = PlayerGUI:WaitForChild("LimitedChristmasPackGui")
local CloseButton = LimitedChristmasPackGui.Frame:WaitForChild("CloseButton")

local BuyButton = LimitedChristmasPackGui.Frame.BuyButton

local LimitedChristmasPackGuiController = Knit.CreateController {
    Name = "LimitedChristmasPackGuiController",
}

function LimitedChristmasPackGuiController:OpenGui()
    GuiAnimation.OpenGui(LimitedChristmasPackGui)
end

local function onBuyButtonClicked()
    local playerData = PlayerDataController:GetData()
    if playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.LIMITED_CHRISTMAS_PACK] then
        NotificationClient.Notify("Already bought")
        return
    end

    MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.LIMITED_CHRISTMAS_PACK))
end

function LimitedChristmasPackGuiController:KnitInit()
    BuyButton.Activated:Connect(function()
        onBuyButtonClicked()
    end)

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(LimitedChristmasPackGui)
    end)
end

function LimitedChristmasPackGuiController:KnitStart()
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId)
        if purchaseId == Constants.PURCHASE_ID.LIMITED_CHRISTMAS_PACK then
            GuiAnimation.CloseGui(LimitedChristmasPackGui)
            NotificationClient.GreenNotify("🎉 Purchase success!")
        end
    end)
end

return LimitedChristmasPackGuiController
