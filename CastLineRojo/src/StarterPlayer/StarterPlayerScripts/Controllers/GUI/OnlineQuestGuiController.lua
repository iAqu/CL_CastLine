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
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local HoverGuiClient = require(ReplicatedStorage.Modules.HoverGuiClient)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local OnlineQuestGui = PlayerGui:WaitForChild("OnlineQuestGui")
local CloseButton = OnlineQuestGui.Frame.CloseButton
local Buy3Button = OnlineQuestGui.Frame.Buy3Button
local Buy10Button = OnlineQuestGui.Frame.Buy10Button
local ClaimButton = OnlineQuestGui.Frame.ClaimButton
local TimeProgressFrame = OnlineQuestGui.Frame.TimeFrame.TimeProgressFrame
local IconFrame = OnlineQuestGui.Frame.IconFrame

local HoverInfoFrame = OnlineQuestGui.HoverInfo
local HoverInfoFrame_Exclusive = OnlineQuestGui.HoverInfo_Exclusive

local PROGRESS_BAR_MAX_X = 1
local PROGRESS_BAR_Y = 1

local questStartTime = 0

local OnlineQuestGuiController = Knit.CreateController {
    Name = "OnlineQuestGuiController",
}

local function init()
    HoverInfoFrame.Visible = false
    HoverInfoFrame_Exclusive.Visible = false
end

function OnlineQuestGuiController:OpenGui()
    GuiAnimation.OpenGui(OnlineQuestGui)
    -- self:UpdateProgress()
end

function OnlineQuestGuiController:CloseGui()
    GuiAnimation.CloseGui(OnlineQuestGui)
end

function OnlineQuestGuiController:IsOpen(): boolean
    return OnlineQuestGui.Enabled
end

local function updateProgress(isTaskDown: boolean)
    if isTaskDown then
        TimeProgressFrame.ProgressBar.Size = UDim2.new(PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        TimeProgressFrame.ProgressLabel.Text = "Complete"

    else
        if not questStartTime then return end
        local onlineTime = os.time() - questStartTime
        local percent = math.min(onlineTime / Constants.ONLINE_QUEST_TIME, PROGRESS_BAR_MAX_X)
        TimeProgressFrame.ProgressBar.Size = UDim2.new(percent, 0, PROGRESS_BAR_Y, 0)
        TimeProgressFrame.ProgressLabel.Text = NumberUtil.ConvertToMS(onlineTime) .. "/" .. NumberUtil.ConvertToMS(Constants.ONLINE_QUEST_TIME)
    end
end

local function startUpdateTimer()
    local updateTimer = Timer.new(1)
    updateTimer.Tick:Connect(function()
        local playerData = PlayerDataController:GetData()
        if playerData.OnlineQuestTaskDown == true then
            updateProgress(true)
            Knit.GetController("HomeGuiController"):UpdateOnlineQuestTimeLabel("Ready!")
            return
        else
            if (os.time() - questStartTime) > Constants.ONLINE_QUEST_TIME then
                playerData.OnlineQuestTaskDown = true
                updateProgress(true)
                Knit.GetController("HomeGuiController"):UpdateOnlineQuestTimeLabel("Ready!")
            else
                updateProgress(false)
                local timeString = NumberUtil.ConvertToAutoHMS(Constants.ONLINE_QUEST_TIME - (os.time() - questStartTime))
                Knit.GetController("HomeGuiController"):UpdateOnlineQuestTimeLabel(timeString)
            end
        end
    end)
    updateTimer:Start()
end

local function claimOnlineQuestReward()
    local playerData = PlayerDataController:GetData()
    if playerData.OnlineQuestTaskDown then
        local OnlineRewardService = Knit.GetService("OnlineRewardService")
        OnlineRewardService:ClaimOnlineQuestReward():andThen(function(result)
            if result.isSuccess then
                if result.resultText then
                    NotificationClient.GreenNotify(result.resultText)
                end
                playerData.OnlineQuestTaskDown = false
                questStartTime = os.time()

            else
                if result.resultText then
                    NotificationClient.RedNotify(result.resultText)
                end
            end
        end)
    else
        NotificationClient.RedNotify(Constants.NOTIFICATION.WAIT)
    end
end

function OnlineQuestGuiController:KnitInit()
    -- Buy3Button.Activated:Connect(function()
    --     buyOnlineQuestReward(3)
    -- end)

    -- Buy10Button.Activated:Connect(function()
    --     buyOnlineQuestReward(10)
    -- end)
end

function OnlineQuestGuiController:KnitStart()

    local playerData = PlayerDataController:GetData()  -- just to make sure it's loaded

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(OnlineQuestGui)
    end)

    -- ClaimButton.Activated:Connect(claimOnlineQuestReward)

    -- local OnlineRewardService = Knit.GetService("OnlineRewardService")

    -- if not playerData.EventRewardClaimLog[Constants.EVENT_REWARD_ID.STARTER_PACK] then
        -- if playerData.StarterPackTaskDown then
        --     self:UpdateProgress(true)
        -- else
            -- OnlineRewardService:GetOnlineStartTime():andThen(function(startTime)
            -- OnlineRewardService:GetOnlineQuestStartTime():andThen(function(startTime)
            --     questStartTime = startTime
            --     startUpdateTimer()
                -- updateTimer = Timer.new(1)

                -- updateTimer.Tick:Connect(function()

                --     if (os.time() - startTime) > Constants.ONLINE_QUEST_TIME then
                --         playerData.OnlineQuestTaskDown = true

                --         self:UpdateProgress(true)
                --         -- updateTimer:Destroy()
                --     else
                --         self:UpdateProgress(false)
                --     end
                -- end)
                -- updateTimer:Start()
            -- end)
        -- end
    -- end

    init()
end

return OnlineQuestGuiController