local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local AchievementsDataHelper = require(ReplicatedFirst.DataHelpers.AchievementsDataHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)
local SeasonQuestsDataHelper = require(ReplicatedFirst.DataHelpers.SeasonQuestsDataHelper)
local SeasonRewardsDataHelper = require(ReplicatedFirst.DataHelpers.SeasonRewardsDataHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local SeasonGui = PlayerGUI:WaitForChild("SeasonGui")
local MainFrame = SeasonGui.Frame
local CloseButton = MainFrame.CloseButton

local QuestsFrame = MainFrame.QuestsFrame
local QuestsDailyFrame = QuestsFrame.DailyFrame
local QuestsWeeklyFrame = QuestsFrame.WeeklyFrame
local DailyQuestTemplate = QuestsDailyFrame.ContentFrame.Template
local WeeklyQuestTemplate = QuestsWeeklyFrame.ContentFrame.Template

local RewardsFrame = MainFrame.RewardsFrame
local PremiumFrame = MainFrame.PremiumFrame

local TabFrame = MainFrame.TabFrame
local PremiumButton = TabFrame.PremiumFrame.PremiumButton
local QuestsButton = TabFrame.QuestsFrame.QuestsButton
local RewardsButton = TabFrame.RewardsFrame.RewardsButton

local RewardTemplate = RewardsFrame.ContentFrame.Template

local PROGRESS_BAR_MAX_X = 1
local PROGRESS_BAR_Y = 1

local LEVEL_COLOR_LOCKED = Color3.fromRGB(0, 75, 113)
local LEVEL_COLOR_UNLOCKED = Color3.fromRGB(34, 255, 0)

local SeasonGuiController = Knit.CreateController {
    Name = "SeasonGuiController",
}

function SeasonGuiController:InitGui()
    RewardsFrame.Visible = true
    QuestsFrame.Visible = false
    PremiumFrame.Visible = false

    for _, frame in QuestsDailyFrame.ContentFrame:GetChildren() do
        if frame:IsA("Frame") and frame.Name:match("Template") then
            frame.Visible = false
        end
    end

    for _, frame in QuestsWeeklyFrame.ContentFrame:GetChildren() do
        if frame:IsA("Frame") and frame.Name:match("Template") then
            frame.Visible = false
        end
    end

    for _, frame in RewardsFrame.ContentFrame:GetChildren() do
        if frame:IsA("Frame") and frame.Name:match("Template") then
            frame.Visible = false
        end
    end
end

function SeasonGuiController:OpenGui()
    GuiAnimation.OpenGui(SeasonGui)
end

function SeasonGuiController:CloseGui()
    GuiAnimation.CloseGui(SeasonGui)
end

function SeasonGuiController:IsOpen()
    return SeasonGui.Enabled
end

function SeasonGuiController:UpdateXpProgress()
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    local currentXp = playerData.SeasonXp
    local currentLevel = SeasonRewardsDataHelper.GetLevelByXp(currentXp)
    if currentLevel >= SeasonRewardsDataHelper.GetMaxLevel() then
        RewardsFrame.ContentFrame.TitleFrame.ProgressFrame.ProgressBar.Size = UDim2.new(PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        RewardsFrame.ContentFrame.TitleFrame.ProgressFrame.ProgressLabel.Text = "Max"
    else
        local currentLevelXp = SeasonRewardsDataHelper.GetLevelXp(currentLevel)
        local nextLevelXp = SeasonRewardsDataHelper.GetLevelXp(currentLevel + 1)
        LogHelper.Print("currentXp: ", currentXp, " currentLevel: ", currentLevel, " currentLevelXp: ", currentLevelXp, " nextLevelXp: ", nextLevelXp)
        local progress = (currentXp - currentLevelXp) / (nextLevelXp - currentLevelXp)
        RewardsFrame.ContentFrame.TitleFrame.ProgressFrame.ProgressBar.Size = UDim2.new(progress*PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        RewardsFrame.ContentFrame.TitleFrame.ProgressFrame.ProgressLabel.Text = (currentXp - currentLevelXp) .. "/" .. (nextLevelXp - currentLevelXp)
    end
end

function SeasonGuiController:UpdateUnlockAllButton()
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    local currentLevel = SeasonRewardsDataHelper.GetLevelByXp(playerData.SeasonXp)
    if currentLevel >= SeasonRewardsDataHelper.GetMaxLevel() then
        RewardsFrame.UnlockAllButton.TextLabel.Text = "Restart Season"
    else
        RewardsFrame.UnlockAllButton.TextLabel.Text = "Unlock All"
    end
end

function SeasonGuiController:UpdatePremiumState()
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    if playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.SEASON_1] == true then
        PremiumFrame.BuyButton.Visible = false
        PremiumFrame.OwnedLabel.Visible = true
    else
        PremiumFrame.BuyButton.Visible = true
        PremiumFrame.OwnedLabel.Visible = false
    end
end

function SeasonGuiController:GenerateRewardList()
    local rewardsData = SeasonRewardsDataHelper.GetAllData()
    for rewardId, _ in pairs(rewardsData) do
        -- local rewardId = seasonRewardData.RewardId
        local clone = RewardTemplate:Clone()
        local level = SeasonRewardsDataHelper.GetLevel(rewardId)
        clone.Name = rewardId
        clone.Visible = true
        clone.Parent = RewardsFrame.ContentFrame
        clone.LayoutOrder = level
        clone.LevelNumber.TextLabel.Text = level
        clone.ZIndex = level * 10
        if level == 20 then clone.LevelBackground.Visible = false end

        clone.FreeFrame.NameLabel.Text = SeasonRewardsDataHelper.GetFreeRewardName(rewardId)
        clone.FreeFrame.ImageLabel.Image = "rbxassetid://" .. SeasonRewardsDataHelper.GetFreeRewardIconId(rewardId)
        local freeRewardItemId = SeasonRewardsDataHelper.GetFreeRewardItemId(rewardId)
        local normalRewardName = SeasonRewardsDataHelper.GetFreeRewardName(rewardId)
        local normalRewardCount = SeasonRewardsDataHelper.GetFreeRewardCount(rewardId)
        if freeRewardItemId == "Wins" or freeRewardItemId == "Strength" then
            -- clone.FreeFrame.AmountLabel.Text = SeasonRewardsDataHelper.GetFreeRewardCount(rewardId)*100 .. "%"
            clone.FreeFrame.NameLabel.Text = normalRewardName .. " x" .. normalRewardCount*100 .. "%"
        else
            -- clone.FreeFrame.AmountLabel.Text = SeasonRewardsDataHelper.GetFreeRewardCount(rewardId)
            clone.FreeFrame.NameLabel.Text = normalRewardName .. " x" .. normalRewardCount
        end
        ButtonAnimation.SetUp(clone.FreeFrame.ClaimButton)
        clone.FreeFrame.ClaimButton.Activated:Connect(function()
            Knit.GetService("SeasonService"):ClaimSeasonReward(false, rewardId):andThen(function(result: {isSuccess: boolean, resultText: string})
                if result.isSuccess then
                    NotificationClient.GreenNotify(result.resultText)
                else
                    NotificationClient.RedNotify(result.resultText)
                end
            end)
        end)
        ButtonAnimation.SetUp(clone.FreeFrame.LockFrame.SkipButton)
        clone.FreeFrame.LockFrame.SkipButton.Activated:Connect(function()
            local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_SKIP_LEVEL)
            MarketplaceService:PromptProductPurchase(localPlayer, productId)
        end)

        clone.PremiumFrame.NameLabel.Text = SeasonRewardsDataHelper.GetPremiumRewardName(rewardId)
        clone.PremiumFrame.ImageLabel.Image = "rbxassetid://" .. SeasonRewardsDataHelper.GetPremiumRewardIconId(rewardId)
        local premiumRewardItemId = SeasonRewardsDataHelper.GetPremiumRewardItemId(rewardId)
        local premiumRewardName = SeasonRewardsDataHelper.GetPremiumRewardName(rewardId)
        local premiumRewardCount = SeasonRewardsDataHelper.GetPremiumRewardCount(rewardId)
        if premiumRewardItemId == "Wins" or premiumRewardItemId == "Strength" then
            clone.PremiumFrame.NameLabel.Text = premiumRewardName .. " x" .. premiumRewardCount*100 .. "%"
        else
            clone.PremiumFrame.NameLabel.Text = premiumRewardName .. " x" .. premiumRewardCount
        end
        ButtonAnimation.SetUp(clone.PremiumFrame.ClaimButton)
        clone.PremiumFrame.ClaimButton.Activated:Connect(function()
            Knit.GetService("SeasonService"):ClaimSeasonReward(true, rewardId):andThen(function(result: {isSuccess: boolean, resultText: string})
                if not result then return end
                if result.isSuccess then
                    NotificationClient.GreenNotify(result.resultText)
                else
                    NotificationClient.RedNotify(result.resultText)
                end
            end)
        end)
        ButtonAnimation.SetUp(clone.PremiumFrame.LockFrame.SkipButton)
        clone.PremiumFrame.LockFrame.SkipButton.Activated:Connect(function()
            local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_SKIP_LEVEL)
            MarketplaceService:PromptProductPurchase(localPlayer, productId)
        end)

        self:UpdateReward(rewardId)
    end
