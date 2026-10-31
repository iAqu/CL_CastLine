local ReplicatedFirst = game:GetService("ReplicatedFirst")
local LimitedPacksData = require(ReplicatedFirst.Data.LimitedPacksData)

local LimitedPacksDataHelper = {}

function LimitedPacksDataHelper.GetLimitedPackData(limitedPackId: string): LimitedPacksData.LimitedPackConfig
    if not LimitedPacksData[limitedPackId] then return nil end
    return LimitedPacksData[limitedPackId]
end

function LimitedPacksDataHelper.GetDisplayName(limitedPackId: string): string
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData.DisplayName
end

function LimitedPacksDataHelper.GetLayoutOrder(limitedPackId: string): number
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData.LayoutOrder
end

function LimitedPacksDataHelper.GetOriginalPrice(limitedPackId: string): number
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData.OriginalPrice
end

function LimitedPacksDataHelper.GetPrice(limitedPackId: string): number
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData.Price
end

function LimitedPacksDataHelper.GetUnlockArea(limitedPackId: string): string
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData.UnlockArea
end

function LimitedPacksDataHelper.GetItemType(limitedPackId:string, itemIndex: number): string
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData["ItemType_" .. itemIndex]
end

function LimitedPacksDataHelper.GetItemId(limitedPackId:string, itemIndex: number): string
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData["ItemID_" .. itemIndex]
end

-- if item is a item, the 'ItemCount' is the rarity index , item count always 1
function LimitedPacksDataHelper.GetItemRarityIndex(limitedPackId:string, itemIndex: number): number
    local itemType = LimitedPacksDataHelper.GetItemType(limitedPackId, itemIndex)
    if not itemType or itemType ~= "Item" then warn("Item is not a item") return end
    return LimitedPacksDataHelper.GetItemCount(limitedPackId, itemIndex)
end

function LimitedPacksDataHelper.GetItemCount(limitedPackId:string, itemIndex: number): number
    local limitedPackData = LimitedPacksDataHelper.GetLimitedPackData(limitedPackId)
    return limitedPackData["ItemCount_" .. itemIndex]
end

return LimitedPacksDataHelper