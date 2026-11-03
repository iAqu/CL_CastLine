local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Template = require(ReplicatedStorage.PlayerData.Template)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)
local AchievementsDataHelper = require(ReplicatedFirst.DataHelpers.AchievementsDataHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local LoadingAttributes = require(ReplicatedFirst:WaitForChild("LoadingAttributes"))
local EARLY_DATA_REMOTE_NAME = "RequestPlayerDataEarly"

local function applyEarlyHomeCurrency(profileData)
	task.spawn(function()
		local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			or Players.LocalPlayer:WaitForChild("PlayerGui", 5)
		local homeGui = playerGui and playerGui:FindFirstChild("HomeGui")
		local bottomFrame = homeGui and homeGui:FindFirstChild("BottomFrame")
		local currencyFrame = bottomFrame and bottomFrame:FindFirstChild("CurrencyFrame")
		if not currencyFrame then
			return
		end

		local winsFrame = currencyFrame:FindFirstChild("Wins")
		local winsShadowLabel = winsFrame and winsFrame:FindFirstChild("WinsShadowLabel")
		local winsLabel = winsShadowLabel and winsShadowLabel:FindFirstChild("WinsLabel")
		local winsText = "$" .. NumberUtil.FormatNumberStartKWithDecimal(tonumber(profileData.Wins) or 0, 2)
		if winsShadowLabel and winsShadowLabel:IsA("TextLabel") then
			winsShadowLabel.Text = winsText
		end
		if winsLabel and winsLabel:IsA("TextLabel") then
			winsLabel.Text = winsText
		end

		local trophyFrame = currencyFrame:FindFirstChild("Trophy")
		local trophyShadowLabel = trophyFrame and trophyFrame:FindFirstChild("TrophyShadowLabel")
		local trophyLabel = trophyShadowLabel and trophyShadowLabel:FindFirstChild("TrophyLabel")
		local trophyText = NumberUtil.FormatNumberStartKWithDecimal(tonumber(profileData.Trophy) or 0, 2)
		if trophyShadowLabel and trophyShadowLabel:IsA("TextLabel") then
			trophyShadowLabel.Text = trophyText
		end
		if trophyLabel and trophyLabel:IsA("TextLabel") then
			trophyLabel.Text = trophyText
		end
	end)
end

local PlayerDataController = Knit.CreateController {
    Name = "PlayerDataController",
    _IsDataLoaded = false,
    _PlayerData = {},
	_EarlyFetchStarted = false,
}

function PlayerDataController:BeginEarlyFetch()
	if self._EarlyFetchStarted then
		return
	end
	self._EarlyFetchStarted = true

	task.spawn(function()
		local remote = ReplicatedStorage:WaitForChild(EARLY_DATA_REMOTE_NAME, 15)
		if not remote or not remote:IsA("RemoteFunction") then
			warn("PlayerDataController: early data remote is unavailable")
			return
		end

		local success, result = pcall(function()
			return remote:InvokeServer()
		end)
		if success then
			self:LoadData(result)
		else
			warn("PlayerDataController: early data request failed", result)
		end
	end)
end

function PlayerDataController:GetData() : Template.PlayerData
    while not self._IsDataLoaded do
		task.wait()
    end

    return self._PlayerData
end

function PlayerDataController:LoadData(profileData : Template.PlayerData)
    if not profileData then
        return
    end

    self._PlayerData = profileData
    self._IsDataLoaded = true
	Players.LocalPlayer:SetAttribute(LoadingAttributes.PLAYER_DATA_LOADED, true)
	applyEarlyHomeCurrency(profileData)
end

function PlayerDataController:KnitInit()
    LogHelper.Print("PlayerDataController initialized")
end

function PlayerDataController:KnitStart()
    LogHelper.Print("PlayerDataController started")
	self:BeginEarlyFetch()

    local PlayerDataService = Knit.GetService("PlayerDataService")

    PlayerDataService.DataLoaded:Connect(function(result)
        self:LoadData(result)
    end)

    local HotbarLayoutService = Knit.GetService("HotbarLayoutService")
    HotbarLayoutService.HotbarLayoutChanged:Connect(function(layout)
        if self._IsDataLoaded and typeof(layout) == "table" then
            self._PlayerData.HotbarLayout = layout
        end
    end)

    PlayerDataService.StrengthChanged:Connect(function(result)
        self._PlayerData.Strength = result
    end)

    PlayerDataService.RebirthsChanged:Connect(function(result)
        self._PlayerData.Rebirths = result
    end)

    PlayerDataService.SuperRebirthsChanged:Connect(function(result)
        self._PlayerData.SuperRebirths = result
    end)

    PlayerDataService.SuperRebirthTokensChanged:Connect(function(result)
        self._PlayerData.SuperRebirthTokens = result
    end)

    PlayerDataService.RebirthUpgradeChanged:Connect(function(upgradeId, newUpgradeLevel)
        self._PlayerData.RebirthUpgrades[upgradeId] = newUpgradeLevel
    end)

    PlayerDataService.WinsChanged:Connect(function(result)
        self._PlayerData.Wins = result
    end)

    PlayerDataService.DiamondsChanged:Connect(function(result)
        self._PlayerData.Diamonds = result
    end)

    PlayerDataService.TotalWinsChanged:Connect(function(result)
        self._PlayerData.TotalWins = result
    end)

    PlayerDataService.TotalStrengthChanged:Connect(function(result)
        self._PlayerData.TotalStrength = result
    end)

    PlayerDataService.TrophyChanged:Connect(function(result)
        self._PlayerData.Trophy = result
    end)

    local UpgradeService = Knit.GetService("UpgradeService")
    UpgradeService.Upgrade:Connect(function(upgradeId: string, isSuccess: boolean, _resultText: string, newLevel: number?)
        if isSuccess then
			self._PlayerData.Upgrades[upgradeId] = newLevel
				or ((self._PlayerData.Upgrades[upgradeId] or 0) + 1)
        end
    end)

    local AreaService = Knit.GetService("AreaService")
    AreaService.ResetAreas:Connect(function()
        self._PlayerData.Areas = Template.DEFAULT_AREAS
        self._PlayerData.PlayerLocation = Template.DEFAULT_AREA
        self._PlayerData.NewestArea = Template.DEFAULT_AREA
    end)

    local AreaController = Knit.GetController("AreaController")
    AreaController.ChangeAreaEvent:Connect(function(areaId : string)
        self._PlayerData.PlayerLocation = areaId
    end)

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId: string)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
        local purchaseType = PurchaseDataHelper.GetType(productId)
        if purchaseType == Constants.PURCHASE_TYPE.GAMEPASS then
            self._PlayerData.GamePasses[purchaseId] = true
        end
    end)

    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId: string)
        self._PlayerData.LimitedPurchaseHistory[purchaseId] = true
    end)

    local GamePassService = Knit.GetService("GamePassService")
    GamePassService.GiveGamePass:Connect(function(gamePassId: string)
        self._PlayerData.GamePasses[gamePassId] = true
    end)

    local ChestService = Knit.GetService("ChestService")
    ChestService.ClaimDailyChestComplete:Connect(function(openTime: number)
        self._PlayerData.DailyChestLastOpenTime = openTime
    end)

    ChestService.ClaimGroupChestComplete:Connect(function(_openTime: number)
        self._PlayerData.GroupChestIsClaimed = true
    end)

    ChestService.MarkGroupJoinedComplete:Connect(function()
        self._PlayerData.GroupJoinPromptSucceeded = true
    end)

    local PotionService = Knit.GetService("PotionService")
    PotionService.UpdatePotionCount:Connect(function(potionId: string, potionCount: number)
        self._PlayerData.Potions[potionId].Count = potionCount
    end)

    local DailyRewardService = Knit.GetService("DailyRewardService")
    DailyRewardService.ClaimDailyReward:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.DailyRewards[index].IsClaimed = true
        end
    end)

    DailyRewardService.CompleteDailyReward:Connect(function(index: number, completeDate: string)
        self._PlayerData.DailyRewards[index].CompleteDate = completeDate
    end)

    DailyRewardService.ResetAllRewards:Connect(function(DailyRewards: {})
        self._PlayerData.DailyRewards = DailyRewards
    end)

    local HareDailyRewardService = Knit.GetService("HareDailyRewardService")
    HareDailyRewardService.ClaimDailyReward:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.HareDailyRewards[index].IsClaimed = true
        end
    end)

    HareDailyRewardService.CompleteDailyReward:Connect(function(index: number, completeDate: string)
        self._PlayerData.HareDailyRewards[index].CompleteDate = completeDate
    end)

    HareDailyRewardService.ResetAllRewards:Connect(function(HareDailyRewards: {})
        self._PlayerData.HareDailyRewards = HareDailyRewards
    end)

    local LongDailyRewardService = Knit.GetService("LongDailyRewardService")
    LongDailyRewardService.ClaimLongDailyReward:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.LongDailyRewards[index].IsClaimed = true
        end
    end)

    LongDailyRewardService.CompleteLongDailyReward:Connect(function(index: number, completeDate: string)
        self._PlayerData.LongDailyRewards[index].CompleteDate = completeDate
    end)

    LongDailyRewardService.ResetAllRewards:Connect(function(longDailyRewards: {})
        self._PlayerData.LongDailyRewards = longDailyRewards
    end)

    local ChristmasDailyRewardService = Knit.GetService("ChristmasDailyRewardService")
    ChristmasDailyRewardService.ClaimRewardEvent:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.ChristmasDailyRewards[index].IsClaimed = true
        end
    end)

    ChristmasDailyRewardService.CompleteDailyRewardEvent:Connect(function(index: number, completeDate: string)
        self._PlayerData.ChristmasDailyRewards[index].CompleteDate = completeDate
    end)

    local ValentineDailyRewardService = Knit.GetService("ValentineDailyRewardService")
    ValentineDailyRewardService.ClaimRewardEvent:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.ValentineDailyRewards[index].IsClaimed = true
        end
    end)

    ValentineDailyRewardService.CompleteDailyRewardEvent:Connect(function(index: number, completeDate: string)
        self._PlayerData.ValentineDailyRewards[index].CompleteDate = completeDate
    end)

    local HalloweenDailyRewardService = Knit.GetService("HalloweenDailyRewardService")
    HalloweenDailyRewardService.ClaimRewardEvent:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.HalloweenDailyRewards[index].IsClaimed = true
        end
    end)

    HalloweenDailyRewardService.CompleteDailyRewardEvent:Connect(function(index: number, completeDate: string)
        self._PlayerData.HalloweenDailyRewards[index].CompleteDate = completeDate
    end)

    local SpinningWheelService = Knit.GetService("SpinningWheelService")
    SpinningWheelService.UpdateSpinningWheelCount:Connect(function(spinningWheelLastCheckTime: number, spinningWheelBonusSpins: number)
        self._PlayerData.SpinningWheelLastCheckTime = spinningWheelLastCheckTime
        self._PlayerData.SpinningWheelBonusSpins = spinningWheelBonusSpins
    end)

    local GiftBoxService = Knit.GetService("GiftBoxService")
    GiftBoxService.DropGifts:Connect(function(giftBoxId: string, _dropGifts: {})
        self._PlayerData.GiftBoxClaimLog[giftBoxId] = true
    end)

    local localDate = TimeUtil.GetLocalDate()
    PlayerDataService.UpdateLoginDate:Fire(localDate)

    local SeasonService = Knit.GetService("SeasonService")
    SeasonService.UpdateSeasonTaskProgress:Connect(function(dailyTasksProgress, weeklyTasksProgress)
        self._PlayerData.SeasonDailyTasksProgress = dailyTasksProgress
        self._PlayerData.SeasonWeeklyTasksProgress = weeklyTasksProgress
    end)

    SeasonService.UpdateFreeRewardsClaimLog:Connect(function(freeRewardsClaimLog)
        self._PlayerData.SeasonFreeRewardsClaimLog = freeRewardsClaimLog
    end)

    SeasonService.UpdatePremiumRewardsClaimLog:Connect(function(premiumRewardsClaimLog)
        self._PlayerData.SeasonPremiumRewardsClaimLog = premiumRewardsClaimLog
    end)

    SeasonService.UpdateSeasonXp:Connect(function(seasonXp)
        self._PlayerData.SeasonXp = seasonXp
    end)

    local AchievementService = Knit.GetService("AchievementService")
    AchievementService.ClaimAchievementResultEvent:Connect(function(achievementId: string, isSuccess: boolean, _resultText: string)
        if isSuccess then
            local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
            local currentRank = self._PlayerData.AchievementRanks[achievementType] or 0
            self._PlayerData.AchievementRanks[achievementType] = currentRank + 1
        end
    end)

    local RandomPotionService = Knit.GetService("RandomPotionService")
    RandomPotionService.UpdateRandomPotionBuyLogEvent:Connect(function(randomPotionBuyLog: {})
        self._PlayerData.RandomPotionBuyLog = randomPotionBuyLog
    end)

    local OnlineRewardService = Knit.GetService("OnlineRewardService")
    OnlineRewardService.ResetOnlineRewards:Connect(function(_rebirth: number, _onlineStartTime: number, _onlineRewards: {})
        self._PlayerData.OnlineRewardsKeepTime = 0
        self._PlayerData.OnlineRewardsClaimLog = {
            [1] = false, [2] = false, [3] = false, [4] = false,
            [5] = false, [6] = false, [7] = false, [8] = false,
            [9] = false, [10] = false, [11] = false, [12] = false,
        }
    end)

    OnlineRewardService.ClaimOnlineReward:Connect(function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.OnlineRewardsClaimLog[index] = true
        end
    end)
end

return PlayerDataController
