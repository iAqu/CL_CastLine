-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local mutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations")
local championMutationName, deluluMutationName = mutations.championMutationName, mutations.deluluMutationName
local getMinJackpotRarity = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils").getMinJackpotRarity
local canFishReceiveMutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").canFishReceiveMutations
local t1 = {
    "hoola1",
    "hoola2",
    "hoola3"
}
local t2 = {
    common = 1,
    uncommon = 2,
    rare = 3,
    epic = 4,
    legendary = 5,
    mythic = 6,
    godly = 7,
    secret = 8,
    hacked = 9,
    cosmic = 10,
    extinct = 11,
    kaijuwu = 12,
    scifi = 13,
    exclusive = 0
}
local getFishMutationKey

local function getCollectionIndexState(p1) -- line: 27
    -- upvalues: getFishMutationKey (ref)
    local t3 = {}

    if p1 ~= nil then
        for v1, v2 in p1.discoveredFish do
            for _, v3 in v2 do
                t3[getFishMutationKey(v1, v3)] = true
            end
        end
    end

    return {
        unlockedFishMutationKeys = t3
    }
end

local sortCollectionItems

local function getCollectionItems() -- line: 45
    -- upvalues: allFishData (copy), sortCollectionItems (ref)
    local t4 = {}

    for _, v4 in allFishData do
        table.insert(t4, {
            nonExclusiveBossOnly = v4.nonExclusiveBossOnly,
            id = v4.name,
            imageId = v4.imageId,
            moneyPerSecond = v4.moneyPerSecond,
            name = v4.displayName,
            noNaturalSpawn = v4.noNaturalSpawn,
            rarity = v4.rarity
        })
    end

    return sortCollectionItems(t4)
end

local v5 = t2[getMinJackpotRarity()]

local function isJackpotEligibleRarity(p2) -- line: 69
    -- upvalues: t2 (copy), v5 (copy)
    return t2[p2] >= v5
end

local isCollectionVariantVisibleForItem

local function getCollectionItemsForVariant(p3) -- line: 79
    -- upvalues: championMutationName (copy), deluluMutationName (copy), t2 (copy), getCollectionItems (copy), v5 (copy), isCollectionVariantVisibleForItem (ref)
    local v6 = getCollectionItems()
    local t6 = {}
    local n1 = 0

    for v7, v8 in v6 do
        local _ = v7 - 1

        if (v8.rarity ~= "exclusive" and isCollectionVariantVisibleForItem(v8, p3)) == true then
            n1 += 1
            t6[n1] = v8
        end
    end

    if p3 == championMutationName then
        local t7 = {}

        local function v9(p4) -- line: 98
            -- upvalues: t2 (copy), v5 (copy)
            return t2[p4.rarity] >= v5
        end

        local n2 = 0

        for v10, v11 in t6 do
            local _ = v10 - 1

            if t2[v11.rarity] >= v5 == true then
                n2 += 1
                t7[n2] = v11
            end
        end

        return t7
    end

    if p3 ~= deluluMutationName then
        return t6
    end

    local t8 = {}

    local function v12(p5) -- line: 114
        -- upvalues: t2 (copy)
        return t2[p5.rarity] >= 2
    end

    local n3 = 0

    for v13, v14 in t6 do
        local _ = v13 - 1

        if t2[v14.rarity] >= t2.uncommon == true then
            n3 += 1
            t8[n3] = v14
        end
    end

    return t8
end

local function getCollectionItemsForHoola() -- line: 130
    -- upvalues: canFishReceiveMutations (copy), getCollectionItems (copy), isCollectionVariantVisibleForItem (ref)
    local t9 = {}
    local n4 = 0

    for v15, v16 in (getCollectionItems()) do
        local _ = v15 - 1

        if (v16.rarity ~= "exclusive" and canFishReceiveMutations(v16.id) and isCollectionVariantVisibleForItem(v16, "hoola1")) == true then
            n4 += 1
            t9[n4] = v16
        end
    end

    return t9
end

function isCollectionVariantVisibleForItem(p6, p7) -- line: 147
    if p7 == "Normal" or p6.nonExclusiveBossOnly == true then
        return true
    end

    return p6.noNaturalSpawn ~= true
