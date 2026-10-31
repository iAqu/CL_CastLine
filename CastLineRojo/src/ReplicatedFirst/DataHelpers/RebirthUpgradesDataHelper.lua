local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthUpgradesData = require(ReplicatedFirst.Data.RebirthUpgradesData)
local PlayerData = require(ReplicatedStorage.PlayerData.Template)

local RebirthUpgradesDataHelper = {}

function RebirthUpgradesDataHelper.GetAllData()
    return RebirthUpgradesData
end

function RebirthUpgradesDataHelper.GetData(upgradeId: string)
    if not RebirthUpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return RebirthUpgradesData[upgradeId]
end

function RebirthUpgradesDataHelper.GetIndex(upgradeId: string): number
    if not RebirthUpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return RebirthUpgradesData[upgradeId].Index
end

function RebirthUpgradesDataHelper.GetPrice(upgradeId: string, upgradeLevel: number?): number
    upgradeLevel = upgradeLevel or 1
    local rebirthUpgradesData = RebirthUpgradesDataHelper.GetData(upgradeId)
    if not rebirthUpgradesData then warn("Item not found: ", upgradeId) return end

    local prices = {}
    for _, price in pairs(rebirthUpgradesData.Price:split("|")) do
        table.insert(prices, price)
    end
    if #prices == 0 then
        return nil
    else
        if not prices[upgradeLevel] then
            return tonumber(prices[#prices])
        else
            return tonumber(prices[upgradeLevel])
        end
    end
end

function RebirthUpgradesDataHelper.GetBoostValue(upgradeId: string): number
    if not RebirthUpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return RebirthUpgradesData[upgradeId].BoostValue
end

function RebirthUpgradesDataHelper.GetDisplayName(upgradeId: string): number
    if not RebirthUpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return RebirthUpgradesData[upgradeId].DisplayName
end

function RebirthUpgradesDataHelper.GetMaxLevel(upgradeId: string): number
    if not RebirthUpgradesData[upgradeId] then warn("upgradeId not found: " .. upgradeId) return end
    return RebirthUpgradesData[upgradeId].MaxLevel
end

function RebirthUpgradesDataHelper.GetIconId(upgradeId: string): number
    return RebirthUpgradesData[upgradeId].IconID
end

return RebirthUpgradesDataHelper