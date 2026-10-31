local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local HareDailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.HareDailyRewardsDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local HareDailyRewardService = Knit.CreateService {
    Name = "HareDailyRewardService",
    Client = {
        ClaimDailyReward = Knit.CreateSignal(),
        CompleteDailyReward = Knit.CreateSignal(),

        -- Server -> Client
        ResetAllRewards = Knit.CreateSignal(),
    },
}

local function resetDailyRewards(player: Player)
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    for i = 1, #profile.Data.HareDailyRewards do
        profile.Data.HareDailyRewards[i].CompleteDate = nil
        profile.Data.HareDailyRewards[i].IsClaimed = false
    end
    HareDailyRewardService.Client.ResetAllRewards:Fire(player, profile.Data.HareDailyRewards)
end

local function checkReset(player: Player)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    local allClaimed = true
    for i = 1, #playerData.HareDailyRewards do
        if playerData.HareDailyRewards[i].IsClaimed == false then
            allClaimed = false
            break
        end
    end
    if allClaimed then
        resetDailyRewards(player)
    end
end

function HareDailyRewardService:ClaimDailyReward(player: Player, index: number)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		self.Client.ClaimDailyReward:Fire(player, index, false, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    if not profile.Data.HareDailyRewards[index] then warn ("Invalid index") return end
    if profile.Data.HareDailyRewards[index].IsClaimed == true then warn ("Already claimed") return end
    if profile.Data.HareDailyRewards[index].CompleteDate == nil then warn ("Not completed") return end

    local itemType = HareDailyRewardsDataHelper.GetItemTypeByDayIndex(index)
    local itemId = HareDailyRewardsDataHelper.GetItemIdByDayIndex(index)
    local itemCount = HareDailyRewardsDataHelper.GetItemCountByDayIndex(index)

    if itemType == "Wins" then
        PlayerDataService:AdjustWins(player, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", itemCount))

    elseif itemType == "Diamond" then
        PlayerDataService:AdjustDiamonds(player, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", itemCount))

    elseif itemType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, itemId, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", itemCount):gsub("#POTION", PurchaseDataHelper.GetName(itemId)))

    else
        warn("Item type wrong!", itemType)
        return
    end

    profile.Data.HareDailyRewards[index].IsClaimed = true

    checkReset(player)
end

function HareDailyRewardService:GetTodayTime()
    local todayTime = os.date("%j%Y")
    return todayTime
end

function HareDailyRewardService:KnitInit()
end

function HareDailyRewardService:KnitStart()
    self.Client.ClaimDailyReward:Connect(function(player: Player, index: number)
        self:ClaimDailyReward(player, index)
    end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        for i = 1, #playerData.HareDailyRewards do
            if playerData.HareDailyRewards[i].CompleteDate == self:GetTodayTime() then return end
        end

        checkReset(player)

        for i = 1, #playerData.HareDailyRewards do
            if playerData.HareDailyRewards[i].CompleteDate == nil then
                playerData.HareDailyRewards[i].CompleteDate = self:GetTodayTime()
                self.Client.CompleteDailyReward:Fire(player, i, playerData.HareDailyRewards[i].CompleteDate)
                break
             end
        end
    end)
end

return HareDailyRewardService
