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

local LimitedPackListGui = PlayerGui:WaitForChild("LimitedPackListGui")
local CloseButton = LimitedPackListGui.Frame.CloseButton
local scrollingFrame = LimitedPackListGui.Frame.ScrollingFrame

local onlineStartTime = 0
local packTimer = nil
local UgcRemaining = 0
local allUgcRemainingCounts = {}

local LimitedPackListGuiController = Knit.CreateController {
    Name = "LimitedPackListGuiController",
}

function LimitedPackListGuiController:OpenGui()
    GuiAnimation.OpenGui(LimitedPackListGui)
end

function LimitedPackListGuiController:CloseGui()
    GuiAnimation.CloseGui(LimitedPackListGui)
end

function LimitedPackListGuiController:IsOpen(): boolean
    return LimitedPackListGui.Enabled
end

local function updateLimitedPack(packId)
    local packFrame = scrollingFrame:FindFirstChild(packId)
    if not packFrame then return end

    local packData = LimitedPacksDataHelper.GetLimitedPackData(packId)
    if not packData then warn("No pack data for " .. packId) return end
    local playerData = PlayerDataController:GetData()
    local buyCount = if playerData.LimitedPurchaseHistory[packId] then 1 else 0
    packFrame.RemainingLabel.Text = "Limitied: " .. (1 - buyCount)

    local isUnlocked = if playerData.Areas[LimitedPacksDataHelper.GetUnlockArea(packId)] then true else false
    if isUnlocked then
        packFrame.UnlockButton.Visible = false
        if buyCount >= 1 then
            packFrame.ViewButton.Visible = false
            packFrame.SoldOutButton.Visible = true
        else
            packFrame.ViewButton.Visible = true
            packFrame.SoldOutButton.Visible = false
        end
    else
        packFrame.ViewButton.Visible = false
        packFrame.SoldOutButton.Visible = false
        packFrame.UnlockButton.Visible = true
    end
end

local function updateLimitedPacks()
    for _, packFrame in pairs(scrollingFrame:GetChildren()) do
        if packFrame:IsA("Frame") then
            local packId = packFrame.Name
            if not LimitedPacksDataHelper.GetLimitedPackData(packId) then continue end
            updateLimitedPack(packId)
        end
    end
end

local function initLimitedPacks()
    for _, packFrame in pairs(scrollingFrame:GetChildren()) do
        if packFrame:IsA("Frame") then
            local packId = packFrame.Name
            if not LimitedPacksDataHelper.GetLimitedPackData(packId) then continue end
            packFrame.NameLabel.Text = LimitedPacksDataHelper.GetDisplayName(packId)
            updateLimitedPack(packId)

            packFrame.ViewButton.Activated:Connect(function()
                Knit.GetController("LimitedPackDetailGuiController"):OpenGui(packId)
            end)
        end
    end
end

function LimitedPackListGuiController:KnitInit()
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId: string)
        task.delay(0, function()
            if LimitedPacksDataHelper.GetLimitedPackData(purchaseId) then
                updateLimitedPack(purchaseId)
            end
        end)
    end)

end

function LimitedPackListGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		LimitedPackListGui.Enabled = false
		return
	end
    local playerData = PlayerDataController:GetData()  -- just to make sure it's loaded

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(LimitedPackListGui)
    end)

    initLimitedPacks()
end

return LimitedPackListGuiController
