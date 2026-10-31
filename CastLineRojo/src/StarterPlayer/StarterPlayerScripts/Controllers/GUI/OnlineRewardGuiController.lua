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
local OnlineRewardsDataHelper = require(ReplicatedFirst.DataHelpers.OnlineRewardsDataHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local OnlineRewardGui = PlayerGui:WaitForChild("OnlineRewardGui")
local CloseButton = OnlineRewardGui.Frame.CloseButton
local SkipAllButton = OnlineRewardGui.Frame.SkipAllButton

local NormalTemplate = OnlineRewardGui.Frame.RewardsFrame.NormalTemplate
local DiamondTemplate = OnlineRewardGui.Frame.RewardsFrame.DiamondTemplate
local PetTemplate = OnlineRewardGui.Frame.RewardsFrame.PetTemplate
local Pet2Template = OnlineRewardGui.Frame.RewardsFrame.Pet2Template
local PotionTemplate = OnlineRewardGui.Frame.RewardsFrame.PotionTemplate
local Potion2Template = OnlineRewardGui.Frame.RewardsFrame.Potion2Template

local RewardsLayoutList = {
    NormalTemplate, NormalTemplate, NormalTemplate, NormalTemplate,
    NormalTemplate, PetTemplate, DiamondTemplate, PotionTemplate,
    PetTemplate, PotionTemplate, Potion2Template, Pet2Template,
}

local isInResetting = nil

local OnlineRewardGuiController = Knit.CreateController {
    Name = "OnlineRewardGuiController",
    _RebirthsWhenLogin = 0,
    _OnlineStartTime = nil,
    -- _OnlineRewards = {},
}

function OnlineRewardGuiController:OpenOnlineRewardGui()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then return end
	GuiAnimation.OpenGui(OnlineRewardGui)
end

function OnlineRewardGuiController:CloseOnlineRewardGui()
    GuiAnimation.CloseGui(OnlineRewardGui)
end

function OnlineRewardGuiController:IsOpen(): boolean
    return OnlineRewardGui.Enabled
end

function OnlineRewardGuiController:Init(rebirth, startTime, onlineRewards)
    self._OnlineStartTime = startTime
    self._RebirthsWhenLogin = rebirth
    -- self._OnlineRewards = onlineRewards

    NormalTemplate.Visible = false
    DiamondTemplate.Visible = false
    PetTemplate.Visible = false
    Pet2Template.Visible = false
    PotionTemplate.Visible = false
    Potion2Template.Visible = false

    NormalTemplate.Button.NameLabel.Visible = false
    DiamondTemplate.Button.NameLabel.Visible = false
end

function OnlineRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index, template in ipairs(RewardsLayoutList) do
        local rewardClone = template:Clone()
        rewardClone.Parent = OnlineRewardGui.Frame.RewardsFrame
        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        
        local itemType = OnlineRewardsDataHelper.GetItemTypeByRebirth(self._RebirthsWhenLogin, index)
        local itemId = OnlineRewardsDataHelper.GetItemIdByRebirth(self._RebirthsWhenLogin, index)

        local image = nil
        if itemType == "Strength" then
            image = Constants.IMAGE.STRENGTH_ICON
        elseif itemType == "Wins" then
            image = Constants.IMAGE.WINS_ICON
        elseif itemType == "Diamonds" then
            image = Constants.IMAGE.DIAMOND_ICON
		elseif itemType == "Potion" then
			local potionId = OnlineRewardsDataHelper.GetItemIdByRebirth(self._RebirthsWhenLogin, index)
			local purchaseId = potionId
			local purchaseData = PurchaseDataHelper.GetData(purchaseId)
			if not purchaseData or not purchaseData.IconId or not purchaseData.Name then
				rewardClone:Destroy()
				continue
			end
			image = purchaseData.IconId

			rewardClone.Button.NameLabel.Text = purchaseData.Name
            rewardClone.Button.NameLabel.Visible = true
        else
            warn("Item type wrong!", itemType)
            rewardClone:Destroy()
            continue
        end
        rewardClone.Button.ItemImage.Image = image
        if itemType == "Wins" then
            rewardClone.Button.AmountLabel.Text = "x" .. NumberUtil.FormatWinsAmount(OnlineRewardsDataHelper.GetItemCountByRebirth(playerData.Rebirths, index))
        else
            rewardClone.Button.AmountLabel.Text = "x" .. FormatNumberSimple.FormatCompact((OnlineRewardsDataHelper.GetItemCountByRebirth(playerData.Rebirths, index)))
        end

        ButtonAnimation.SetUp(rewardClone.Button, 1.1)

        rewardClone.Button.Activated:Connect(function()
            -- if self._OnlineRewards[index] then
            if playerData.OnlineRewardsClaimLog[index] then
                NotificationClient.RedNotify("Already claimed!")
            else
                -- if os.time() - self._OnlineStartTime < Constants.ONLINE_REWARDS_TIME[index] then
                --     NotificationClient.RedNotify("Not enough online time!")
                -- else
                local OnlineRewardService = Knit.GetService("OnlineRewardService")
                OnlineRewardService.ClaimOnlineReward:Fire(index)
                -- end
            end
        end)
    end
end

function OnlineRewardGuiController:ResetOnlineRewards(rebirth: number, onlineStartTime: number, onlineRewards: {})
    isInResetting = true
    self._RebirthsWhenLogin = rebirth
    self._OnlineStartTime = onlineStartTime
    -- self._OnlineRewards = onlineRewards

    for _, frame in OnlineRewardGui.Frame.RewardsFrame:GetChildren() do
        -- if frame:IsA("Frame") and frame.Name ~= "NormalTemplate" and frame.Name ~= "DiamondTemplate" and frame.Name ~= "PetTemplate" and frame.Name ~= "YellowPetTemplate" then
        if frame:IsA("Frame") and not frame.Name:match("Template") then
            frame:Destroy()
        end
    end

    self:GenerateRewardsList()

    isInResetting = false
end

function OnlineRewardGuiController:UpdateOnlineRewardGui()
    if isInResetting then return end

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    if not self._OnlineStartTime then return end

    for index = 1, 12 do
        local frame = OnlineRewardGui.Frame.RewardsFrame:FindFirstChild(tostring(index))
        if not frame then return end

        if os.time() - self._OnlineStartTime  < Constants.ONLINE_REWARDS_TIME[index] then
        -- if os.time() - self._OnlineStartTime + playerData.OnlineRewardsKeepTime < Constants.ONLINE_REWARDS_TIME[index] then
            frame.Button.ClaimLabel.Visible = false
            -- frame.Button.ClaimedLabel.Visible = false
            -- frame.Button.ClaimedImage.Visible = false
            frame.Button.ClaimedCover.Visible = false
            frame.Button.TimeLabel.Visible = true
            -- frame.Button.TimeLabel.Text = NumberUtil.ConvertToAutoHMS(Constants.ONLINE_REWARDS_TIME[index] - (os.time() - self._OnlineStartTime + playerData.OnlineRewardsKeepTime))
            frame.Button.TimeLabel.Text = NumberUtil.ConvertToAutoHMS(Constants.ONLINE_REWARDS_TIME[index] - (os.time() - self._OnlineStartTime))
        else
            frame.Button.ClaimLabel.Visible = true
            frame.Button.TimeLabel.Visible = false

            -- if self._OnlineRewards[index] == true then
            if playerData.OnlineRewardsClaimLog[index] == true then
                -- frame.Button.ClaimedLabel.Visible = true
                frame.Button.ClaimLabel.Visible = false
                -- frame.Button.ClaimedImage.Visible = true
                frame.Button.ClaimedCover.Visible = true
            else

                -- frame.Button.ClaimedLabel.Visible = false
                frame.Button.ClaimLabel.Visible = true
                -- frame.Button.ClaimedImage.Visible = false
                frame.Button.ClaimedCover.Visible = false
            end
        end
    end
end

function OnlineRewardGuiController:UpdateHomeButton()
    if isInResetting then return end

    if not self._OnlineStartTime then return end

    local HomeGuiController = Knit.GetController("HomeGuiController")

    local isRewardReady = false
    local readyCount = 0
    local nextRewardTime = 0

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 12 do
        -- if self._OnlineRewards[index] == true then continue end
        if playerData.OnlineRewardsClaimLog[index] == true then continue end

        --  if os.time() - self._OnlineStartTime + playerData.OnlineRewardsKeepTime >= Constants.ONLINE_REWARDS_TIME[index] then
        if os.time() - self._OnlineStartTime >= Constants.ONLINE_REWARDS_TIME[index] then
            isRewardReady = true
            readyCount += 1
         else
            if nextRewardTime == 0 then
                nextRewardTime = Constants.ONLINE_REWARDS_TIME[index]
            else
                nextRewardTime = math.min(nextRewardTime, Constants.ONLINE_REWARDS_TIME[index])
            end
        end
    end

    if isRewardReady then
        HomeGuiController:UpdateOnlineRewardButton("CLAIM!", readyCount)
    else
        if nextRewardTime == 0 then
            HomeGuiController:UpdateOnlineRewardButton("FREE!")
        else
            HomeGuiController:UpdateOnlineRewardButton(NumberUtil.ConvertToAutoHMS(nextRewardTime - (os.time() - self._OnlineStartTime)))
        end
    end
end

function OnlineRewardGuiController:KnitInit()
end

function OnlineRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		OnlineRewardGui.Enabled = false
		return
	end

	CloseButton.Activated:Connect(function()
        self:CloseOnlineRewardGui()
    end)

    SkipAllButton.Activated:Connect(function()
        local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SKIP_ONLINE_REWARDS)
        MarketplaceService:PromptProductPurchase(localPlayer, productId)
    end)

    local OnlineRewardService = Knit.GetService("OnlineRewardService")
    OnlineRewardService.ClaimOnlineReward:Connect(function(index: number, isSuccess: boolean, resultText: string)
        task.delay(0, function()
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
                -- self._OnlineRewards[index] = true
                local playerData = PlayerDataController:GetData()

                self:UpdateOnlineRewardGui()
            else
                NotificationClient.RedNotify(resultText)
            end
        end)
    end)

    OnlineRewardService.ResetOnlineRewards:Connect(function(rebirth: number, onlineStartTime: number, onlineRewards: {})
        task.delay(0, function()
            -- self:ResetOnlineRewards(rebirth, onlineStartTime, onlineRewards)
            self:ResetOnlineRewards(0, onlineStartTime, onlineRewards)
            self:UpdateOnlineRewardGui()
            NotificationClient.WhiteNotify("🔔 Online Gift Reset!")
        end)
    end)

    OnlineRewardService.SkipOnlineRewards:Connect(function(startTime: number)
        self._OnlineStartTime = startTime
        self:UpdateOnlineRewardGui()
    end)

    PlayerDataController:GetData()  -- just to make sure it's loaded
    OnlineRewardService:GetOnlineRewardData():andThen(function(rebirth, startTime, onlineRewards)

        self:Init(0, startTime, onlineRewards)
        self:GenerateRewardsList()

        task.spawn(function()
            while true do
                self:UpdateOnlineRewardGui()
                self:UpdateHomeButton()
                task.wait(1)
            end
        end)
    end)

end

return OnlineRewardGuiController
