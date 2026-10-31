-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    [1] = 59,
    [5] = 229,
    [10] = 449
}
local t2 = {
    0, 3, 6
}
local t3 = {
    {
        auraName = "FireAura",
        displayName = "Fire",
        chancePercent = 32,
        rarity = "common",
        description = "A hot flame trail that wraps the bait in bright sparks.",
        color = Color3.fromRGB(255, 112, 47),
        buffs = {
            aquariumIncome = 0.03
        }
    },
    {
        auraName = "LinesAura",
        displayName = "Lines",
        chancePercent = 17.5,
        rarity = "uncommon",
        description = "Clean energy lines orbit the bait in quick pulses.",
        color = Color3.fromRGB(132, 238, 255),
        buffs = {
            hopDistance = 0.04
        }
    },
    {
        auraName = "YinyangAura",
        displayName = "Yinyang",
        chancePercent = 17.5,
        rarity = "uncommon",
        description = "Balanced black-and-white wisps circle around the hook.",
        color = Color3.fromRGB(232, 232, 232),
        buffs = {
            mutationLuck = 0.1
        }
    },
    {
        auraName = "HeartAura",
        displayName = "Heart",
        chancePercent = 10,
        rarity = "rare",
        description = "Soft heart particles drift from the bait.",
        color = Color3.fromRGB(255, 93, 151),
        buffs = {
            moneyDiscount = 0.08
        }
    },
    {
        auraName = "FrostPetalAura",
        displayName = "Frost Petal",
        chancePercent = 10,
        rarity = "rare",
        description = "Frozen petals spin gently around the lure.",
        color = Color3.fromRGB(169, 238, 255),
        buffs = {
            bossDamage = 0.25,
            bossQteSize = 0.15
        }
    },
    {
        auraName = "RainbowFireAura",
        displayName = "Rainbow Fire",
        chancePercent = 5,
        rarity = "epic",
        description = "Color-shifting fire flickers from the bait.",
        color = Color3.fromRGB(255, 91, 224),
        buffs = {
            aquariumIncome = 0.15,
            mutationLuck = 0.1
        }
    },
    {
        auraName = "SnowAura",
        displayName = "Snow",
        chancePercent = 5,
        rarity = "epic",
        description = "A crisp snowfall follows the hook through the air.",
        color = Color3.fromRGB(219, 248, 255),
        buffs = {
            bonusLuck = 0.1,
            trainingPower = 0.1
        }
    },
    {
        auraName = "AngelAura",
        displayName = "Angel",
        chancePercent = 1.25,
        rarity = "legendary",
        description = "Holy gold light shines from the bait.",
        color = Color3.fromRGB(255, 232, 122),
        buffs = {
            hopDistance = 0.05,
            aquariumIncome = 0.15,
            mutationLuck = 0.15
        }
    },
    {
        auraName = "DemonAura",
        displayName = "Demon",
        chancePercent = 1.25,
        rarity = "legendary",
        description = "Dark crimson energy burns around the hook.",
        color = Color3.fromRGB(255, 57, 66),
        buffs = {
            trainingPower = 0.15,
            championMutationChance = 0.2,
            bonusLuck = 0.15
        }
    },
    {
        auraName = "VoidsporeAura",
        displayName = "Voidspore",
        chancePercent = 0.5,
        rarity = "mythic",
        description = "Void spores pulse with strange mythic energy.",
        color = Color3.fromRGB(125, 255, 50),
        buffs = {
            mutationLuck = 0.15,
            weatherMutationLuck = 0.1,
            trainingPower = 0.2,
            aquariumIncome = 0.2
        }
    }
}

local function getBaitAuraConfig(p1) -- line: 143
    -- upvalues: t3 (copy)
    if p1 == nil or p1 == "" then
        return nil
    end

    if p1 == "RadioactiveAura" then
        local function v1(p2) -- line: 152
            return p2.auraName == "VoidsporeAura"
        end

        for v2, v3 in t3 do
            local _ = v2 - 1

            if v3.auraName == "VoidsporeAura" == true then
                return v3
            end
        end
    else
        for v4, v5 in t3 do
            local _ = v4 - 1

            if v5.auraName == p1 == true then
                return v5
            end
        end
    end

    return nil
