-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local hoolaSystemConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config").hoolaSystemConfig
local t1 = {
    hoola1 = "Hoola I",
    hoola2 = "Hoola II",
    hoola3 = "Hoola III"
}
local t2 = {
    hoola1 = "Hoola1",
    hoola2 = "Hoola2",
    hoola3 = "Hoola3"
}

local function getFishMutationDisplayName(p1) -- line: 15
    -- upvalues: t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = p1
    end

    return v1
end

local t3

local function getFishMutationNameFromCommandName(p2) -- line: 23
    -- upvalues: t2 (copy), t3 (ref)
    for v2, v3 in pairs(t2) do
        if v3 == p2 then
            return v2
        end
    end

    return if t3[p2] ~= nil then p2 else nil
end

local t4 = {
    "i'm not a fish..",
    "i'm not real..",
    "du bist gut genung"
}

t3 = {
    Gold = {
        mutationName = "Gold",
        mutationCashMultiplier = 1.5,
        mutationChance = 0.25
    },
    Diamond = {
        mutationName = "Diamond",
        mutationCashMultiplier = 2,
        mutationChance = 0.14285714285714285
    },
    Plasma = {
        mutationName = "Plasma",
        mutationCashMultiplier = 4,
        mutationChance = 0.025
    },
    Molten = {
        mutationName = "Molten",
        mutationCashMultiplier = 6,
        mutationChance = 0.013333333333333334
    },
    Radioactive = {
        mutationName = "Radioactive",
        mutationCashMultiplier = 8,
        mutationChance = 0.007692307692307693
    },
    Glitched = {
        mutationName = "Glitched",
        mutationCashMultiplier = 5,
        mutationChance = 0.1,
        weatherRequirement = "Glitched"
    },
    Champion = {
        mutationName = "Champion",
        mutationCashMultiplier = 3,
        mutationChance = 0.3
    },
    Delulu = {
        mutationName = "Delulu",
        mutationCashMultiplier = 2,
        mutationChance = 0.5
    },
    hoola1 = {
        mutationName = "hoola1",
        mutationChance = 0,
        mutationCashMultiplier = hoolaSystemConfig.cosmeticCashMultipliers.hoola1
    },
    hoola2 = {
        mutationName = "hoola2",
        mutationChance = 0,
        mutationCashMultiplier = hoolaSystemConfig.cosmeticCashMultipliers.hoola2
    },
    hoola3 = {
        mutationName = "hoola3",
        mutationChance = 0,
        mutationCashMultiplier = hoolaSystemConfig.cosmeticCashMultipliers.hoola3
    }
}

return {
    championMutationName = "Champion",
    deluluMutationName = "Delulu",
    getFishMutationDisplayName = getFishMutationDisplayName,
    getFishMutationNameFromCommandName = getFishMutationNameFromCommandName,
    hoolaMutationDisplayNames = t1,
    hoolaMutationCommandNames = t2,
    deluluSpewPhrases = t4,
    fishMutations = t3
}
