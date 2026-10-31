-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local getTotalCollectionFishCount = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "collection-index-utils").getTotalCollectionFishCount
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 170, 50)),
    ColorSequenceKeypoint.new(0.34, Color3.fromRGB(255, 245, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 130)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(70, 190, 255)),
    ColorSequenceKeypoint.new(0.84, Color3.fromRGB(170, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 200))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 246, 170)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 156, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 235)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 165, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 255, 250))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 246, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 235, 90))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 45, 255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(210, 60, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 255, 215))
})
local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 205, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 225, 255))
})
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 135)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 70, 255))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 255, 130)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 235, 75)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 210, 95))
})
local v10 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 125, 65)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 70, 105)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 80))
})
local v11 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 220)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(95, 210, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(105, 255, 145)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 110))
})
local v12 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 255, 210)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 170, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 105, 235)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 120))
})
local v13 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 20)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 55, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 205, 45)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(190, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 232, 90))
})
local v14 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 250, 255)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(95, 210, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.78, Color3.fromRGB(115, 135, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 250, 255))
})
local v15 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 255, 245)),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(85, 205, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(190, 245, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))
})
local v16 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 225, 255)),
    ColorSequenceKeypoint.new(0.125, Color3.fromRGB(255, 60, 215)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 238, 45)),
    ColorSequenceKeypoint.new(0.375, Color3.fromRGB(75, 255, 105)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 225, 255)),
    ColorSequenceKeypoint.new(0.625, Color3.fromRGB(255, 60, 215)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 238, 45)),
    ColorSequenceKeypoint.new(0.875, Color3.fromRGB(75, 255, 105)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 225, 255))
})
local v17 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 45)),
    ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 250, 215)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 70, 190)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(75, 225, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 75, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 205, 45)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 250, 215)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 70, 190)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(75, 225, 255)),
    ColorSequenceKeypoint.new(0.9, Color3.fromRGB(150, 75, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 205, 45))
})
local t1 = {
    {
        id = "freshBait",
        displayName = "Fresh Bait",
        description = "The default title for every player.",
        order = 2,
        obtainable = true,
        color = Color3.fromRGB(205, 205, 205)
    },
    {
        id = "maxedAquarium",
        displayName = "Fish Hoarder",
        description = "Upgrade your aquarium to the maximum level.",
        order = 3,
        obtainable = true,
        color = Color3.fromRGB(45, 165, 255),
        animatedColor = v4
    },
    {
        id = "rageBait",
        displayName = "Rage Bait",
        description = "Fail a Boss Fish skill check.",
        order = 4,
        obtainable = true,
        color = Color3.fromRGB(255, 59, 59)
    },
    {
        id = "blessedBait",
        displayName = "Blessed Bait",
        description = "Battle 2x Boss Fish in a row.",
        order = 5,
        obtainable = true,
        color = Color3.fromRGB(255, 172, 52),
        animatedColor = v5
    },
    {
        id = "baitAgain",
        displayName = "Bait Again",
        description = "Reach a 2-day login streak.",
        order = 6,
        obtainable = true,
        color = Color3.fromRGB(70, 205, 255)
    },
    {
        id = "hooked",
        displayName = "Hooked",
        description = "Reach a 7-day login streak.",
        order = 7,
        obtainable = true,
        color = Color3.fromRGB(82, 255, 153)
    },
    {
        id = "vip",
        displayName = "VIP",
        description = "Own the VIP gamepass.",
        order = 8,
        obtainable = true,
        color = Color3.fromRGB(255, 215, 0),
        animatedColor = v2
    },
    {
        id = "devourer",
        displayName = "Devourerer",
        description = "Catch the Devourer.",
        order = 9,
        obtainable = true,
        color = Color3.fromRGB(138, 62, 255),
        animatedColor = v6
    },
    {
        id = "mjfish",
        displayName = "Smooth Criminal",
        description = "Catch a MJFish.",
        order = 10,
        obtainable = true,
        color = Color3.fromRGB(234, 247, 255)
    },
    {
        id = "bassRod",
        displayName = "Bait-thoven",
        description = "Obtain the Bass Rod.",
        order = 11,
        obtainable = true,
        color = Color3.fromRGB(201, 124, 255)
    },
    {
        id = "excalibur",
        displayName = "Chosen One",
        description = "Obtain the Excalibur Rod.",
        order = 12,
        obtainable = true,
        color = Color3.fromRGB(255, 203, 48),
        animatedColor = v7
    },
    {
        id = "judgement",
        displayName = "One Above All",
        description = "Obtain the Judgement Barbell.",
        order = 13,
        obtainable = true,
        color = Color3.fromRGB(255, 78, 118),
        animatedColor = v8
    },
    {
        id = "billionaire",
        displayName = "Billionaire",
        description = "Reach your first 1,000,000,000 dollars.",
        order = 14,
        obtainable = true,
        color = Color3.fromRGB(55, 224, 102),
        animatedColor = v9
    },
    {
        id = "gymBait",
        displayName = "Gym Bait",
        description = "Reach 100,000,000,000 power.",
        order = 15,
        obtainable = true,
        color = Color3.fromRGB(255, 108, 58),
        animatedColor = v10
    },
    {
        id = "jebaiter",
        displayName = "Jebaiter",
        order = 16,
        obtainable = true,
        description = ("Discover all %* unique fish."):format((getTotalCollectionFishCount())),
        color = Color3.fromRGB(245, 74, 210),
        animatedColor = v11
    },
    {
        id = "marathon",
        displayName = "Locked In",
        description = "Play for 2 hours in a single session.",
        order = 17,
        obtainable = true,
        color = Color3.fromRGB(59, 130, 255)
    },
    {
        id = "quack",
        displayName = "Quack",
        description = "Catch a Duck.",
        order = 18,
        obtainable = true,
        color = Color3.fromRGB(255, 228, 92)
    },
    {
        id = "certifiedBait",
        displayName = "Fanbait",
        description = "Join our Discord server.",
        order = 19,
        obtainable = true,
        color = Color3.fromRGB(88, 101, 242),
        animatedColor = v3
    },
    {
        id = "baller",
        displayName = "Baller",
        description = "Obtain an Exclusive fish.",
        order = 20,
        obtainable = true,
        rainbow = true,
        color = Color3.fromRGB(255, 255, 255),
        animatedColor = v1
    },
    {
        id = "monarch",
        displayName = "Monarch",
        description = "Win the 2% title reward from the Spin Wheel.",
        order = 21,
        obtainable = true,
        color = Color3.fromRGB(120, 225, 255),
        animatedColor = v12
    },
    {
        id = "frozenOne",
        displayName = "The Frozen One",
        description = "Capture the Exclusive Frostwyrm",
        lockedDisplayName = "???",
        lockedDescription = "Capture the Exclusive Frostwyrm.",
        order = 0,
        obtainable = true,
        color = Color3.fromRGB(145, 225, 255),
        animatedColor = v14
    },
    {
        id = "icyFingers",
        displayName = "Icy Fingers",
        description = "x1.25 Frostwyrm encounter luck when equipped.",
        lockedDisplayName = "???",
        lockedDescription = "The Frostwyrm Stone keeps its coldest secret behind it.",
        order = 1,
        obtainable = true,
        perkDescription = "x1.25 Frostwyrm encounter luck\nwhen equipped",
        color = Color3.fromRGB(45, 220, 255),
        animatedColor = v15
    },
    {
        id = "markOfTheOg",
        displayName = "Mark of The OG",
        description = "Purchase with Celebration Tickets.",
        order = -2,
        obtainable = true,
        color = Color3.fromRGB(255, 188, 74),
        animatedColor = v16
    },
    {
        id = "ogPrime",
        displayName = "OG Prime",
        description = "Premium Celebration title.",
        order = -1,
        obtainable = true,
        visualTier = "premiumEvent",
        color = Color3.fromRGB(255, 190, 62),
        animatedColor = v17
    },
    {
        id = "finalBoss",
        displayName = "Final Boss",
        description = "Unlock 21 unique titles",
        order = 24,
        obtainable = true,
        color = Color3.fromRGB(210, 28, 36),
        animatedColor = v13
    },
    {
        id = "developer",
        displayName = "Developer",
        description = "Reserved for the game's developers.",
        order = 25,
        obtainable = false,
        rainbow = true,
        color = Color3.fromRGB(255, 255, 255),
        animatedColor = v1
    }
}
local v18 = table.create(#t1)

local function v19(p1) -- line: 246
    return {
        p1.id,
        p1
    }
end

for v20, v21 in t1 do
    local _ = v20 - 1

    v18[v20] = {
        v21.id,
        v21
    }
end

local t2 = {}

for _, v22 in v18 do
    t2[v22[1]] = v22[2]
end

return {
    defaultTitleId = "freshBait",
    finalBossTitleId = "finalBoss",
    finalBossRequiredUniqueTitles = 21,
    getTitleData = function(p2) -- getTitleData | line: 258
        -- upvalues: t2 (copy)
        return t2[p2]
    end,
    isValidTitleId = function(p3) -- isValidTitleId | line: 262
        -- upvalues: t2 (copy)
        return t2[p3] ~= nil
    end,
    getFinalBossOwnedTitleCount = function(p4) -- getFinalBossOwnedTitleCount | line: 269
        -- upvalues: t2 (copy)
        local t3 = {}

        for _, v23 in p4 do
            local v24 = t2[v23]

            if (if v24 == nil then v24 else v24.obtainable) and v24.id ~= "finalBoss" then
                t3[v24.id] = true
            end
        end

        local n1 = 0

        for _ in t3 do
            n1 += 1
        end

        return n1
    end,
    rainbowTitleSequence = v1,
    vipTitleSequence = v2,
    fanbaitTitleSequence = v3,
    aquariumMasterTitleSequence = v4,
    blessedBaitTitleSequence = v5,
    devourerTitleSequence = v6,
    chosenOneTitleSequence = v7,
    judgementTitleSequence = v8,
    billionaireTitleSequence = v9,
    gymBaitTitleSequence = v10,
    completionistTitleSequence = v11,
    monarchTitleSequence = v12,
    finalBossTitleSequence = v13,
    frozenOneTitleSequence = v14,
    icyFingersTitleSequence = v15,
    celebrationTitleSequence = v16,
    markOfTheOgTitleSequence = v16,
    ogPrimeTitleSequence = v17,
    titlesData = t1,
    titlesById = t2
}
