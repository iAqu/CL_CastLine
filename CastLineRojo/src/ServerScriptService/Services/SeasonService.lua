local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local SeasonQuestsDataHelper = require(ReplicatedFirst.DataHelpers.SeasonQuestsDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local SeasonRewardsDataHelper = require(ReplicatedFirst.DataHelpers.SeasonRewardsDataHelper)
local PotionService = require(ServerScriptService.Services.PotionService)
local SpinningWheelService = require(ServerScriptService.Services.SpinningWheelService)
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local SeasonService = Knit.CreateService {
    Name = "SeasonService",
    Client = {
        -- Server to Client
        UpdateSeasonTaskProgress = Knit.CreateSignal(),
        -- ResetSeasonDailyTasksProgress = Knit.CreateSignal(),
        -- ResetSeasonWeeklyTasksProgress = Knit.CreateSignal(),
        UpdateFreeRewardsClaimLog = Knit.CreateSignal(),
        UpdatePremiumRewardsClaimLog = Knit.CreateSignal(),
        UpdateSeasonXp = Knit.CreateSignal(),
    },
}

function SeasonService.Client:ClaimSeasonReward(player: Player, isPremium: boolean, rewardId: string): {isSuccess: boolean, resultText: string}
    return self.Server:ClaimSeasonReward(player, isPremium, rewardId)
end

function SeasonService:ClaimSeasonReward(player: Player, isPremium: boolean, rewardId: string): {isSuccess: boolean, resultText: string}
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {isSuccess = false, resultText = PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
	local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    if isPremium then
        if playerData.SeasonPremiumRewardsClaimLog[rewardId] == true then
            return {isSuccess = false, resultText = "Already claimed!"}
        end
        if not playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.SEASON_1] then
            -- return {isSuccess = false, resultText = "Premium required!"}
            local productId = PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SEASON_1)
            MarketplaceService:PromptProductPurchase(player, productId)
            return
        end
    else
        if playerData.SeasonFreeRewardsClaimLog[rewardId] == true then
            return {isSuccess = false, resultText = "Already claimed!"}
        end
    end

    local requirementXp = SeasonRewardsDataHelper.GetRequirementXp(rewardId)
    if playerData.SeasonXp < requirementXp then
        return {isSuccess = false, resultText = "Not enough XP!"}
    end

    local rewardItemId = isPremium and SeasonRewardsDataHelper.GetPremiumRewardItemId(rewardId) or SeasonRewardsDataHelper.GetFreeRewardItemId(rewardId)
    local rewardCount = isPremium and SeasonRewardsDataHelper.GetPremiumRewardCount(rewardId) or SeasonRewardsDataHelper.GetFreeRewardCount(rewardId)

    if rewardItemId == "Diamond" then
        PlayerDataService:AdjustDiamonds(player, rewardCount)
    elseif rewardItemId == "Wins" then
        PlayerDataService:AdjustWins(player, playerData.Wins * rewardCount)
    elseif rewardItemId == "Strength" then
        PlayerDataService:AdjustStrength(player, tonumber(playerData.Strength) * rewardCount)
    elseif rewardItemId:match("Potion") then
        PotionService:AdjustPotionCount(player, rewardItemId, rewardCount)
    elseif rewardItemId == "Spin" then
        SpinningWheelService:AdjustSpinNum(player, rewardCount)
    else
        return {isSuccess = false, resultText = "Unknown reward!"}
    end

    if isPremium then
        playerData.SeasonPremiumRewardsClaimLog[rewardId] = true
        self.Client.UpdatePremiumRewardsClaimLog:Fire(player, playerData.SeasonPremiumRewardsClaimLog)
    else
        playerData.SeasonFreeRewardsClaimLog[rewardId] = true
        self.Client.UpdateFreeRewardsClaimLog:Fire(player, playerData.SeasonFreeRewardsClaimLog)
    end

    return {isSuccess = true, resultText = "Claimed!"}
end

function SeasonService:SkipLevel(player: Player, skipLevel: number): boolean
   local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    skipLevel = skipLevel or 1

    local currentLevel = SeasonRewardsDataHelper.GetLevelByXp(playerData.SeasonXp)
    local targetLevel = currentLevel + skipLevel
    if targetLevel > SeasonRewardsDataHelper.GetMaxLevel() then warn("SkipLevel: Max level reached!") return end

    playerData.SeasonXp = SeasonRewardsDataHelper.GetRequirementXpByLevel(targetLevel)

    self.Client.UpdateSeasonXp:Fire(player, playerData.SeasonXp)
    return true
end

