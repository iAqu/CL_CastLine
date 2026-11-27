-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Config = require(script.Parent.Config)
local Economy = require(script.Parent.Economy)
local Format = require(script.Parent.Format)
local t1 = {
    {
        { "Minnow", "Common", 0.01 },
        { "Tadpole", "Common", 0.005 },
        { "Goldfish", "Common", 0.3 },
        { "PondSnail", "Uncommon", 0.02 },
        { "Koi", "Uncommon", 4 },
        { "Crayfish", "Rare", 0.05 },
        { "PaintedTurtle", "Rare", 0.5 },
        { "SnappingTurtle", "Epic", 15 }
    },
    {
        { "Perch", "Common", 0.5 },
        { "Bass", "Uncommon", 2.5 },
        { "RainbowTrout", "Uncommon", 2 },
        { "Catfish", "Rare", 10 },
        { "Pike", "Rare", 6 },
        { "Paddlefish", "Epic", 25 },
        { "GiantSturgeon", "Epic", 150 },
        { "GhostPike", "Legendary", 12 }
    },
    {
        { "Mudskipper", "Uncommon", 0.03 },
        { "Archerfish", "Rare", 0.2 },
        { "Piranha", "Rare", 1.5 },
        { "ElectricEel", "Epic", 20 },
        { "AlligatorGar", "Epic", 70 },
        { "Arapaima", "Legendary", 120 },
        { "Caiman", "Legendary", 40 },
        { "SwampHydra", "Mythic", 900 }
    },
    {
        { "HermitCrab", "Rare", 0.1 },
        { "SeaTurtle", "Epic", 150 },
        { "Stingray", "Epic", 30 },
        { "BlueLobster", "Legendary", 4 },
        { "LemonShark", "Legendary", 120 },
        { "DragonTurtle", "Mythic", 600 },
        { "KrakenHatchling", "Mythic", 250 },
        { "Archelon", "Ancient", 2000 }
    },
    {
        { "Pufferfish", "Epic", 1 },
        { "Lionfish", "Legendary", 1.2 },
        { "MantaRay", "Legendary", 1300 },
        { "CoralWyrm", "Mythic", 1800 },
        { "PearlClam", "Mythic", 250 },
        { "Helicoprion", "Ancient", 2500 },
        { "Ammonite", "Ancient", 150 },
        { "StarlightManta", "Celestial", 1600 }
    },
    {
        { "GiantOctopus", "Legendary", 50 },
        { "Kelpie", "Mythic", 700 },
        { "LeafySeaDragon", "Mythic", 0.1 },
        { "Plesiosaur", "Ancient", 4000 },
        { "Cameroceras", "Ancient", 3500 },
        { "ConstellationSeahorse", "Celestial", 0.5 },
        { "MoonlightOtter", "Celestial", 35 },
        { "NebulaOctopus", "Cosmic", 300 }
    },
    {
        { "SeaSerpent", "Mythic", 9000 },
        { "Megalodon", "Ancient", 50000 },
        { "Mosasaurus", "Ancient", 15000 },
        { "StarfallSwordfish", "Celestial", 650 },
        { "CometDolphin", "Celestial", 300 },
        { "GalaxyWhaleShark", "Cosmic", 20000 },
        { "CosmicGreatWhite", "Cosmic", 2500 },
        { "PrismHumpback", "Prismatic", 35000 }
    },
    {
        { "AuroraSeal", "Celestial", 250 },
        { "StarlitPenguin", "Celestial", 40 },
        { "CometBeluga", "Cosmic", 1500 },
        { "NebulaOrca", "Cosmic", 6000 },
        { "CosmicWalrus", "Cosmic", 1500 },
        { "CrystalNarwhal", "Prismatic", 1600 },
        { "PrismJellyfish", "Prismatic", 200 },
        { "DiamondWalrus", "Prismatic", 2500 },
        { "TitanOrca", "Titan", 25000 },
        { "GlacierTurtle", "Titan", 60000 },
        { "ColossalBlueWhale", "Titan", 180000 },
        { "MammothWalrus", "Titan", 30000 }
    },
    {
        { "GalaxyAnglerfish", "Cosmic", 50 },
        { "NebulaJellyfish", "Cosmic", 150 },
        { "PrismVampireSquid", "Prismatic", 20 },
        { "CrystalGulperEel", "Prismatic", 30 },
        { "PrismIsopod", "Prismatic", 60 },
        { "ColossalSquid", "Titan", 750 },
        { "TitanIsopod", "Titan", 4000 },
        { "TitanOarfish", "Titan", 2500 },
        { "VoidAngler", "Abyssal", 900 },
        { "ShadowShark", "Abyssal", 3000 },
        { "AbyssalRay", "Abyssal", 2000 },
        { "AbyssWatcher", "Abyssal", 12000 }
    },
    {
        { "MagmaCrystalCrab", "Prismatic", 400 },
        { "PrismLavaEel", "Prismatic", 300 },
        { "VolcanoTurtle", "Titan", 80000 },
        { "MoltenWhale", "Titan", 150000 },
        { "ObsidianBehemoth", "Titan", 90000 },
        { "CinderSquid", "Abyssal", 1200 },
        { "SmokeShark", "Abyssal", 4000 },
        { "EmberManta", "Abyssal", 2500 },
        { "MagmaSerpent", "Secret", 2E+05 },
        { "GoldenKoi", "Secret", 777 },
        { "EclipseWhale", "Secret", 250000 }
    },
    {
        { "TitanTempleTurtle", "Titan", 95000 },
        { "PlazaManta", "Titan", 40000 },
        { "RuneEel", "Abyssal", 900 },
        { "ShadeSeahorse", "Abyssal", 30 },
        { "VoidPufferfish", "Abyssal", 150 },
        { "TridentSwordfish", "Secret", 1200 },
        { "CrownCrab", "Secret", 600 },
        { "MarbleHydra", "Secret", 220000 },
        { "RadiantDolphin", "Radiant", 500 },
        { "RadiantKoi", "Radiant", 888 },
        { "RadiantNarwhal", "Radiant", 2200 },
        { "RadiantHumpback", "Radiant", 45000 }
    },
    {
        { "SquallSquid", "Abyssal", 1500 },
        { "VoidBarracuda", "Abyssal", 400 },
        { "StormKraken", "Secret", 3E+05 },
        { "WhirlpoolSerpent", "Secret", 250000 },
        { "LighthouseAngler", "Secret", 800 },
        { "RadiantStingray", "Radiant", 900 },
        { "RadiantSeal", "Radiant", 600 },
        { "RadiantOrca", "Radiant", 9000 },
        { "ThunderShark", "Tempest", 5000 },
        { "StormMegalodon", "Tempest", 70000 },
        { "LightningEel", "Tempest", 1800 },
        { "CloudWhale", "Tempest", 2E+05 }
    },
    {
        { "RiftWatcher", "Secret", 15000 },
        { "MirrorKoi", "Secret", 999 },
        { "RadiantJellyfish", "Radiant", 400 },
        { "RadiantSeaDragon", "Radiant", 50 },
        { "RadiantMosasaurus", "Radiant", 20000 },
        { "TempestPlesiosaur", "Tempest", 6000 },
        { "TempestRay", "Tempest", 3500 },
        { "TempestIsopod", "Tempest", 6000 },
        { "GlitchedGreatWhite", "Glitched", 4040 },
        { "GlitchedOctopus", "Glitched", 404 },
        { "GlitchedSnapper", "Glitched", 1404 },
        { "ErrorWhale", "Glitched", 404000 }
    },
    {
        { "Bristlemouth", "Radiant", 0.005 },
        { "Hatchetfish", "Radiant", 0.02 },
        { "Lanternfish", "Radiant", 0.03 },
        { "Barreleye", "Tempest", 0.1 },
        { "CockeyedSquid", "Tempest", 0.4 },
        { "SpiderCrab", "Tempest", 19 },
        { "FrilledShark", "Glitched", 8 },
        { "GoblinShark", "Glitched", 210 },
        { "Coelacanth", "Dusk", 90 },
        { "Sunfish", "Dusk", 1000 }
    },
    {
        { "FireflySquid", "Tempest", 0.01 },
        { "Viperfish", "Tempest", 0.03 },
        { "Fangtooth", "Tempest", 0.12 },
        { "StoplightLoosejaw", "Glitched", 0.05 },
        { "Dragonfish", "Glitched", 0.2 },
        { "BlackSwallower", "Glitched", 0.1 },
        { "DumboOctopus", "Dusk", 6 },
        { "SixgillShark", "Dusk", 500 },
        { "ShroudRay", "Nightfall", 350 },
        { "GiantSiphonophore", "Nightfall", 120 }
    },
    {
        { "LampSnail", "Glitched", 0.05 },
        { "FireBreathingShrimp", "Glitched", 0.05 },
        { "YetiCrab", "Dusk", 0.1 },
        { "Pyrosome", "Dusk", 2 },
        { "CrownJellyfish", "Dusk", 1.5 },
        { "StalactiteBatRay", "Nightfall", 80 },
        { "LumenNudibranch", "Lumen", 0.3 },
        { "LumenMantisShrimp", "Lumen", 1.5 },
        { "LumenMoray", "Lumen", 30 },
        { "LumenCaveDragon", "Lumen", 2500 }
    },
    {
        { "SpotPrawn", "Dusk", 0.05 },
        { "BasketStar", "Dusk", 2 },
        { "SeaLily", "Dusk", 1 },
        { "DecoratorCrab", "Nightfall", 0.3 },
        { "YelloweyeRockfish", "Nightfall", 10 },
        { "SailfinSculpin", "Nightfall", 0.2 },
        { "WolfEel", "Lumen", 18 },
        { "SleeperShark", "Lumen", 700 },
        { "PhantomLeafEel", "Phantom", 2 },
        { "PhantomOctopus", "Phantom", 40 },
        { "PhantomChimaera", "Phantom", 30 },
        { "PhantomHammerhead", "Phantom", 450 }
    },
    {
        { "SquatLobster", "Nightfall", 0.1 },
        { "IceWorm", "Nightfall", 0.01 },
        { "VeilCucumber", "Nightfall", 0.5 },
        { "SeaToad", "Lumen", 0.4 },
        { "Hagfish", "Lumen", 1 },
        { "TripodFish", "Lumen", 0.5 },
        { "Lizardfish", "Phantom", 0.6 },
        { "Brinewalker", "Phantom", 120 },
        { "QuicksilverNautilus", "Quicksilver", 1.5 },
        { "QuicksilverBlobfish", "Quicksilver", 9 },
        { "QuicksilverMarlin", "Quicksilver", 600 },
        { "QuicksilverSerpent", "Quicksilver", 3000 }
    },
    {
        { "VentShrimp", "Lumen", 0.02 },
        { "ScalyFootSnail", "Lumen", 0.05 },
        { "Eelpout", "Lumen", 0.6 },
        { "Rattail", "Phantom", 2 },
        { "GiantTubeWorm", "Phantom", 5 },
        { "ChimneySalamander", "Phantom", 15 },
        { "FurnaceSquid", "Quicksilver", 60 },
        { "Dunkleosteus", "Quicksilver", 3500 },
        { "ThermalSeaScorpion", "Thermal", 400 },
        { "ThermalSawfish", "Thermal", 600 },
        { "ThermalTubeDragon", "Thermal", 2000 },
        { "ThermalBeakedWhale", "Thermal", 3000 }
    },
    {
        { "SkeletonShrimp", "Phantom", 0.01 },
        { "BrittleStar", "Phantom", 0.1 },
        { "SeaSpider", "Phantom", 0.3 },
        { "RibCrawler", "Quicksilver", 5 },
        { "WhaleboneWrasse", "Quicksilver", 3 },
        { "AntlerSquid", "Quicksilver", 40 },
        { "ElephantSeal", "Thermal", 3000 },
        { "MegamouthShark", "Thermal", 1200 },
        { "BonecrestMako", "Bonecrest", 500 },
        { "BonecrestIchthyosaur", "Bonecrest", 4000 },
        { "BonecrestBasilosaurus", "Bonecrest", 15000 },
        { "BonecrestHumpback", "Bonecrest", 30000 }
    },
    {
        { "Cutlassfish", "Quicksilver", 4 },
        { "PeriscopeEel", "Quicksilver", 8 },
        { "CongerEel", "Quicksilver", 50 },
        { "SeaMinePuffer", "Thermal", 3 },
        { "DivingBellJelly", "Thermal", 30 },
        { "WreckGrouper", "Thermal", 200 },
        { "WreckOctopus", "Bonecrest", 60 },
        { "TorpedoRay", "Bonecrest", 90 },
        { "ThresherShark", "Bonecrest", 350 },
        { "DreadnoughtLobster", "Dreadnought", 40 },
        { "DreadnoughtTigerShark", "Dreadnought", 900 },
        { "DreadnoughtManta", "Dreadnought", 2500 },
        { "DreadnoughtPliosaur", "Dreadnought", 20000 },
        { "DreadnoughtWhaleShark", "Dreadnought", 25000 }
    },
    {
        { "SupergiantAmphipod", "Thermal", 0.05 },
        { "MarianaSnailfish", "Thermal", 0.2 },
        { "CuskEel", "Thermal", 10 },
        { "PancakeBatfish", "Bonecrest", 0.3 },
        { "TrenchCrawler", "Bonecrest", 25 },
        { "PressurePangolinFish", "Bonecrest", 40 },
        { "BigfinSquid", "Dreadnought", 60 },
        { "AnvilheadShark", "Dreadnought", 700 },
        { "EchoWhale", "Dreadnought", 40000 },
        { "HadalStargazer", "Hadal", 30 },
        { "HadalHorseshoeCrab", "Hadal", 50 },
        { "HadalColossusCrab", "Hadal", 2000 },
        { "HadalTrenchWyrm", "Hadal", 30000 },
        { "HadalSpineWhale", "Hadal", 60000 }
    },
    {
        { "LumenCookiecutterShark", "Lumen", 5 },
        { "PhantomOpah", "Phantom", 150 },
        { "QuicksilverTarpon", "Quicksilver", 120 },
        { "ThermalMegapiranha", "Thermal", 300 },
        { "BonecrestLivyatan", "Bonecrest", 50000 },
        { "DreadnoughtBaskingShark", "Dreadnought", 6000 },
        { "AbyssMoth", "Hadal", 20 },
        { "TidecallerCuttlefish", "Hadal", 60 },
        { "HadalLionsMane", "Hadal", 1000 },
        { "HadalLeedsichthys", "Hadal", 45000 },
        { "GeodeWhale", "Fathom", 80000 },
        { "SandglassSerpent", "Fathom", 25000 },
        { "FathomDragon", "Fathom", 120000 },
        { "MawWarden", "Fathom", 150000 }
    }
}
local t2 = {
    PondSnail = true,
    Crayfish = true,
    PaintedTurtle = true,
    SnappingTurtle = true,
    MoonlightOtter = true,
    Mudskipper = true,
    Caiman = true,
    SwampHydra = true,
    HermitCrab = true,
    BlueLobster = true,
    SeaTurtle = true,
    DragonTurtle = true,
    Kelpie = true,
    StarlitPenguin = true,
    AuroraSeal = true,
    CosmicWalrus = true,
    DiamondWalrus = true,
    GlacierTurtle = true,
    MammothWalrus = true,
    PrismIsopod = true,
    TitanIsopod = true,
    MagmaCrystalCrab = true,
    VolcanoTurtle = true,
    TitanTempleTurtle = true,
    CrownCrab = true,
    RadiantSeal = true,
    TempestIsopod = true,
    GlitchedSnapper = true,
    SpiderCrab = true,
    LampSnail = true,
    YetiCrab = true,
    LumenNudibranch = true,
    BasketStar = true,
    DecoratorCrab = true,
    SquatLobster = true,
    IceWorm = true,
    VeilCucumber = true,
    SeaToad = true,
    Brinewalker = true,
    ScalyFootSnail = true,
    ChimneySalamander = true,
    ThermalSeaScorpion = true,
    BrittleStar = true,
    SeaSpider = true,
    RibCrawler = true,
    ElephantSeal = true,
    DreadnoughtLobster = true,
    PancakeBatfish = true,
    TrenchCrawler = true,
    HadalHorseshoeCrab = true,
    HadalColossusCrab = true
}
local t3 = {
    SpiderCrab = true,
    YetiCrab = true,
    DecoratorCrab = true,
    SeaSpider = true,
    Brinewalker = true,
    HadalColossusCrab = true
}
local t4 = {
    { "TreasureTurtle", 400, 3, true },
    { "CrystalLeviathan", 6000, 5, false },
    { "AbyssDragon", 9000, 7, false },
    { "Kraken", 20000, 15, false },
    { "Mermaid", 3000, 10, false },
    { "StarSeahorse", 0.5, 2, false, "ConstellationSeahorse" },
    { "GalaxyOrca", 6000, 3, false, "NebulaOrca" },
    { "CosmicShark", 2500, 4, false, "CosmicGreatWhite" },
    { "SeaMonster", 30000, 3, false }
}
local t5 = {
    SeaMonster = "Loch Ness Monster"
}
local t6 = {
    ById = {},
    ByBiome = {},
    TopRarity = {},
    LowRarity = {},
    Order = {},
    megaBase = 0
}

