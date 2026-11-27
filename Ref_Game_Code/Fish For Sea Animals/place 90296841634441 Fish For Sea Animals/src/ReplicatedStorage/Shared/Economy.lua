-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    StartingMoney = 30,
    World2 = {
        Hardness = 2,
        OddsJump = 10,
        UnlockPrice = 1E+16,
        FirstLike = 11,
        BiomeStep = 1.3333333333333333,
        Reach = {
            80000, 220000, 590000, 2100000, 6100000, 1.6E+07, 4.5E+07, 1.2E+08,
            3.3E+08, 9E+08
        }
    }
}
local Hardness = t1.World2.Hardness

t1.PlotUpgrades = {
    {
        Animals = 6,
        Price = 0
    },
    {
        Animals = 8,
        Price = 1E+05
    },
    {
        Animals = 10,
        Price = 5E+06
    },
    {
        Animals = 12,
        Price = 2.5E+08
    },
    {
        Animals = 14,
        Price = 1.25E+10
    },
    {
        Animals = 16,
        Price = 6.25E+11
    },
    {
        Animals = 18,
        Price = 3E+13
    },
    {
        Animals = 20,
        Price = 1.5E+15
    }
}
t1.TankBoost = {
    Price = 1E+17,
    PriceGrowth = 1.6,
    Income = 1.15
}
t1.XPGain = 100
t1.BarbellXPMult = 1.5 * t1.XPGain
t1.Barbells = {
    {
        Strength = 1,
        Price = 0
    },
    {
        Strength = 2,
        Price = 100
    },
    {
        Strength = 4,
        Price = 1250
    },
    {
        Strength = 8,
        Price = 12500
    },
    {
        Strength = 15,
        Price = 1E+05
    },
    {
        Strength = 30,
        Price = 8E+05
    },
    {
        Strength = 60,
        Price = 6E+06
    },
    {
        Strength = 120,
        Price = 6E+07
    },
    {
        Strength = 250,
        Price = 6E+08
    },
    {
        Strength = 500,
        Price = 8E+09
    },
    {
        Strength = 1000,
        Price = 1E+11
    },
    {
        Strength = 2000,
        Price = 1.5E+12
    },
    {
        Strength = 4000,
        Price = 2.5E+13
    },
    {
        Strength = 8000,
        Price = 5E+14
    },
    {
        Strength = 16000,
        Price = 1E+16
    },
    {
        Strength = 32000,
        Price = 2.5E+17
    },
    {
        Strength = 64000,
        Price = 4E+18
    },
    {
        Strength = 128000,
        Price = 4E+19
    },
    {
        Strength = 256000,
        Price = 3E+20
    },
    {
        Strength = 512000,
        Price = 2E+21
    },
    {
        Strength = 1500000,
        Price = Hardness * 2E+22
    },
    {
        Strength = 4500000,
        Price = Hardness * 2E+23
    },
    {
        Strength = 1.4E+07,
        Price = Hardness * 2E+24
    },
    {
        Strength = 4E+07,
        Price = Hardness * 2E+25
    },
    {
        Strength = 1.25E+08,
        Price = Hardness * 2E+26
    },
    {
        Strength = 3.75E+08,
        Price = Hardness * 2E+27
    },
    {
        Strength = 1.1E+09,
        Price = Hardness * 2E+28
    },
    {
        Strength = 3.4E+09,
        Price = Hardness * 2E+29
    },
    {
        Strength = 1E+10,
        Price = Hardness * 2E+30
    },
    {
        Strength = 3E+10,
        Price = Hardness * 2E+31
    }
}
t1.Rods = {
    {
        Name = "Twig Rod",
        Reel = 10,
        Price = 0
    },
    {
        Name = "Bamboo Rod",
        Reel = 16,
        Price = 30
    },
    {
        Name = "Fiberglass Rod",
        Reel = 26,
        Price = 1000
    },
    {
        Name = "Carbon Rod",
        Reel = 41,
        Price = 50000
    },
    {
        Name = "Coral Rod",
        Reel = 66,
        Price = 2500000
    },
    {
        Name = "Tidecaller Rod",
        Reel = 105,
        Price = 1.5E+08
    },
    {
        Name = "Golden Rod",
        Reel = 168,
        Price = 1E+10
    },
    {
        Name = "Frostbite Rod",
        Reel = 268,
        Price = 6E+11
    },
    {
        Name = "Abyssal Rod",
        Reel = 429,
        Price = 4E+13
    },
    {
        Name = "Magma Rod",
        Reel = 687,
        Price = 2.5E+15
    },
    {
        Name = "Starlight Rod",
        Reel = 1100,
        Price = 1.5E+17
    },
    {
        Name = "Nebula Rod",
        Reel = 1759,
        Price = 5E+18
    },
    {
        Name = "Kraken Rod",
        Reel = 2815,
        Price = 1E+20
    },
    {
        Name = "Twilight Rod",
        Reel = 4504,
        Price = Hardness * 1E+21
    },
    {
        Name = "Midnight Rod",
        Reel = 7206,
        Price = Hardness * 1E+22
    },
    {
        Name = "Lantern Rod",
        Reel = 11530,
        Price = Hardness * 1E+23
    },
    {
        Name = "Glass Sponge Rod",
        Reel = 18448,
        Price = Hardness * 1E+24
    },
    {
        Name = "Brine Rod",
        Reel = 29517,
        Price = Hardness * 1E+25
    },
    {
        Name = "Vent Rod",
        Reel = 47227,
        Price = Hardness * 1E+26
    },
    {
        Name = "Bone Rod",
        Reel = 75563,
        Price = Hardness * 1E+27
    },
    {
        Name = "Salvage Rod",
        Reel = 120901,
        Price = Hardness * 1E+28
    },
    {
        Name = "Trench Rod",
        Reel = 193441,
        Price = Hardness * 1E+29
    },
    {
        Name = "Leviathan Rod",
        Reel = 309506,
        Price = Hardness * 1E+30
    }
}
t1.LegacyPrices = {
    Rods = {
        0, 30, 1000, 7E+05, 1.5E+07, 4E+08, 2E+10, 9E+11,
        3.5E+13, 5E+15, 9E+17, 9E+19, 8E+21
    },
    Barbells = {
        0, 100, 3500, 15000, 60000, 6E+05, 3E+06, 2E+07,
        5E+08, 1E+10, 1E+11, 2E+12, 1.5E+13, 7E+14, 1E+16, 2E+17,
        4E+18, 8E+19, 1.5E+21, 2.5E+22
    },
    PlotUpgrades = { 0, 2000, 40000, 8E+05, 4E+07, 3.5E+09, 1.5E+12, 2E+14 }
}
t1.Baits = {
    {
        Key = "Cricket",
        Name = "Cricket",
        Luck = 1.2,
        Price = 50000
    },
    {
        Key = "GoldenWorm",
        Name = "Golden Worm",
        Luck = 1.5,
        Price = 1E+08
    },
    {
        Key = "GlowShrimp",
        Name = "Glow Shrimp",
        Luck = 2,
        Price = 5E+10
    },
    {
        Key = "GalaxyLure",
        Name = "Galaxy Lure",
        Luck = 2.5,
        Price = 1E+14
    },
    {
        Key = "StormLure",
        Name = "Storm Lure",
        Luck = 2.75,
        Price = 5E+18
    },
    {
        Key = "DiamondLure",
        Name = "Diamond Lure",
        Luck = 3,
        Product = "BaitDiamond"
    },
    {
        Key = "RainbowBait",
        Name = "Rainbow Bait",
        Luck = 4,
        Rainbow = 3,
        Product = "BaitRainbow"
    }
}
t1.CardCashSeconds = 100
t1.CardLevels = 1
t1.Boss = {
    Interval = 900,
    JoinTime = 45,
    IntroTime = 21,
    FightTime = 60,
    Hearts = 3,
    HealthPerPlayer = 15000,
    CastRange = 230,
    CastGap = 0.7,
    LatchRadius = 26,
    ReelGap = 0.07,
    ReelDamage = 100,
    YankDamage = 1400,
    YankTaps = 7,
    RecommendedRod = 13,
    RodStep = 1.25,
    WeakMult = 3,
    WeakTime = 2.2,
    DodgeCooldown = 1.4,
    DodgeSafe = 0.45,
    WinRodCash = 0.3,
    EscapeRodCash = 0.05,
    RodNextStep = 20,
    MinIncomeSeconds = 180,
    NoHitBonus = 0.5,
    FinalBlowBonus = 0,
    WinLevels = 4,
    AnimalLuck = 25,
    WinPotions = {
        {
            Stat = "Luck",
            Seconds = 1800
        },
        {
            Stat = "Cash",
            Seconds = 900
        },
        {
            Stat = "Strength",
            Seconds = 900
        }
    }
}
t1.SubBoss = {
    Interval = 900,
    FirstDelay = 0,
    JoinTime = 45,
    IntroTime = 23,
    FightTime = 90,
    Hearts = 3,
    MaxFighters = 5,
    HealthPerPlayer = 15000,
    RecommendedRod = 23,
    HarpoonRange = 200,
    HarpoonGap = 0.8,
    LatchRadius = 34,
    BoostCooldown = 1.6,
    BoostSafe = 0.5
}
t1.FishPower = {
    10, 16, 26, 41, 66, 105, 168, 268,
    429, 687, 1100, 1759, 2815, 1100, 2057, 3851,
    7206, 13486, 25237, 47227, 88379, 165390, 309506
}
t1.RarityPower = 0.15
t1.LevelMerge = 3
t1.StrengthPerLevel = 5 * t1.LevelMerge
t1.XPScale = 1.25 * t1.XPGain
t1.XPEarly = {
    4, 4, 4, 4, 4, 4, 4, 4,
    4, 4, 5, 5, 5, 5, 5, 5,
    5, 6, 6, 6, 6, 6, 7, 7,
    7, 8, 9, 10, 11, 12, 13, 15
}
t1.XPGrowth = 1.4
t1.XPBase = t1.XPScale * t1.XPEarly[#t1.XPEarly] / (#t1.XPEarly) ^ t1.XPGrowth
t1.RepsPerLevel = 25
t1.RepsEarly = 4
t1.RepsFullTier = 7
t1.MinRepsPerLevel = 8
t1.LevelTierFit = {
    Tier = 4,
    Strength = 390,
    Log2PerTier = 0.55
}
t1.ThrowBase = 99
t1.ThrowPerStrength = 0.411
t1.ThrowExponent = 1.314
t1.MinCast = 18
t1.BiomeStart = {
    ["Backyard Pond"] = 0,
    ["Misty Lake"] = 100,
    ["Mangrove Swamp"] = 250,
    ["Sunny Shallows"] = 500,
    ["Coral Reef"] = 1000,
    ["Kelp Forest"] = 2000,
    ["Open Ocean"] = 4000,
    ["Frozen Sea"] = 8500,
    ["Abyss Trench"] = 18000,
    ["Volcanic Depths"] = 40000,
    ["Sunken Atlantis"] = 80000,
    ["Storm Sea"] = 170000,
    ["The Rift"] = 360000,
    ["Twilight Zone"] = 750000,
    ["Midnight Zone"] = 2100000,
    ["Lantern Caves"] = 4800000,
    ["Glass Sponge Reef"] = 1E+07,
    ["Brine Pools"] = 2.1E+07,
    ["Hydrothermal Vents"] = 4.5E+07,
    ["Whale Fall"] = 9.5E+07,
    ["Sunken Fleet"] = 2E+08,
    ["Hadal Trench"] = 4.2E+08,
    ["The Maw"] = 9E+08
}
t1.LastBiomeEnd = 1.9E+09
t1.BiomeLuck = {
    1, 1.15, 1.3, 1.5, 1.75, 2, 2.4, 2.8,
    3.3, 4, 4.8, 5.8, 7, 4.8, 6.2, 7.9,
    10, 12.8, 16.4, 21, 26.6, 33.9, 43
}
t1.Mutations = {
    {
        Name = "Rainbow",
        Percent = 0.5,
        Income = 20
    },
    {
        Name = "Ruby",
        Percent = 1,
        Income = 10
    },
    {
        Name = "Emerald",
        Percent = 2,
        Income = 5
    },
    {
        Name = "Diamond",
        Percent = 4,
        Income = 3
    },
    {
        Name = "Gold",
        Percent = 13,
        Income = 1.5
    },
    {
        Name = "Galaxy",
        Percent = 0,
        Income = 25
    },
    {
        Name = "Albino",
        Percent = 0,
        Income = 1.5
    }
}
t1.MutationLuckPower = 0.15
t1.MutationLuckCap = 2
t1.Sizes = {
    {
        Name = "Big",
        Percent = 15,
        Income = 1.5
    },
    {
        Name = "Large",
        Percent = 3.5,
        Income = 2.25
    },
    {
        Name = "Huge",
        Percent = 0.97,
        Income = 3.38
    },
    {
        Name = "Colossal",
        Percent = 0.31,
        Income = 5.06
    },
    {
        Name = "Gigantic",
        Percent = 0.12,
        Income = 7.59
    },
    {
        Name = "Titanic",
        Percent = 0.05,
        Income = 11.39
    },
    {
        Name = "Monstrous",
        Percent = 0.02,
        Income = 17.09
    },
    {
        Name = "Cosmic",
        Percent = 0.008,
        Income = 25.63
    },
    {
        Name = "Infinite",
        Percent = 0.005,
        Income = 38.44
    }
}
t1.SizeLuckPower = 0.08
t1.SizeLuckCap = 1.5
t1.SizeStepMax = 0.45
t1.NewSpeciesWeight = 1.5
t1.RecentWeight = { 0.35, 0.6, 0.85 }
t1.SellSeconds = 15
t1.Animals = {
    Minnow = {
        Income = 2,
        Chance = 23
    },
    Tadpole = {
        Income = 2,
        Chance = 23
    },
    Goldfish = {
        Income = 2,
        Chance = 23
    },
    PondSnail = {
        Income = 10,
        Chance = 12
    },
    Koi = {
        Income = 10,
        Chance = 12
    },
    Crayfish = {
        Income = 40,
        Chance = 2.75
    },
    PaintedTurtle = {
        Income = 40,
        Chance = 2.75
    },
    SnappingTurtle = {
        Income = 200,
        Chance = 1.5
    },
    Perch = {
        Income = 20,
        Chance = 30
    },
    Bass = {
        Income = 60,
        Chance = 18
    },
    RainbowTrout = {
        Income = 60,
        Chance = 18
    },
    Catfish = {
        Income = 200,
        Chance = 11
    },
    Pike = {
        Income = 200,
        Chance = 11
    },
    Paddlefish = {
        Income = 600,
        Chance = 5
    },
    GiantSturgeon = {
        Income = 600,
        Chance = 5
    },
    GhostPike = {
        Income = 6000,
        Chance = 2
    },
    Mudskipper = {
        Income = 200,
        Chance = 22
    },
    Archerfish = {
        Income = 600,
        Chance = 17
    },
    Piranha = {
        Income = 600,
        Chance = 17
    },
    ElectricEel = {
        Income = 2000,
        Chance = 13
    },
    AlligatorGar = {
        Income = 2000,
        Chance = 13
    },
    Arapaima = {
        Income = 6000,
        Chance = 8.5
    },
    Caiman = {
        Income = 6000,
        Chance = 8.5
    },
    SwampHydra = {
        Income = 2E+05,
        Chance = 1
    },
    HermitCrab = {
        Income = 6000,
        Chance = 22
    },
    SeaTurtle = {
        Income = 6000,
        Chance = 17
    },
    Stingray = {
        Income = 6000,
        Chance = 17
    },
    BlueLobster = {
        Income = 20000,
        Chance = 13
    },
    LemonShark = {
        Income = 20000,
        Chance = 13
    },
    DragonTurtle = {
        Income = 60000,
        Chance = 8.5
    },
    KrakenHatchling = {
        Income = 60000,
        Chance = 8.5
    },
    Archelon = {
        Income = 2E+06,
        Chance = 1
    },
    Pufferfish = {
        Income = 60000,
        Chance = 22
    },
    Lionfish = {
        Income = 60000,
        Chance = 17
    },
    MantaRay = {
        Income = 60000,
        Chance = 17
    },
    CoralWyrm = {
        Income = 2E+05,
        Chance = 13
    },
    PearlClam = {
        Income = 2E+05,
        Chance = 13
    },
    Helicoprion = {
        Income = 6E+05,
        Chance = 8.5
    },
    Ammonite = {
        Income = 6E+05,
        Chance = 8.5
    },
    StarlightManta = {
        Income = 2E+07,
        Chance = 1
    },
    GiantOctopus = {
        Income = 6E+05,
        Chance = 22
    },
    Kelpie = {
        Income = 6E+05,
        Chance = 17
    },
    LeafySeaDragon = {
        Income = 6E+05,
        Chance = 17
    },
    Plesiosaur = {
        Income = 2E+06,
        Chance = 13
    },
    Cameroceras = {
        Income = 2E+06,
        Chance = 13
    },
    ConstellationSeahorse = {
        Income = 6E+06,
        Chance = 8.5
    },
    MoonlightOtter = {
        Income = 6E+06,
        Chance = 8.5
    },
    NebulaOctopus = {
        Income = 1E+08,
        Chance = 1
    },
    SeaSerpent = {
        Income = 6E+06,
        Chance = 22
    },
    Megalodon = {
        Income = 6E+06,
        Chance = 17
    },
    Mosasaurus = {
        Income = 6E+06,
        Chance = 17
    },
    StarfallSwordfish = {
        Income = 2E+07,
        Chance = 13
    },
    CometDolphin = {
        Income = 2E+07,
        Chance = 13
    },
    GalaxyWhaleShark = {
        Income = 6E+07,
        Chance = 8.5
    },
    CosmicGreatWhite = {
        Income = 6E+07,
        Chance = 8.5
    },
    PrismHumpback = {
        Income = 1E+09,
        Chance = 1
    },
    AuroraSeal = {
        Income = 6E+07,
        Chance = 15
    },
    StarlitPenguin = {
        Income = 6E+07,
        Chance = 15
    },
    CometBeluga = {
        Income = 1E+08,
        Chance = 12.5
    },
    NebulaOrca = {
        Income = 1E+08,
        Chance = 12.5
    },
    CosmicWalrus = {
        Income = 1E+08,
        Chance = 12.5
    },
    CrystalNarwhal = {
        Income = 4E+08,
        Chance = 10
    },
    PrismJellyfish = {
        Income = 4E+08,
        Chance = 10
    },
    DiamondWalrus = {
        Income = 4E+08,
        Chance = 10
    },
    TitanOrca = {
        Income = 4E+10,
        Chance = 0.6
    },
    GlacierTurtle = {
        Income = 4E+10,
        Chance = 0.6
    },
    ColossalBlueWhale = {
        Income = 4E+10,
        Chance = 0.6
    },
    MammothWalrus = {
        Income = 4E+10,
        Chance = 0.6
    },
    GalaxyAnglerfish = {
        Income = 4E+08,
        Chance = 15
    },
    NebulaJellyfish = {
        Income = 4E+08,
        Chance = 15
    },
    PrismVampireSquid = {
        Income = 1E+09,
        Chance = 12.5
    },
    CrystalGulperEel = {
        Income = 1E+09,
        Chance = 12.5
    },
    PrismIsopod = {
        Income = 1E+09,
        Chance = 12.5
    },
    ColossalSquid = {
        Income = 4E+09,
        Chance = 10
    },
    TitanIsopod = {
        Income = 4E+09,
        Chance = 10
    },
    TitanOarfish = {
        Income = 4E+09,
        Chance = 10
    },
    VoidAngler = {
        Income = 4E+11,
        Chance = 0.6
    },
    ShadowShark = {
        Income = 4E+11,
        Chance = 0.6
    },
    AbyssalRay = {
        Income = 4E+11,
        Chance = 0.6
    },
    AbyssWatcher = {
        Income = 4E+11,
        Chance = 0.6
    },
    MagmaCrystalCrab = {
        Income = 4E+09,
        Chance = 15
    },
    PrismLavaEel = {
        Income = 4E+09,
        Chance = 15
    },
    VolcanoTurtle = {
        Income = 1E+10,
        Chance = 12.5
    },
    MoltenWhale = {
        Income = 1E+10,
        Chance = 12.5
    },
    ObsidianBehemoth = {
        Income = 1E+10,
        Chance = 12.5
    },
    CinderSquid = {
        Income = 4E+10,
        Chance = 10
    },
    SmokeShark = {
        Income = 4E+10,
        Chance = 10
    },
    EmberManta = {
        Income = 4E+10,
        Chance = 10
    },
    MagmaSerpent = {
        Income = 4E+12,
        Chance = 0.8
    },
    GoldenKoi = {
        Income = 4E+12,
        Chance = 0.8
    },
    EclipseWhale = {
        Income = 4E+12,
        Chance = 0.8
    },
    TitanTempleTurtle = {
        Income = 4E+10,
        Chance = 15
    },
    PlazaManta = {
        Income = 4E+10,
        Chance = 15
    },
    RuneEel = {
        Income = 1E+11,
        Chance = 12.5
    },
    ShadeSeahorse = {
        Income = 1E+11,
        Chance = 12.5
    },
    VoidPufferfish = {
        Income = 1E+11,
        Chance = 12.5
    },
    TridentSwordfish = {
        Income = 4E+11,
        Chance = 10
    },
    CrownCrab = {
        Income = 4E+11,
        Chance = 10
    },
    MarbleHydra = {
        Income = 4E+11,
        Chance = 10
    },
    RadiantDolphin = {
        Income = 4E+13,
        Chance = 0.6
    },
    RadiantKoi = {
        Income = 4E+13,
        Chance = 0.6
    },
    RadiantNarwhal = {
        Income = 4E+13,
        Chance = 0.6
    },
    RadiantHumpback = {
        Income = 4E+13,
        Chance = 0.6
    },
    SquallSquid = {
        Income = 4E+11,
        Chance = 15
    },
    VoidBarracuda = {
        Income = 4E+11,
        Chance = 15
    },
    StormKraken = {
        Income = 1E+12,
        Chance = 12.5
    },
    WhirlpoolSerpent = {
        Income = 1E+12,
        Chance = 12.5
    },
    LighthouseAngler = {
        Income = 1E+12,
        Chance = 12.5
    },
    RadiantStingray = {
        Income = 4E+12,
        Chance = 10
    },
    RadiantSeal = {
        Income = 4E+12,
        Chance = 10
    },
    RadiantOrca = {
        Income = 4E+12,
        Chance = 10
    },
    ThunderShark = {
        Income = 4E+13,
        Chance = 0.6
    },
    StormMegalodon = {
        Income = 4E+13,
        Chance = 0.6
    },
    LightningEel = {
        Income = 4E+13,
        Chance = 0.6
    },
    CloudWhale = {
        Income = 4E+13,
        Chance = 0.6
    },
    RiftWatcher = {
        Income = 4E+12,
        Chance = 15
    },
    MirrorKoi = {
        Income = 4E+12,
        Chance = 15
    },
    RadiantJellyfish = {
        Income = 1E+13,
        Chance = 12.5
    },
    RadiantSeaDragon = {
        Income = 1E+13,
        Chance = 12.5
    },
    RadiantMosasaurus = {
        Income = 1E+13,
        Chance = 12.5
    },
    TempestPlesiosaur = {
        Income = 4E+13,
        Chance = 10
    },
    TempestRay = {
        Income = 4E+13,
        Chance = 10
    },
    TempestIsopod = {
        Income = 4E+13,
        Chance = 10
    },
    GlitchedGreatWhite = {
        Income = 2E+14,
        Chance = 0.6
    },
    GlitchedOctopus = {
        Income = 2E+14,
        Chance = 0.6
    },
    GlitchedSnapper = {
        Income = 2E+14,
        Chance = 0.6
    },
    ErrorWhale = {
        Income = 2E+14,
        Chance = 0.6
    },
    Bristlemouth = {
        Income = 2E+14,
        Chance = 15
    },
    Hatchetfish = {
        Income = 2E+14,
        Chance = 15
    },
    Lanternfish = {
        Income = 2E+14,
        Chance = 15
    },
    Barreleye = {
        Income = 2E+14,
        Chance = 12.5
    },
    CockeyedSquid = {
        Income = 2E+14,
        Chance = 12.5
    },
    SpiderCrab = {
        Income = 2E+14,
        Chance = 12.5
    },
    FrilledShark = {
        Income = 4E+14,
        Chance = 10
    },
    GoblinShark = {
        Income = 4E+14,
        Chance = 10
    },
    Coelacanth = {
        Income = 4E+16,
        Chance = 0.6
    },
    Sunfish = {
        Income = 4E+16,
        Chance = 0.6
    },
    FireflySquid = {
        Income = 4E+14,
        Chance = 15
    },
    Viperfish = {
        Income = 4E+14,
        Chance = 15
    },
    Fangtooth = {
        Income = 4E+14,
        Chance = 15
    },
    StoplightLoosejaw = {
        Income = 1E+15,
        Chance = 12.5
    },
    Dragonfish = {
        Income = 1E+15,
        Chance = 12.5
    },
    BlackSwallower = {
        Income = 1E+15,
        Chance = 12.5
    },
    DumboOctopus = {
        Income = 4E+15,
        Chance = 10
    },
    SixgillShark = {
        Income = 4E+15,
        Chance = 10
    },
    ShroudRay = {
        Income = 4E+17,
        Chance = 0.6
    },
    GiantSiphonophore = {
        Income = 4E+17,
        Chance = 0.6
    },
    LampSnail = {
        Income = 4E+15,
        Chance = 15
    },
    FireBreathingShrimp = {
        Income = 4E+15,
        Chance = 15
    },
    YetiCrab = {
        Income = 1E+16,
        Chance = 12.5
    },
    Pyrosome = {
        Income = 1E+16,
        Chance = 12.5
    },
    CrownJellyfish = {
        Income = 1E+16,
        Chance = 12.5
    },
    StalactiteBatRay = {
        Income = 4E+16,
        Chance = 10
    },
    LumenNudibranch = {
        Income = 4E+18,
        Chance = 0.6
    },
    LumenMantisShrimp = {
        Income = 4E+18,
        Chance = 0.6
    },
    LumenMoray = {
        Income = 4E+18,
        Chance = 0.6
    },
    LumenCaveDragon = {
        Income = 4E+18,
        Chance = 0.6
    },
    SpotPrawn = {
        Income = 4E+16,
        Chance = 15
    },
    BasketStar = {
        Income = 4E+16,
        Chance = 15
    },
    SeaLily = {
        Income = 4E+16,
        Chance = 15
    },
    DecoratorCrab = {
        Income = 1E+17,
        Chance = 12.5
    },
    YelloweyeRockfish = {
        Income = 1E+17,
        Chance = 12.5
    },
    SailfinSculpin = {
        Income = 1E+17,
        Chance = 12.5
    },
    WolfEel = {
        Income = 4E+17,
        Chance = 10
    },
    SleeperShark = {
        Income = 4E+17,
        Chance = 10
    },
    PhantomLeafEel = {
        Income = 4E+19,
        Chance = 0.6
    },
    PhantomOctopus = {
        Income = 4E+19,
        Chance = 0.6
    },
    PhantomChimaera = {
        Income = 4E+19,
        Chance = 0.6
    },
    PhantomHammerhead = {
        Income = 4E+19,
        Chance = 0.6
    },
    SquatLobster = {
        Income = 4E+17,
        Chance = 15
    },
    IceWorm = {
        Income = 4E+17,
        Chance = 15
    },
    VeilCucumber = {
        Income = 4E+17,
        Chance = 15
    },
    SeaToad = {
        Income = 1E+18,
        Chance = 12.5
    },
    Hagfish = {
        Income = 1E+18,
        Chance = 12.5
    },
    TripodFish = {
        Income = 1E+18,
        Chance = 12.5
    },
    Lizardfish = {
        Income = 4E+18,
        Chance = 10
    },
    Brinewalker = {
        Income = 4E+18,
        Chance = 10
    },
    QuicksilverNautilus = {
        Income = 4E+20,
        Chance = 0.6
    },
    QuicksilverBlobfish = {
        Income = 4E+20,
        Chance = 0.6
    },
    QuicksilverMarlin = {
        Income = 4E+20,
        Chance = 0.6
    },
    QuicksilverSerpent = {
        Income = 4E+20,
        Chance = 0.6
    },
    VentShrimp = {
        Income = 4E+18,
        Chance = 15
    },
    ScalyFootSnail = {
        Income = 4E+18,
        Chance = 15
    },
    Eelpout = {
        Income = 4E+18,
        Chance = 15
    },
    Rattail = {
        Income = 1E+19,
        Chance = 12.5
    },
    GiantTubeWorm = {
        Income = 1E+19,
        Chance = 12.5
    },
    ChimneySalamander = {
        Income = 1E+19,
        Chance = 12.5
    },
    FurnaceSquid = {
        Income = 4E+19,
        Chance = 10
    },
    Dunkleosteus = {
        Income = 4E+19,
        Chance = 10
    },
    ThermalSeaScorpion = {
        Income = 4E+21,
        Chance = 0.6
    },
    ThermalSawfish = {
        Income = 4E+21,
        Chance = 0.6
    },
    ThermalTubeDragon = {
        Income = 4E+21,
        Chance = 0.6
    },
    ThermalBeakedWhale = {
        Income = 4E+21,
        Chance = 0.6
    },
    SkeletonShrimp = {
        Income = 4E+19,
        Chance = 15
    },
    BrittleStar = {
        Income = 4E+19,
        Chance = 15
    },
    SeaSpider = {
        Income = 4E+19,
        Chance = 15
    },
    RibCrawler = {
        Income = 1E+20,
        Chance = 12.5
    },
    WhaleboneWrasse = {
        Income = 1E+20,
        Chance = 12.5
    },
    AntlerSquid = {
        Income = 1E+20,
        Chance = 12.5
    },
    ElephantSeal = {
        Income = 4E+20,
        Chance = 10
    },
    MegamouthShark = {
        Income = 4E+20,
        Chance = 10
    },
    BonecrestMako = {
        Income = 4E+22,
        Chance = 0.6
    },
    BonecrestIchthyosaur = {
        Income = 4E+22,
        Chance = 0.6
    },
    BonecrestBasilosaurus = {
        Income = 4E+22,
        Chance = 0.6
    },
    BonecrestHumpback = {
        Income = 4E+22,
        Chance = 0.6
    },
    Cutlassfish = {
        Income = 4E+20,
        Chance = 15
    },
    PeriscopeEel = {
        Income = 4E+20,
        Chance = 15
    },
    CongerEel = {
        Income = 4E+20,
        Chance = 15
    },
    SeaMinePuffer = {
        Income = 1E+21,
        Chance = 12.5
    },
    DivingBellJelly = {
        Income = 1E+21,
        Chance = 12.5
    },
    WreckGrouper = {
        Income = 1E+21,
        Chance = 12.5
    },
    WreckOctopus = {
        Income = 4E+21,
        Chance = 10
    },
    TorpedoRay = {
        Income = 4E+21,
        Chance = 10
    },
    ThresherShark = {
        Income = 4E+21,
        Chance = 10
    },
    DreadnoughtLobster = {
        Income = 4E+23,
        Chance = 0.6
    },
    DreadnoughtTigerShark = {
        Income = 4E+23,
        Chance = 0.6
    },
    DreadnoughtManta = {
        Income = 4E+23,
        Chance = 0.6
    },
    DreadnoughtPliosaur = {
        Income = 4E+23,
        Chance = 0.6
    },
    DreadnoughtWhaleShark = {
        Income = 4E+23,
        Chance = 0.6
    },
    SupergiantAmphipod = {
        Income = 4E+21,
        Chance = 15
    },
    MarianaSnailfish = {
        Income = 4E+21,
        Chance = 15
    },
    CuskEel = {
        Income = 4E+21,
        Chance = 15
    },
    PancakeBatfish = {
        Income = 1E+22,
        Chance = 12.5
    },
    TrenchCrawler = {
        Income = 1E+22,
        Chance = 12.5
    },
    PressurePangolinFish = {
        Income = 1E+22,
        Chance = 12.5
    },
    BigfinSquid = {
        Income = 4E+22,
        Chance = 10
    },
    AnvilheadShark = {
        Income = 4E+22,
        Chance = 10
    },
    EchoWhale = {
        Income = 4E+22,
        Chance = 10
    },
    HadalStargazer = {
        Income = 8E+23,
        Chance = 0.6
    },
    HadalHorseshoeCrab = {
        Income = 8E+23,
        Chance = 0.6
    },
    HadalColossusCrab = {
        Income = 8E+23,
        Chance = 0.6
    },
    HadalTrenchWyrm = {
        Income = 8E+23,
        Chance = 0.6
    },
    HadalSpineWhale = {
        Income = 8E+23,
        Chance = 0.6
    },
    LumenCookiecutterShark = {
        Income = 4E+22,
        Chance = 15
    },
    PhantomOpah = {
        Income = 7E+22,
        Chance = 13
    },
    QuicksilverTarpon = {
        Income = 1E+23,
        Chance = 11
    },
    ThermalMegapiranha = {
        Income = 1.5E+23,
        Chance = 9
    },
    BonecrestLivyatan = {
        Income = 2.5E+23,
        Chance = 7
    },
    DreadnoughtBaskingShark = {
        Income = 4E+23,
        Chance = 5
    },
    AbyssMoth = {
        Income = 8E+23,
        Chance = 3
    },
    TidecallerCuttlefish = {
        Income = 8E+23,
        Chance = 3
    },
    HadalLionsMane = {
        Income = 8E+23,
        Chance = 3
    },
    HadalLeedsichthys = {
        Income = 8E+23,
        Chance = 3
    },
    GeodeWhale = {
        Income = 3E+24,
        Chance = 0.4
    },
    SandglassSerpent = {
        Income = 2E+24,
        Chance = 0.5
    },
    FathomDragon = {
        Income = 2E+24,
        Chance = 0.5
    },
    MawWarden = {
        Income = 2E+24,
        Chance = 0.5
    }
}
t1.OldCashScale = {
    5, 7, 10, 30, 100, 500, 1600, 4900,
    9000, 40000, 1E+05, 2E+05, 6E+05
}

return t1