end

local function getBaitAuraSlotRebirthRequirement(p3) -- line: 179
    -- upvalues: t2 (copy)
    local v6 = t2[p3 + 1]

    if v6 == nil then
        v6 = 0
    end

    return v6
end

local function isBaitAuraSlotUsable(p4, p5, p6) -- line: 187
    -- upvalues: t2 (copy)
    if p5 < 0 or p5 >= 3 then
        return false
    end

    local v7 = p4[p5 + 1]

    if v7 == nil then
        v7 = false
    end

    local v8 = t2[p5 + 1]

    if v8 == nil then
        v8 = 0
    end

    local v9 = v8 <= p6

    return v7 or v9
end

local function rollBaitAura() -- line: 199
    -- upvalues: t3 (copy)
    local function v10(p7, p8) -- line: 202
        return p7 + p8.chancePercent
    end

    local n1 = 0

    for i = 1, #t3 do
        local v12 = t3[i]
        local _ = i - 1

        n1 += v12.chancePercent
    end

    local v13 = math.random() * n1

    for _, v14 in t3 do
        v13 -= v14.chancePercent

        if v13 <= 0 then
            return v14
        end
    end

    return t3[#t3]
end

local t4 = {
    aquariumIncome = 0,
    bonusLuck = 0,
    bossDamage = 0,
    bossQteSize = 0,
    caughtFishCash = 0,
    championMutationChance = 0,
    hopDistance = 0,
    moneyDiscount = 0,
    mutationLuck = 0,
    sellValueMultiplier = 1,
    trainingPower = 0,
    weatherMutationLuck = 0
}

local function getBaitAuraBuffBonuses(p9) -- line: 240
    -- upvalues: getBaitAuraConfig (copy), t4 (copy)
    local v15 = getBaitAuraConfig(p9)

    if not v15 then
        return t4
    end

    local buffs = v15.buffs
    local aquariumIncome = buffs.aquariumIncome

    if aquariumIncome == nil then
        aquariumIncome = 0
    end

    local t5 = {
        aquariumIncome = math.min(aquariumIncome, 0.2)
    }
    local bonusLuck = buffs.bonusLuck

    t5.bonusLuck = if bonusLuck == nil then 0 else bonusLuck

    local bossDamage = buffs.bossDamage

    if bossDamage == nil then
        bossDamage = 0
    end

    t5.bossDamage = math.min(bossDamage, 0.25)

    local bossQteSize = buffs.bossQteSize

    t5.bossQteSize = if bossQteSize == nil then 0 else bossQteSize

    local caughtFishCash = buffs.caughtFishCash

    if caughtFishCash == nil then
        caughtFishCash = 0
    end

    t5.caughtFishCash = math.min(caughtFishCash, 0.1)

    local championMutationChance = buffs.championMutationChance

    if championMutationChance == nil then
        championMutationChance = 0
    end

    t5.championMutationChance = math.min(championMutationChance, 0.3)

    local hopDistance = buffs.hopDistance

    if hopDistance == nil then
        hopDistance = 0
    end

    t5.hopDistance = math.min(hopDistance, 0.1)

    local moneyDiscount = buffs.moneyDiscount

    if moneyDiscount == nil then
        moneyDiscount = 0
    end

    t5.moneyDiscount = math.min(moneyDiscount, 0.1)

    local mutationLuck = buffs.mutationLuck

    if mutationLuck == nil then
        mutationLuck = 0
    end

    t5.mutationLuck = math.min(mutationLuck, 0.3)

    local sellValueMultiplier = buffs.sellValueMultiplier

    t5.sellValueMultiplier = if sellValueMultiplier == nil then 1 else sellValueMultiplier

    local trainingPower = buffs.trainingPower

    t5.trainingPower = if trainingPower == nil then 0 else trainingPower

    local weatherMutationLuck = buffs.weatherMutationLuck

    if weatherMutationLuck == nil then
        weatherMutationLuck = 0
    end

    t5.weatherMutationLuck = math.min(weatherMutationLuck, 0.3)

    return t5
end

return {
    baitAuraCaughtFishCashCap = 0.1,
    baitAuraAquariumIncomeCap = 0.2,
    baitAuraMutationLuckCap = 0.3,
    baitAuraHopDistanceCap = 0.1,
    baitAuraBossDamageCap = 0.25,
    baitAuraChampionMutationChanceCap = 0.3,
    baitAuraMoneyDiscountCap = 0.1,
    baitAuraWeatherMutationLuckCap = 0.3,
    baitAuraRollRobuxPrice = 59,
    maxBaitAuraSlots = 3,
    baitAuraSlot2RobuxPrice = 175,
    baitAuraSlot3RobuxPrice = 225,
    defaultBaitAuraName = "FireAura",
    getBaitAuraConfig = getBaitAuraConfig,
    getBaitAuraSlotRebirthRequirement = getBaitAuraSlotRebirthRequirement,
    isBaitAuraSlotUsable = isBaitAuraSlotUsable,
    rollBaitAura = rollBaitAura,
    getBaitAuraBuffBonuses = getBaitAuraBuffBonuses,
    getBaitAuraBuffDescriptions = function(p10) -- getBaitAuraBuffDescriptions | line: 327
        -- upvalues: getBaitAuraBuffBonuses (copy)
        local v16 = getBaitAuraBuffBonuses(p10)
        local t6 = {}

        local function v17(p11) -- line: 330
            return (("%*"):format((math.round(p11 * 100))))
        end

        if v16.caughtFishCash > 0 then
            table.insert(t6, (("+%*%% cash from caught fish"):format((("%*"):format((math.round(v16.caughtFishCash * 100)))))))
        end

        if v16.aquariumIncome > 0 then
            table.insert(t6, (("+%*%% aquarium income"):format((("%*"):format((math.round(v16.aquariumIncome * 100)))))))
        end

        if v16.sellValueMultiplier > 1 then
            table.insert(t6, (("x%* sell value"):format(v16.sellValueMultiplier)))
        end

        if v16.mutationLuck > 0 then
            table.insert(t6, (("+%*%% mutation luck"):format((("%*"):format((math.round(v16.mutationLuck * 100)))))))
        end

        if v16.bonusLuck > 0 then
            table.insert(t6, (("+%*%% bonus luck"):format((("%*"):format((math.round(v16.bonusLuck * 100)))))))
        end

        if v16.trainingPower > 0 then
            table.insert(t6, (("+%*%% training power"):format((("%*"):format((math.round(v16.trainingPower * 100)))))))
        end

        if v16.hopDistance > 0 then
            table.insert(t6, (("+%*%% bait hop distance"):format((("%*"):format((math.round(v16.hopDistance * 100)))))))
        end

        if v16.bossQteSize > 0 then
            table.insert(t6, (("+%*%% Bigger Boss Fish Skill Check Circles"):format((("%*"):format((math.round(v16.bossQteSize * 100)))))))
        end

        if v16.bossDamage > 0 then
            table.insert(t6, (("+%*%% Boss Fish Skill Check progress"):format((("%*"):format((math.round(v16.bossDamage * 100)))))))
        end

        if v16.championMutationChance > 0 then
            table.insert(t6, (("+%*%% Champion mutation chance"):format((("%*"):format((math.round(v16.championMutationChance * 100)))))))
        end

        if v16.weatherMutationLuck > 0 then
            table.insert(t6, (("+%*%% weather mutation luck"):format((("%*"):format((math.round(v16.weatherMutationLuck * 100)))))))
        end

        if v16.moneyDiscount > 0 then
            table.insert(t6, (("-%*%% shop & upgrade prices"):format((("%*"):format((math.round(v16.moneyDiscount * 100)))))))
        end

        return t6
    end,
    baitAuraRerollPackPrices = t1,
    baitAuraSlotRebirthRequirements = t2,
    baitAuraConfigs = t3
}
