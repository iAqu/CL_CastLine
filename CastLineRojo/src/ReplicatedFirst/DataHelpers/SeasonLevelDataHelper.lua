local ReplicatedFirst = game:GetService("ReplicatedFirst")
local SeasonLevelData = require(ReplicatedFirst.Data.SeasonLevelData)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Modules.Constants)

local Template = require(ReplicatedStorage.PlayerData.Template)

local SeasonLevelDataHelper= {}

function SeasonLevelDataHelper.GetAllData()
    return SeasonLevelData
end

function SeasonLevelDataHelper.GetData(levelId: string)
    return SeasonLevelData[levelId]
end

function SeasonLevelDataHelper.GetRequirementXp(levelId: string): string
    local SeasonLevelData = SeasonLevelData[levelId]
    if not SeasonLevelData then  warn("Achievement not found: ", SeasonLevelData) return end
    return SeasonLevelData.RequirementXp
end

return SeasonLevelDataHelper