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
local ValentineDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.ValentineDailyRewardsDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local ValentineDailyRewardGui = PlayerGui:WaitForChild("ValentineDailyRewardGui")
local CloseButton = ValentineDailyRewardGui.Frame.CloseButton

local RewardTemplate = ValentineDailyRewardGui.Frame.ScrollingFrame.RewardTemplate

local ValentineDailyRewardGuiController = Knit.CreateController {
    Name = "ValentineDailyRewardGuiController",
}

function ValentineDailyRewardGuiController:OpenGui()
    GuiAnimation.OpenGui(ValentineDailyRewardGui)
end

function ValentineDailyRewardGuiController:CloseGui()
    GuiAnimation.CloseGui(ValentineDailyRewardGui)
end

function ValentineDailyRewardGuiController:IsOpen(): boolean
    return ValentineDailyRewardGui.Enabled
end

function ValentineDailyRewardGuiController:Init()
    for _, item in pairs(ValentineDailyRewardGui.Frame.ScrollingFrame:GetChildren()) do
        if item.Name:match("Template") then
            item.Visible = false
        end
    end
end

function ValentineDailyRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 15 do
        local rewardClone = RewardTemplate:Clone()

        rewardClone.Parent = ValentineDailyRewardGui.Frame.ScrollingFrame
        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        rewardClone.DayLabel.Text = "Day " .. index
        rewardClone.NameLabel.Text = ValentineDailyRewardsDataHelper.GetItemNameByDayIndex(index)
        rewardClone.ImageLabel.Image = "rbxassetid://" .. ValentineDailyRewardsDataHelper.GetIconIdByDayIndex(index)

        ButtonAnimation.SetUp(rewardClone.ClaimButton, 1.1)
        ButtonAnimation.SetUp(rewardClone.ClaimedButton, 1.1)
        ButtonAnimation.SetUp(rewardClone.DayButton, 1.1)

        rewardClone.ClaimButton.Activated:Connect(function()
            local ValentineDailyRewardService = Knit.GetService("ValentineDailyRewardService")
            ValentineDailyRewardService.ClaimRewardEvent:Fire(index)
        end)

        -- rewardClone.ClaimedButton.Activated:Connect(function()
        --     NotificationClient.WhiteNotify("💡 Already claimed!")
        -- end)

        -- rewardClone.DayButton.Activated:Connect(function()
        --     NotificationClient.WhiteNotify("💡 Not completed!")
        -- end)

        self:UpdateReward(index)
    end
end

function ValentineDailyRewardGuiController:UpdateReward(index: number)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found"); return end

    local reward = ValentineDailyRewardGui.Frame.ScrollingFrame:FindFirstChild(tostring(index))
    if not reward then return end

    if playerData.ValentineDailyRewards[index].CompleteDate == nil then
        reward.ClaimButton.Visible = false
        reward.ClaimedButton.Visible = false
        reward.DayButton.Visible = true
        reward.DayButton.NameLabel.Text = "Day " .. index
    else
        reward.ClaimButton.Visible = not playerData.ValentineDailyRewards[index].IsClaimed
        reward.ClaimedButton.Visible = playerData.ValentineDailyRewards[index].IsClaimed
        reward.DayButton.Visible = false
    end
end

-- local function autoOpenWhenLogin()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("Player data not found") return end

--     for index = 1, 15 do
--         if playerData.LongDailyRewards[index].CompleteDate ~= nil and not playerData.LongDailyRewards[index].IsClaimed then
--             ValentineDailyRewardGuiController:OpenGui()
--             return
--         end
--     end
-- end

local function updateValentineDailyNotif()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found"); return end

    local isCompleteToday = false
    for index = 1, 15 do
        if playerData.ValentineDailyRewards[index].CompleteDate ~= nil and not playerData.ValentineDailyRewards[index].IsClaimed then
            isCompleteToday = true
        end
    end

    Knit.GetController("HomeGuiController"):ShowValentineDailyNotif(isCompleteToday)
end

function ValentineDailyRewardGuiController:KnitInit()
end

function ValentineDailyRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		ValentineDailyRewardGui.Enabled = false
		return
	end
    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    -- BottomCloseButton.Activated:Connect(function()
    --     self:CloseGui()
    -- end)

    local ValentineDailyRewardService = Knit.GetService("ValentineDailyRewardService")
    ValentineDailyRewardService.CompleteDailyRewardEvent:Connect(function(index, completeDate)
        task.delay(0, function()
            self:UpdateReward(index)
            updateValentineDailyNotif()
        end)
    end)

    -- -- LongDailyRewardService.ClaimFail:Connect(function(resultText)
    -- --     NotificationClient.RedNotify(resultText)
    -- -- end)

    ValentineDailyRewardService.ClaimRewardEvent:Connect(function(index, isSuccess, resultText)
        task.delay(0, function()
            self:UpdateReward(index)
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
            else
                NotificationClient.RedNotify(resultText)
            end
            updateValentineDailyNotif()
        end)
    end)

    self:Init()
    self:GenerateRewardsList()
    updateValentineDailyNotif()

    GuiUtil.AutoResizeScrollingFrame(ValentineDailyRewardGui)
end

return ValentineDailyRewardGuiController
