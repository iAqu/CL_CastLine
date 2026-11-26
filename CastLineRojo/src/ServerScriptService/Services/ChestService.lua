local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)

export type RedeemResult = {
    isSuccess: boolean,
    resultText: string,
}

local groupClaims = {}

local JOIN_GROUP_NOTIF_TEXT = "👍 Like the game and join the group to unlock!"

local ChestService = Knit.CreateService {
    Name = "ChestService",
    Client = {
        ClaimGroupChestComplete = Knit.CreateSignal(),
        MarkGroupJoinedComplete = Knit.CreateSignal(),
    },
}

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

return ChestService
