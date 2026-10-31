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
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local DistanceUtil = require(ReplicatedStorage.Modules.DistanceUtil)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local Template = require(ReplicatedStorage.PlayerData.Template)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)

local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local LimitedStarterPackGui = PlayerGUI:WaitForChild("LimitedStarterPackGui")
local CloseButton = LimitedStarterPackGui.Frame:WaitForChild("CloseButton")

local BuyButton = LimitedStarterPackGui.Frame.BuyButton

local TimeLabel = LimitedStarterPackGui.Frame.TimeLabel

local PACK_START_TIME = 60 * 1 -- show time
-- local PACK_START_TIME = 15 -- test
local STARTER_PACK_DURATION = 60 * 60 -- last time
-- local STARTER_PACK_DURATION = 10 -- test

local LimitedStarterPackGuiController = Knit.CreateController {
    Name = "LimitedStarterPackGuiController",
}

function LimitedStarterPackGuiController:IsOpen()
    return LimitedStarterPackGui.Enabled
end

function LimitedStarterPackGuiController:OpenGui()
    GuiAnimation.OpenGui(LimitedStarterPackGui)
end

function LimitedStarterPackGuiController:CloseGui()
    GuiAnimation.CloseGui(LimitedStarterPackGui)
end

local function onBuyButtonClicked()
    local playerData = PlayerDataController:GetData()
    if playerData.LimitedPurchaseHistory["LimitedStarterPack"] then
        NotificationClient.Notify("Already bought")
        return
    end

    MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId("LimitedStarterPack"))
end

local function updateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    local currentTime = os.time()
    local firstJoinTime = playerData.FirstJoinTime
    local diffTime = currentTime - firstJoinTime
    local isLimitedPackBought = playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.LIMITED_STARTER_PACK]

    local HomeGuiController = Knit.GetController("HomeGuiController")

    if isLimitedPackBought or diffTime < PACK_START_TIME or diffTime > PACK_START_TIME + STARTER_PACK_DURATION then
        HomeGuiController:UpdateStarterPackButton(false, "")

        Knit.GetController("LimitedDailyPotionGuiController"):ShowLimitedDailyPotionButton(true)
    else
        -- Temporarily disable the periodic StartPack auto-popup. Players can still open it from the home button.

        local formatTime = NumberUtil.ConvertToMS(PACK_START_TIME + STARTER_PACK_DURATION - diffTime)
        HomeGuiController:UpdateStarterPackButton(true, formatTime)

        TimeLabel.Text = formatTime

        Knit.GetController("LimitedDailyPotionGuiController"):ShowLimitedDailyPotionButton(false)
    end
end

function LimitedStarterPackGuiController:KnitInit()
    BuyButton.Activated:Connect(function()
        onBuyButtonClicked()
    end)

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(LimitedStarterPackGui)
    end)
end

function LimitedStarterPackGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		LimitedStarterPackGui.Enabled = false
		return
	end
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId)
        if purchaseId == Constants.PURCHASE_ID.LIMITED_STARTER_PACK then
            GuiAnimation.CloseGui(LimitedStarterPackGui)
            NotificationClient.GreenNotify("🎉 Purchase success!")
        end
    end)

    Timer.Simple(1, function()
        updateGui()
    end)
end

return LimitedStarterPackGuiController
