-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    pendingPurchaseRecipientUserId = nil,
    recipientOwnership = nil,
    recipientUnavailable = false,
    recipientUserId = nil
}, {
    storeGiftModeStarted = produceWrapper(function(p1, p2) -- line: 12
        p1.recipientUserId = p2.recipientUserId
        p1.recipientOwnership = nil
        p1.recipientUnavailable = false
    end),
    storeGiftModeStopped = produceWrapper(function(p3) -- line: 17
        p3.recipientUserId = nil
        p3.recipientOwnership = nil
        p3.recipientUnavailable = false
    end),
    storeGiftRecipientOwnershipUpdated = produceWrapper(function(p4, p5) -- line: 22
        if p5.ownership == nil then
            p4.recipientOwnership = nil
            p4.recipientUnavailable = true

            return nil
        end

        p4.recipientOwnership = p5.ownership
        p4.recipientUnavailable = false
    end),
    storePurchasePromptStarted = produceWrapper(function(p6, p7) -- line: 31
        p6.pendingPurchaseRecipientUserId = p7.recipientUserId
    end),
    storePurchasePromptConsumed = produceWrapper(function(p8) -- line: 34
        p8.pendingPurchaseRecipientUserId = nil
    end)
})

v1:getActions()

return {
    storeGiftUiSlice = v1
}
