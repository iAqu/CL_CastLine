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
local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local OnlineRewardsDataHelper = require(ReplicatedFirst.DataHelpers.OnlineRewardsDataHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local HareDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.HareDailyRewardsDataHelper)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local HareDailyRewardGui = PlayerGui:WaitForChild("HareDailyRewardGui")
local CloseButton = HareDailyRewardGui.Frame.CloseButton

local NomalTemplate = HareDailyRewardGui.Frame.RewardsFrame.NomalTemplate

local HareDailyRewardGuiController = Knit.CreateController {
    Name = "HareDailyRewardGuiController",
}

function HareDailyRewardGuiController:OpenGui()
    if HareDailyRewardGui.Enabled then return end
    GuiAnimation.OpenGui(HareDailyRewardGui)

    SoundHelper.PlaySound(ReplicatedStorage.Sound.Gui.Gui_Hare_Event_Open)
    SoundHelper.PlaySound(ReplicatedStorage.Sound.Animal.Hare)
end

function HareDailyRewardGuiController:CloseGui()
    GuiAnimation.CloseGui(HareDailyRewardGui)
end

function HareDailyRewardGuiController:IsOpen(): boolean
    return HareDailyRewardGui.Enabled
end

function HareDailyRewardGuiController:Init()
    -- NomalTemplate.Visible = false
    -- PetTemplate.Visible = false
    for _, item in pairs(HareDailyRewardGui.Frame.RewardsFrame:GetChildren()) do
        if item:IsA("Frame") then
            item.Visible = false
        end
    end
end

local function initHareEventMachine()
    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local items = areaRoot:FindFirstChild("Items")
        if not items then return end

        local hareEventMachine = items:FindFirstChild("HareEventMachine")
        if not hareEventMachine then return end

        if not hareEventMachine.PrimaryPart then
            warn("HareEventMachine has no PrimaryPart")
            return
        end

        if not Constants.DEBUG then
            hareEventMachine.PrimaryPart.Transparency = 1
        end

        local prompt = hareEventMachine.PrimaryPart:FindFirstChild("ProximityPrompt")
        if not prompt then
            warn("HareEventMachine has no ProximityPrompt")
            return
        end

        prompt.Triggered:Connect(function(player)
            if player == localPlayer then
                HareDailyRewardGuiController:OpenGui()
            end
        end)
    end)
end

function HareDailyRewardGuiController:GenerateRewardsList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    for index = 1, 6 do
        local rewardClone = NomalTemplate:Clone()
        rewardClone.Parent = HareDailyRewardGui.Frame.RewardsFrame
        rewardClone.ItemImage.Image = "rbxassetid://" .. HareDailyRewardsDataHelper.GetIconIdByDayIndex(index)

        rewardClone.Visible = true
        rewardClone.Name = index
        rewardClone.LayoutOrder = index
        rewardClone.NameLabel.Text = HareDailyRewardsDataHelper.GetItemNameByDayIndex(index)
        rewardClone.AmountLabel.Text = "x" .. HareDailyRewardsDataHelper.GetItemCountByDayIndex(index)
        ButtonAnimation.SetUp(rewardClone.ClaimButton)

        rewardClone.ClaimButton.Activated:Connect(function()
            if playerData.HareDailyRewards[index].CompleteDate == nil then
                NotificationClient.RedNotify("Not completed!")
            else
                if playerData.HareDailyRewards[index].IsClaimed == true then
                    NotificationClient.RedNotify("Already claimed!")
                else
                    local HareDailyRewardService = Knit.GetService("HareDailyRewardService")
                    HareDailyRewardService.ClaimDailyReward:Fire(index)
                end
            end
        end)
    end

    -- 7th day reward
    HareDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Activated:Connect(function()
        if playerData.HareDailyRewards[7].CompleteDate == nil then
            NotificationClient.RedNotify("Not completed!")
            return
        end

        if playerData.HareDailyRewards[7].IsClaimed == true then
            NotificationClient.RedNotify("Already claimed!")
            return
        end

        local HareDailyRewardService = Knit.GetService("HareDailyRewardService")
        HareDailyRewardService.ClaimDailyReward:Fire(7)
    end)
end

function HareDailyRewardGuiController:UpdateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local isDailyRewardAvailable = false

    for index = 1, 6 do
        local frame = HareDailyRewardGui.Frame.RewardsFrame:FindFirstChild(tostring(index))
        if not frame then return end

        if playerData.HareDailyRewards[index].CompleteDate == nil then
            frame.ClaimButton.Visible = false
            frame.DayLabel.Visible = true
            frame.DayLabel.Text = "Day " .. index
        
        else
            if playerData.HareDailyRewards[index].IsClaimed == true then
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
    if playerData.HareDailyRewards[7].CompleteDate == nil then
        HareDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
        HareDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
        HareDailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Day 7"
    
    else
        if playerData.HareDailyRewards[7].IsClaimed == true then
            HareDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = false
            HareDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = true
            HareDailyRewardGui.Frame.LastRewardFrame.DayLabel.Text = "Claimed"
        else
            HareDailyRewardGui.Frame.LastRewardFrame.ClaimButton.Visible = true
            HareDailyRewardGui.Frame.LastRewardFrame.DayLabel.Visible = false
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
        if playerData.HareDailyRewards[index].CompleteDate ~= nil and playerData.HareDailyRewards[index].IsClaimed == false then
            idRewardOk = true
            break
        end
    end

    return idRewardOk
end

function HareDailyRewardGuiController:KnitInit()
    -- LogHelper.Print("HareDailyRewardGuiController initialized")

    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(function()
        initHareEventMachine()
    end)
end

function HareDailyRewardGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		HareDailyRewardGui.Enabled = false
		return
	end
    -- LogHelper.Print("HareDailyRewardGuiController started")

    CloseButton.Activated:Connect(function()
        self:CloseGui()
    end)

    local HareDailyRewardService = Knit.GetService("HareDailyRewardService")
    HareDailyRewardService.ClaimDailyReward:Connect(function(index, isSuccess, resultText)
        task.delay(0, function()
            self:UpdateGui()
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
            else
                NotificationClient.RedNotify(resultText)
            end
        end)
    end)

    HareDailyRewardService.CompleteDailyReward:Connect(function(index, completeDate)
        self:UpdateGui()
        -- if canClaim() then
        --     self:OpenGui()
        -- end
    end)

    self:Init()
    self:GenerateRewardsList()
    initHareEventMachine()

    self:UpdateGui()
    -- if canClaim() then
    --     self:OpenGui()
    -- end
end

return HareDailyRewardGuiController