end

function SeasonGuiController:UpdateAllRewards()
    for _, rewardFrame in pairs(RewardsFrame.ContentFrame:GetChildren()) do
        if rewardFrame:IsA("Frame") and rewardFrame.Name:match("Reward") then
            self:UpdateReward(rewardFrame.Name)
        end
    end
end

function SeasonGuiController:UpdateReward(rewardId: string)
    local rewardFrame = RewardsFrame.ContentFrame:FindFirstChild(rewardId)
    if not rewardFrame then return end

    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    local isUnlocked = SeasonRewardsDataHelper.IsUnlocked(playerData, rewardId)
    if isUnlocked then
        rewardFrame.FreeFrame.LockFrame.Visible = false
        rewardFrame.PremiumFrame.LockFrame.Visible = false
        local isFreeRewardClaimed = playerData.SeasonFreeRewardsClaimLog[rewardId]
        rewardFrame.FreeFrame.ClaimButton.Visible = not isFreeRewardClaimed
        -- rewardFrame.FreeFrame.AmountLabel.Visible = isFreeRewardClaimed
        local isPremiumRewardClaimed = playerData.SeasonPremiumRewardsClaimLog[rewardId]
        rewardFrame.PremiumFrame.ClaimButton.Visible = not isPremiumRewardClaimed
        -- rewardFrame.PremiumFrame.AmountLabel.Visible = isPremiumRewardClaimed
        rewardFrame.LevelBackground.BackgroundColor3 = LEVEL_COLOR_UNLOCKED
        rewardFrame.LevelNumber.BackgroundColor3 = LEVEL_COLOR_UNLOCKED
    else
        rewardFrame.FreeFrame.LockFrame.Visible = true
        rewardFrame.FreeFrame.ClaimButton.Visible = false
        -- rewardFrame.FreeFrame.AmountLabel.Visible = true
        rewardFrame.PremiumFrame.LockFrame.Visible = true
        rewardFrame.PremiumFrame.ClaimButton.Visible = false
        -- rewardFrame.PremiumFrame.AmountLabel.Visible = true
        rewardFrame.LevelBackground.BackgroundColor3 = LEVEL_COLOR_LOCKED
        rewardFrame.LevelNumber.BackgroundColor3 = LEVEL_COLOR_LOCKED
    end
