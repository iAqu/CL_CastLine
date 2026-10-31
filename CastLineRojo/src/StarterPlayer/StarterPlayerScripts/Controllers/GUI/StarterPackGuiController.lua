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

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local StarterPackGui = PlayerGui:WaitForChild("StarterPackGui")
local CloseButton = StarterPackGui.Frame.CloseButton
local BuyButton = StarterPackGui.Frame.BuyButton
local ClaimButton = StarterPackGui.Frame.ClaimFrame.ClaimButton
local ProgressFrame = StarterPackGui.Frame.ClaimFrame.Frame.ProgressFrame

local PROGRESS_BAR_MAX_X = 0.988
local PROGRESS_BAR_Y = 0.867

local onlineStartTime = 0
local packTimer = nil

local StarterPackGuiController = Knit.CreateController {
    Name = "StarterPackGuiController",
}

function StarterPackGuiController:OpenGui()
    GuiAnimation.OpenGui(StarterPackGui)
    -- self:UpdateProgress()
end

function StarterPackGuiController:CloseGui()
    GuiAnimation.CloseGui(StarterPackGui)
end

function StarterPackGuiController:IsOpen(): boolean
    return StarterPackGui.Enabled
end

function StarterPackGuiController:BuyStarterPack()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.STARTER_PACK)
    MarketplaceService:PromptProductPurchase(localPlayer, productId)
end

function StarterPackGuiController:UpdateProgress(isTaskDown: boolean)
    
    if isTaskDown then
        ProgressFrame.ProgressBar.Size = UDim2.new(PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        ProgressFrame.ProgressLabel.Text = "Complete"

    else
        if not onlineStartTime then return end
        local onlineTime = os.time() - onlineStartTime
        local percent = math.min(onlineTime / Constants.ONLINE_STARTER_PACK_TIME, PROGRESS_BAR_MAX_X)
        ProgressFrame.ProgressBar.Size = UDim2.new(percent, 0, PROGRESS_BAR_Y, 0)
        ProgressFrame.ProgressLabel.Text = NumberUtil.ConvertToMS(onlineTime) .. "/" .. NumberUtil.ConvertToMS(Constants.ONLINE_STARTER_PACK_TIME)
    end
end

-- function StarterPackGuiController:UpdateHomeButton(isTaskDown: boolean)
--     if not onlineStartTime then return end
--     if isTaskDown then
--          Knit.GetController("HomeLeftGuiController"):UpdateStartPackButton("Claim!")
--     else
--          Knit.GetController("HomeLeftGuiController"):UpdateStartPackButton(NumberUtil.ConvertToMS(Constants.ONLINE_STARTER_PACK_TIME - (os.time() - onlineStartTime)))
--     end
-- end

function StarterPackGuiController:KnitInit()
end

function StarterPackGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		StarterPackGui.Enabled = false
		return
	end

    local playerData = PlayerDataController:GetData()  -- just to make sure it's loaded

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(StarterPackGui)
    end)

    BuyButton.Activated:Connect(function()
        self:BuyStarterPack()
    end)

    ClaimButton.Activated:Connect(function()
        if playerData.StarterPackTaskDown then
            local OnlineRewardService = Knit.GetService("OnlineRewardService")
            OnlineRewardService:ClaimStarterPack():andThen(function(result)
                if result.isSuccess then
                    self:CloseGui()
                    Knit.GetController("HomeGuiController"):UpdateStarterPackButton(false, "")
                    NotificationClient.GreenNotify("🎉 Got Double Wins Potion")
                    NotificationClient.GreenNotify("🎉 Got Super Lucky Potion")
                    NotificationClient.GreenNotify("🎉 Got Double Golden Potion")
                else
                    NotificationClient.RedNotify(result.resultText)
                end
            end)
        else
            NotificationClient.RedNotify(Constants.NOTIFICATION.WAIT)
        end
    end)

   
    local OnlineRewardService = Knit.GetService("OnlineRewardService")

    if not playerData.EventRewardClaimLog[Constants.EVENT_REWARD_ID.STARTER_PACK] then
        if playerData.StarterPackTaskDown then
            self:UpdateProgress(true)
            -- self:UpdateHomeButton(true)
        else
            OnlineRewardService:GetOnlineStartTime():andThen(function(startTime)
                onlineStartTime = startTime
                packTimer = Timer.new(1)
                packTimer.Tick:Connect(function()

                    if (os.time() - startTime) > Constants.ONLINE_STARTER_PACK_TIME then
                        playerData.StarterPackTaskDown = true
                        -- Knit.GetService("OnlineRewardService").CompleteStarterPackTask:Fire()
                        self:UpdateProgress(true)
                        -- self:UpdateHomeButton(true)
                        packTimer:Destroy()
                    else
                        self:UpdateProgress(false)
                        -- self:UpdateHomeButton(false)
                    end
                end)
                packTimer:Start()
            end)
        end
    end
end

return StarterPackGuiController
