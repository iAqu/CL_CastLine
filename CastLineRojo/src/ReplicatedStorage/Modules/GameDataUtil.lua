local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Template = require(ReplicatedStorage.PlayerData.Template)
local Constants = require(ReplicatedStorage.Modules.Constants)
local UpgradesDataHelper = require(ReplicatedFirst.DataHelpers.UpgradesDataHelper)
local AchievementsDataHelper = require(ReplicatedFirst.DataHelpers.AchievementsDataHelper)

local GameDataUtil = {}

function GameDataUtil.CalculateSuperRebirthBaseBoost(superRebirths: number): number
    return superRebirths * 0.2
end

function GameDataUtil.CalculateSuperRebirtRequired(superRebirths: number): number
    return 30 + superRebirths
end

function GameDataUtil.CalculateWinsBoost(playerData: Template.PlayerData): number
    local totalBoost = 1

    if playerData.GamePasses[Constants.GAMEPASS.DOUBLE_WINS] then
        totalBoost *= 2
    end

    local achievementBoost = AchievementsDataHelper.GetBoostValue(playerData, AchievementsDataHelper.ACHIEVEMENT_TYPE.WINS)
    totalBoost *= (1 + achievementBoost)

    local winsUpgradeBoost = UpgradesDataHelper.GetPlayerBoostValue(playerData, Constants.UPGRADE_ID.WINS_BOOST)
    totalBoost *= (1 + winsUpgradeBoost)

    return totalBoost
end

function GameDataUtil.IsTradeSystemLocked(playerData): boolean
    if not playerData then warn("playerData is nil!") return end

    if playerData.Rebirths >= 3 then
        return false
    else
        return true
    end
end

return GameDataUtil
