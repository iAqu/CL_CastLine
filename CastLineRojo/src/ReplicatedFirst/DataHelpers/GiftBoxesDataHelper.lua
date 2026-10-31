local ReplicatedFirst = game:GetService("ReplicatedFirst")
local GiftBoxesData = require(ReplicatedFirst.Data.GiftBoxesData)

local GiftBoxesDataHelper = {}

export type GiftInstance = {
    UUID: string,           -- 唯一标识
    ItemType: "Wins" | "Strength" | "Potion" | "Diamond",     -- 类型
    ItemId: string,                     -- ID
    Value: number,                   -- 每个实例的数量(价值)
    AllowDisabledPotionGrant: boolean?,
}

function GiftBoxesDataHelper.GetAllData()
    return GiftBoxesData
end

function GiftBoxesDataHelper.GetGiftTypeNum(): number
    return 4
end

function GiftBoxesDataHelper.GetItemType(giftBoxId: string, index: number): string
    if not GiftBoxesData[giftBoxId] then warn("GiftBoxId not found: " .. giftBoxId) return end
    return GiftBoxesData[giftBoxId]["Type_" .. index]
end

function GiftBoxesDataHelper.GetItemId(giftBoxId: string, index: number): string
    if not GiftBoxesData[giftBoxId] then warn("GiftBoxId not found: " .. giftBoxId) return end
    return GiftBoxesData[giftBoxId]["Id_" .. index]
end

function GiftBoxesDataHelper.GetItemCount(giftBoxId: string, index: number): number
    if not GiftBoxesData[giftBoxId] then warn("GiftBoxId not found: " .. giftBoxId) return end
    return  GiftBoxesData[giftBoxId]["Count_" .. index]
end

return GiftBoxesDataHelper