for v1, v2 in t1 do
    t6.ByBiome[v1] = {}

    local n1 = 1
    local n2 = 1e999

    for _, v3 in v2 do
        n1 = math.max(n1, Config.RarityByName[v3[2]].Index)
        n2 = math.min(n2, Config.RarityByName[v3[2]].Index)
    end

    t6.TopRarity[v1] = n1
    t6.LowRarity[v1] = n2

    for v4, v5 in v2 do
        local v6 = Config.RarityByName[v5[2]]
        local v9 = assert(Economy.Animals[v5[1]], (("Economy.Animals has no %*"):format(v5[1])))
        local t7 = {
            Id = v5[1],
            Name = v5[1]:gsub("(%l)(%u)", "%1 %2"),
            Rarity = v6.Name,
            RarityIndex = v6.Index,
            Biome = v1,
            World = Config.worldOfBiome(v1),
            Income = v9.Income,
            Chance = v9.Chance,
            Weight = v5[3],
            Walks = t2[v5[1]] == true,
            Crab = t3[v5[1]] == true,
            Vfx = v1 > 5 and #v2 - 2 < v4
        }

        t7.SellPrice = t7.Income * Config.SellMultiplier
        t6.ById[t7.Id] = t7
        table.insert(t6.ByBiome[v1], t7)
        table.insert(t6.Order, t7.Id)
    end
