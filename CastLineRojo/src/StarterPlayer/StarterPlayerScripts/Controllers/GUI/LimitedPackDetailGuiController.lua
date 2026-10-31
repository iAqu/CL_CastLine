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
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)
local LimitedPacksDataHelper = require(ReplicatedFirst.DataHelpers.LimitedPacksDataHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local UgcDetailGui = PlayerGui:WaitForChild("LimitedPackDetailGui")
local MainFrame = UgcDetailGui.Frame

local CloseButton = MainFrame.CloseButton
local BuyButton = MainFrame.BuyButton

local LimitedPackListGui = PlayerGui:WaitForChild("LimitedPackListGui")

local currentPackId = nil

local LimitedPackDetailGuiController = Knit.CreateController {
    Name = "LimitedPackDetailGuiController",
}

function LimitedPackDetailGuiController:CloseGui()
    GuiAnimation.CloseGui(UgcDetailGui)
    task.wait(0.1)
    Knit.GetController("LimitedPackListGuiController"):OpenGui()
end

function LimitedPackDetailGuiController:IsOpen(): boolean
    return UgcDetailGui.Enabled
end

function LimitedPackDetailGuiController:InitGui()
end

local function getItemName(packId: string, index: number): string
    local itemType = LimitedPacksDataHelper.GetItemType(packId, index)
    local itemId = LimitedPacksDataHelper.GetItemId(packId, index)
    if itemType == "Potion" then
        return PurchaseDataHelper.GetName(itemId)
    elseif itemType == "Spin" then
        return "Spin"
    elseif itemType == "Wins" then
        return "Wins"
    elseif itemType == "Diamond" then
        return "Gems"
    else
        return "Unknown"
    end
end

local function getItemImage(packId: string, index: number): string
    local itemType = LimitedPacksDataHelper.GetItemType(packId, index)
    local itemId = LimitedPacksDataHelper.GetItemId(packId, index)
    if itemType == "Potion" then
        return "rbxassetid://" .. PurchaseDataHelper.GetIconId(itemId)
    elseif itemType == "Spin" then
        return Constants.IMAGE.SPIN
    elseif itemType == "Wins" then
        return Constants.IMAGE.WINS_ICON
    elseif itemType == "Diamond" then
        return Constants.IMAGE.DIAMOND_ICON
    else
        return ""
    end
end

local function getItemInfo(packId: string, index: number): string
    local itemType = LimitedPacksDataHelper.GetItemType(packId, index)
    local itemId = LimitedPacksDataHelper.GetItemId(packId, index)
    if itemType == "Wins" then
        return "x" .. NumberUtil.FormatWinsAmount(LimitedPacksDataHelper.GetItemCount(packId, index))
    else
        return "x" .. LimitedPacksDataHelper.GetItemCount(packId, index)
    end
end

function LimitedPackDetailGuiController:OpenGui(packId: string)
    currentPackId = packId
    GuiAnimation.OpenGui(UgcDetailGui)

    for _, guiElement in pairs(MainFrame:GetChildren()) do
        if guiElement:IsA("UIGradient") then
            guiElement:Destroy()
        end
    end

    local gradient = LimitedPackListGui.Frame.ScrollingFrame[packId]:FindFirstChild("UIGradient")
    if gradient then
        local gradienClone = gradient:Clone()
        gradienClone.Parent = MainFrame
        gradienClone.Enabled = true
    end

    MainFrame.TitleImage.TitleLabel.Text = LimitedPacksDataHelper.GetDisplayName(packId)
    MainFrame.BuyButton.OriginalPriceLabel.Text = LimitedPacksDataHelper.GetOriginalPrice(packId)
    MainFrame.BuyButton.PriceLabel.Text = LimitedPacksDataHelper.GetPrice(packId)

    for i = 1, 4 do
        local itemId = LimitedPacksDataHelper.GetItemId(packId, i)
        local itemFrame = MainFrame["Item_" .. i]
        itemFrame.NameLabel.Text = getItemName(packId, i)
        itemFrame.InfoLabel.Text = getItemInfo(packId, i)
        itemFrame.ImageLabel.Image = getItemImage(packId, i)
    end
end

local function buyPack()
    if not currentPackId then warn("No pack id") return end
    local productId = PurchaseDataHelper.GetProductId(currentPackId)
    MarketplaceService:PromptProductPurchase(localPlayer, productId)
end

local function notifyPurchaseSuccess(packId: string)
    for i = 1, 4 do
        local itemCount = LimitedPacksDataHelper.GetItemCount(packId, i)
        local itemType = LimitedPacksDataHelper.GetItemType(packId, i)
        local itemName = getItemName(packId, i)
        local notificationText
        if itemCount > 1 then
            local itemCountText = if itemType == "Wins" then NumberUtil.FormatWinsAmount(itemCount) else itemCount
            notificationText = "Got " .. itemCountText .. " x " .. itemName
        else
            notificationText = "Got " .. itemName
        end

        local iconId = getItemImage(packId, i)
        if iconId and iconId ~= "" then
            NotificationClient.IconNotify(notificationText, iconId)
        else
            NotificationClient.GreenNotify(notificationText)
        end
    end
end

function LimitedPackDetailGuiController:KnitInit()
    GuiAnimation.SetNavigationOptions(UgcDetailGui, nil, function()
        self:CloseGui()
    end)

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId: string)
        if purchaseId == currentPackId then
            self:CloseGui()
            notifyPurchaseSuccess(currentPackId)
        end
    end)
end

function LimitedPackDetailGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		UgcDetailGui.Enabled = false
		return
	end
    local playerData = PlayerDataController:GetData()   -- just to make sure it's loaded

    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    BuyButton.Activated:Connect(buyPack)

    self:InitGui()
end

return LimitedPackDetailGuiController
