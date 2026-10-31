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
local DailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.DailyRewardsDataHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local DailyRewardGui = PlayerGui:WaitForChild("DailyRewardGui")
local CloseButton = DailyRewardGui.Frame.CloseButton

local NomalTemplate = DailyRewardGui.Frame.RewardsFrame.NomalTemplate

local DailyRewardGuiController = Knit.CreateController {
    Name = "DailyRewardGuiController",
}

function DailyRewardGuiController:OpenGui()
    if DailyRewardGui.Enabled then return end

    GuiAnimation.OpenGui(DailyRewardGui)
end

function DailyRewardGuiController:CloseGui()
    GuiAnimation.CloseGui(DailyRewardGui)
end

function DailyRewardGuiController:IsOpen(): boolean
    return DailyRewardGui.Enabled
end

function DailyRewardGuiController:Init()
    -- NomalTemplate.Visible = false
    -- PetTemplate.Visible = false
    for _, item in pairs(DailyRewardGui.Frame.RewardsFrame:GetChildren()) do
        if item:IsA("Frame") then
            item.Visible = false
        end
    end
end

function DailyRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 6 do
        local itemType = DailyRewardsDataHelper.GetItemTypeByDayIndex(index)
        local itemId = DailyRewardsDataHelper.GetItemIdByDayIndex(index)
        local itemCount = DailyRewardsDataHelper.GetItemCountByDayIndex(index)

        local rewardClone = NomalTemplate:Clone()
        rewardClone.Parent = DailyRewardGui.Frame.RewardsFrame
        if itemType == "Potion" then
            rewardClone.ItemImage.Image = "rbxassetid://" .. PurchaseDataHelper.GetIconId(itemId)
            rewardClone.NameLabel.Text = PurchaseDataHelper.GetName(itemId)

        elseif itemType == "Wins" then
            rewardClone.ItemImage.Image = Constants.IMAGE.WINS_ICON
            rewardClone.NameLabel.Text = NumberUtil.FormatWinsAmount(itemCount) .. " Cash"

        elseif itemType == "Diamond" then
            rewardClone.ItemImage.Image = Constants.IMAGE.DIAMOND_ICON
            rewardClone.NameLabel.Text = "Diamonds"

        else
            warn("Item type wrong!", itemType)
            return
        end

        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        -- rewardClone.Button.AmountLabel.Text = "x" .. DailyRewardsDataHelper.GetItemCountByDayIndex(index)
        -- rewardClone.Button.NameLabel.Text = DailyRewardsDataHelper.GetItemNameByDayIndex(index)
        -- rewardClone.NameLabel.Text = DailyRewardsDataHelper.GetItemNameByDayIndex(index)
        if itemType == "Wins" then
            rewardClone.AmountLabel.Text = "x" .. NumberUtil.FormatWinsAmount(DailyRewardsDataHelper.GetItemCountByDayIndex(index))
        else
            rewardClone.AmountLabel.Text = "x" .. DailyRewardsDataHelper.GetItemCountByDayIndex(index)
        end
        ButtonAnimation.SetUp(rewardClone.ClaimButton)

        rewardClone.ClaimButton.Activated:Connect(function()
            if playerData.DailyRewards[index].CompleteDate == nil then
                NotificationClient.RedNotify("Not completed!")
            else
                if playerData.DailyRewards[index].IsClaimed == true then
                    NotificationClient.RedNotify("Already claimed!")
                else
                    local DailyRewardService = Knit.GetService("DailyRewardService")
                    DailyRewardService.ClaimDailyReward:Fire(index)
                end
            end
        end)
    end

    -- 7th day reward
    DailyRewardGui.Frame.LastRewardFrame.ClaimButton.Activated:Connect(function()
        if playerData.DailyRewards[7].CompleteDate == nil then
            NotificationClient.RedNotify("Not completed!")
            return
        end

        if playerData.DailyRewards[7].IsClaimed == true then
            NotificationClient.RedNotify("Already claimed!")
            return
        end

        local DailyRewardService = Knit.GetService("DailyRewardService")
        DailyRewardService.ClaimDailyReward:Fire(7)
    end)
end

function DailyRewardGuiController:UpdateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local isDailyRewardAvailable = false

    for index = 1, 6 do
        local frame = DailyRewardGui.Frame.RewardsFrame:FindFirstChild(tostring(index))
        if not frame then return end

        if playerData.DailyRewards[index].CompleteDate == nil then
            frame.ClaimButton.Visible = false
            frame.DayLabel.Visible = true
            frame.DayLabel.Text = "Day " .. index
        
        else
            if playerData.DailyRewards[index].IsClaimed == true then
                frame.ClaimButton.Visible = false
                frame.DayLabel.Visible = true
                frame.DayLabel.Text = "Claimed"
            else
                frame.ClaimButton.Visible = true
                frame.DayLabel.Visible = false
                isDailyRewardAvailable = true
            end
        end
    end

    -- greatsword
    if playerData.DailyRewards[7].CompleteDate == nil then
        DailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
        DailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
        DailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Day 7"
    
    else
        if playerData.DailyRewards[7].IsClaimed == true then
            DailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
            DailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
            DailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Claimed"
        else
            DailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = true
            DailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = false
            isDailyRewardAvailable = true
        end
    end

    Knit.GetController("HomeGuiController"):ShowDailyRewardNotif(isDailyRewardAvailable)
end

local function canClaim()
    local playerData = PlayerDataController:GetData()
    if not playerData then return false end

    local idRewardOk = false
    for index = 1, 7 do
        if playerData.DailyRewards[index].CompleteDate ~= nil and playerData.DailyRewards[index].IsClaimed == false then
            idRewardOk = true
            break
        end
    end

    return idRewardOk
end

function DailyRewardGuiController:KnitInit()
    -- LogHelper.Print("DailyRewardGuiController initialized")
end

function DailyRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		DailyRewardGui.Enabled = false
		return
	end
    -- LogHelper.Print("DailyRewardGuiController started")

    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    local DailyRewardService = Knit.GetService("DailyRewardService")
    DailyRewardService.ClaimDailyReward:Connect(function(index, isSuccess, resultText)
        task.delay(0, function()
            self:UpdateGui()
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
            else
                NotificationClient.RedNotify(resultText)
            end
        end)
    end)

    DailyRewardService.CompleteDailyReward:Connect(function(index, completeDate)
        self:UpdateGui()
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

return DailyRewardGuiController
