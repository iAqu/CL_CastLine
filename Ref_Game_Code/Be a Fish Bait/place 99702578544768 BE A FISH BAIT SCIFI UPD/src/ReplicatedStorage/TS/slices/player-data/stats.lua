-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v9 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 7
        p1[p2.userId] = p2.data.stats
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 13
        p3[p4.userId] = nil
    end),
    playerMoneyChanged = produceWrapper(function(p5, p6) -- line: 18
        local v1 = p5[p6.userId]

        if v1 then
            v1.money += p6.moneyChange
        end
    end),
    statGiven = produceWrapper(function(p7, p8) -- line: 26
        local v2 = p7[p8.userId]

        if v2 then
            v2[p8.stat] += p8.amount
        end
    end),
    statSet = produceWrapper(function(p9, p10) -- line: 34
        local v3 = p9[p10.userId]

        if v3 then
            v3[p10.stat] = p10.value
        end
    end),
    rebirthed = produceWrapper(function(p11, p12) -- line: 42
        local v4 = p11[p12.userId]

        if v4 then
            v4.power = 0
        end
    end),
    offlineEarningsCleared = produceWrapper(function(p13, p14) -- line: 50
        local v5 = p13[p14.userId]

        if not v5 then
            return nil
        end

        v5.money += p14.amount
    end),
    fishSold = produceWrapper(function(p15, p16) -- line: 59
        local v6 = p15[p16.userId]

        if not v6 then
            return nil
        end

        v6.money += p16.totalSellPrice
    end),
    highScoreUpdated = produceWrapper(function(p17, p18) -- line: 68
        local v7 = p17[p18.userId]

        if not v7 then
            return nil
        end

        v7.highScoreDistance = p18.distance
        v7.highScorePosition = p18.position
    end),
    charmRollStarted = produceWrapper(function(p19, p20) -- line: 78
        local v8 = p19[p20.userId]

        if not v8 then
            return nil
        end

        v8.money -= p20.cost
    end)
})

v9:getActions()

return {
    statsSlice = v9
}