end

for _, v11 in t4 do
    t6.ById[v11[1]] = {
        Rarity = "Secret",
        Biome = 13,
        World = 1,
        Income = 0,
        SellPrice = 0,
        Vfx = false,
        Exclusive = true,
        Id = v11[1],
        Name = t5[v11[1]] or v11[1]:gsub("(%l)(%u)", "%1 %2"),
        RarityIndex = Config.RarityByName.Secret.Index,
        Mult = v11[3],
        Weight = v11[2],
        Walks = v11[4],
        Look = v11[5]
    }
end

function t6.look(p1) -- line: 238
    -- upvalues: t6 (copy)
    local v13 = t6.ById[p1]

    if not (v13 and v13.Look) then
        return p1
    end

    return v13.Look
end

function t6.get(p2) -- line: 243
    -- upvalues: t6 (copy)
    return t6.ById[p2]
end

function t6.worldOf(p3) -- line: 249
    -- upvalues: t6 (copy)
    local v14 = if type(p3) == "table" then p3.Id else p3
    local v15 = t6.ById[v14]

    if v15 then
        return v15.World
    end

    return 1
end

function t6.inWorld(p4, p5) -- line: 257
    -- upvalues: t6 (copy)
    return t6.isPaid(p4) or t6.worldOf(p4) == p5
