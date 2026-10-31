-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    inFlightRetryProductIds = {},
    pendingExtraInfoByProductId = {}
}, {
    purchaseExtraInfoQueued = produceWrapper(function(p1, p2) -- line: 10
        p1.pendingExtraInfoByProductId[p2.productId] = p2.extraInfo
    end),
    purchaseExtraInfoConsumed = produceWrapper(function(p3, p4) -- line: 16
        p3.pendingExtraInfoByProductId[p4.productId] = nil
    end),
    purchasePromptWasCancelled = produceWrapper(function(p5, p6) -- line: 21
        p5.pendingExtraInfoByProductId[p6.productId] = nil
        p5.inFlightRetryProductIds[p6.productId] = nil
    end),
    purchaseRetryStarted = produceWrapper(function(p7, p8) -- line: 29
        p7.inFlightRetryProductIds[p8.productId] = true
    end),
    purchaseRetryFinished = produceWrapper(function(p9, p10) -- line: 34
        p9.inFlightRetryProductIds[p10.productId] = nil
    end)
})

v1:getActions()

return {
    storePurchaseSlice = v1
}
