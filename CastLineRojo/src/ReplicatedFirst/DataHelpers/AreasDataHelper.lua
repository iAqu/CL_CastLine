local ReplicatedFirst = game:GetService("ReplicatedFirst")
local AreasData = require(ReplicatedFirst.Data.AreasData)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Modules.Constants)

local Template = require(ReplicatedStorage.PlayerData.Template)

-- export type GearInstance = {
--     UUID: string,           -- 唯一标识
--     AreaId: string,         -- 所在场景ID
--     Type: "Gear" | "GoldenGear" | "VoidGear",           -- 类型
--     Count: number,          -- 数量
-- }

local AreasDataHelper = {}

function AreasDataHelper.GetAllData(): {}
    return AreasData
end

function AreasDataHelper.GetAreaData(areaId: string): {}
    return AreasData[areaId]
end

function AreasDataHelper.GetName(areaId: string): string
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then  warn("Area not found: ", areaId) return end
 if not areaInfo then return end
    return areaInfo.Name
end

function AreasDataHelper.GetIndex(areaId: string): number
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then  warn("Area not found: ", areaId) return end
 if not areaInfo then return end
    return areaInfo.Index
end

function AreasDataHelper.GetAreaIdByIndex(index: number): string
    for areaId, areaInfo in pairs(AreasData) do
        if areaInfo.Index == index then
            return areaId
        end
    end
    -- warn("Area not found: ", index)
    return nil
end

-- function AreasDataHelper.GetAreaIdsByWorldIndex(worldIndex: number): {string}
--     local areas = {}
--     for areaId, areaInfo in pairs(AreasData) do
--         if areaInfo.WorldIndex == worldIndex then
--             table.insert(areas, areaId)
--         end
--     end
--     return areas
-- end

function AreasDataHelper.GetWorldIndexByAreaId(areaId: string)
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then warn("Area not found: ", areaId) return end
 if not areaInfo then return end
    return areaInfo.WorldIndex
end

function AreasDataHelper.GetBackgroundId(areaId: string): string
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then warn("Area not found: ", areaId) return "" end
 if not areaInfo then return "" end
    return areaInfo.BackgroundID
end

function AreasDataHelper.GetTeleportBgId(areaId: string): string
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then warn("Area not found: ", areaId) return "" end
 if not areaInfo then return "" end
    return areaInfo.TeleportBgId
end

function AreasDataHelper.GetTagIconId(areaId: string, tagNum: number): string
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then warn("Area not found: ", areaId) return end
 if not areaInfo then return end
    local tag = nil
    if tagNum == 1 then
        tag = areaInfo.TeleportTagIcon1Id
    elseif tagNum == 2 then
        tag = areaInfo.TeleportTagIcon2Id
    end
    if tag == "nil" then
        return nil
    else
        return tag
    end
end

function AreasDataHelper.IsAreaUnlocked(playerdata: Template.PlayerData, areaId: string): boolean
    if areaId == "Area_Boss" then
        return playerdata.Areas["Area_1_2_Summer"]
    else
        return playerdata.Areas[areaId]
    end
end

function AreasDataHelper.GetWinsMultiplier(areaId: string): number
    local areaInfo = AreasData[areaId]
    -- if not areaInfo then warn("Area not found: ", areaId) return 0 end
 if not areaInfo then return 0 end
    return areaInfo.WinsMultiplier
end

function AreasDataHelper.GetPreviousArea(areaId: string): string
    local worldIndex = AreasDataHelper.GetWorldIndexByAreaId(areaId)
    local previousAreaId = nil
    for id, areaInfo in pairs(AreasData) do
        if areaInfo.WorldIndex == worldIndex-1 then
            previousAreaId = id
            break
        end
    end
    if previousAreaId then
        return previousAreaId
    else
        warn("No previous area found: ", areaId)
        return nil
    end
end

function AreasDataHelper.GetNextArea(areaId: string): string
    local worldIndex = AreasDataHelper.GetWorldIndexByAreaId(areaId)
    if worldIndex == 0 then return nil end

    local nextAreaId = nil
    for id, areaInfo in pairs(AreasData) do
        if areaInfo.WorldIndex == worldIndex+1 then
            nextAreaId = id
            break
        end
    end
    if nextAreaId then
        return nextAreaId
    else
        -- warn("No next area found: ", areaId)
        return nil
    end
end

function AreasDataHelper.IsPreviousAreasUnlocked(playerdata: Template.PlayerData, areaId: string): boolean
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return end

    for i = 1, areaData.Index - 1 do
        if not AreasDataHelper.IsAreaUnlocked(playerdata, AreasDataHelper.GetAreaIdByIndex(i)) then
            return false
        end
    end
    return true
end

function AreasDataHelper.IsBossUnlocked(playerdata: Template.PlayerData)
    return AreasDataHelper.IsAreaUnlocked(playerdata, "Area_Boss")
end

function AreasDataHelper.GetLastAreaId(playerdata: Template.PlayerData): string
    local lastAreaId = "Area_1"
    for areaId, isUnlocked in pairs(playerdata.Areas) do
        if not isUnlocked then continue end
        if not AreasDataHelper.GetIndex(areaId) then continue end
        if AreasDataHelper.GetIndex(areaId) > AreasDataHelper.GetIndex(lastAreaId) then
            lastAreaId = areaId
        end
    end
    return lastAreaId
end

function AreasDataHelper.GetNewestNormalAreaId(playerdata: Template.PlayerData): string
    local newestAreaId = "Area_1"

    for areaId, isUnlocked in pairs(playerdata.Areas) do
        if not isUnlocked then continue end
        if not AreasDataHelper.GetIndex(areaId) then continue end
        if AreasDataHelper.GetType(areaId) ~= "Normal" then continue end

        if AreasDataHelper.GetIndex(areaId) > AreasDataHelper.GetIndex(newestAreaId) then
            newestAreaId = areaId
        end
    end

    return newestAreaId
end

function AreasDataHelper.GetUnlockedAreaCount(playerdata: Template.PlayerData): number
    local count = 0
    for areaId, isUnlocked in pairs(playerdata.Areas) do
        if isUnlocked and AreasDataHelper.GetType(areaId) == "Normal" then
            count = count + 1
        end
    end
    return count
end

function AreasDataHelper.GetLayoutOrder(areaId: string): number
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return end
    return areaData.LayoutOrder
end

function AreasDataHelper.GetType(areaId: string): string
    local areaData = AreasData[areaId]
    if not areaData then return end
    return areaData.Type
end

function AreasDataHelper.GetBackgroudImageId(areaId: string): string
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return end
    return areaData.BackgroudImageId
end

function AreasDataHelper.GetNextAeraImageId(areaId: string): string
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return end
    return areaData.NextAeraImageId
end

function AreasDataHelper.GetUnlockTrophy(areaId: string): number
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return end
    return areaData.UnlockTrophy
end

function AreasDataHelper.GetUnlockRebirth(areaId: string): number
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
 if not areaData then return 0 end
    return areaData.UnlockRebirth
end

function AreasDataHelper.GetTrophyCount(areaId: string): number
    local areaData = AreasData[areaId]
    -- if not areaData then warn("Area not found: ", areaId) return end
    if not areaData then return 0 end
    return areaData.TrophyCount
end

return AreasDataHelper