-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local dailyRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").dailyRewards
local celebrationRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils").celebrationRewards
local playtimeRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils").playtimeRewards
local v8 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = p2.data.rewards
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 16
        p3[p4.userId] = nil
    end),
    rewardClaimed = produceWrapper(function(p5, p6) -- line: 21
        local v1 = p5[p6.userId]

        if v1 then
            v1[p6.rewardId] = true
        end
    end),
    resetDailyRewards = produceWrapper(function(p7, p8) -- line: 30
        -- upvalues: dailyRewards (copy)
        local v2 = p7[p8.userId]

        if v2 then
            for _, v3 in dailyRewards do
                v2[v3.rewardId] = false
            end
        end
    end),
    resetCelebrationRewards = produceWrapper(function(p9, p10) -- line: 41
        -- upvalues: celebrationRewards (copy)
        local v4 = p9[p10.userId]

        if v4 then
            for _, v5 in celebrationRewards do
                v4[v5.rewardId] = false
            end
        end
    end),
    resetPlaytimeRewards = produceWrapper(function(p11, p12) -- line: 52
        -- upvalues: playtimeRewards (copy)
        local v6 = p11[p12.userId]

        if v6 then
            for _, v7 in playtimeRewards do
                v6[v7.rewardId] = false
            end
        end
    end)
})

v8:getActions()

return {
    rewardsSlice = v8
}
