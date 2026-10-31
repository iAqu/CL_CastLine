local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UpgradesData = require(ReplicatedFirst.Data.UpgradesData)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)

local UpgradesDataHelper = {}

function UpgradesDataHelper.GetAllData()
    return UpgradesData
end

function UpgradesDataHelper.GetData(upgradeId: string)
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return UpgradesData[upgradeId]
end

function UpgradesDataHelper.GetIndex(upgradeId: string): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return 0 end
    return UpgradesData[upgradeId].Index
end

function UpgradesDataHelper.GetPrice(upgradeId: string, level: number): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return 0 end
    if level <= 0 then return 0 end
    local data = UpgradesData[upgradeId]
    local price = data.InitPrice * (data.PriceGrowth ^ (level - 1))
    return NumberUtil.ZeroOutFromThirdDigit(price)
end

function UpgradesDataHelper.GetRealBoost(upgradeId: string, level :number): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return 0 end
    level = level or 0
    return UpgradesData[upgradeId].LevelBoost * level / 100
end

function UpgradesDataHelper.GetPercentBoost(upgradeId: string, level :number): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return 0 end
    level = level or 0
    return UpgradesData[upgradeId].LevelBoost * level
end

function UpgradesDataHelper.GetName(upgradeId: string): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return UpgradesData[upgradeId].Name
end

function UpgradesDataHelper.GetMaxLevel(upgradeId: string): number
    if not UpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return 0 end
    return UpgradesData[upgradeId].MaxLevel
end

function UpgradesDataHelper.GetIconId(upgradeId: string): number
    local upgradeData = UpgradesData[upgradeId]
    if not upgradeData then return 0 end
    return upgradeData.IconID
end

function UpgradesDataHelper.GetNameColor(upgradeId: string): Color3
    local upgradeData = UpgradesData[upgradeId]
    if not upgradeData then warn("Upgrade not found: ", upgradeId) return Color3.new(1, 1, 1) end
    local r,g,b = string.match(upgradeData.NameColor,"(%d+), (%d+), (%d+)")
    local color3Value = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    return color3Value
end

function UpgradesDataHelper.GetPlayerBoostValue(playerData, upgradeId: string): number
    local upgradeRank = playerData.Upgrades[upgradeId] or 0
    return UpgradesDataHelper.GetRealBoost(upgradeId, upgradeRank)
end

return UpgradesDataHelper
