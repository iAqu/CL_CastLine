-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local filterOriginal, includesOriginal, produceWrapper, push = v1.filterOriginal, v1.includesOriginal, v1.produceWrapper, v1.push
local maxAquariumFishLevel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").maxAquariumFishLevel
local v49 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 12
        local v2 = p2.data.aquarium.ownedSkins or { "Default" }
        local v3 = p2.data.aquarium.resolvedCrateReveals or {}
        local userId = p2.userId
        local v4 = table.clone(p2.data.aquarium)

        setmetatable(v4, nil)
        v4.aquariumUpgradeCompleteTimestamp = p2.data.aquarium.aquariumUpgradeCompleteTimestamp
        v4.aquariumUpgradeStartedTimestamp = p2.data.aquarium.aquariumUpgradeStartedTimestamp

        local cratePityCount = p2.data.aquarium.cratePityCount

        v4.cratePityCount = if cratePityCount == nil then 0 else cratePityCount

        local equippedSkin = p2.data.aquarium.equippedSkin

        v4.equippedSkin = if equippedSkin == nil then "Default" else equippedSkin
        v4.claimedFirstPurchaseCrateSeriesIds = p2.data.aquarium.claimedFirstPurchaseCrateSeriesIds or {}

        local hasClaimedFreeCratePull = p2.data.aquarium.hasClaimedFreeCratePull

        v4.hasClaimedFreeCratePull = hasClaimedFreeCratePull ~= nil and hasClaimedFreeCratePull
        v4.lifetimeShardsEarned = p2.data.aquarium.lifetimeShardsEarned or {
            rare = 0,
            epic = 0,
            legendary = 0,
            mythic = 0,
            universal = 0
        }

        local moneyPerSecond = p2.data.aquarium.moneyPerSecond

        v4.moneyPerSecond = if moneyPerSecond == nil then 0 else moneyPerSecond
        v4.ownedSkins = v2

        local t3 = {}
        local v5 = #t3

        for v6, v7 in v3 do
            v5 += 1
            t3[v5] = { v6, v7 }
        end

        local v8 = table.create(#t3)

        local function v9(p3) -- line: 73
            return p3[2]
        end

        for v10, v11 in t3 do
            local _ = v10 - 1

            v8[v10] = v11[2]
        end

        v4.pendingCrateReveals = v8
        v4.resolvedCrateReveals = v3

        local seenSkins = p2.data.aquarium.seenSkins

        if seenSkins == nil then
            seenSkins = {}

            local v12 = #seenSkins

            table.move(v2, 1, #v2, v12 + 1, seenSkins)
        end

        v4.seenSkins = seenSkins
        v4.skinShardBalances = p2.data.aquarium.skinShardBalances or {
            rare = 0,
            epic = 0,
            legendary = 0,
            mythic = 0
        }
        v4.skinRollCounts = p2.data.aquarium.skinRollCounts or {}

        local uncollectedMoney = p2.data.aquarium.uncollectedMoney

        v4.uncollectedMoney = if uncollectedMoney == nil then 0 else uncollectedMoney

        local universalSkinShards = p2.data.aquarium.universalSkinShards

        v4.universalSkinShards = if universalSkinShards == nil then 0 else universalSkinShards
        p1[userId] = v4
    end),
    playerLeft = produceWrapper(function(p4, p5) -- line: 113
        p4[p5.userId] = nil
    end),
    aquariumFishAdded = produceWrapper(function(p6, p7) -- line: 118
        local v13 = p6[p7.userId]

        if not v13 or v13.fishItems[p7.fishId] ~= nil then
            return nil
        end

        v13.fishItems[p7.fishId] = {
            exclusiveIndex = p7.exclusiveIndex,
            fishId = p7.fishId,
            fishObtainedTimestamp = p7.fishObtainedTimestamp,
            fishSpecies = p7.fishSpecies,
            level = p7.level,
            mutations = p7.mutations
        }
    end),
    aquariumFishUnequipped = produceWrapper(function(p8, p9) -- line: 142
        local v14 = p8[p9.userId]

        if not v14 then
            return nil
        end

        v14.fishItems[p9.fishId] = nil
    end),
    equipBestFishApplied = produceWrapper(function(p10, p11) -- line: 153
        local v15 = p10[p11.userId]

        if not v15 then
            return nil
        end

        for _, v16 in p11.toRemove do
            v15.fishItems[v16.fishId] = nil
        end

        for _, v17 in p11.toAdd do
            if v15.fishItems[v17.fishId] == nil then
                v15.fishItems[v17.fishId] = {
                    exclusiveIndex = v17.exclusiveIndex,
                    fishId = v17.fishId,
                    fishObtainedTimestamp = v17.fishObtainedTimestamp,
                    fishSpecies = v17.fishSpecies,
                    level = v17.level,
                    mutations = v17.mutations
                }
            end
        end
    end),
    aquariumFishLeveledUp = produceWrapper(function(p12, p13) -- line: 184
        -- upvalues: maxAquariumFishLevel (copy)
        local v18 = p12[p13.userId]

        if not v18 then
            return nil
        end

        local v19 = v18.fishItems[p13.fishId]

        if not v19 or v19.level >= maxAquariumFishLevel then
            return nil
        end

        v19.level += 1
    end),
    aquariumLevelSet = produceWrapper(function(p14, p15) -- line: 202
        local v20 = p14[p15.userId]

        if not v20 or p15.level <= v20.aquariumLevel then
            return nil
        end

        v20.aquariumLevel = p15.level
    end),
    aquariumLevelForceSet = produceWrapper(function(p16, p17) -- line: 214
        local v21 = p16[p17.userId]

        if not v21 then
            return nil
        end

        v21.aquariumLevel = p17.level
        v21.aquariumUpgradeStartedTimestamp = nil
        v21.aquariumUpgradeCompleteTimestamp = nil

        local n1 = 0

        for _ in v21.fishItems do
            n1 += 1
        end

        if not (p17.maxFish < n1) then
            return
        end

        local n2 = 0

        for _ in v21.fishItems do
            n2 += 1
        end

        local v22 = n2 - p17.maxFish

        for v23 in v21.fishItems do
            if v22 <= 0 then
                break
            end

            v21.fishItems[v23] = nil
            v22 -= 1
        end
    end),
    aquariumMoneyAccumulated = produceWrapper(function(p18, p19) -- line: 250
        local v24 = p18[p19.userId]

        if not v24 then
            return nil
        end

        v24.uncollectedMoney += p19.amount
    end),
    aquariumMoneyCollected = produceWrapper(function(p20, p21) -- line: 259
        local v25 = p20[p21.userId]

        if not v25 then
            return nil
        end

        v25.uncollectedMoney = 0
    end),
    aquariumMoneyPerSecondUpdated = produceWrapper(function(p22, p23) -- line: 268
        local v26 = p22[p23.userId]

        if not v26 then
            return nil
        end

        v26.moneyPerSecond = p23.moneyPerSecond
    end),
    aquariumUncollectedMoneySet = produceWrapper(function(p24, p25) -- line: 277
        local v27 = p24[p25.userId]

        if not v27 then
            return nil
        end

        v27.uncollectedMoney = p25.amount
    end),
    aquariumUpgradeStarted = produceWrapper(function(p26, p27) -- line: 286
        local v28 = p26[p27.userId]

        if not v28 then
            return nil
        end

        v28.aquariumUpgradeStartedTimestamp = p27.startedTimestamp
        v28.aquariumUpgradeCompleteTimestamp = p27.completeTimestamp
    end),
    aquariumUpgradeCleared = produceWrapper(function(p28, p29) -- line: 296
        local v29 = p28[p29.userId]

        if not v29 then
            return nil
        end

        v29.aquariumUpgradeStartedTimestamp = nil
        v29.aquariumUpgradeCompleteTimestamp = nil
    end),
    aquariumSkinEquipped = produceWrapper(function(p30, p31) -- line: 306
        local v30 = p30[p31.userId]

        if not v30 then
            return nil
        end

        v30.equippedSkin = p31.skinName
    end),
    aquariumSkinPurchased = produceWrapper(function(p32, p33) -- line: 315
        -- upvalues: includesOriginal (copy), push (copy)
        local v31 = p32[p33.userId]

        if not v31 or includesOriginal(v31.ownedSkins, p33.skinName) then
            return nil
        end

        push(v31.ownedSkins, p33.skinName)
    end),
    aquariumSkinSeen = produceWrapper(function(p34, p35) -- line: 327
        -- upvalues: includesOriginal (copy), push (copy)
        local v32 = p34[p35.userId]

        if not v32 or includesOriginal(v32.seenSkins, p35.skinName) then
            return nil
        end

        push(v32.seenSkins, p35.skinName)
    end),
    aquariumCrateResolved = produceWrapper(function(p36, p37) -- line: 339
        -- upvalues: filterOriginal (copy), push (copy)
        local v33 = p36[p37.userId]

        if not v33 or #filterOriginal(v33.pendingCrateReveals, function(p38) -- line: 346
            -- upvalues: p37 (copy)
            return p38.purchaseId == p37.reveal.purchaseId
        end) > 0 then
            return nil
        end

        v33.cratePityCount = p37.pityCount
        push(v33.pendingCrateReveals, p37.reveal)
        v33.resolvedCrateReveals[p37.reveal.purchaseId] = p37.reveal
    end),
    aquariumCrateSkinGranted = produceWrapper(function(p39, p40) -- line: 359
        -- upvalues: includesOriginal (copy), push (copy)
        local v34 = p39[p40.userId]

        if not v34 or includesOriginal(v34.ownedSkins, p40.skinName) then
            return nil
        end

        push(v34.ownedSkins, p40.skinName)
    end),
    aquariumUniversalSkinShardsChanged = produceWrapper(function(p41, p42) -- line: 371
        local v35 = p41[p42.userId]

        if not v35 then
            return nil
        end

        v35.universalSkinShards = math.max(0, v35.universalSkinShards + p42.amount)

        if not (p42.amount > 0) then
            return
        end

        local v37 = v35.lifetimeShardsEarned or {
            rare = 0,
            epic = 0,
            legendary = 0,
            mythic = 0,
            universal = 0
        }

        v37.universal += p42.amount
        v35.lifetimeShardsEarned = v37
    end),
    aquariumSkinShardBalanceChanged = produceWrapper(function(p43, p44) -- line: 391
        local v38 = p43[p44.userId]

        if not v38 then
            return nil
        end

        v38.skinShardBalances[p44.rarity] = math.max(0, v38.skinShardBalances[p44.rarity] + p44.amount)

        if not (p44.amount > 0) then
            return
        end

        local v40 = v38.lifetimeShardsEarned or {
            rare = 0,
            epic = 0,
            legendary = 0,
            mythic = 0,
            universal = 0
        }

        v40[p44.rarity] += p44.amount
        v38.lifetimeShardsEarned = v40
    end),
    aquariumSkinRollRecorded = produceWrapper(function(p45, p46) -- line: 411
        local v41 = p45[p46.userId]

        if not v41 then
            return nil
        end

        local v42 = v41.skinRollCounts or {}
        local skinName = p46.skinName
        local v43 = v42[p46.skinName]

        if v43 == nil then
            v43 = 0
        end

        v42[skinName] = v43 + 1
        v41.skinRollCounts = v42
    end),
    aquariumFreeCratePullClaimed = produceWrapper(function(p47, p48) -- line: 428
        local v44 = p47[p48.userId]

        if not v44 then
            return nil
        end

        v44.hasClaimedFreeCratePull = true
    end),
    aquariumCrateFirstPurchaseClaimed = produceWrapper(function(p49, p50) -- line: 437
        -- upvalues: includesOriginal (copy), push (copy)
        local v45 = p49[p50.userId]

        if not v45 then
            return nil
        end

        local v46 = v45.claimedFirstPurchaseCrateSeriesIds or {}

        v45.claimedFirstPurchaseCrateSeriesIds = v46

        if includesOriginal(v46, p50.seriesId) then
            return nil
        end

        push(v46, p50.seriesId)
    end),
    aquariumCrateRevealAcknowledged = produceWrapper(function(p51, p52) -- line: 451
        -- upvalues: filterOriginal (copy)
        local v47 = p51[p52.userId]

        if not v47 then
            return nil
        end

        v47.pendingCrateReveals = filterOriginal(v47.pendingCrateReveals, function(p53) -- line: 458
            -- upvalues: p52 (copy)
            return p53.purchaseId ~= p52.purchaseId
        end)
        v47.resolvedCrateReveals[p52.purchaseId] = nil
    end),
    aquariumCratePitySynchronized = produceWrapper(function(p54, p55) -- line: 465
        local v48 = p54[p55.userId]

        if not v48 then
            return nil
        end

        v48.cratePityCount = math.max(0, p55.pityCount)
    end)
})

v49:getActions()

return {
    aquariumSlice = v49
}
