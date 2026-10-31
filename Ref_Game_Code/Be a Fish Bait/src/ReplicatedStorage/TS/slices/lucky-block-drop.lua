-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    activeDrop = nil,
    banner = nil,
    nextDropTimestamp = 0,
    reveal = nil
}, {
    luckyBlockDropSpawned = produceWrapper(function(p1, p2) -- line: 12
        p1.activeDrop = {
            dropId = p2.dropId,
            position = p2.position,
            spawnedAt = p2.spawnedAt
        }
    end),
    luckyBlockDropCleared = produceWrapper(function(p3, _) -- line: 19
        p3.activeDrop = nil
    end),
    luckyBlockNextDropTimestampSet = produceWrapper(function(p5, p6) -- line: 22
        p5.nextDropTimestamp = p6.nextDropTimestamp
    end),
    luckyBlockRevealStarted = produceWrapper(function(p7, p8) -- line: 25
        p7.reveal = {
            awardedReward = p8.awardedReward,
            dropId = p8.dropId,
            expireTimestamp = p8.expireTimestamp,
            rewardPool = p8.rewardPool,
            winnerUserId = p8.winnerUserId
        }
    end),
    luckyBlockRevealCleared = produceWrapper(function(p9, _) -- line: 34
        p9.reveal = nil
    end),
    luckyBlockBannerShown = produceWrapper(function(p11, p12) -- line: 37
        p11.banner = {
            id = p12.id,
            message = p12.message
        }
    end)
})

v1:getActions()

return {
    luckyBlockDropSlice = v1
}
