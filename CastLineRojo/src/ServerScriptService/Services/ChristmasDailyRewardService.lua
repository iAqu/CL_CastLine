local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local ChristmasDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.ChristmasDailyRewardsDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local ChristmasDailyRewardService = Knit.CreateService {
    Name = "ChristmasDailyRewardService",
    Client = {
        ClaimRewardEvent = Knit.CreateSignal(),
        CompleteDailyRewardEvent = Knit.CreateSignal(),

        -- Server -> Client
        -- ResetAllRewards = Knit.CreateSignal(),
    },
}

function ChristmasDailyRewardService:ClaimReward(player: Player, index: number)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		self.Client.ClaimRewardEvent:Fire(player, index, false, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    if not profile.Data.ChristmasDailyRewards[index] then warn ("Invalid index") return end
    if profile.Data.ChristmasDailyRewards[index].IsClaimed == true then warn ("Already claimed") return end
    if profile.Data.ChristmasDailyRewards[index].CompleteDate == nil then warn ("Not completed") return end

    local itemType = ChristmasDailyRewardsDataHelper.GetItemTypeByDayIndex(index)
    local itemId = ChristmasDailyRewardsDataHelper.GetItemIdByDayIndex(index)
    local itemCount = ChristmasDailyRewardsDataHelper.GetItemCountByDayIndex(index)

    if itemType == "Wins" then
        PlayerDataService:AdjustWins(player, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", itemCount))

    elseif itemType == "Diamond" then
        PlayerDataService:AdjustDiamonds(player, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", itemCount))

    elseif itemType == "WinsTier" then
        local winsCount = PurchaseDataHelper.GetBuyNum(itemId)
        -- local winsCount = GameDataUtil.CalculateWinTierCount(profile.Data, itemId)
        local tierName = PurchaseDataHelper.GetName(itemId)
        PlayerDataService:AdjustWins(player, winsCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, "🏆 Got " .. tierName)

    elseif itemType == "Token" then
        PlayerDataService:AdjustTokens(player, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_TOKEN_NUM:gsub("#NUM", itemCount))

    elseif itemType == "Spin" then
        local SpinningWheelService = Knit.GetService("SpinningWheelService")
        SpinningWheelService:AdjustSpinNum(player, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_SPIN_NUM:gsub("#NUM", itemCount))

    elseif itemType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, itemId, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", itemCount):gsub("#POTION", PurchaseDataHelper.GetName(itemId)))

    elseif itemType == "PotionPack" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_WINS, itemCount)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.GOLDEN, itemCount)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.SUPER_LUCKY, itemCount)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.RAINBOW, itemCount)
        self.Client.ClaimRewardEvent:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_PACK)

    else
        warn("Item type wrong!", itemType)
        return
    end

    profile.Data.ChristmasDailyRewards[index].IsClaimed = true
    self:UpdateAllRewards(player)

    -- local allClaimed = true
    -- for i = 1, #profile.Data.ChristmasDailyRewards do
    --     if profile.Data.ChristmasDailyRewards[i].IsClaimed == false then
    --         allClaimed = false
    --         break
    --     end
    -- end
    -- if allClaimed then
        -- self:ResetDailyRewards(player)
    -- end
end

-- function ChristmasDailyRewardService:ResetDailyRewards(player: Player)
--     local profile = PlayerDataService:GetProfile(player)
--     if not profile then return {isSuccess = false, resultText = "No profile found!"} end

--     for i = 1, #profile.Data.ChristmasDailyRewards do
--         -- if i == 1 then
--         --     profile.Data.LongDailyRewards[i].CompleteDate = self:GetTodayTime()
--         -- else
--             profile.Data.ChristmasDailyRewards[i].CompleteDate = nil
--         -- end
--         profile.Data.ChristmasDailyRewards[i].IsClaimed = false
--     end
--     self.Client.ResetAllRewards:Fire(player, profile.Data.ChristmasDailyRewards)

--     task.delay(0.5, function()
--         self:UpdateAllRewards(player)
--     end)
-- end

function ChristmasDailyRewardService:GetTodayTime()
    local todayTime = os.date("%j%Y")
    return todayTime
end

function ChristmasDailyRewardService:UpdateAllRewards(player: Player)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end
    
    local isCompleteToday = false
    for i = 1, #playerData.ChristmasDailyRewards do
        if playerData.ChristmasDailyRewards[i].CompleteDate == self:GetTodayTime() then
            isCompleteToday = true
        end
    end

    -- isCompleteToday = false     -- for test

    if not isCompleteToday then
        for i = 1, #playerData.ChristmasDailyRewards do
            if playerData.ChristmasDailyRewards[i].CompleteDate == nil then
                playerData.ChristmasDailyRewards[i].CompleteDate = self:GetTodayTime()
                self.Client.CompleteDailyRewardEvent:Fire(player, i, playerData.ChristmasDailyRewards[i].CompleteDate)
                break
            end
        end
    end
end

function ChristmasDailyRewardService:KnitInit()
end

function ChristmasDailyRewardService:KnitStart()
    self.Client.ClaimRewardEvent:Connect(function(player: Player, index: number)
        self:ClaimReward(player, index)
    end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        self:UpdateAllRewards(player)
        -- local isCompleteToday = false
        -- for i = 1, #playerData.LongDailyRewards do
        --     if playerData.LongDailyRewards[i].CompleteDate == self:GetTodayTime() then 
        --         isCompleteToday = true
        --     end
        -- end

        -- if not isCompleteToday then
        --     for i = 1, #playerData.LongDailyRewards do
        --         if playerData.LongDailyRewards[i].CompleteDate == nil then
        --             playerData.LongDailyRewards[i].CompleteDate = self:GetTodayTime()
        --             self.Client.CompleteDailyRewardEvent:Fire(player, i, playerData.LongDailyRewards[i].CompleteDate)
        --             break
        --         end
        --     end
        -- end
    end)
end

return ChristmasDailyRewardService
