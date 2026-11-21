local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

export type RedeemResult = {
    isSuccess: boolean,
    resultText: string,
}

local groupClaims = {}

local JOIN_GROUP_NOTIF_TEXT = "👍 Like the game and join the group to unlock!"

local DailyChestReward = {
	{ Type = "Potion", Id = Constants.POTION_ID.DOUBLE_WINS},
	{ Type = "Potion", Id = Constants.POTION_ID.DOUBLE_EXP},
	{ Type = "Potion", Id = Constants.POTION_ID.DOUBLE_WINS_SPEED},
	{ Type = "Potion", Id = Constants.POTION_ID.MUTATION},
	{ Type = "Potion", Id = Constants.POTION_ID.MUTATION},
}

local ChestService = Knit.CreateService {
    Name = "ChestService",
    Client = {
        ClaimDailyChestComplete = Knit.CreateSignal(),
        ClaimGroupChestComplete = Knit.CreateSignal(),
        MarkGroupJoinedComplete = Knit.CreateSignal(),
    },
}

function ChestService.Client:ClaimDailyChest(player: Player): {string}
    return self.Server:ClaimDailyChest(player)
end

local function chooseDailyRewardIndex(): number
    local itemList = {}
    local totalWeight = 0
    for index, weight in pairs(Constants.CHEST_DAILY_CHANCE) do
        totalWeight += weight
        table.insert(itemList, {
            INDEX = index,
            WEIGHT = weight,
        })
    end

    local randomNum = math.random(1, totalWeight)
    local count = 0
    local finalItemIndex = nil
    for _, itemInfo in ipairs(itemList) do
        count += itemInfo.WEIGHT
        if randomNum <= count then
            finalItemIndex = itemInfo.INDEX
            break
        end
    end
    return finalItemIndex
end

function ChestService:ClaimDailyChest(player: Player): {string}
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile or not profile:IsActive() then
        return { "Player data is not ready." }
    end
    local now = os.time()
    local lastOpenTime = profile.Data.DailyChestLastOpenTime
    if now - (tonumber(lastOpenTime) or 0) < Constants.CHEST_OPEN_COOLDOWN then
        return { "Daily chest cooldown not reached." }
    end

    local rewardIndex = chooseDailyRewardIndex()
    local rewardType = DailyChestReward[rewardIndex].Type
    local rewardId = DailyChestReward[rewardIndex].Id
    local resultText = nil
    if rewardType == "Potion" then
        profile.Data.DailyChestLastOpenTime = now
        if not Knit.GetService("PotionService"):AdjustPotionCount(player, rewardId, 1) then
            profile.Data.DailyChestLastOpenTime = lastOpenTime
            return { "Could not claim this reward." }
        end
        resultText = Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", PurchaseDataHelper.GetName(rewardId))
    end

    self.Client.ClaimDailyChestComplete:Fire(player, profile.Data.DailyChestLastOpenTime)

    return {resultText}
end

function ChestService.Client:ClaimGroupChest(player: Player): RedeemResult
    return self.Server:ClaimGroupChest(player)
end

function ChestService.Client:MarkGroupJoined(player: Player): boolean
    return self.Server:MarkGroupJoined(player)
end

function ChestService:ClaimGroupChest(player: Player): RedeemResult
    local profile = PlayerDataService:GetProfile(player)
    if not profile then
        warn("ChestService: no profile found for group chest")
        return {isSuccess = false, resultText = "Player data is not ready."}
    end
    if profile.Data.GroupChestIsClaimed then
        return {isSuccess = false, resultText = "Group chest already claimed!"}
    end

    if groupClaims[player] then
        return {isSuccess = false, resultText = "Group chest claim is in progress."}
    end

    groupClaims[player] = true
    local ok, isInGroup = pcall(player.IsInGroupAsync, player, game.CreatorId)
    groupClaims[player] = nil
    if PlayerDataService:GetProfile(player) ~= profile or not profile:IsActive() then
        return {isSuccess = false, resultText = "Player data is not ready."}
    end
    if profile.Data.GroupChestIsClaimed then
        return {isSuccess = false, resultText = "Group chest already claimed!"}
    end
    if not ok then
        warn("ChestService: IsInGroupAsync failed for", player, isInGroup)
    end
    if (not ok or not isInGroup) and profile.Data.GroupJoinPromptSucceeded ~= true then
        return {isSuccess = false, resultText = JOIN_GROUP_NOTIF_TEXT}
    end

    if not PlayerDataService:AdjustWins(player, 5000) then
        return {isSuccess = false, resultText = "Could not claim this reward."}
    end
    profile.Data.GroupChestIsClaimed = true
    self.Client.ClaimGroupChestComplete:Fire(player)
    return {isSuccess = true, resultText = "Received 5000 Wins!"}
end

function ChestService:MarkGroupJoined(player: Player): boolean
    local profile = PlayerDataService:GetProfile(player)
    if not profile then
        warn("ChestService: no profile found when marking group join")
        return false
    end

    local ok, isInGroup = pcall(function()
        return player:IsInGroupAsync(game.CreatorId)
    end)
    if not ok or not isInGroup then
        if not ok then
            warn("ChestService: IsInGroupAsync failed when marking group join", isInGroup)
        end
        return false
    end

    if PlayerDataService:GetProfile(player) ~= profile or not profile:IsActive() then
        return false
    end
    profile.Data.GroupJoinPromptSucceeded = true
    self.Client.MarkGroupJoinedComplete:Fire(player)
    return true
end

function ChestService:KnitInit()
end

function ChestService:KnitStart()
    -- self.Client.ClaimDailyChest:Connect(function(player: Player)
    --     self:ClaimDailyChest(player)
    -- end)

    -- self.Client.ClaimGroupChest:Connect(function(player: Player)
    --     self:ClaimGroupChest(player)
    -- end)
end

return ChestService
