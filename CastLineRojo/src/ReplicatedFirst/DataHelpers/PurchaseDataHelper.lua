local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PurchaseData = require(ReplicatedFirst.Data.PurchaseData)
local PurchaseDataHelper = {}

function PurchaseDataHelper.IsRetired(purchaseId: unknown): boolean
    return purchaseId == "FastMove"
end

function PurchaseDataHelper.GetAllData(): {string: PurchaseData.PurchaseConfig}
    return PurchaseData
end

function PurchaseDataHelper.GetData(purchaseId: string): PurchaseData.PurchaseConfig
    return PurchaseData[purchaseId]
end

function PurchaseDataHelper.GetGamePassesData(): {string: PurchaseData.PurchaseConfig}
    local gamePasses = {}
    for purchaseId, purchaseData in pairs(PurchaseData) do
        if purchaseData.Type == "GamePass" and not PurchaseDataHelper.IsRetired(purchaseId) then
            gamePasses[purchaseId] = purchaseData
        end
    end
    return gamePasses
end

function PurchaseDataHelper.GetWinsData(): {string: PurchaseData.PurchaseConfig}
    local winsData = {}
    for purchaseId, purchaseData in pairs(PurchaseData) do
        if purchaseData.Type == "Wins" then
            winsData[purchaseId] = purchaseData
        end
    end
    return winsData
end

function PurchaseDataHelper.GetDiamondsData(): {string: PurchaseData.PurchaseConfig}
    local diamondsData = {}
    for purchaseId, purchaseData in pairs(PurchaseData) do
        if purchaseData.Type == "Diamond" then
            diamondsData[purchaseId] = purchaseData
        end
    end
    return diamondsData
end

function PurchaseDataHelper.GetDataByType(type: "Wins" | "Gear" | "VoidGear"): {string: PurchaseData.PurchaseConfig}
    local data = {}
    for purchaseId, purchaseData in pairs(PurchaseData) do
        if purchaseData.Type == type then
            data[purchaseId] = purchaseData
        end
    end
    return data
end

function PurchaseDataHelper.GetIndex(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).Index then warn("PurchaseData.Index not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).Index
end

    function PurchaseDataHelper.GetName(purchaseId: string): string
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).Name then warn("PurchaseData.Name not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).Name
end

function PurchaseDataHelper.GetIconId(purchaseId: string): string
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).IconId then warn("PurchaseData.IconId not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).IconId
end

function PurchaseDataHelper.GetPrice(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).Price then warn("PurchaseData.Price not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).Price
end

function PurchaseDataHelper.GetDescription(purchaseId: string): string
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).Description then warn("PurchaseData.Description not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).Description
end

function PurchaseDataHelper.GetLimitedCount(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).ProductId then warn("PurchaseData.ProductId not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).LimitedCount
end

function PurchaseDataHelper.GetBuyNum(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).BuyNum then warn("PurchaseData.BuyNum not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).BuyNum
end

function PurchaseDataHelper.GetProductId(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).ProductId then warn("PurchaseData.ProductId not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).ProductId
end

function PurchaseDataHelper.GetGiftProductId(purchaseId: string): number
    if not PurchaseDataHelper.GetData(purchaseId) then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    if not PurchaseDataHelper.GetData(purchaseId).GiftProductId then warn("PurchaseData.GiftProductId not found for purchaseId: " .. purchaseId) return end
    return PurchaseDataHelper.GetData(purchaseId).GiftProductId
end

function PurchaseDataHelper.GetType(productId: number): string
    for _, purchaseData in pairs(PurchaseData) do
        if purchaseData.ProductId == productId or purchaseData.GiftProductId == productId then
            return purchaseData.Type
        end
    end
end

function PurchaseDataHelper.GetTypeByPurchaseId(purchaseId: string): string
    if not PurchaseData[purchaseId] then warn("PurchaseData not found for purchaseId: " .. purchaseId) return end
    return PurchaseData[purchaseId].Type
end

function PurchaseDataHelper.GetPurchaseId(productId: number): string
    for purchaseId, purchaseData in pairs(PurchaseData) do
        if purchaseData.ProductId == productId then
            return purchaseId
        end
        if purchaseData.GiftProductId == productId then
            return purchaseId
        end
    end
end

return PurchaseDataHelper
