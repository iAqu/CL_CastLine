-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "collection-index-utils")
local getCollectionIndexState, getCollectionItemsForVariant, isCollectionItemUnlocked = v1.getCollectionIndexState, v1.getCollectionItemsForVariant, v1.isCollectionItemUnlocked
local t1 = {
    {
        earningsBonusPercent = 1,
        kind = "aquariumEarnings",
        percent = 25,
        rewardId = "index-fishes-discovered-25",
        rewardText = "+1% AQUARIUM EARNINGS"
    },
    {
        earningsBonusPercent = 2,
        kind = "aquariumEarnings",
        percent = 50,
        rewardId = "index-fishes-discovered-50",
        rewardText = "+2% AQUARIUM EARNINGS"
    },
    {
        earningsBonusPercent = 3,
        kind = "aquariumEarnings",
        percent = 75,
        rewardId = "index-fishes-discovered-75",
        rewardText = "+3% AQUARIUM EARNINGS"
    },
    {
        earningsBonusPercent = 5,
        kind = "goldAquariumSkin",
        percent = 100,
        rewardId = "index-fishes-discovered-100",
        rewardText = "GOLD AQUARIUM SKIN"
    }
}

local function getIndexRewardProgressPercent(p1) -- line: 32
    -- upvalues: getCollectionIndexState (copy), getCollectionItemsForVariant (copy), isCollectionItemUnlocked (copy)
    local v2 = getCollectionIndexState(p1)
    local Normal = getCollectionItemsForVariant("Normal")
    local v3 = #Normal

    if v3 <= 0 then
        return 0
    end

    local n1 = 0

    for _, v4 in Normal do
        if isCollectionItemUnlocked(v4, v2, "Normal") then
            n1 += 1
        end
    end

    return n1 / v3 * 100
end

local function getClaimableIndexRewardMilestones(p2, p3) -- line: 48
    -- upvalues: t1 (copy), getIndexRewardProgressPercent (copy)
    local v5 = getIndexRewardProgressPercent(p2)
    local t2 = {}
    local n2 = 0

    for v6, v7 in t1 do
        local _ = v6 - 1
        local v8 = v7.percent <= v5

        v8 = v8 and (if p3 == nil then p3 else p3[v7.rewardId]) ~= true

        if v8 == true then
            n2 += 1
            t2[n2] = v7
        end
    end

    return t2
end

local function getIndexRewardMilestoneById(p4) -- line: 74
    -- upvalues: t1 (copy)
    for v9, v10 in t1 do
        local _ = v9 - 1

        if v10.rewardId == p4 == true then
            return v10
        end
    end

    return nil
end

local function getIndexAquariumEarningsMultiplier(p5) -- line: 89
    -- upvalues: t1 (copy)
    local n3 = 0

    for _, v11 in t1 do
        if (if p5 == nil then p5 else p5[v11.rewardId]) == true then
            n3 += v11.earningsBonusPercent
        end
    end

    return n3 / 100 + 1
end

return {
    getIndexRewardProgressPercent = getIndexRewardProgressPercent,
    getClaimableIndexRewardMilestones = getClaimableIndexRewardMilestones,
    getIndexRewardMilestoneById = getIndexRewardMilestoneById,
    getIndexAquariumEarningsMultiplier = getIndexAquariumEarningsMultiplier,
    getIndexAquariumEarningsBonus = function(p6) -- getIndexAquariumEarningsBonus | line: 103
        -- upvalues: getIndexAquariumEarningsMultiplier (copy)
        return getIndexAquariumEarningsMultiplier(p6) - 1
    end,
    indexRewardMilestones = t1
}
