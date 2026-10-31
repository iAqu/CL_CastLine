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

local function chooseDailyRewardIndex(player: Player): number
    local itemList = {}
    local totalWeight = 0
    for index, weight in pairs(Constants.CHEST_DAILY_CHANCE) do
        totalWeight += weight
        table.insert(itemList, {
            INDEX = index,
            WEIGHT = weight,
        })
    end

    table.sort(itemList, function(a, b) return a.WEIGHT < b.WEIGHT end)

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
    if not profile then warn "No profile found!" end
    if not profile.Data.DailyChestLastOpenTime then warn "No daily chest data found!" end

    if os.time() - profile.Data.DailyChestLastOpenTime < Constants.CHEST_OPEN_COOLDOWN then
        warn("Daily chest cooldown not reached!")
    end

    local rewardIndex = chooseDailyRewardIndex(player)
    local rewardType = DailyChestReward[rewardIndex].Type
    local rewardId = DailyChestReward[rewardIndex].Id
    local resultText = nil
    if rewardType == "Potion" then
        Knit.GetService("PotionService"):AdjustPotionCount(player, rewardId, 1)
        resultText = Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", PurchaseDataHelper.GetName(rewardId))
    end

    profile.Data.DailyChestLastOpenTime = os.time()

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

    local isInGroup = false
    local ok, result = pcall(function()
        return player:IsInGroupAsync(game.CreatorId)
    end)
    if ok then
        isInGroup = result
    else
        warn("ChestService: IsInGroupAsync failed for", player, result)
    end
    if not isInGroup and profile.Data.GroupJoinPromptSucceeded ~= true then
        return {isSuccess = false, resultText = JOIN_GROUP_NOTIF_TEXT}
    end

    PlayerDataService:AdjustWins(player, 5000)
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
