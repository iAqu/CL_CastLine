-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
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
local v1 = #t1

local function getFishingZoneIndex(p1) -- line: 8
    -- upvalues: t1 (copy)
    return (table.find(t1, p1) or 0) - 1
end

local t2 = {
    common = {
        baseRarity = "common",
        chanceToSpawnHigherRarityFish = 0.2
    },
    uncommon = {
        baseRarity = "uncommon",
        chanceToSpawnHigherRarityFish = 0.25
    },
    rare = {
        baseRarity = "rare",
        chanceToSpawnHigherRarityFish = 0.3
    },
    epic = {
        baseRarity = "epic",
        chanceToSpawnHigherRarityFish = 0.35
    },
    legendary = {
        baseRarity = "legendary",
        chanceToSpawnHigherRarityFish = 0.4
    },
    mythic = {
        baseRarity = "mythic",
        chanceToSpawnHigherRarityFish = 0.5
    },
    godly = {
        baseRarity = "godly",
        chanceToSpawnHigherRarityFish = 0.55
    },
    secret = {
        baseRarity = "secret",
        chanceToSpawnHigherRarityFish = 0.6
    },
    hacked = {
        baseRarity = "hacked",
        chanceToSpawnHigherRarityFish = 0.65
    },
    cosmic = {
        baseRarity = "cosmic",
        chanceToSpawnHigherRarityFish = 0.7
    },
    extinct = {
        baseRarity = "extinct",
        chanceToSpawnHigherRarityFish = 0.75
    },
    kaijuwu = {
        baseRarity = "kaijuwu",
        chanceToSpawnHigherRarityFish = 0.8
    },
    scifi = {
        baseRarity = "scifi",
        chanceToSpawnHigherRarityFish = 0.85
    }
}

return {
    apexRarityMinOffset = 1,
    apexRarityMaxOffset = 1,
    getFishingZoneIndex = getFishingZoneIndex,
    getMinJackpotRarity = function() -- getMinJackpotRarity | line: 77
        -- upvalues: t1 (copy), t2 (copy)
        return t2[t1[math.min(1, #t1 - 1) + 1]].baseRarity
    end,
    fishingZonesList = t1,
    fishingZoneCount = v1,
    progressBarZoneCount = v1,
    fishingZonesData = t2
}
