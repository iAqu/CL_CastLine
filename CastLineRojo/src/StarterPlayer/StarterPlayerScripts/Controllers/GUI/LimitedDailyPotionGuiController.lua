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
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local HomeGui = PlayerGui:WaitForChild("HomeGui")
local LimitedDailyPotionButton = HomeGui.TopFrame.LimitedDailyPotionButton

local LimitedDailyPotionGuiController = Knit.CreateController {
    Name = "LimitedDailyPotionGuiController",
}

-- function LimitedDailyPotionGuiController:BuyBundle()
--     local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.LIMITED_DAILY_POTION_BUNDLE)
--     MarketplaceService:PromptProductPurchase(localPlayer, productId)
-- end

local function showLimitedDailyPotionButton(_enable: boolean)
    -- Temporarily disabled: never expose the limited daily potion entry point.
    LimitedDailyPotionButton.Visible = false
end

function LimitedDailyPotionGuiController:ShowLimitedDailyPotionButton(enable: boolean)
    if enable then
        local playerData = PlayerDataController:GetData()
        local dayOfYear = DateTime.now():FormatUniversalTime("DDD", "en-us")
        if playerData.LimitedDailyPotionPurchaseHistory[dayOfYear] then
            showLimitedDailyPotionButton(false)
        else
            showLimitedDailyPotionButton(true)
        end
    else
        showLimitedDailyPotionButton(false)
    end
end

function LimitedDailyPotionGuiController:KnitInit()

end

function LimitedDailyPotionGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		LimitedDailyPotionButton.Visible = false
		return
	end

    local playerData = PlayerDataController:GetData()  -- just to make sure it's loaded

    local dayOfYear = DateTime.now():FormatUniversalTime("DDD", "en-us")
    if playerData.LimitedDailyPotionPurchaseHistory[dayOfYear] then
        showLimitedDailyPotionButton(false)
    else
        showLimitedDailyPotionButton(true)
    end

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId: string)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
        if purchaseId == Constants.PURCHASE_ID.LIMITED_DAILY_POTION_BUNDLE then

            playerData.LimitedDailyPotionPurchaseHistory[dayOfYear] = true

            NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", "Double Win"), 1)
            NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", "Super Luck"), 1)
            NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", "Golden"), 1)
            NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", "Rainbow"), 1)
            NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", "Double Strength"), 1)
        
            showLimitedDailyPotionButton(false)
        end
    end)

    LimitedDailyPotionButton.Activated:Connect(function()
        MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.LIMITED_DAILY_POTION_BUNDLE))
    end)
end

return LimitedDailyPotionGuiController
