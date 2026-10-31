-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    CelebrationEventShop = "CelebrationEventShop",
    DailyReward = "DailyReward",
    ExclusiveShop = "ExclusiveShop",
    Index = "Index",
    SkinCrate = "SkinCrate",
    SpinWheel = "SpinWheel"
}
local t2 = {
    "rare",
    "epic",
    "legendary",
    "mythic"
}
local t3 = {
    "rare",
    "epic",
    "legendary"
}
local t4 = {
    rare = {
        universalShardsPerCraft = 1
    },
    epic = {
        universalShardsPerCraft = 4
    },
    legendary = {
        universalShardsPerCraft = 15
    },
    mythic = {
        universalShardsPerCraft = 40
    }
}
local t5 = {
    rare = {
        sourceShardsPerCraft = 8,
        targetRarity = "epic"
    },
    epic = {
        sourceShardsPerCraft = 3,
        targetRarity = "legendary"
    },
    legendary = {
        sourceShardsPerCraft = 7,
        targetRarity = "mythic"
    }
}
local t6 = {
    "Basketball",
    "IceHockey",
    "RaceArena",
    "Football"
}
local t7 = {
    "Scifi",
    "ModernHouse",
    "Castle",
    "Fantasy"
}
local t8 = {
    rare = {
        duplicateReward = 1,
        exchangeCost = 500
    },
    epic = {
        duplicateReward = 7,
        exchangeCost = 200
    },
    legendary = {
        duplicateReward = 32,
        exchangeCost = 75
    },
    mythic = {
        duplicateReward = 128,
        exchangeCost = 25
    }
}

local function getAquariumSkinShardValues(p1) -- line: 75
    -- upvalues: t8 (copy)
    return t8[p1]
end

local function isAquariumSkinShardRarity(p2) -- line: 79
    if p2 == "rare" or p2 == "epic" or p2 == "legendary" then
        return true
    end

    return p2 == "mythic"
end

local function isAquariumSkinShardUpgradeSourceRarity(p3) -- line: 82
    if p3 == "rare" or p3 == "epic" then
        return true
    end

    return p3 == "legendary"
end

local function getAquariumSkinShardExchangeRate(p4) -- line: 85
    -- upvalues: t4 (copy)
    return t4[p4]
end

local function getAquariumSkinShardUpgradeRate(p5) -- line: 89
    -- upvalues: t5 (copy)
    return t5[p5]
end

local t9

local function getAquariumSkinExchangeCost(p6) -- line: 94
    -- upvalues: t8 (copy), t9 (ref)
    if p6 == "Default" then
        return nil
    end

    local v1 = t9[p6]

    if v1 == nil then
        return nil
    end

    local v2 = t8[v1.rarity]

    if v2 ~= nil then
        v2 = v2.exchangeCost
    end

    return v2
end

local function getAquariumSkinExchangeRarity(p7) -- line: 112
    -- upvalues: t9 (ref)
    local v3 = t9[p7]

    if v3 ~= nil then
        local rarity = v3.rarity

        if rarity == "rare" or rarity == "epic" or rarity == "legendary" or rarity == "mythic" then
            return v3.rarity
        end
    end

    return nil
end

local function skinModels(p8) -- line: 117
    -- upvalues: ReplicatedStorage (copy)
    local Aquariums = ReplicatedStorage:FindFirstChild("Aquariums")

    if Aquariums ~= nil then
        Aquariums = Aquariums:FindFirstChild("Skins")

        if Aquariums ~= nil then
            Aquariums = Aquariums:FindFirstChild(p8)
        end
    end

    local v4 = if Aquariums == nil then Aquariums else Aquariums:FindFirstChild("Aquarium1")
    local v5 = if Aquariums == nil then Aquariums else Aquariums:FindFirstChild("Aquarium2")
    local v6 = if Aquariums == nil then Aquariums else Aquariums:FindFirstChild("Aquarium3")
    local v7 = if Aquariums == nil then Aquariums else Aquariums:FindFirstChild("Aquarium4")

    if Aquariums ~= nil then
        Aquariums = Aquariums:FindFirstChild("Aquarium5")
    end

    return { v4, v5, v6, v7, Aquariums }
end

