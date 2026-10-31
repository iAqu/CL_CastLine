local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local OnlineRewardsDataHelper = require(ReplicatedFirst.DataHelpers.OnlineRewardsDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local OnlineRewardService = Knit.CreateService {
    Name = "OnlineRewardService",
    Client = {
        ClaimOnlineReward = Knit.CreateSignal(),
        ResetOnlineRewards = Knit.CreateSignal(),

        -- Server <-> Client
        SkipOnlineRewards = Knit.CreateSignal(),

    -- client
        -- CompleteStarterPackTask = Knit.CreateSignal(),
        -- CompleteAdvancedPackTask1 = Knit.CreateSignal(),
        UpdateAdvancedPackTask2Progress = Knit.CreateSignal(),

        -- Server To Client
        ResetTokenCountdown = Knit.CreateSignal(),

    },
    _OnlineStartTimes = {},         -- nenver reset
    -- _OnlineEventStartTimes = {},    -- will be reset when claimed all
    _OnlineRewardStartTimes = {},   -- will be reset when claimed all
    -- _OnlineRewardPerPlayer = {},
    _RebirthsWhenLoginPerPlayer = {},
    _AdvancedPackStartTime = {},
    _OnlineQuestStartTime = {},
}

function OnlineRewardService:GetOnlineTime(player: Player)
    return os.time() - OnlineRewardService._OnlineStartTimes[player]
end

function OnlineRewardService.Client:GetOnlineStartTime(player: Player)
    return self.Server:GetOnlineStartTime(player)
end

function OnlineRewardService:GetOnlineStartTime(player: Player)
    return self._OnlineStartTimes[player]
end

function OnlineRewardService.Client:GetOnlineQuestStartTime(player: Player)
    -- OnlineQuest 相关功能已禁用
    return os.time()
end

function OnlineRewardService:GetOnlineQuestStartTime(player: Player)
    -- OnlineQuest 相关功能已禁用
    return os.time()
end

function OnlineRewardService.Client:GetOnlineRewardData(player: Player)
    return self.Server:GetOnlineRewardData(player)
end

function OnlineRewardService:GetOnlineRewardData(player: Player)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return nil
	end
    if not self._OnlineRewardStartTimes[player] then
        self._OnlineRewardStartTimes[player] = os.time()
    end

    if not self._RebirthsWhenLoginPerPlayer[player] then
        self._RebirthsWhenLoginPerPlayer[player] = PlayerDataService:GetProfile(player).Data.Rebirths
    end
    -- if not self._OnlineRewardPerPlayer[player] then
    --     self._OnlineRewardPerPlayer[player] = {
    --         [1] = false, [2] = false, [3] = false, [4] = false,
    --         [5] = false, [6] = false, [7] = false, [8] = false,
    --         [9] = false, [10] = false, [11] = false, [12] = false,
    --     }
    -- end

    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    -- return self._RebirthsWhenLoginPerPlayer[player], self._OnlineRewardStartTimes[player], self._OnlineRewardPerPlayer[player]
    return self._RebirthsWhenLoginPerPlayer[player], self._OnlineRewardStartTimes[player], playerData.OnlineRewardsClaimLog

end

function OnlineRewardService.Client:GetAdvancedPackInitData(player: Player)
    return self.Server:GetAdvancedPackInitData(player)
end

function OnlineRewardService:GetAdvancedPackInitData(player: Player)
    if not self._AdvancedPackStartTime[player] then
        self._AdvancedPackStartTime[player] = os.time()
    end
    return self._AdvancedPackStartTime[player]
end

function OnlineRewardService:ClaimOnlineReward(player: Player, index: number)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		self.Client.ClaimOnlineReward:Fire(player, index, false, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    if not Constants.ONLINE_REWARDS_TIME[index] then warn("Online rewards time not found for index: " .. index); return end

    -- if not self._OnlineRewardPerPlayer[player] then
    --     self._OnlineRewardPerPlayer[player] = {
    --         [1] = false, [2] = false, [3] = false, [4] = false,
    --         [5] = false, [6] = false, [7] = false, [8] = false,
    --         [9] = false, [10] = false, [11] = false, [12] = false,
    --     }
    -- end

    local onlineTime = os.time() - self._OnlineRewardStartTimes[player]

    if onlineTime < Constants.ONLINE_REWARDS_TIME[index] then
        self.Client.ClaimOnlineReward:Fire(player, index, false, "Please wait")
        return
    end

    -- if self._OnlineRewardPerPlayer[player][index] then
    if profile.Data.OnlineRewardsClaimLog[index] then
        self.Client.ClaimOnlineReward:Fire(player, index, false, "Already claimed!")
        return
    end

    local rebirthsWhenLogin = self._RebirthsWhenLoginPerPlayer[player]

    local rewardType = OnlineRewardsDataHelper.GetItemTypeByRebirth(rebirthsWhenLogin, index)
    local rewardId = OnlineRewardsDataHelper.GetItemIdByRebirth(rebirthsWhenLogin, index)
    local rewardCount = OnlineRewardsDataHelper.GetItemCountByRebirth(rebirthsWhenLogin, index)

    if rewardType == "Wins" then
        PlayerDataService:AdjustWins(player, rewardCount)
        self.Client.ClaimOnlineReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", rewardCount))

    elseif rewardType == "Strength" then
        PlayerDataService:AdjustStrength(player, rewardCount)
        self.Client.ClaimOnlineReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_STRENGTH:gsub("#NUM", rewardCount))

    elseif rewardType == "Diamonds" then
        PlayerDataService:AdjustDiamonds(player, rewardCount)
        self.Client.ClaimOnlineReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", rewardCount))

    elseif rewardType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, rewardId, rewardCount)
        -- PotionService:UsePotion(player, rewardId)
        self.Client.ClaimOnlineReward:Fire(player, index, true, Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", rewardCount):gsub("#POTION", PurchaseDataHelper.GetName(rewardId)))

    else
        warn("Reward type wrong!")
        self.Client.ClaimOnlineReward:Fire(player, index, false, "Reward type wrong!")
        return
    end

    -- self._OnlineRewardPerPlayer[player][index] = true

    profile.Data.OnlineRewardsClaimLog[index] = true

    local isAllClaimed = true
    -- for _, value in pairs(self._OnlineRewardPerPlayer[player]) do
    for _, value in profile.Data.OnlineRewardsClaimLog do
        if value == false then
            isAllClaimed = false
            break
        end
    end

    if isAllClaimed then
        self:ResetOnlineRewards(player)
    end
end

function OnlineRewardService:SkipOnlineRewards(player: Player)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return
	end
    self._OnlineRewardStartTimes[player] = os.time() - Constants.ONLINE_REWARDS_TIME[12]

    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    self.Client.SkipOnlineRewards:Fire(player, self._OnlineRewardStartTimes[player])
end

function OnlineRewardService:ResetOnlineRewards(player: Player)
    self._OnlineRewardStartTimes[player] = os.time()
    self._RebirthsWhenLoginPerPlayer[player] = PlayerDataService:GetProfile(player).Data.Rebirths
    -- self._OnlineRewardPerPlayer[player] = {
    --     [1] = false, [2] = false, [3] = false, [4] = false,
    --     [5] = false, [6] = false, [7] = false, [8] = false,
    --     [9] = false, [10] = false, [11] = false, [12] = false,
    -- }

    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end
    playerData.OnlineRewardsKeepTime = 0

    playerData.OnlineRewardsClaimLog = {
        [1] = false, [2] = false, [3] = false, [4] = false,
        [5] = false, [6] = false, [7] = false, [8] = false,
        [9] = false, [10] = false, [11] = false, [12] = false,
    }

    -- self.Client.ResetOnlineRewards:Fire(player,  self._RebirthsWhenLoginPerPlayer[player], self._OnlineRewardStartTimes[player], self._OnlineRewardPerPlayer[player])
    self.Client.ResetOnlineRewards:Fire(player,  self._RebirthsWhenLoginPerPlayer[player], self._OnlineRewardStartTimes[player], playerData.OnlineRewardsClaimLog)
end

function OnlineRewardService.Client:ClaimStarterPack(player: Player) : {isSuccess: boolean, resultText: string}
    return self.Server:ClaimStarterPack(player)
end

function OnlineRewardService:ClaimStarterPack(player: Player) : {isSuccess: boolean, resultText: string}
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {isSuccess = false, resultText = PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    if not profile.Data.StarterPackTaskDown then
        return {isSuccess = false, resultText = "You haven't completed the task!"}
    end

    if profile.Data.EventRewardClaimLog[Constants.EVENT_REWARD_ID.STARTER_PACK] then
        return {isSuccess = false, resultText = "You already claimed this reward!"}
    end

    self:GiveStartPack(player)
    profile.Data.EventRewardClaimLog[Constants.EVENT_REWARD_ID.STARTER_PACK] = true
    self._AdvancedPackStartTime[player] = os.time()

    return {isSuccess = true, resultText = "Success"}
end

function OnlineRewardService.Client:ClaimAdvancedPack(player: Player) : {isSuccess: boolean, resultText: string}
    return self.Server:ClaimAdvancedPack(player)
end

function OnlineRewardService:ClaimAdvancedPack(player: Player) : {isSuccess: boolean, resultText: string}
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {isSuccess = false, resultText = PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    -- if not profile.Data.AdvancedPackTask1Down or not profile.Data.AdvancedPackTask2Down then
    if not profile.Data.AdvancedPackTask1Down then
        return {isSuccess = false, resultText = "You haven't completed the task!"}
    end

    if profile.Data.EventRewardClaimLog[Constants.EVENT_REWARD_ID.ADVANCED_PACK] then
        return {isSuccess = false, resultText = "You already claimed this reward!"}
    end

    self:GiveAvancedPack(player)
    profile.Data.EventRewardClaimLog[Constants.EVENT_REWARD_ID.ADVANCED_PACK] = true
    return {isSuccess = true, resultText = "Success"}
end

function OnlineRewardService.Client:ClaimOnlineQuestReward(player: Player) : {isSuccess: boolean, resultText: string}
    -- OnlineQuest 相关功能已禁用
    return {isSuccess = false, resultText = "Online quest is disabled"}
end

function OnlineRewardService:ClaimOnlineQuestReward(player: Player): {isSuccess: boolean, resultText: string}
    -- OnlineQuest 相关功能已禁用
    return {isSuccess = false, resultText = "Online quest is disabled"}
end

function OnlineRewardService:GiveOnlineQuestReward(player: Player)
    -- OnlineQuest 相关功能已禁用
end

function OnlineRewardService:GiveStartPack(player: Player, allowDisabledPotionGrant: boolean?)
	local PotionService = Knit.GetService("PotionService")
	PotionService:AdjustPotionCount(player, Constants.POTION_ID.GOLDEN, 1, allowDisabledPotionGrant)
	PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_WINS, 1, allowDisabledPotionGrant)
	PotionService:AdjustPotionCount(player, Constants.POTION_ID.SUPER_LUCKY, 1, allowDisabledPotionGrant)
end

function OnlineRewardService:GiveAvancedPack(player: Player)
    local PotionService = Knit.GetService("PotionService")
    PotionService:AdjustPotionCount(player, Constants.POTION_ID.GOLDEN, 1)
    PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_WINS, 1)
    PotionService:AdjustPotionCount(player, Constants.POTION_ID.SUPER_LUCKY, 1)
end

function OnlineRewardService:GetTodayTime()
    local todayTime = os.date("%j%Y")
    return todayTime
end

function OnlineRewardService:KnitInit()
    Players.PlayerRemoving:Connect(function(player)
        self._OnlineStartTimes[player] = nil
        self._OnlineRewardStartTimes[player] = nil
        -- self._OnlineRewardPerPlayer[player] = nil
        self._RebirthsWhenLoginPerPlayer[player] = nil
        self._AdvancedPackStartTime[player] = nil
        self._OnlineQuestStartTime[player] = nil
    end)
end

function OnlineRewardService:KnitStart()
    self.Client.ClaimOnlineReward:Connect(function(player: Player, index: number)
        self:ClaimOnlineReward(player, index)
    end)

    self.Client.ResetOnlineRewards:Connect(function(player: Player)
        self:SkipOnlineRewards(player)
    end)

    -- self.Client.UpdateAdvancedPackTask2Progress:Connect(function(player: Player, localDate: number)
    --     if math.abs(TimeUtil.GetUniversalDate() - localDate) > 1 then return end

    --     local profile = PlayerDataService:GetProfile(player)
    --     if not profile then return end

    --     if profile.Data.AdvancedPackTask2FirstDate == nil then
    --         profile.Data.AdvancedPackTask2FirstDate = localDate
    --     else
    --         if profile.Data.AdvancedPackTask2FirstDate ~= localDate then
    --             profile.Data.AdvancedPackTask2Down = true
    --         end
    --     end
    -- end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        self._OnlineStartTimes[player] = os.time()

        self._OnlineRewardStartTimes[player] = os.time()
        playerData.OnlineRewardsKeepTime = 0
        playerData.OnlineRewardsClaimLog = {
            [1] = false, [2] = false, [3] = false, [4] = false,
            [5] = false, [6] = false, [7] = false, [8] = false,
            [9] = false, [10] = false, [11] = false, [12] = false,
        }

        if playerData.EventRewardClaimLog[Constants.EVENT_REWARD_ID.STARTER_PACK] == true then
            self._AdvancedPackStartTime[player] = os.time()
        end
        -- if not playerData.OnlineQuestTaskDown then
        --     self._OnlineQuestStartTime[player] = os.time() - playerData.OnlineQuestKeepTime
        -- end

        -- self.Client.UpdateTokenCountdown:Fire(player, playerData.TokenOnlineTime)
    end)

    local updateTimer = Timer.new(1)
    updateTimer.Tick:Connect(function()
        for  _, player in pairs(Players:GetPlayers()) do
            local profile = PlayerDataService:GetProfile(player)
            if not profile then continue end

            -- profile.Data.OnlineQuestKeepTime += 1

            if self._OnlineRewardStartTimes[player] then
                if profile.Data.StarterPackTaskDown ~= true then
                    if os.time() - self._OnlineRewardStartTimes[player] >= Constants.ONLINE_STARTER_PACK_TIME then
                        profile.Data.StarterPackTaskDown = true
                    end
                end
            end

            if self._AdvancedPackStartTime[player] then
                if profile.Data.AdvancedPackTask1Down ~= true then
                    if os.time() - self._AdvancedPackStartTime[player] >= Constants.ONLINE_ADVANCED_PACK_TIME then
                        profile.Data.AdvancedPackTask1Down = true
                    end
                end
            end

            -- if self._OnlineQuestStartTime[player] then
            --     if profile.Data.OnlineQuestTaskDown ~= true then
            --         if os.time() - self._OnlineQuestStartTime[player] >= Constants.ONLINE_QUEST_TIME then
            --             profile.Data.OnlineQuestTaskDown = true
            --             profile.Data.OnlineQuestKeepTime = 0
            --         end
            --     end
            -- end

            -- if profile.Data.TokenOnlineTime >= Constants.TOKEN_RESET_TIME then
            --     profile.Data.TokenOnlineTime = 0
            --     local addToken = 1
            --     if profile.Data.GamePasses[Constants.GAMEPASS.DOUBLE_TOKENS] == true then
            --         addToken = 2
            --     end
            --     PlayerDataService:AdjustTokens(player, addToken)
            --     self.Client.ResetTokenCountdown:Fire(player)
            -- else
            --     profile.Data.TokenOnlineTime = profile.Data.TokenOnlineTime + 1
            -- end
        end
    end)
    updateTimer:Start()
end


return OnlineRewardService
