local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StorePacksData = require(ReplicatedFirst.Data.StorePacksData)

local Template = require(ReplicatedStorage.PlayerData.Template)

local StorePacksDataHelper  = {}

function StorePacksDataHelper.GetAllPackIds(): {string}
    local allPackIds = {}
    for packId, _ in pairs(StorePacksData) do
        table.insert(allPackIds, packId)
    end
    return allPackIds
end

function StorePacksDataHelper .GetRewardDataByPackId(packId: string): StorePacksData.StorePackConfig | nil
    local packData = StorePacksData[packId]
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end
    return packData
end

function StorePacksDataHelper.GetItemTypeByPackId(packId: string, index: number): string | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end

    return packData["Type_" .. index]
end

function StorePacksDataHelper.GetItemIdByPackId(packId: string, index: number): string | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end

    return packData["Id_" .. index]
end

function StorePacksDataHelper.GetItemCountByPackId(packId: string, index: number): number | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end

    return packData["Count_" .. index]
end

function StorePacksDataHelper.GetDisplayName(packId: string): string | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end

    return packData.DisplayName
end

function StorePacksDataHelper.GetOriginalPrice(packId: string): number
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return 0 end

    return packData.OriginalPrice
end

function StorePacksDataHelper.GetCurrentPrice(packId: string): number | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)

    return packData.CurrentPrice
end

function StorePacksDataHelper.GetSloganText(packId: string): string | nil
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return nil end

    return packData.SloganText
end

function StorePacksDataHelper.GetShowRebirth(packId: string): number
    local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
    if not packData then warn("StorePacksData not found for packId: " .. packId); return 0 end

    return packData.ShowRebirth
end

function StorePacksDataHelper.GetShowPackId(playerData: Template.PlayerData): string | nil
    local sortedAllPacks = {}
    local sortedLeftPacks = {}

    for packId, _ in pairs(StorePacksData) do
        table.insert(sortedAllPacks, packId)
        if not playerData.LimitedPurchaseHistory[packId] then 
            table.insert(sortedLeftPacks, packId) 
        end
    end
    table.sort(sortedAllPacks, function(a, b)
        return StorePacksDataHelper.GetShowRebirth(a) < StorePacksDataHelper.GetShowRebirth(b)
    end)
    table.sort(sortedLeftPacks, function(a, b)
        return StorePacksDataHelper.GetShowRebirth(a) < StorePacksDataHelper.GetShowRebirth(b)
    end)

    if playerData.LimitedPurchaseHistory[sortedAllPacks[#sortedAllPacks]] then return nil end     -- have bought the best pack in all packs
    if #sortedLeftPacks == 0 then return nil end   -- sold out

    local bestPackId = nil
    -- local bestIndex = 0

    for _, packId in ipairs(sortedLeftPacks) do
        if not bestPackId then bestPackId = packId end

        if playerData.Rebirths >= StorePacksDataHelper.GetShowRebirth(packId) then
            bestPackId = packId
        end
    end

    return bestPackId
end

function StorePacksDataHelper.GetAllItemData(packId: string): {string: string}
    local packData = StorePacksDataHelper.GetRewardDataByPackId(packId)
    local allItemData = {}
    for i = 1, 5 do
        if packData["Type_" .. i] ~= "nil" and packData["Type_" .. i] ~= nil then
            
            if packData["Type_" .. i] == nil or packData["Id_" .. i] == nil or packData["Count_" .. i] == nil then
                break 
            end

            -- if packData["Type_" .. i] == "nil" or packData["Id_" .. i] == "nil" or packData["Count_" .. i] == "nil" then
            --     break 
            -- end

            allItemData[i] = {
                Type = packData["Type_" .. i],
                Id = packData["Id_" .. i],
                Count = packData["Count_" .. i],
            }
        else
            break
        end
    end
    return allItemData
end

-- function StorePacksDataHelper.GetTotalItemNum(packId: string): number
--     local packData = StorePacksDataHelper .GetRewardDataByPackId(packId)
--     local totalNum = 0
--     for i = 1, 5 do
--         if packData["Type_" .. i] ~= "nil" then
--             totalNum = totalNum + 1
--         else
--             break
--         end
--     end
--     return totalNum
-- end

return StorePacksDataHelper 