end

function SeasonGuiController:GenerateQuestList(type: "Daily" | "Weekly")
    local questsData = type == "Daily" and SeasonQuestsDataHelper.GetDailyQuestsData() or SeasonQuestsDataHelper.GetWeekQuestsData()
    for _, seasonQuestData in pairs(questsData) do
        local questId = seasonQuestData.QuestId
        local clone = type == "Daily" and DailyQuestTemplate:Clone() or WeeklyQuestTemplate:Clone()
        clone.Name = questId
        clone.Visible = true
        clone.Parent = type == "Daily" and QuestsDailyFrame.ContentFrame or QuestsWeeklyFrame.ContentFrame
        clone.LayoutOrder = SeasonQuestsDataHelper.GetLayoutOrder(questId)
        clone.NameLabel.Text = SeasonQuestsDataHelper.GetDescription(questId)
        self:UpdateQuest(type, questId)
    end
end

function SeasonGuiController:UpdateQuest(type: "Daily" | "Weekly", questId: string)
    if not SeasonQuestsDataHelper.GetData(questId) then return end

    local questFrame = type == "Daily" and QuestsDailyFrame.ContentFrame:FindFirstChild(questId) or QuestsWeeklyFrame.ContentFrame:FindFirstChild(questId)
    if not questFrame then return end

    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    local progress = type == "Daily" and playerData.SeasonDailyTasksProgress[questId] or playerData.SeasonWeeklyTasksProgress[questId]
    progress = progress or 0
    local requirementValue = SeasonQuestsDataHelper.GetRequirementValue(questId)

    questFrame.ProgressFrame.ProgressLabel.Text = progress .. "/" .. requirementValue
    questFrame.ProgressFrame.XpLabel.Text = progress >= requirementValue and "Completed!" or SeasonQuestsDataHelper.GetRewardXp(questId) .. " XP"
    questFrame.ProgressFrame.ProgressBar.Size = progress >= requirementValue and UDim2.new(PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0) or UDim2.new(progress / requirementValue * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
end

function SeasonGuiController:SwitchFrame(frame: Frame)
    RewardsFrame.Visible = false
    QuestsFrame.Visible = false
    PremiumFrame.Visible = false

    frame.Visible = true
end

function SeasonGuiController:KnitInit()
end

function SeasonGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		SeasonGui.Enabled = false
		return
	end
    GuiUtil.AutoResizeScrollingFrame(SeasonGui)

    local playerData = PlayerDataController:GetData(localPlayer)

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(SeasonGui)
    end)

    PremiumButton.Activated:Connect(function()
        self:SwitchFrame(PremiumFrame)
    end)

    QuestsButton.Activated:Connect(function()
        self:SwitchFrame(QuestsFrame)
    end)

    RewardsButton.Activated:Connect(function()
        self:SwitchFrame(RewardsFrame)
    end)

    RewardsFrame.ContentFrame.TitleFrame.PremiumFrame.GetButton.Activated:Connect(function()
        self:SwitchFrame(PremiumFrame)
    end)

    PremiumFrame.BuyButton.Activated:Connect(function()
        local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_1)
        MarketplaceService:PromptProductPurchase(localPlayer, productId)
    end)

    RewardsFrame.UnlockAllButton.Activated:Connect(function()
        local currentLevel = SeasonRewardsDataHelper.GetLevelByXp(playerData.SeasonXp)
        if currentLevel >= SeasonRewardsDataHelper.GetMaxLevel() then
            local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_RESTART)
            MarketplaceService:PromptProductPurchase(localPlayer, productId)
        else
            local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_UNLOCK_ALL)
            MarketplaceService:PromptProductPurchase(localPlayer, productId)
        end
        
    end)

    local SeasonService = Knit.GetService("SeasonService")
    SeasonService.UpdateSeasonTaskProgress:Connect(function(seasonDailyTasksProgress: {}, seasonWeeklyTasksProgress: {})
        task.delay(0, function()
            for _, questFrame in pairs(QuestsDailyFrame.ContentFrame:GetChildren()) do
                if questFrame:IsA("Frame") and questFrame.Name:match("Daily") then
                    self:UpdateQuest("Daily", questFrame.Name)
                end
            end
            for _, questFrame in pairs(QuestsWeeklyFrame.ContentFrame:GetChildren()) do
                if questFrame:IsA("Frame") and questFrame.Name:match("Weekly") then
                    self:UpdateQuest("Weekly", questFrame.Name)
                end
            end
            self:UpdateAllRewards()
        end)
    end)

    SeasonService.UpdateFreeRewardsClaimLog:Connect(function(freeRewardsClaimLog: {[string]: boolean})
        task.delay(0, function()
            self:UpdateAllRewards()
        end)
    end)

    SeasonService.UpdatePremiumRewardsClaimLog:Connect(function(premiumRewardsClaimLog: {[string]: boolean})
        task.delay(0, function()
            self:UpdateAllRewards()
        end)
    end)

    SeasonService.UpdateSeasonXp:Connect(function(seasonXp: number)
        task.delay(0, function()
            self:UpdateXpProgress()
            self:UpdateAllRewards()
            self:UpdateUnlockAllButton()
        end)
    end)

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId)
        task.delay(0, function()
            local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
            if purchaseId == Constants.PURCHASE_ID.SEASON_1 then
                self:UpdatePremiumState()
            end
        end)
    end)

    PurchaseService.ReceiveGiftSuccess:Connect(function(productId, senderName: string)
        task.delay(0, function()
            local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
            if purchaseId == Constants.PURCHASE_ID.SEASON_1 then
                self:UpdatePremiumState()
            end
        end)
    end)

    self:InitGui()
    self:GenerateQuestList("Daily")
    self:GenerateQuestList("Weekly")
    self:GenerateRewardList()
    self:UpdateXpProgress()
    self:UpdatePremiumState()
    self:UpdateUnlockAllButton()

    local updateTimer = Timer.new(1)
    updateTimer.Tick:Connect(function()
        local currentTime = os.time()
        local endOfDay = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d"), hour=23, min=59, sec=59}
        local daySecondsLeft = endOfDay - currentTime
        QuestsDailyFrame.ResetLabel.Text = NumberUtil.ConvertToHMS_Unit(daySecondsLeft)
        
        local endOfWeek = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d") + (7 - tonumber(os.date("%w"))), hour=23, min=59, sec=59}
        local weekSecondsLeft = endOfWeek - currentTime
        QuestsWeeklyFrame.ResetLabel.Text = NumberUtil.ConvertToHMS_Unit(weekSecondsLeft)
    end)
    updateTimer:StartNow()
end

return SeasonGuiController
