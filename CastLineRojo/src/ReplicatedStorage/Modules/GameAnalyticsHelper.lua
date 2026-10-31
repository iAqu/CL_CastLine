local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local GameAnalytics = require(ReplicatedStorage.GameAnalytics)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

module = {}

function module.AddBusinessEvent(player: Player, productId: string)
    if not player then warn("No player") return end
    local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
    if not purchaseId then warn("No purchaseId") return end
    if not PurchaseDataHelper.GetData(purchaseId) then warn("No purchase data") return end

    GameAnalytics:addBusinessEvent(player.UserId, {
        amount = PurchaseDataHelper.GetPrice(purchaseId),
        itemType = PurchaseDataHelper.GetType(productId),
        itemId = purchaseId,
        cartType = "ingame"
    })
end

return module
