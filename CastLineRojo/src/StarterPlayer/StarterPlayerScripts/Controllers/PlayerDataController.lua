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
local interfaceReady = Instance.new("BindableEvent")

local currencyRevision = 0
local function applyEarlyHomeCurrency(profileData)
	currencyRevision += 1
	local revision = currencyRevision
	task.spawn(function()
		local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			or Players.LocalPlayer:WaitForChild("PlayerGui", 5)
		local homeGui = playerGui and playerGui:FindFirstChild("HomeGui")
		local bottomFrame = homeGui and homeGui:FindFirstChild("BottomFrame")
		local currencyFrame = bottomFrame and bottomFrame:FindFirstChild("CurrencyFrame")
		if not currencyFrame or revision ~= currencyRevision then
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
		if success and result and not self._IsDataLoaded then
			applyEarlyHomeCurrency(result)
			Players.LocalPlayer:SetAttribute(LoadingAttributes.PLAYER_DATA_LOADED, true)
		elseif not success then
			warn("PlayerDataController: early data request failed", result)
		end
	end)
end

function PlayerDataController:_RequestInterfaceData()
    if self._InterfaceService and not self._InterfaceRequested then
        self._InterfaceRequested = true
        self._InterfaceService.DataLoaded:Fire()
    end
end

function PlayerDataController:GetData(): Template.PlayerData
    if not self._IsDataLoaded then
        self._WaitingForInterface = true
        self:_RequestInterfaceData()
        interfaceReady.Event:Wait()
    end
    return self._PlayerData
end