end

function t6.income(p6, p7) -- line: 265
    -- upvalues: Config (copy), t6 (copy)
    local v16 = t6.shopMult(p6)

    if v16 then
        return v16 * math.max(Config.ShopAnimalMin, p7 or t6.megaBase)
    end

    local v18 = t6.ById[p6.Id]
    local v19 = p6.Mutation and Config.MutationByName[p6.Mutation]
    local v20 = p6.Size and Config.SizeByName[p6.Size]

    return (if v18 then v18.Income else 0) * (if v19 then v19.Mult else 1) * (if v20 then v20.Mult else 1)
end

function t6.sellPrice(p8, p9) -- line: 276
    -- upvalues: Config (copy), t6 (copy)
    return t6.income(p8, p9) * Config.SellMultiplier
end

function t6.shopMult(p10) -- line: 281
    -- upvalues: Config (copy), t6 (copy)
    if p10.Mega then
        return Config.MegaMult
    end

    local v21 = t6.ById[p10.Id]

    return if v21 and v21.Exclusive then v21.Mult else nil
end

function t6.bestIncome(p11) -- line: 290
    -- upvalues: t6 (copy)
    local n3 = 0

    for _, v22 in p11 do
        if not t6.shopMult(v22) then
            n3 = math.max(n3, t6.income(v22))
        end
    end

    return n3