function SeasonService:Restart(player: Player): boolean
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    playerData.SeasonXp = 0
    playerData.SeasonDailyTasksProgress = {}
    playerData.SeasonWeeklyTasksProgress = {}
    playerData.SeasonDailyTaskResetDate = TimeUtil.GetUniversalDate()
    playerData.SeasonWeeklyTaskResetDate = TimeUtil.GetUniversalDate()
    playerData.SeasonFreeRewardsClaimLog = {}
    playerData.SeasonPremiumRewardsClaimLog = {}

    self.Client.UpdateSeasonXp:Fire(player, playerData.SeasonXp)
    self.Client.UpdateSeasonTaskProgress:Fire(player, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)
    self.Client.UpdateFreeRewardsClaimLog:Fire(player, playerData.SeasonFreeRewardsClaimLog)
    self.Client.UpdatePremiumRewardsClaimLog:Fire(player, playerData.SeasonPremiumRewardsClaimLog)
    return true
end

function SeasonService:UnlockAll(player: Player)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    playerData.SeasonXp = SeasonRewardsDataHelper.GetRequirementXpByLevel(SeasonRewardsDataHelper.GetMaxLevel())

    self.Client.UpdateSeasonXp:Fire(player, playerData.SeasonXp)
    return true
end

function SeasonService:UpdateSeasonTaskProgress(player: Player, taskType: "Daily" | "Weekly", seasonTaskId: string, progress: number)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    if taskType == Constants.SEASON_TASK_TYPE.DAILY then
        if not playerData.SeasonDailyTasksProgress[seasonTaskId] then
            playerData.SeasonDailyTasksProgress[seasonTaskId] = 0
        end
        local requirementValue = SeasonQuestsDataHelper.GetRequirementValue(seasonTaskId)
        if playerData.SeasonDailyTasksProgress[seasonTaskId] >= requirementValue then
            return
        end

        playerData.SeasonDailyTasksProgress[seasonTaskId] = playerData.SeasonDailyTasksProgress[seasonTaskId] + progress
        self.Client.UpdateSeasonTaskProgress:Fire(player, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)

        if playerData.SeasonDailyTasksProgress[seasonTaskId] >= requirementValue then   -- complete task
            playerData.SeasonDailyTasksProgress[seasonTaskId] = requirementValue
            playerData.SeasonXp = playerData.SeasonXp + SeasonQuestsDataHelper.GetRewardXp(seasonTaskId)
            self.Client.UpdateSeasonXp:Fire(player, playerData.SeasonXp)
        end

    elseif taskType == Constants.SEASON_TASK_TYPE.WEEKLY then
        if not playerData.SeasonWeeklyTasksProgress[seasonTaskId] then
            playerData.SeasonWeeklyTasksProgress[seasonTaskId] = 0
        end
        local requirementValue = SeasonQuestsDataHelper.GetRequirementValue(seasonTaskId)
        if playerData.SeasonWeeklyTasksProgress[seasonTaskId] >= requirementValue then
            return
        end

        playerData.SeasonWeeklyTasksProgress[seasonTaskId] = playerData.SeasonWeeklyTasksProgress[seasonTaskId] + progress
        self.Client.UpdateSeasonTaskProgress:Fire(player, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)

        if playerData.SeasonWeeklyTasksProgress[seasonTaskId] >= requirementValue then  -- complete task
            playerData.SeasonWeeklyTasksProgress[seasonTaskId] = requirementValue
            playerData.SeasonXp = playerData.SeasonXp + SeasonQuestsDataHelper.GetRewardXp(seasonTaskId)
            self.Client.UpdateSeasonXp:Fire(player, playerData.SeasonXp)
        end
    end

    -- self.Client.UpdateSeasonTaskProgress:Fire(player, playerData.SeasonXp, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)
end

function SeasonService:KnitInit()
end

function SeasonService:KnitStart()
    local updateTimer = Timer.new(10)
    updateTimer.Tick:Connect(function()
        for _, loopPlayer in pairs(Players:GetPlayers()) do
            local playerData = PlayerDataService:GetAllData(loopPlayer)
            if not playerData then continue end

            if playerData.SeasonDailyTaskResetDate ~= TimeUtil.GetUniversalDate() then
                playerData.SeasonDailyTaskResetDate = TimeUtil.GetUniversalDate()
                playerData.SeasonDailyTasksProgress = {}
                -- self.Client.ResetSeasonTaskProgress:Fire(loopPlayer, Constants.SEASON_TASK_TYPE.DAILY)
                self.Client.UpdateSeasonTaskProgress:Fire(loopPlayer, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)
            end

            local dayOfWeek = tonumber(DateTime.now():FormatUniversalTime("d", "en-us"))
            if dayOfWeek == 1 and playerData.SeasonWeeklyTaskResetDate ~= TimeUtil.GetUniversalDate() then
                playerData.SeasonWeeklyTaskResetDate = TimeUtil.GetUniversalDate()
                playerData.SeasonWeeklyTasksProgress = {}
                -- self.Client.ResetSeasonTaskProgress:Fire(loopPlayer, Constants.SEASON_TASK_TYPE.WEEKLY)
                self.Client.UpdateSeasonTaskProgress:Fire(loopPlayer, playerData.SeasonDailyTasksProgress, playerData.SeasonWeeklyTasksProgress)
            end
        end
    end)
    updateTimer:StartNow()
end

return SeasonService
