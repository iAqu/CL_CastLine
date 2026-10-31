local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RebirthData = require(ReplicatedFirst.Data.RebirthData)
local TableUtil = require(ReplicatedStorage.Modules.TableUtil)

local RebirthDataHelper = {}

function RebirthDataHelper.GetRebirthId(rebirth: number): string
    return "Rebirth_" .. rebirth
end

function RebirthDataHelper.GetRebirthData(rebirth: number): RebirthData.RebirthConfig
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    return RebirthData[rebirthId]
end

function RebirthDataHelper.GetRebirthCost(rebirth: number): number
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then return nil end
    return math.round(RebirthData[rebirthId].Cost)
end

function RebirthDataHelper.GetRebirthBoost(rebirth: number): number
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then warn("RebirthData not found for rebirth: " .. rebirth) return nil end
    return RebirthData[rebirthId].Boost
end

function RebirthDataHelper.GetAuraId(rebirth: number): string
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then warn("RebirthData not found for rebirth: " .. rebirth) return nil end
    return RebirthData[rebirthId].AuraId
end

function RebirthDataHelper.GetBodyWidthScale(rebirth: number): number
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then warn("RebirthData not found for rebirth: " .. rebirth) return nil end
    return RebirthData[rebirthId].BodyWidthScale
end

function RebirthDataHelper.GetBodyDepthScale(rebirth: number): number
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then warn("RebirthData not found for rebirth: " .. rebirth) return nil end
    return RebirthData[rebirthId].BodyDepthScale
end

function RebirthDataHelper.GetBodyHeightScale(rebirth: number): number
    local rebirthId = RebirthDataHelper.GetRebirthId(rebirth)
    if not RebirthData[rebirthId] then warn("RebirthData not found for rebirth: " .. rebirth) return nil end
    return RebirthData[rebirthId].BodyHeightScale
end

function RebirthDataHelper.GetMaxRebirthCount(): number
    return TableUtil.CalculateTableLength(RebirthData)
end

return RebirthDataHelper