end

local function maxVariantsForFish(p8) -- line: 154
    -- upvalues: canFishReceiveMutations (copy), t2 (copy), v5 (copy)
    if p8.noNaturalSpawn == true and p8.nonExclusiveBossOnly ~= true then
        return 1
    end

    return (if canFishReceiveMutations(p8.name) then 3 else 0) + 8 + (if t2[p8.rarity] >= v5 then 1 else 0)
end

local function getTotalCollectionVariantCount() -- line: 162
    -- upvalues: allFishData (copy), canFishReceiveMutations (copy), t2 (copy), v5 (copy)
    local n5 = 0

    for _, v18 in allFishData do
        local v19 = if v18.noNaturalSpawn ~= true or v18.nonExclusiveBossOnly == true then (if canFishReceiveMutations(v18.name) then 3 else 0) + 8 + (if v5 <= t2[v18.rarity] then 1 else 0) else 1

        n5 += v19
    end

    return n5
end

local function isFishDiscoveryProgressItem(p9) -- line: 170
    return p9.rarity ~= "exclusive"
end

local function getTotalCollectionFishCount() -- line: 173
    -- upvalues: allFishData (copy)
    local n6 = 0

    for _, v24 in allFishData do
        if v24.rarity ~= "exclusive" then
            n6 += 1
        end
    end

    return n6
end

local function getDiscoveredFishCount(p10) -- line: 182
    -- upvalues: allFishData (copy)
    if p10 == nil then
        return 0
    end

    local n7 = 0

    for _, v25 in allFishData do
        if v25.rarity ~= "exclusive" and p10.discoveredFish[v25.name] ~= nil then
            n7 += 1
        end
    end

    return n7
end

local function getDiscoveredVariantCount(p11) -- line: 199
    -- upvalues: allFishData (copy), canFishReceiveMutations (copy), t2 (copy), v5 (copy), isCollectionVariantVisibleForItem (ref)
    if p11 == nil then
        return 0
    end

    local n8 = 0

    for _, v26 in allFishData do
        local v27 = p11.discoveredFish[v26.name]

        if v27 ~= nil then
            local n9 = 0

            for _, v28 in v27 do
                if isCollectionVariantVisibleForItem(v26, v28) then
                    n9 += 1
                end
            end

            local v29 = if v26.noNaturalSpawn ~= true or v26.nonExclusiveBossOnly == true then (if canFishReceiveMutations(v26.name) then 3 else 0) + 8 + (if v5 <= t2[v26.rarity] then 1 else 0) else 1

            n8 += math.min(n9, v29)
        end
    end

    return n8
end

local function isCollectionItemUnlocked(p12, p13, p14) -- line: 220
    -- upvalues: getFishMutationKey (ref)
    return p13.unlockedFishMutationKeys[getFishMutationKey(p12.id, p14)] ~= nil
end

function getFishMutationKey(p15, p16) -- line: 225
    return (("%*:%*"):format(p15, p16))
end

function sortCollectionItems(p17) -- line: 228
    -- upvalues: t2 (copy)
    table.sort(p17, function(p18, p19) -- line: 229
        -- upvalues: t2 (copy)
        local v34 = t2[p18.rarity]
        local v35 = t2[p19.rarity]

        if v34 == v35 then
            return p18.name < p19.name
        end

        return v34 < v35
    end)

    return p17
end

return {
    getCollectionIndexState = getCollectionIndexState,
    getCollectionItems = getCollectionItems,
    isJackpotEligibleRarity = isJackpotEligibleRarity,
    getCollectionItemsForVariant = getCollectionItemsForVariant,
    getCollectionItemsForHoola = getCollectionItemsForHoola,
    isCollectionVariantVisibleForItem = isCollectionVariantVisibleForItem,
    getTotalCollectionVariantCount = getTotalCollectionVariantCount,
    getTotalCollectionFishCount = getTotalCollectionFishCount,
    getDiscoveredFishCount = getDiscoveredFishCount,
    getDiscoveredVariantCount = getDiscoveredVariantCount,
    isCollectionItemUnlocked = isCollectionItemUnlocked,
    hoolaCollectionVariants = t1
}
