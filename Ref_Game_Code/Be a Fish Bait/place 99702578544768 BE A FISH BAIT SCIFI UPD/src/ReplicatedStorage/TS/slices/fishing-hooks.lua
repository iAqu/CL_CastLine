-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push, remove = v1.produceWrapper, v1.push, v1.remove
local v24 = createProducer({}, {
    hookCreated = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.hookId] = {
            apexCaught = false,
            apexFishId = nil,
            bonusComponentMountRetries = 0,
            bonusWaveComboCount = 0,
            caughtFishName = nil,
            hookLifespanLocked = false,
            nibbleExpireTimeStamp = 0,
            phase = "settling",
            waveInjectedBonusFishId = nil,
            zone = nil,
            activeTeaserFish = {},
            bonusFishRarityCap = p2.bonusFishRarityCap,
            casterUserId = p2.casterUserId,
            caughtFishMutations = {},
            guaranteedBonusWave = p2.guaranteedBonusWave,
            hookSpawnedTimeStamp = p2.hookSpawnedTimeStamp,
            nibbleFish = {},
            capAtOneBonusWave = p2.capAtOneBonusWave
        }
    end),
    hookDestroyed = produceWrapper(function(p3, p4) -- line: 35
        p3[p4.hookId] = nil
    end),
    hookPhaseChanged = produceWrapper(function(p5, p6) -- line: 40
        local v2 = p5[p6.hookId]

        if v2 then
            v2.phase = p6.phase
        end
    end),
    hookNibbleExpireSet = produceWrapper(function(p7, p8) -- line: 48
        local v3 = p7[p8.hookId]

        if v3 then
            v3.nibbleExpireTimeStamp = p8.nibbleExpireTimeStamp
        end
    end),
    hookLifespanLocked = produceWrapper(function(p9, p10) -- line: 56
        local v4 = p9[p10.hookId]

        if v4 then
            v4.hookLifespanLocked = p10.locked
        end
    end),
    hookZoneSet = produceWrapper(function(p11, p12) -- line: 64
        local v5 = p11[p12.hookId]

        if v5 then
            v5.zone = p12.zone
        end
    end),
    hookBonusComboIncremented = produceWrapper(function(p13, p14) -- line: 72
        local v6 = p13[p14.hookId]

        if v6 then
            v6.bonusWaveComboCount += 1
        end
    end),
    hookBonusRetryIncremented = produceWrapper(function(p15, p16) -- line: 80
        local v7 = p15[p16.hookId]

        if v7 then
            v7.bonusComponentMountRetries += 1
        end
    end),
    hookBonusRetriesCleared = produceWrapper(function(p17, p18) -- line: 88
        local v8 = p17[p18.hookId]

        if v8 then
            v8.bonusComponentMountRetries = 0
        end
    end),
    hookBonusFishInjected = produceWrapper(function(p19, p20) -- line: 96
        local v9 = p19[p20.hookId]

        if v9 then
            v9.waveInjectedBonusFishId = p20.fishId
        end
    end),
    hookBonusFishCleared = produceWrapper(function(p21, p22) -- line: 104
        local v10 = p21[p22.hookId]

        if v10 then
            v10.waveInjectedBonusFishId = nil
        end
    end),
    hookApexFishSet = produceWrapper(function(p23, p24) -- line: 112
        local v11 = p23[p24.hookId]

        if v11 then
            v11.apexFishId = p24.fishId
        end
    end),
    hookNibbleFishAdded = produceWrapper(function(p25, p26) -- line: 120
        -- upvalues: push (copy)
        local v12 = p25[p26.hookId]

        if v12 then
            push(v12.nibbleFish, {
                fishName = p26.fishName,
                fishId = p26.fishId,
                mutations = p26.mutations
            })
        end
    end),
    hookNibbleFishRemoved = produceWrapper(function(p27, p28) -- line: 132
        -- upvalues: remove (copy)
        local v13 = p27[p28.hookId]

        if not v13 then
            return nil
        end

        local n1 = -1

        for v14, v15 in v13.nibbleFish do
            local _ = v14 - 1

            if v15.fishId == p28.fishId == true then
                n1 = v14 - 1
                break
            end
        end

        if n1 ~= -1 then
            remove(v13.nibbleFish, n1)
        end
    end),
    hookNibbleFishCleared = produceWrapper(function(p29, p30) -- line: 157
        local v16 = p29[p30.hookId]

        if v16 then
            v16.nibbleFish = {}
        end
    end),
    hookTeaserFishAdded = produceWrapper(function(p31, p32) -- line: 165
        -- upvalues: push (copy)
        local v17 = p31[p32.hookId]

        if v17 then
            push(v17.activeTeaserFish, p32.fishId)
        end
    end),
    hookTeaserFishRemoved = produceWrapper(function(p33, p34) -- line: 173
        -- upvalues: remove (copy)
        local v18 = p33[p34.hookId]

        if not v18 then
            return nil
        end

        local n2 = -1

        for v19, v20 in v18.activeTeaserFish do
            local _ = v19 - 1

            if v20 == p34.fishId == true then
                n2 = v19 - 1
                break
            end
        end

        if n2 ~= -1 then
            remove(v18.activeTeaserFish, n2)
        end
    end),
    hookTeaserFishCleared = produceWrapper(function(p35, p36) -- line: 198
        local v21 = p35[p36.hookId]

        if v21 then
            v21.activeTeaserFish = {}
        end
    end),
    hookFishCaught = produceWrapper(function(p37, p38) -- line: 206
        local v22 = p37[p38.hookId]

        if v22 then
            v22.caughtFishName = p38.fishName
            v22.caughtFishMutations = p38.mutations
        end
    end),
    hookApexCaught = produceWrapper(function(p39, p40) -- line: 215
        local v23 = p39[p40.hookId]

        if v23 then
            v23.apexCaught = true
        end
    end)
})

v24:getActions()

return {
    fishingHooksSlice = v24
}
