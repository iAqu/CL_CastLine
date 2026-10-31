-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectPendingPurchaseExtraInfo = function(p1) -- selectPendingPurchaseExtraInfo | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return p2.storePurchase.pendingExtraInfoByProductId[p1]
        end
    end,
    selectIsPurchaseRetryInFlight = function(p3) -- selectIsPurchaseRetryInFlight | line: 9
        return function(p4) -- line: 10
            -- upvalues: p3 (copy)
            return p4.storePurchase.inFlightRetryProductIds[p3] ~= nil
        end
    end
}
