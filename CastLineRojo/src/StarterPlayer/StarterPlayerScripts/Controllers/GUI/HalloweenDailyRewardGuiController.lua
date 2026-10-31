local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Template = require(ReplicatedStorage.PlayerData.Template)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
-- local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Constants = require(ReplicatedStorage.Modules.Constants)
-- local DistanceDetectClient = require(ReplicatedStorage.Modules.DistanceDetectClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local OnlineRewardsDataHelper = require(ReplicatedFirst.DataHelpers.OnlineRewardsDataHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local HalloweenDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.HalloweenDailyRewardsDataHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local HalloweenDailyRewardGui = PlayerGui:WaitForChild("HalloweenDailyRewardGui")
local CloseButton = HalloweenDailyRewardGui.Frame.CloseButton

local NomalTemplate = HalloweenDailyRewardGui.Frame.RewardsFrame.NomalTemplate

local HalloweenDailyRewardGuiController = Knit.CreateController {
    Name = "HalloweenDailyRewardGuiController",
}

function HalloweenDailyRewardGuiController:OpenGui()
    if HalloweenDailyRewardGui.Enabled then return end

    GuiAnimation.OpenGui(HalloweenDailyRewardGui)
end

function HalloweenDailyRewardGuiController:CloseGui()
    GuiAnimation.CloseGui(HalloweenDailyRewardGui)
end

function HalloweenDailyRewardGuiController:IsOpen(): boolean
    return HalloweenDailyRewardGui.Enabled
end

function HalloweenDailyRewardGuiController:Init()
    -- NomalTemplate.Visible = false
    -- PetTemplate.Visible = false
    for _, item in pairs(HalloweenDailyRewardGui.Frame.RewardsFrame:GetChildren()) do
        if item:IsA("Frame") then
            item.Visible = false
        end
    end
end

function HalloweenDailyRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 6 do
        local itemType = HalloweenDailyRewardsDataHelper.GetItemTypeByDayIndex(index)

        local rewardClone = NomalTemplate:Clone()
        rewardClone.Parent = HalloweenDailyRewardGui.Frame.RewardsFrame
        rewardClone.ItemImage.Image = "rbxassetid://" .. HalloweenDailyRewardsDataHelper.GetIconIdByDayIndex(index)

        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        rewardClone.NameLabel.Text = HalloweenDailyRewardsDataHelper.GetItemNameByDayIndex(index)
        if itemType == "Wins" then
            rewardClone.AmountLabel.Text = "x" .. NumberUtil.FormatWinsAmount(HalloweenDailyRewardsDataHelper.GetItemCountByDayIndex(index))
        else
            rewardClone.AmountLabel.Text = "x" .. HalloweenDailyRewardsDataHelper.GetItemCountByDayIndex(index)
        end
        ButtonAnimation.SetUp(rewardClone.ClaimButton)

        rewardClone.ClaimButton.Activated:Connect(function()
            if playerData.HalloweenDailyRewards[index].CompleteDate == nil then
                NotificationClient.RedNotify("Not completed!")
            else
                if playerData.HalloweenDailyRewards[index].IsClaimed == true then
                    NotificationClient.RedNotify("Already claimed!")
                else
                    local HalloweenDailyRewardService = Knit.GetService("HalloweenDailyRewardService")
                    HalloweenDailyRewardService.ClaimRewardEvent:Fire(index)
                end
            end
        end)
    end

    -- 7th day reward
    HalloweenDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Activated:Connect(function()
        if playerData.HalloweenDailyRewards[7].CompleteDate == nil then
            NotificationClient.RedNotify("Not completed!")
            return
        end

        if playerData.HalloweenDailyRewards[7].IsClaimed == true then
            NotificationClient.RedNotify("Already claimed!")
            return
        end

        local HalloweenDailyRewardService = Knit.GetService("HalloweenDailyRewardService")
        HalloweenDailyRewardService.ClaimRewardEvent:Fire(7)
    end)
end

function HalloweenDailyRewardGuiController:UpdateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 6 do
        local frame = HalloweenDailyRewardGui.Frame.RewardsFrame:FindFirstChild(tostring(index))
        if not frame then return end

        if playerData.HalloweenDailyRewards[index].CompleteDate == nil then
            frame.ClaimButton.Visible = false
            frame.DayLabel.Visible = true
            frame.DayLabel.Text = "Day " .. index
        
        else
            if playerData.HalloweenDailyRewards[index].IsClaimed == true then
                frame.ClaimButton.Visible = false
                frame.DayLabel.Visible = true
                frame.DayLabel.Text = "Claimed"
            else
                frame.ClaimButton.Visible = true
                frame.DayLabel.Visible = false
            end
        end
    end

    -- greatsword
    if playerData.HalloweenDailyRewards[7].CompleteDate == nil then
        HalloweenDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
        HalloweenDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
        HalloweenDailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Day 7"
    
    else
        if playerData.HalloweenDailyRewards[7].IsClaimed == true then
            HalloweenDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
            HalloweenDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
            HalloweenDailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Claimed"
        else
            HalloweenDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = true
            HalloweenDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = false
        end
    end
end

local function canClaim()
    local playerData = PlayerDataController:GetData()
    if not playerData then return false end

    local idRewardOk = false
    for index = 1, 7 do
        if playerData.HalloweenDailyRewards[index].CompleteDate ~= nil and playerData.HalloweenDailyRewards[index].IsClaimed == false then
            idRewardOk = true
            break
        end
    end

    return idRewardOk
end

function HalloweenDailyRewardGuiController:KnitInit()
    -- LogHelper.Print("HalloweenDailyRewardGuiController initialized")
end

function HalloweenDailyRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		HalloweenDailyRewardGui.Enabled = false
		return
	end
    -- LogHelper.Print("HalloweenDailyRewardGuiController started")

    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    local HalloweenDailyRewardService = Knit.GetService("HalloweenDailyRewardService")
    HalloweenDailyRewardService.ClaimRewardEvent:Connect(function(index, isSuccess, resultText)
        task.delay(0, function()
            self:UpdateGui()
            if resultText ~= nil then
                if isSuccess then
                    NotificationClient.GreenNotify(resultText)
                else
                    NotificationClient.RedNotify(resultText)
                end
            end
        end)
    end)

    HalloweenDailyRewardService.CompleteDailyRewardEvent:Connect(function(index, completeDate)
        task.delay(0, function()
            self:UpdateGui()
        end)
        -- if canClaim() then
        --     self:OpenGui()
        -- end
    end)

    self:Init()
    self:GenerateRewardsList()

    self:UpdateGui()
    -- if canClaim() then
    --     self:OpenGui()
    -- end
end

return HalloweenDailyRewardGuiController