end

function t6.rarityText(p12) -- line: 301
    if p12.Exclusive then
        return "Exclusive"
    end

    return p12.Rarity
end

function t6.cardReward(p13) -- line: 308
    -- upvalues: Config (copy), Economy (copy), t6 (copy)
    local v23 = t6.ById[p13]

    if not v23 or v23.Exclusive or not v23.Biome or not Config.Biomes[v23.Biome] then
        return nil, nil
    end

    local v25 = (math.max(Config.throwFor(v23.Biome) - Config.ThrowBase, 0) / Config.ThrowPerStrength) ^ (1 / Config.ThrowExponent)

    return math.floor(v23.Income * Economy.CardCashSeconds), (math.floor(Config.levelCostFull(v25) * Economy.CardLevels))
end

function t6.isPaid(p14) -- line: 319
    -- upvalues: t6 (copy)
    local v29 = t6.ById[p14.Id]

    if p14.Mega == true then
        return true
    end

    return v29 ~= nil and v29.Exclusive == true
end

local t9 = {
    Kraken = true,
    Mermaid = true
}

function t6.isLimitedTradeable(p15) -- line: 330
    -- upvalues: t9 (copy)
    if p15.Mega == true then
        return false
    end

    return t9[p15.Id] == true
end

function t6.isTradeable(p16) -- line: 335
    -- upvalues: t6 (copy)
    return not t6.isPaid(p16) or t6.isLimitedTradeable(p16)