t9 = {
    Default = {
        name = "Default",
        description = "Your first Aquarium!",
        displayName = "Default",
        imageId = "rbxassetid://80385013879055",
        rarity = "common",
        models = skinModels("Default")
    },
    Basketball = {
        name = "Basketball",
        description = "Unlocked from the Sports Crate",
        displayName = "Basketball Court",
        imageId = "rbxassetid://84664893907136",
        moneyBoost = 0.02,
        rarity = "rare",
        models = skinModels("Basketball"),
        source = t1.SkinCrate
    },
    IceHockey = {
        name = "IceHockey",
        description = "Unlocked from the Sports Crate",
        displayName = "Ice Hockey Rink",
        imageId = "rbxassetid://88898056054951",
        moneyBoost = 0.04,
        rarity = "epic",
        models = skinModels("IceHockey"),
        source = t1.SkinCrate
    },
    RaceArena = {
        name = "RaceArena",
        description = "Unlocked from the Sports Crate",
        displayName = "Race Track",
        imageId = "rbxassetid://129604502178706",
        moneyBoost = 0.06,
        rarity = "legendary",
        models = skinModels("RaceArena"),
        source = t1.SkinCrate
    },
    Football = {
        name = "Football",
        description = "Unlocked from the Sports Crate",
        displayName = "Soccer Stadium",
        imageId = "rbxassetid://104225616980671",
        moneyBoost = 0.12,
        rarity = "mythic",
        models = skinModels("Football"),
        source = t1.SkinCrate
    },
    FOMO = {
        name = "FOMO",
        description = "Unlocked from the Celebration Event Shop",
        displayName = "FOMO",
        imageId = "rbxassetid://117117144452618",
        moneyBoost = 0.04,
        rarity = "rare",
        models = skinModels("FOMO"),
        source = t1.CelebrationEventShop
    },
    Fossil = {
        name = "Fossil",
        description = "Unlocked from day 2 Daily reward",
        displayName = "Fossil",
        imageId = "rbxassetid://75140088527655",
        moneyBoost = 0.03,
        rarity = "rare",
        models = skinModels("Fossil"),
        source = t1.DailyReward
    },
    Gold = {
        name = "Gold",
        description = "Unlocked from Index reward",
        displayName = "Gold",
        imageId = "rbxassetid://132442549778622",
        moneyBoost = 0.05,
        rarity = "epic",
        models = skinModels("Gold"),
        source = t1.Index
    },
    Jurassic = {
        name = "Jurassic",
        description = "Unlocked from Spin Wheel Reward",
        displayName = "Jurassic",
        imageId = "rbxassetid://78368161382853",
        moneyBoost = 0.08,
        rarity = "legendary",
        models = skinModels("Jurassic"),
        source = t1.SpinWheel
    },
    Volcanic = {
        name = "Volcanic",
        description = "Unlocked from Exclusive Shop offer",
        displayName = "Volcanic",
        imageId = "rbxassetid://139946971226656",
        moneyBoost = 0.1,
        rarity = "mythic",
        models = skinModels("Volcanic"),
        source = t1.ExclusiveShop
    },
    Scifi = {
        name = "Scifi",
        description = "Unlocked from the Multiverse Crate",
        displayName = "Sci-Fi Lab",
        moneyBoost = 0.02,
        rarity = "rare",
        imageId = images.sciFiAquariumSkin,
        models = skinModels("Scifi"),
        source = t1.SkinCrate
    },
    ModernHouse = {
        name = "ModernHouse",
        description = "Unlocked from the Multiverse Crate",
        displayName = "Modern House",
        moneyBoost = 0.04,
        rarity = "epic",
        imageId = images.modernHouseAquariumSkin,
        models = skinModels("ModernHouse"),
        source = t1.SkinCrate
    },
    Castle = {
        name = "Castle",
        description = "Unlocked from the Multiverse Crate",
        displayName = "Castle",
        moneyBoost = 0.06,
        rarity = "legendary",
        imageId = images.castleAquariumSkin,
        models = skinModels("Castle"),
        source = t1.SkinCrate
    },
    Fantasy = {
        name = "Fantasy",
        description = "Unlocked from the Multiverse Crate",
        displayName = "Fantasy Realm",
        moneyBoost = 0.12,
        rarity = "mythic",
        imageId = images.fantasyAquariumSkin,
        models = skinModels("Fantasy"),
        source = t1.SkinCrate
    }
}

local function getAquariumSkinData(p9) -- line: 288
    -- upvalues: t9 (ref)
    return t9[p9]
end

local function getAquariumSkinMutationLuckSetProgress(p10) -- line: 292
    -- upvalues: t6 (copy)
    local n1 = 0

    for _, v8 in t6 do
        if table.find(p10, v8) ~= nil then
            n1 += 1
        end
    end

    return n1
end

local function hasAquariumSkinMutationLuckSet(p11) -- line: 301
    -- upvalues: t6 (copy), getAquariumSkinMutationLuckSetProgress (copy)
    return getAquariumSkinMutationLuckSetProgress(p11) == #t6
end

local function getAquariumMultiverseSkinMutationLuckSetProgress(p12) -- line: 304
    -- upvalues: t7 (copy)
    local n2 = 0

    for _, v9 in t7 do
        if table.find(p12, v9) ~= nil then
            n2 += 1
        end
    end

    return n2
end

return {
    aquariumSkinMutationLuckSetBonus = 0.2,
    aquariumMultiverseSkinMutationLuckSetBonus = 0.2,
    getAquariumSkinShardValues = getAquariumSkinShardValues,
    isAquariumSkinShardRarity = isAquariumSkinShardRarity,
    isAquariumSkinShardUpgradeSourceRarity = isAquariumSkinShardUpgradeSourceRarity,
    getAquariumSkinShardExchangeRate = getAquariumSkinShardExchangeRate,
    getAquariumSkinShardUpgradeRate = getAquariumSkinShardUpgradeRate,
    getAquariumSkinExchangeCost = getAquariumSkinExchangeCost,
    getAquariumSkinExchangeRarity = getAquariumSkinExchangeRarity,
    getAquariumSkinData = getAquariumSkinData,
    getAquariumSkinMutationLuckSetProgress = getAquariumSkinMutationLuckSetProgress,
    hasAquariumSkinMutationLuckSet = hasAquariumSkinMutationLuckSet,
    getAquariumMultiverseSkinMutationLuckSetProgress = getAquariumMultiverseSkinMutationLuckSetProgress,
    hasAquariumMultiverseSkinMutationLuckSet = function(p13) -- hasAquariumMultiverseSkinMutationLuckSet | line: 313
        -- upvalues: t7 (copy), getAquariumMultiverseSkinMutationLuckSetProgress (copy)
        return getAquariumMultiverseSkinMutationLuckSetProgress(p13) == #t7
    end,
    AquariumSkinSource = t1,
    aquariumSkinShardRarities = t2,
    aquariumSkinShardUpgradeSourceRarities = t3,
    aquariumSkinShardExchangeRates = t4,
    aquariumSkinShardUpgradeRates = t5,
    aquariumSkinMutationLuckSet = t6,
    aquariumMultiverseSkinMutationLuckSet = t7,
    aquariumSkinShardValues = t8,
    aquariumSkinsData = t9
}