function PlayerDataController:LoadData(profileData: Template.PlayerData)
    if not profileData or self._IsDataLoaded then
        return
    end
    self._PlayerData = profileData
    self._IsDataLoaded = true
    Players.LocalPlayer:SetAttribute(LoadingAttributes.PLAYER_DATA_LOADED, true)
    applyEarlyHomeCurrency(profileData)
    interfaceReady:Fire()
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

    local function listen(signal, callback)
        signal:Connect(function(...)
            if self._IsDataLoaded then
                callback(...)
            end
        end)
    end

    local HotbarLayoutService = Knit.GetService("HotbarLayoutService")
    listen(HotbarLayoutService.HotbarLayoutChanged, function(layout)
        if typeof(layout) == "table" then
            self._PlayerData.HotbarLayout = layout
        end
    end)

    listen(PlayerDataService.StrengthChanged, function(result)
        self._PlayerData.Strength = result
    end)

    listen(PlayerDataService.RebirthsChanged, function(result)
        self._PlayerData.Rebirths = result
    end)

    listen(PlayerDataService.SuperRebirthsChanged, function(result)
        self._PlayerData.SuperRebirths = result
    end)

    listen(PlayerDataService.SuperRebirthTokensChanged, function(result)
        self._PlayerData.SuperRebirthTokens = result
    end)

    listen(PlayerDataService.RebirthUpgradeChanged, function(upgradeId, newUpgradeLevel)
        self._PlayerData.RebirthUpgrades[upgradeId] = newUpgradeLevel
    end)

    listen(PlayerDataService.WinsChanged, function(result)
        self._PlayerData.Wins = result
    end)

    listen(PlayerDataService.DiamondsChanged, function(result)
        self._PlayerData.Diamonds = result
    end)

    listen(PlayerDataService.TotalWinsChanged, function(result)
        self._PlayerData.TotalWins = result
    end)

    listen(PlayerDataService.TotalStrengthChanged, function(result)
        self._PlayerData.TotalStrength = result
    end)

    listen(PlayerDataService.TrophyChanged, function(result)
        self._PlayerData.Trophy = result
    end)

    local UpgradeService = Knit.GetService("UpgradeService")
    listen(UpgradeService.Upgrade, function(upgradeId: string, isSuccess: boolean, _resultText: string, newLevel: number?)
        if isSuccess then
			self._PlayerData.Upgrades[upgradeId] = newLevel
				or ((self._PlayerData.Upgrades[upgradeId] or 0) + 1)
        end
    end)

    local AreaService = Knit.GetService("AreaService")
    listen(AreaService.ResetAreas, function()
        self._PlayerData.Areas = Template.DEFAULT_AREAS
        self._PlayerData.PlayerLocation = Template.DEFAULT_AREA
        self._PlayerData.NewestArea = Template.DEFAULT_AREA
    end)

    local AreaController = Knit.GetController("AreaController")
    listen(AreaController.ChangeAreaEvent, function(areaId : string)
        self._PlayerData.PlayerLocation = areaId
    end)

    local PurchaseService = Knit.GetService("PurchaseService")
    listen(PurchaseService.PurchaseSuccess, function(productId: string)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
        local purchaseType = PurchaseDataHelper.GetType(productId)
        if purchaseType == Constants.PURCHASE_TYPE.GAMEPASS then
            self._PlayerData.GamePasses[purchaseId] = true
        end
    end)

    listen(PurchaseService.PurchaseLimitSuccess, function(purchaseId: string)
        self._PlayerData.LimitedPurchaseHistory[purchaseId] = true
    end)

    local GamePassService = Knit.GetService("GamePassService")
    listen(GamePassService.GiveGamePass, function(gamePassId: string)
        self._PlayerData.GamePasses[gamePassId] = true
    end)

    local ChestService = Knit.GetService("ChestService")
    listen(ChestService.ClaimDailyChestComplete, function(openTime: number)
        self._PlayerData.DailyChestLastOpenTime = openTime
    end)

    listen(ChestService.ClaimGroupChestComplete, function(_openTime: number)
        self._PlayerData.GroupChestIsClaimed = true
    end)

    listen(ChestService.MarkGroupJoinedComplete, function()
        self._PlayerData.GroupJoinPromptSucceeded = true
    end)

    local PotionService = Knit.GetService("PotionService")
    listen(PotionService.UpdatePotionCount, function(potionId: string, potionCount: number)
        self._PlayerData.Potions[potionId].Count = potionCount
    end)

    local DailyRewardService = Knit.GetService("DailyRewardService")
    listen(DailyRewardService.ClaimDailyReward, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.DailyRewards[index].IsClaimed = true
        end
    end)

    listen(DailyRewardService.CompleteDailyReward, function(index: number, completeDate: string)
        self._PlayerData.DailyRewards[index].CompleteDate = completeDate
    end)

    listen(DailyRewardService.ResetAllRewards, function(DailyRewards: {})
        self._PlayerData.DailyRewards = DailyRewards
    end)

    local HareDailyRewardService = Knit.GetService("HareDailyRewardService")
    listen(HareDailyRewardService.ClaimDailyReward, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.HareDailyRewards[index].IsClaimed = true
        end
    end)

    listen(HareDailyRewardService.CompleteDailyReward, function(index: number, completeDate: string)
        self._PlayerData.HareDailyRewards[index].CompleteDate = completeDate
    end)

    listen(HareDailyRewardService.ResetAllRewards, function(HareDailyRewards: {})
        self._PlayerData.HareDailyRewards = HareDailyRewards
    end)

    local LongDailyRewardService = Knit.GetService("LongDailyRewardService")
    listen(LongDailyRewardService.ClaimLongDailyReward, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.LongDailyRewards[index].IsClaimed = true
        end
    end)

    listen(LongDailyRewardService.CompleteLongDailyReward, function(index: number, completeDate: string)
        self._PlayerData.LongDailyRewards[index].CompleteDate = completeDate
    end)

    listen(LongDailyRewardService.ResetAllRewards, function(longDailyRewards: {})
        self._PlayerData.LongDailyRewards = longDailyRewards
    end)

    local ChristmasDailyRewardService = Knit.GetService("ChristmasDailyRewardService")
    listen(ChristmasDailyRewardService.ClaimRewardEvent, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.ChristmasDailyRewards[index].IsClaimed = true
        end
    end)

    listen(ChristmasDailyRewardService.CompleteDailyRewardEvent, function(index: number, completeDate: string)
        self._PlayerData.ChristmasDailyRewards[index].CompleteDate = completeDate
    end)

    local ValentineDailyRewardService = Knit.GetService("ValentineDailyRewardService")
    listen(ValentineDailyRewardService.ClaimRewardEvent, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.ValentineDailyRewards[index].IsClaimed = true
        end
    end)

    listen(ValentineDailyRewardService.CompleteDailyRewardEvent, function(index: number, completeDate: string)
        self._PlayerData.ValentineDailyRewards[index].CompleteDate = completeDate
    end)

    local HalloweenDailyRewardService = Knit.GetService("HalloweenDailyRewardService")
    listen(HalloweenDailyRewardService.ClaimRewardEvent, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.HalloweenDailyRewards[index].IsClaimed = true
        end
    end)

    listen(HalloweenDailyRewardService.CompleteDailyRewardEvent, function(index: number, completeDate: string)
        self._PlayerData.HalloweenDailyRewards[index].CompleteDate = completeDate
    end)

    local SpinningWheelService = Knit.GetService("SpinningWheelService")
    listen(SpinningWheelService.UpdateSpinningWheelCount, function(spinningWheelLastCheckTime: number, spinningWheelBonusSpins: number)
        self._PlayerData.SpinningWheelLastCheckTime = spinningWheelLastCheckTime
        self._PlayerData.SpinningWheelBonusSpins = spinningWheelBonusSpins
    end)

    local GiftBoxService = Knit.GetService("GiftBoxService")
    listen(GiftBoxService.DropGifts, function(giftBoxId: string, _dropGifts: {})
        self._PlayerData.GiftBoxClaimLog[giftBoxId] = true
    end)

    local localDate = TimeUtil.GetLocalDate()
    PlayerDataService.UpdateLoginDate:Fire(localDate)

    local SeasonService = Knit.GetService("SeasonService")
    listen(SeasonService.UpdateSeasonTaskProgress, function(dailyTasksProgress, weeklyTasksProgress)
        self._PlayerData.SeasonDailyTasksProgress = dailyTasksProgress
        self._PlayerData.SeasonWeeklyTasksProgress = weeklyTasksProgress
    end)

    listen(SeasonService.UpdateFreeRewardsClaimLog, function(freeRewardsClaimLog)
        self._PlayerData.SeasonFreeRewardsClaimLog = freeRewardsClaimLog
    end)

    listen(SeasonService.UpdatePremiumRewardsClaimLog, function(premiumRewardsClaimLog)
        self._PlayerData.SeasonPremiumRewardsClaimLog = premiumRewardsClaimLog
    end)

    listen(SeasonService.UpdateSeasonXp, function(seasonXp)
        self._PlayerData.SeasonXp = seasonXp
    end)

    local AchievementService = Knit.GetService("AchievementService")
    listen(AchievementService.ClaimAchievementResultEvent, function(achievementId: string, isSuccess: boolean, _resultText: string)
        if isSuccess then
            local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
            local currentRank = self._PlayerData.AchievementRanks[achievementType] or 0
            self._PlayerData.AchievementRanks[achievementType] = currentRank + 1
        end
    end)

    local RandomPotionService = Knit.GetService("RandomPotionService")
    listen(RandomPotionService.UpdateRandomPotionBuyLogEvent, function(randomPotionBuyLog: {})
        self._PlayerData.RandomPotionBuyLog = randomPotionBuyLog
    end)

    local OnlineRewardService = Knit.GetService("OnlineRewardService")
    listen(OnlineRewardService.ResetOnlineRewards, function(_rebirth: number, _onlineStartTime: number, _onlineRewards: {})
        self._PlayerData.OnlineRewardsKeepTime = 0
        self._PlayerData.OnlineRewardsClaimLog = {
            [1] = false, [2] = false, [3] = false, [4] = false,
            [5] = false, [6] = false, [7] = false, [8] = false,
            [9] = false, [10] = false, [11] = false, [12] = false,
        }
    end)

    listen(OnlineRewardService.ClaimOnlineReward, function(index: number, isSuccess: boolean, _resultText: string)
        if isSuccess then
            self._PlayerData.OnlineRewardsClaimLog[index] = true
        end
    end)
    self._InterfaceService = PlayerDataService
    if self._WaitingForInterface then
        self:_RequestInterfaceData()
    end
end

return PlayerDataController
