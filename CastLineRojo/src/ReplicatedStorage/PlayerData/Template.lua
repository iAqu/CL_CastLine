local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AreasData = require(ReplicatedFirst.Data.AreasData)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local FishingConfig = require(ReplicatedStorage.Modules.FishingConfig)
local UpgradesDataHelper = require(ReplicatedFirst.DataHelpers.UpgradesDataHelper)
local GiftBoxesDataHelper = require(ReplicatedFirst.DataHelpers.GiftBoxesDataHelper)

local DEFAULT_AREAS = {}
local DEFAULT_AREA = "Area_1"
for areaId, _ in AreasData do
    DEFAULT_AREAS[areaId] = (areaId == DEFAULT_AREA)
end

local DEFAULT_GAMEPASSES = {}
for purchaseId, purchaseInfo in pairs(PurchaseDataHelper.GetGamePassesData()) do
    if purchaseInfo.Type == "GamePass" then
        DEFAULT_GAMEPASSES[purchaseId] = false
    end
end

local DEFAULT_POTIONS = {}
for _, potionId in Constants.POTION_ID do
    DEFAULT_POTIONS[potionId] = {
        Count = 0,
        LastTime = 0
    }
end

local DEFAULT_SETTINGS = {
    [Constants.SETTINGS_ID.SHOW_YOUR_PETS] = true,
    [Constants.SETTINGS_ID.SHOW_OTHER_PETS] = true,
    [Constants.SETTINGS_ID.MUSIC] = true,
    [Constants.SETTINGS_ID.SOUND] = true,
    [Constants.SETTINGS_ID.TRADE] = false,
    [Constants.SETTINGS_ID.AUTO_REBIRTH] = false,
    [Constants.SETTINGS_ID.GLOBAL_MESSAGE] = true,
    [Constants.SETTINGS_ID.PERFORMANCE_MODE] = "Auto",
}

local DEFAULT_DAILY_REWARDS = {}
for i = 1, 7 do
    DEFAULT_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_HARE_DAILY_REWARDS = {}
for i = 1, 7 do
    DEFAULT_HARE_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_LONG_DAILY_REWARDS = {}
for i = 1, 15 do
    DEFAULT_LONG_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_CHRISTMAS_DAILY_REWARDS = {}
for i = 1, 15 do
    DEFAULT_CHRISTMAS_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_VALENTINE_DAILY_REWARDS = {}
for i = 1, 15 do
    DEFAULT_VALENTINE_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_HALLOWEEN_DAILY_REWARDS = {}
for i = 1, 7 do
    DEFAULT_HALLOWEEN_DAILY_REWARDS[i] = {
        CompleteDate = nil,
        IsClaimed = false
    }
end

local DEFAULT_UPGRADES = {}
for upgradeId, _ in UpgradesDataHelper.GetAllData() do
    if upgradeId ~= Constants.UPGRADE_ID.MOVE_SPEED then
        DEFAULT_UPGRADES[upgradeId] = 0
    end
end

local DEFAULT_GIFT_BOX_CLAIM_LOG = {}
for giftBoxId, _ in GiftBoxesDataHelper.GetAllData() do
    DEFAULT_GIFT_BOX_CLAIM_LOG[giftBoxId] = false
end

local Template = {

    FirstJoinTime = os.time(),
    LastOnlineTime = 0,
    UpdateReadLog = {},
    Strength = 10,
    Wins = 0,
    OwnedRods = { [FishingConfig.DefaultRodId] = true },
    EquippedRodId = FishingConfig.DefaultRodId,
    Rebirths = 0,
    Diamonds = 0,
    RobuxSpent = 0,
    Trophy = 0,

    RandomPotionBuyLog = {},

    Areas = DEFAULT_AREAS,
    NewestArea = DEFAULT_AREA,
    PlayerLocation = DEFAULT_AREA,
    LastFarmSlotId = nil,
    LastPlotSlotId = nil,

    TotalWins = 0,
    TotalCashEarned = 0,
    TotalItemWeightTenths = 0,
    TotalStrength = 100,
    TotalTrophy = 0,
    PlayTime = 0,

    GamePasses = DEFAULT_GAMEPASSES,
    RedeemedCodesHistory = {},
    Settings = DEFAULT_SETTINGS,
    DailyChestLastOpenTime = 0,
    GroupChestLastOpenTime = 0,
    GroupChestIsClaimed = false,
    GroupJoinPromptSucceeded = false,
    Potions = DEFAULT_POTIONS,
    DailyRewards = DEFAULT_DAILY_REWARDS,
    LongDailyRewards = DEFAULT_LONG_DAILY_REWARDS,
    ChristmasDailyRewards = DEFAULT_CHRISTMAS_DAILY_REWARDS,
    HalloweenDailyRewards = DEFAULT_HALLOWEEN_DAILY_REWARDS,
    ValentineDailyRewards = DEFAULT_VALENTINE_DAILY_REWARDS,
    HareDailyRewards = DEFAULT_HARE_DAILY_REWARDS,
    LimitedPurchaseHistory = {},
    LimitedDailyPotionPurchaseHistory = {},
    SpinningWheelLastCheckTime = nil,
    SpinningWheelBonusSpins = 0,
    Upgrades = DEFAULT_UPGRADES,
    GiftBoxClaimLog = DEFAULT_GIFT_BOX_CLAIM_LOG,
    EventRewardClaimLog = {},
    StarterPackTaskDown = false,
    AdvancedPackTask1Down = false,
    AdvancedPackTask2Down = false,
    AdvancedPackTask2FirstDate = nil,

    OnlineQuestTaskDown = false,
    OnlineQuestKeepTime = 0,

    OnlineRewardsKeepTime = 0,
    OnlineRewardsClaimLog = {
        [1] = false, [2] = false, [3] = false, [4] = false,
        [5] = false, [6] = false, [7] = false, [8] = false,
        [9] = false, [10] = false, [11] = false, [12] = false,
    },

    FirstLoginDate = nil,
    LoginDate = nil,
    ContinueLoginDays = 1,

    AchievementRanks = {},

    SeasonXp = 0,
    SeasonDailyTasksProgress = {},
    SeasonWeeklyTasksProgress = {},
    SeasonDailyTaskResetDate = nil,
    SeasonWeeklyTaskResetDate = nil,
    SeasonFreeRewardsClaimLog = {},
    SeasonPremiumRewardsClaimLog = {},

    HotbarLayout = {},
    Items = {},
	Pets = {},
	PetIndex = {},
	Eggs = {},
    -- Index progress intentionally starts empty for every existing profile; it is
    -- populated only by items obtained after the Index feature is introduced.
    IndexDiscoveryLog = {},
    IndexRewardClaimLog = {},
    -- Tracks item types obtained after the NEW title tag feature is introduced.
    -- Existing profiles intentionally begin with this empty, so the feature
    -- starts counting from its release rather than their prior inventory.
    NewItemTagSeenLog = {},
    PlotPlacements = {},
    PendingPlotOfflineCash = 0,

    SuperRebirths = 0,
    SuperRebirthTokens = 0,
    RebirthUpgrades = {},
}

Template.DEFAULT_AREAS = DEFAULT_AREAS
Template.DEFAULT_AREA = DEFAULT_AREA

export type PlayerData = typeof(Template)

return Template
