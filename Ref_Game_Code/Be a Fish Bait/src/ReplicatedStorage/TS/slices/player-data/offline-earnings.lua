-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v3 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 7
        local userId = p2.userId
        local pendingOfflineEarnings = p2.data.offlineEarnings.pendingOfflineEarnings

        if pendingOfflineEarnings == nil then
            pendingOfflineEarnings = 0
        end

        p1[userId] = {
            pendingOfflineEarnings = pendingOfflineEarnings
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 19
        p3[p4.userId] = nil
    end),
    offlineEarningsPending = produceWrapper(function(p5, p6) -- line: 24
        local v1 = p5[p6.userId]

        if not v1 then
            return nil
        end

        v1.pendingOfflineEarnings = p6.amount
    end),
    offlineEarningsCleared = produceWrapper(function(p7, p8) -- line: 33
        local v2 = p7[p8.userId]

        if not v2 then
            return nil
        end

        v2.pendingOfflineEarnings = 0
    end)
})

v3:getActions()

return {
    offlineEarningsSlice = v3
}
