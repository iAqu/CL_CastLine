local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local DailyRewardsDataHelper = require(ReplicatedFirst.DataHelpers.DailyRewardsDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local DailyRewardService = Knit.CreateService {
    Name = "DailyRewardService",
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

    for i = 1, #profile.Data.DailyRewards do
        profile.Data.DailyRewards[i].CompleteDate = nil
        profile.Data.DailyRewards[i].IsClaimed = false
    end
    DailyRewardService.Client.ResetAllRewards:Fire(player, profile.Data.DailyRewards)
end

local function checkReset(player: Player)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    local allClaimed = true
    for i = 1, #playerData.DailyRewards do
        if playerData.DailyRewards[i].IsClaimed == false then
            allClaimed = false
            break
        end
    end
    if allClaimed then
        resetDailyRewards(player)
    end
end

function DailyRewardService:ClaimDailyReward(player: Player, index: number)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		self.Client.ClaimDailyReward:Fire(player, index, false, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    if not profile.Data.DailyRewards[index] then warn ("Invalid index") return end
    if profile.Data.DailyRewards[index].IsClaimed == true then warn ("Already claimed") return end
    if profile.Data.DailyRewards[index].CompleteDate == nil then warn ("Not completed") return end

    local itemType = DailyRewardsDataHelper.GetItemTypeByDayIndex(index)
    local itemId = DailyRewardsDataHelper.GetItemIdByDayIndex(index)
    local itemCount = DailyRewardsDataHelper.GetItemCountByDayIndex(index)

    if itemType == "Strength" then
        PlayerDataService:AdjustStrength(player, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_STRENGTH:gsub("#NUM", itemCount))

    elseif itemType == "Wins" then
        PlayerDataService:AdjustWins(player, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", itemCount))

    elseif itemType == "Diamond" then
        PlayerDataService:AdjustDiamonds(player, itemCount)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", itemCount))

    elseif itemType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, itemId, itemCount)
        -- self.Client.ClaimDailyReward:Fire(player, index, true, "🎉 You have got " .. itemCount .. " " .. PurchaseDataHelper.GetName(itemId) .. "Potion!")
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", itemCount):gsub("#POTION", PurchaseDataHelper.GetName(itemId)))

    elseif itemType == "PotionBundle" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.GOLDEN, 1)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_WINS, 1)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.SUPER_LUCKY, 1)
        PotionService:AdjustPotionCount(player, Constants.POTION_ID.RAINBOW, 1)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_PACK)

    elseif itemType == "GamePass" then
        local GamePassService = Knit.GetService("GamePassService")
        GamePassService:GiveGamePass(player, itemId)
        self.Client.ClaimDailyReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_GAMEPASS:gsub("#NAME", DailyRewardsDataHelper.GetItemNameByDayIndex(index)))

    else
        warn("Daily reward item type wrong: " .. tostring(itemType))
        self.Client.ClaimDailyReward:Fire(player, index, false, "Reward type wrong!")
        return
    end

    profile.Data.DailyRewards[index].IsClaimed = true

    checkReset(player)
end

function DailyRewardService:GetTodayTime()
    local todayTime = os.date("%j%Y")
    return todayTime
end

function DailyRewardService:KnitInit()
end

function DailyRewardService:KnitStart()
    self.Client.ClaimDailyReward:Connect(function(player: Player, index: number)
        self:ClaimDailyReward(player, index)
    end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        for i = 1, #playerData.DailyRewards do
            if playerData.DailyRewards[i].CompleteDate == self:GetTodayTime() then return end
        end

        checkReset(player)

        for i = 1, #playerData.DailyRewards do
            if playerData.DailyRewards[i].CompleteDate == nil then
                playerData.DailyRewards[i].CompleteDate = self:GetTodayTime()
                self.Client.CompleteDailyReward:Fire(player, i, playerData.DailyRewards[i].CompleteDate)
                break
             end
        end
    end)
end

return DailyRewardService
