-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v3 = createProducer({}, {
    playerLeft = produceWrapper(function(p1, p2) -- line: 8
        for v1, v2 in p1 do
            if v2.gifterUserId == p2.userId or v2.receiverUserId == p2.userId then
                p1[v1] = nil
            end
        end
    end),
    giftRequestCreated = produceWrapper(function(p3, p4) -- line: 16
        p3[p4.requestId] = {
            lavaBucketXp = p4.lavaBucketXp,
            gifterUserId = p4.gifterUserId,
            itemId = p4.itemId,
            itemName = p4.itemName,
            itemType = p4.itemType,
            receiverUserId = p4.receiverUserId,
            requestId = p4.requestId,
            timestamp = p4.timestamp
        }
    end),
    itemGifted = produceWrapper(function(p5, p6) -- line: 31
        p5[p6.requestId] = nil
    end),
    giftRequestRemoved = produceWrapper(function(p7, p8) -- line: 36
        p7[p8.requestId] = nil
    end)
})

v3:getActions()

return {
    giftRequestsSlice = v3
}
