-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local fishLuckGamepassName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils").fishLuckGamepassName
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByRarity, fishDataByName, bonusFishData = fish.fishDataByRarity, fish.fishDataByName, fish.bonusFishData
local fishingZonesData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils").fishingZonesData
local t1 = {
    common = {
        common = 80,
        uncommon = 15,
        rare = 5,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    uncommon = {
        common = 10,
        uncommon = 60,
        rare = 25,
        epic = 5,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    rare = {
        common = 0,
        uncommon = 10,
        rare = 60,
        epic = 25,
        legendary = 5,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    epic = {
        common = 0,
        uncommon = 0,
        rare = 10,
        epic = 60,
        legendary = 25,
        mythic = 5,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    legendary = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 80,
        mythic = 20,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    mythic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 85,
        godly = 15,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    godly = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 85,
        secret = 15,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    secret = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 85,
        hacked = 15,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    hacked = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 85,
        cosmic = 15,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    cosmic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 85,
        extinct = 15,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    extinct = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    kaijuwu = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    scifi = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 100,
        exclusive = 0
    }
}

local function pickBiteWeightedRarity(p1) -- line: 245
    -- upvalues: t1 (copy)
    local v1 = t1[p1]
    local t2 = {}
    local n1 = 0

    for v2, v3 in pairs(v1) do
        if not (v3 <= 0) then
            n1 += v3
            table.insert(t2, {
                rarity = v2,
                ceiling = n1
            })
        end
    end

    if n1 == 0 then
        return nil
    end

    local v4 = math.random() * n1

    for _, v5 in t2 do
        if v4 < v5.ceiling then
            return v5.rarity
        end
    end

    local v6 = t2[#t2]

    if v6 ~= nil then
        v6 = v6.rarity
    end

    return v6
end

local function pickBiteWeightedFish(p2, p3) -- line: 294
    -- upvalues: fishDataByName (copy), pickBiteWeightedRarity (copy)
    if #p2 == 0 then
        return nil
    end

    local v7 = pickBiteWeightedRarity(p3)
    local v8 = v7 == nil
    local t4, v9

    if not v8 then
        t4 = {}

        for _, v10 in p2 do
            local v11 = fishDataByName[v10.fishName]

            if v11 ~= nil and v11.rarity == v7 then
                table.insert(t4, v10.fishId)
            end
        end

        v9 = #t4 > 0
    end

    if not v8 and v9 then
        return t4[math.random(0, #t4 - 1) + 1]
    end

    local t5 = {}

    for _, v12 in p2 do
        table.insert(t5, v12.fishId)
    end

    return t5[math.random(0, #t5 - 1) + 1]
end

local t6 = {
    "common",
    "uncommon",
    "rare",
    "epic",
    "legendary",
    "mythic",
    "godly",
    "secret",
    "hacked",
    "cosmic",
    "extinct",
    "kaijuwu",
    "scifi"
}

local function pickTeaserFishData(p4) -- line: 355
    -- upvalues: fishDataByRarity (copy), fishingZonesData (copy), t6 (copy)
    local baseRarity = fishingZonesData[p4].baseRarity
    local v13 = (table.find(t6, baseRarity) or 0) - 1
    local v14 = #t6 - 1
    local n2 = 0
    local n3 = 0.2

    while n2 < 0 and math.random() < n3 do
        n2 += 1
        n3 *= n3
    end

    local v17 = fishDataByRarity[t6[math.min(v13 + n2, v14) + 1]]

    if v17 ~= nil and #v17 > 0 then
        return v17[math.random(0, #v17 - 1) + 1]
    end

    local t7 = {}

    for _, v18 in pairs(fishDataByRarity) do
        for _, v19 in v18 do
            table.insert(t7, v19)
        end
    end

    return if #t7 ~= 0 then t7[math.random(0, #t7 - 1) + 1] else nil
end

local function pickElevatedFishData(p5, p6, p7) -- line: 390
    -- upvalues: fishDataByRarity (copy), fishingZonesData (copy), t6 (copy)
    local baseRarity = fishingZonesData[p5].baseRarity
    local v20 = #t6 - 1
    local v21 = #t6 - 1
    local n4 = 0

    for i = 0, v21 do
        if t6[i + 1] == baseRarity then
            n4 = i
            break
        end
    end

    local v23 = math.min(n4 + p6, v20)
    local v25 = math.min(n4 + p7, v20)
    local t8 = {}
    local v26 = v23
    local v27 = false

    while true do
        if v27 then
            v26 += 1
        else
            v27 = true
        end

        if v26 <= v25 then
            local v28 = fishDataByRarity[t6[v26 + 1]]

            if v28 ~= nil then
                for _, v29 in v28 do
                    table.insert(t8, v29)
                end
            end

            continue
        end

        break
    end

    if #t8 > 0 then
        return t8[math.random(0, #t8 - 1) + 1]
    end

    local v30 = false
    local v31 = v23 - 1
    local v32

    repeat
        if v30 then
            v31 -= 1
        else
            v30 = true
        end

        if not (v31 >= 0) then
            return nil
        end

        v32 = fishDataByRarity[t6[v31 + 1]]
    until v32 ~= nil and #v32 > 0

    return v32[math.random(0, #v32 - 1) + 1]
end

local function pickNaturalApexFishData(p8) -- line: 456
    -- upvalues: fishDataByRarity (copy), fishingZonesData (copy), t6 (copy)
    local baseRarity = fishingZonesData[p8].baseRarity
    local v33 = #t6 - 1
    local v34 = #t6 - 1
    local n5 = 0

    for i = 0, v34 do
        if t6[i + 1] == baseRarity then
            n5 = i
            break
        end
    end

    local v36 = math.min(n5 + 2, v33)
    local v37 = false
    local v38

    repeat
        if v37 then
            v36 += 1
        else
            v37 = true
        end

        if not (v36 <= v33) then
            return nil
        end

        v38 = fishDataByRarity[t6[v36 + 1]]
    until v38 ~= nil and #v38 > 0

    return v38[math.random(0, #v38 - 1) + 1]
end

local function pickBaselineZoneFishData(p9) -- line: 497
    -- upvalues: fishDataByRarity (copy), fishingZonesData (copy), pickTeaserFishData (copy)
    local v39 = fishDataByRarity[fishingZonesData[p9].baseRarity]

    if v39 == nil or not (#v39 > 0) then
        return (pickTeaserFishData(p9))
    end

    return v39[math.random(0, #v39 - 1) + 1]
end

local t9 = {
    100, 100, 100
}
local t10 = {
    common = {
        common = 60,
        uncommon = 25,
        rare = 15,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    uncommon = {
        common = 5,
        uncommon = 40,
        rare = 40,
        epic = 12,
        legendary = 3,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    rare = {
        common = 0,
        uncommon = 5,
        rare = 45,
        epic = 35,
        legendary = 15,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    epic = {
        common = 0,
        uncommon = 0,
        rare = 5,
        epic = 45,
        legendary = 35,
        mythic = 15,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    legendary = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 60,
        mythic = 40,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    mythic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 80,
        godly = 20,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    godly = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 80,
        secret = 20,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    secret = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 80,
        hacked = 20,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    hacked = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 80,
        cosmic = 20,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    cosmic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 80,
        extinct = 20,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    extinct = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    kaijuwu = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    scifi = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 100,
        exclusive = 0
    }
}

local function pickAmplifiedBiteWeightedRarity(p10, p11) -- line: 751
    -- upvalues: t6 (copy), t10 (copy)
    local v40 = if p11 == nil then 0 else p11
    local v41 = t10[p10]
    local v43 = math.min(v40, #t6 - 1)
    local t11 = {}

    for i = 0, #t6 - 1 do
        t11[t6[i + 1]] = i
    end

    local t12 = {}
    local n6 = 0

    for v44, v45 in pairs(v41) do
        if not (v45 <= 0) then
            local v46 = t11[v44]

            if v46 == nil then
                v46 = 0
            end

            if not (v46 < v43) then
                n6 += v45
                table.insert(t12, {
                    rarity = v44,
                    ceiling = n6
                })
            end
        end
    end

    if n6 == 0 then
        return nil
    end

    local v47 = math.random() * n6

    for _, v48 in t12 do
        if v47 < v48.ceiling then
            return v48.rarity
        end
    end

    local v49 = t12[#t12]

    if v49 ~= nil then
        v49 = v49.rarity
    end

    return v49
end

local function calculateFishLuckWeightMultiplier(p12, p13, p14) -- line: 831
    -- upvalues: fishLuckGamepassName (copy)
    local v50 = if p13 == nil then 0 else p13
    local v51 = if p14 == nil then 1 else p14
    local v52

    if p12 ~= nil then
        local function v53(p15) -- line: 842
            -- upvalues: fishLuckGamepassName (copy)
            return p15.gamepassName == fishLuckGamepassName
        end

        v52 = false

        for v54, v55 in p12 do
            local _ = v54 - 1

            if v55.gamepassName == fishLuckGamepassName then
                v52 = true
                break
            end

            v52 = false
        end
    else
        v52 = p12
    end

    return (if v52 then 1.7 else 1) * (1 + v50) + (v51 - 1) * 0.7
end

local function calculateFullJackpotChance(p16, p17) -- line: 858
    -- upvalues: t9 (copy)
    local v56 = if p16 == nil then 0 else p16
    local v57 = if p17 == nil then 1 else p17
    local n7 = 1

    for i = 0, 2 do
        local v58 = t9[i + 1]

        if v58 == nil then
            v58 = 0
        end

        local v59 = v58 * v57 + v56

        if v59 <= 0 then
            return 0
        end

        n7 *= v59 / (v59 + 100)
    end

    return n7
end

local function shouldRollBonusFish(p18, p19, p20) -- line: 879
    -- upvalues: t9 (copy)
    local v60 = if p19 == nil then 0 else p19
    local v61 = if p20 == nil then 1 else p20

    if p18 >= 3 then
        return false
    end

    local v62 = t9[p18 + 1]

    if v62 == nil then
        v62 = 0
    end

    local v63 = v62 * v61 + v60

    return math.random() * (v63 + 100) < v63
end

return {
    teaserCatchChance = 0.05,
    bonusFishWaveSpawnDelay = 1,
    bonusWaveComboCountMax = 3,
    bonusWaveSpeedupPerWave = 0.7,
    fishLuckWeightMultiplier = 1.7,
    pickBiteWeightedRarity = pickBiteWeightedRarity,
    pickBiteWeightedFish = pickBiteWeightedFish,
    pickTeaserFishData = pickTeaserFishData,
    pickElevatedFishData = pickElevatedFishData,
    pickNaturalApexFishData = pickNaturalApexFishData,
    pickBaselineZoneFishData = pickBaselineZoneFishData,
    pickAmplifiedBiteWeightedRarity = pickAmplifiedBiteWeightedRarity,
    calculateFishLuckWeightMultiplier = calculateFishLuckWeightMultiplier,
    calculateFullJackpotChance = calculateFullJackpotChance,
    shouldRollBonusFish = shouldRollBonusFish,
    pickBonusFishData = function() -- pickBonusFishData | line: 901
        -- upvalues: bonusFishData (copy)
        return if #bonusFishData ~= 0 then bonusFishData[math.random(0, #bonusFishData - 1) + 1] else nil
    end,
    fishBiteWeightMatrix = t1,
    orderedRarities = t6,
    bonusFishBiteWeightByCombo = t9,
    amplifiedWeightMatrix = t10
}
