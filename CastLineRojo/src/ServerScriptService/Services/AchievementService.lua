local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local AchievementsDataHelper = require(ReplicatedFirst.DataHelpers.AchievementsDataHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local AchievementService = Knit.CreateService {
    Name = "AchievementService",
    Client = {
        -- Client -> Server
        ClaimAchievementEvent = Knit.CreateSignal(),

        -- Server -> Client
        ClaimAchievementResultEvent = Knit.CreateSignal(),
    },
}

local function claimAchievement(player: Player, achievementId: string)
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then warn("PlayerData not found: ", player) return end

    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    local currentRank = playerData.AchievementRanks[achievementType] or 0

    if currentRank >= AchievementsDataHelper.GetAchievementRank(achievementId) then warn("Achievement already claimed: ", achievementId) return end
    if currentRank >= AchievementsDataHelper.GetAchievementMaxRank(achievementType) then warn("Achievement max rank: ", achievementId) return end

    local progressValue = AchievementsDataHelper.GetProgressValueByType(playerData, achievementType)
    if progressValue < AchievementsDataHelper.GetRequirementValue(achievementId) then
        warn("Not enough progress: ", achievementId)
        return
    end

    playerData.AchievementRanks[achievementType] = currentRank + 1
    -- playerData.AchievementClaimLog[achievementId] = true

    AchievementService.Client.ClaimAchievementResultEvent:Fire(player, achievementId, true, "Claim Success!")
end

function AchievementService:KnitInit()
end

function AchievementService:KnitStart()
    self.Client.ClaimAchievementEvent:Connect(function(player: Player, achievementId: string)
        claimAchievement(player, achievementId)
    end)

    local playTimer = Timer.new(1)
    playTimer.Tick:Connect(function()
        for _, loopPlayer in pairs(Players:GetPlayers()) do
            local playerData = PlayerDataService:GetAllData(loopPlayer)
            if not playerData then continue end

            playerData.PlayTime = playerData.PlayTime + 1
        end
    end)
    playTimer:Start()
end

return AchievementService