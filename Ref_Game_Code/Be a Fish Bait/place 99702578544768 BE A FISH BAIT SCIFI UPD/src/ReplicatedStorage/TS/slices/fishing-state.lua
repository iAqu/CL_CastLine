-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v9 = createProducer({}, {
    playerStartedFishing = produceWrapper(function(p1, p2) -- line: 7
        local v1 = p1[p2.userId]

        p1[p2.userId] = {
            fishingState = "flying",
            caughtFishName = nil,
            castParams = p2.castParams,
            castTimestamp = p2.castTimestamp,
            caughtFishMutations = {},
            lastCastTimestamp = if v1 ~= nil then v1.lastCastTimestamp else v1,
            pendingApexFishId = nil,
            pendingCaughtFishId = nil
        }
    end),
    lastCastTimestampUpdated = produceWrapper(function(p3, p4) -- line: 30
        local v2 = p3[p4.userId]

        if v2 then
            v2.lastCastTimestamp = p4.lastCastTimestamp
        else
            p3[p4.userId] = {
                fishingState = nil,
                castParams = nil,
                castTimestamp = nil,
                caughtFishName = nil,
                pendingApexFishId = nil,
                pendingCaughtFishId = nil,
                caughtFishMutations = {},
                lastCastTimestamp = p4.lastCastTimestamp
            }
        end
    end),
    playerHookLandedFishing = produceWrapper(function(p5, p6) -- line: 52
        local v3 = p5[p6.userId]

        if v3 then
            v3.fishingState = "nibbling"
        end
    end),
    playerFishCaught = produceWrapper(function(p7, p8) -- line: 60
        local v4 = p7[p8.userId]

        if v4 then
            v4.caughtFishName = p8.fishName
            v4.caughtFishMutations = p8.mutations
        end
    end),
    playerReelStartedFishing = produceWrapper(function(p9, p10) -- line: 69
        local v5 = p9[p10.userId]

        if not v5 then
            return
        end

        v5.fishingState = "reeling"
        v5.caughtFishName = nil
        v5.caughtFishMutations = {}
    end),
    playerApexFishPending = produceWrapper(function(p11, p12) -- line: 79
        local v6 = p11[p12.userId]

        if v6 then
            v6.pendingApexFishId = p12.fishId
        end
    end),
    playerCaughtFishIdSet = produceWrapper(function(p13, p14) -- line: 87
        local v7 = p13[p14.userId]

        if v7 then
            v7.pendingCaughtFishId = p14.fishId
        end
    end),
    playerStoppedFishing = produceWrapper(function(p15, p16) -- line: 95
        local v8 = p15[p16.userId]

        if not v8 then
            return
        end

        v8.fishingState = nil
        v8.castParams = nil
        v8.castTimestamp = nil
        v8.caughtFishName = nil
        v8.caughtFishMutations = {}
        v8.pendingApexFishId = nil
        v8.pendingCaughtFishId = nil
    end),
    playerLeft = produceWrapper(function(p17, p18) -- line: 109
        p17[p18.userId] = nil
    end)
})

v9:getActions()

return {
    fishingStateSlice = v9
}