end

function t6.displayName(p17) -- line: 340
    -- upvalues: Config (copy), t6 (copy)
    local v30 = t6.ById[p17.Id]
    local v31 = if v30 then v30.Name else tostring(p17.Id)

    if p17.Mutation and Config.MutationByName[p17.Mutation] then
        v31 = ("%* %*"):format(p17.Mutation, v31)
    end

    if p17.Size and Config.SizeByName[p17.Size] then
        v31 = ("%* %*"):format(p17.Size, v31)
    end

    if p17.Mega then
        return "Mega " .. v31
    end

    return v31
end

function t6.rollWeight(p18, p19, p20) -- line: 354
    -- upvalues: Config (copy), t6 (copy)
    local v32 = t6.ById[p18]
    local v33 = p20 and Config.SizeByName[p20]
    local v34 = 0.8 * 1.5625 ^ p19:NextNumber() ^ 1.5
    local v35 = (if v32 then v32.Weight else 1) * v34 * (if v33 then v33.Mult else 1)
    local v37 = 10 ^ (2 - math.floor((math.log10(v35))))

    return math.floor(v35 * v37 + 0.5) / v37
end

function t6.biomeSizeMult(p21) -- line: 381
    -- upvalues: Config (copy)
    local v39 = Config.Worlds[Config.worldOfBiome((math.max(p21, 1)))]

    return 1.1 ^ (math.max(p21, 1) - v39.First)
