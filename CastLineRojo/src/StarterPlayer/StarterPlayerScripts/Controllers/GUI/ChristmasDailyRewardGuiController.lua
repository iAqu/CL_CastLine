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
local ChristmasDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.ChristmasDailyRewardsDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local ChristmasDailyRewardGui = PlayerGui:WaitForChild("ChristmasDailyRewardGui")
local CloseButton = ChristmasDailyRewardGui.Frame.CloseButton
local BottomCloseButton = ChristmasDailyRewardGui.Frame.BottomCloseButton

local RewardTemplate = ChristmasDailyRewardGui.Frame.ScrollingFrame.RewardTemplate

local ChristmasDailyRewardGuiController = Knit.CreateController {
    Name = "ChristmasDailyRewardGuiController",
}

function ChristmasDailyRewardGuiController:OpenGui()
    GuiAnimation.OpenGui(ChristmasDailyRewardGui)
end

function ChristmasDailyRewardGuiController:CloseGui()
    GuiAnimation.CloseGui(ChristmasDailyRewardGui)
end

function ChristmasDailyRewardGuiController:IsOpen(): boolean
    return ChristmasDailyRewardGui.Enabled
end

function ChristmasDailyRewardGuiController:Init()
    for _, item in pairs(ChristmasDailyRewardGui.Frame.ScrollingFrame:GetChildren()) do
        if item.Name:match("Template") then
            item.Visible = false
        end
    end
end

function ChristmasDailyRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 15 do
        local rewardClone = RewardTemplate:Clone()

        rewardClone.Parent = ChristmasDailyRewardGui.Frame.ScrollingFrame
        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        rewardClone.DayLabel.Text = "Day " .. index
        rewardClone.NameLabel.Text = ChristmasDailyRewardsDataHelper.GetItemNameByDayIndex(index)
        rewardClone.ImageLabel.Image = "rbxassetid://" .. ChristmasDailyRewardsDataHelper.GetIconIdByDayIndex(index)

        ButtonAnimation.SetUp(rewardClone.ClaimButton, 1.1)
        ButtonAnimation.SetUp(rewardClone.ClaimedButton, 1.1)
        ButtonAnimation.SetUp(rewardClone.DayButton, 1.1)

        rewardClone.ClaimButton.Activated:Connect(function()
            local ChristmasDailyRewardService = Knit.GetService("ChristmasDailyRewardService")
            ChristmasDailyRewardService.ClaimRewardEvent:Fire(index)
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

function ChristmasDailyRewardGuiController:UpdateReward(index: number)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local reward = ChristmasDailyRewardGui.Frame.ScrollingFrame:FindFirstChild(tostring(index))
    if not reward then return end

    if playerData.ChristmasDailyRewards[index].CompleteDate == nil then
        reward.ClaimButton.Visible = false
        reward.ClaimedButton.Visible = false
        reward.DayButton.Visible = true
        reward.DayButton.NameLabel.Text = "Day " .. index
    else
        reward.ClaimButton.Visible = not playerData.ChristmasDailyRewards[index].IsClaimed
        reward.ClaimedButton.Visible = playerData.ChristmasDailyRewards[index].IsClaimed
        reward.DayButton.Visible = false
    end
end

-- local function autoOpenWhenLogin()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("Player data not found") return end

--     for index = 1, 15 do
--         if playerData.LongDailyRewards[index].CompleteDate ~= nil and not playerData.LongDailyRewards[index].IsClaimed then
--             ChristmasDailyRewardGuiController:OpenGui()
--             return
--         end
--     end
-- end

function ChristmasDailyRewardGuiController:KnitInit()
end

function ChristmasDailyRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		ChristmasDailyRewardGui.Enabled = false
		return
	end
    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    -- BottomCloseButton.Activated:Connect(function()
    --     self:CloseGui()
    -- end)

    local ChristmasDailyRewardService = Knit.GetService("ChristmasDailyRewardService")
    ChristmasDailyRewardService.CompleteDailyRewardEvent:Connect(function(index, completeDate)
        task.delay(0, function()
            self:UpdateReward(index)
        end)
    end)

    -- -- LongDailyRewardService.ClaimFail:Connect(function(resultText)
    -- --     NotificationClient.RedNotify(resultText)
    -- -- end)

    ChristmasDailyRewardService.ClaimRewardEvent:Connect(function(index, isSuccess, resultText)
        task.delay(0, function()
            self:UpdateReward(index)
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
            else
                NotificationClient.RedNotify(resultText)
            end
        end)
    end)

    -- LongDailyRewardService.ResetAllRewards:Connect(function(longDailyRewards: {})
    --     for index = 1, 15 do
    --         self:UpdateReward(index)
    --     end
    --     NotificationClient.GreenNotify("🎉 All rewards reset!")
    -- end)

    self:Init()
    self:GenerateRewardsList()

    GuiUtil.AutoResizeScrollingFrame(ChristmasDailyRewardGui)
end

return ChristmasDailyRewardGuiController