end

function t6.naturalSize(p22) -- line: 387
    -- upvalues: t6 (copy)
    local v40 = t6.ById[p22]

    if not v40 then
        return 4
    end

    return (math.max(2.2 * v40.Weight ^ 0.26, 1.5))
end

function t6.baseSize(p23) -- line: 396
    -- upvalues: t6 (copy)
    local v42 = t6.ById[p23]

    if v42 then
        return t6.naturalSize(p23) * t6.biomeSizeMult(v42.Biome)
    end

    return 4
end

function t6.displaySize(p24) -- line: 406
    -- upvalues: Config (copy), t6 (copy)
    local v43 = t6.ById[p24.Id]

    if not v43 then
        return 4
    end

    local v44 = p24.Size and Config.SizeByName[p24.Size]
    local v45 = if v44 then v44.Mult else 1
    local v46 = if type(p24.Weight) == "number" and p24.Weight > 0 then math.clamp((p24.Weight / (v43.Weight * v45)) ^ 0.3333333333333333, 0.85, 1.3) else 1

    return t6.baseSize(p24.Id) * (if v44 then v44.Scale else 1) * v46 * (if p24.Mega then 4 else 1)
end

function t6.formatWeight(p25) -- line: 421
    -- upvalues: Format (copy)
    local v48 = tonumber(p25) or 0

    if v48 < 1 then
        return (("%* g"):format((math.max(1, (math.floor(v48 * 1000 + 0.5))))))
    end

    if v48 < 100 then
        return (`{ math.floor(v48 * 10 + 0.5) / 10 } kg`)
    end

    if not (v48 < 10000) then
        return Format.short(v48) .. " kg"
    end

    return (("%* kg"):format((math.floor(v48 + 0.5))))
end

function t6.speciesWeight(p26, p27) -- line: 435
    -- upvalues: Config (copy)
    return p26.Chance * p27 ^ ((p26.RarityIndex - 1) * Config.LuckTilt)
end

local function totalWeight(p28, p29) -- line: 440
    -- upvalues: Config (copy), t6 (copy)
    local n4 = 0

    for _, v53 in t6.ByBiome[p28] do
        n4 += v53.Chance * p29 ^ ((v53.RarityIndex - 1) * Config.LuckTilt)
    end

    return n4
end

function t6.odds(p30) -- line: 451
    -- upvalues: Config (copy), t6 (copy)
    local v54 = t6.ById[p30]

    if v54 and v54.Exclusive then
        for _, v55 in t6.ByBiome[v54.Biome] do
            if v55.RarityIndex == v54.RarityIndex then
                v54 = v55
                break
            end
        end
    end

    if not v54 or not v54.Chance or v54.Chance <= 0 then
        return 1
    end

    local Biome = v54.Biome
    local n5 = 0

    for _, v56 in t6.ByBiome[Biome] do
        n5 += v56.Chance * 1 ^ ((v56.RarityIndex - 1) * Config.LuckTilt)
    end

    return (math.max(1, (math.floor(n5 / (v54.Chance * 1 ^ ((v54.RarityIndex - 1) * Config.LuckTilt)) * Config.oddsScale(v54.Biome) + 0.5))))
end

function t6.fishPower(p31) -- line: 470
    -- upvalues: Config (copy), Economy (copy), t6 (copy)
    local v59 = t6.ById[p31]

    if not v59 then
        return Economy.FishPower[1]
    end

    return Config.fishPower(v59.Biome, v59.RarityIndex, t6.LowRarity[v59.Biome] or v59.RarityIndex)
end

return t6
