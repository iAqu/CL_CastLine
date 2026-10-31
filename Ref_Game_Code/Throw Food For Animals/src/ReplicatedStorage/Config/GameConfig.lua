-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    MaxPlayers = 5,
    PlotCount = 5,
    DataStoreName = "Game",
    StudioDataStoreName = "",
    DevDataStoreName = "GameDev",
    AutoSaveInterval = 60,
    StartingMoney = 0,
    WalkSpeed = 20,
    StudioFreshSave = false,
    StudioCopyPlayer = {
        UserId = 0,
        Fresh = false
    },
    StudioNewAnimals = true,
    StudioServerKind = nil,
    Plot = {
        TrainingSpotOffset = Vector3.new(-16, 0.5, -30.5),
        PullUpBarOffset = Vector3.new(-16, 8.375, -30.5),
        UpgradeButtonOffset = Vector3.new(-16, 0.65, -39),
        ShopCircleOffset = Vector3.new(10.53, 0.51, -30.8),
        EntranceOffset = Vector3.new(0, 3.5, -5),
        TrainingExitOffset = Vector3.new(-9, 3.5, -30.5),
        FenceInnerMargin = 3,
        MaxPlacedAnimals = 10,
        GrownSizeSoftCap = 95,
        GrownSizeCurve = 0.3,
        HandFoodSize = 1.6,
        WanderSpeedFactor = 0.35,
        HandAnimalOffset = CFrame.new(0, -0.2, -0.9),
        WanderIdleTime = NumberRange.new(2, 5)
    },
    Music = {
        Folder = "Music",
        Fade = 0.4,
        FadeLobby = 0.9,
        Lobby = {
            Sound = "Music",
            Volume = 0.5,
            Resume = true
        },
        Throw = {
            Sound = "ThrowSequence",
            Volume = 0.7
        },
        POV = {
            Sound = "POV",
            Volume = 0.7
        }
    },
    Offline = {
        MinutesPerHour = 2,
        MaxHours = 48,
        MinSeconds = 60,
        ReminderHours = 12,
        ReminderFirst = 300,
        ReminderInterval = 300,
        ReminderLater = 600,
        ReminderSlowAfter = 3,
        ReminderShowTime = 15
    },
    Analytics = {
        Enabled = true,
        DebugInStudio = true,
        SessionMinutes = {
            1, 2, 3, 5, 10, 15, 20, 30,
            45, 60, 90, 120
        }
    },
    HUD = {
        ShowLevelPill = false,
        ShowTargetSelector = true,
        ShowIndexButton = true
    },
    Economy = {
        IncomeTickInterval = 1,
        SellMultiplier = 20,
        InventoryAnimalsGenerateIncome = false
    },
    Throw = {
        LaunchPosition = Vector3.new(0, 0, -45),
        MeterBonusStuds = 20,
        MeterBaseSpeed = 0.55,
        MeterTopSpeedFactor = 2.6,
        FirstThrowDistance = 55,
        BaseFlightTime = 1.6,
        FlightTimeExponent = 0.585,
        MaxFlightTime = 6,
        ApexHeightFactor = 0.25,
        ApexHeightMin = 12,
        ApexHeightMax = 60,
        LandingXSpread = 12,
        LandingEdgeMargin = 8,
        LineMargin = 4,
        Cooldown = 1.5,
        MeterRatings = {
            {
                Min = 0.92,
                Text = "PERFECT!",
                Color = Color3.fromRGB(120, 255, 120)
            },
            {
                Min = 0.72,
                Text = "GREAT!",
                Color = Color3.fromRGB(190, 255, 90)
            },
            {
                Min = 0.45,
                Text = "GOOD",
                Color = Color3.fromRGB(255, 220, 80)
            },
            {
                Min = 0,
                Text = "BAD",
                Color = Color3.fromRGB(255, 90, 90)
            }
        }
    },
    Luck = {
        StepSound = 0.1,
        WholeSound = 1
    },
    Sequence = {
        FadeIn = 0.35,
        FadeOut = 0.3,
        POVDuration = 5,
        RevealZoomNormal = 0.9,
        RevealZoomDramatic = 2.2,
        DramaticRarityIndex = 5,
        ShowTimeNormal = 5,
        ShowTimeShort = 3,
        ShortRarityIndex = 2,
        SkipAfterRevealDelay = 1
    },
    POVTest = {
        Enabled = true,
        StudioForce = nil,
        Variants = {
            {
                Key = "A",
                Name = "A - normal POV",
                Weight = 75
            },
            {
                Key = "B",
                Name = "B - 3s POV",
                Weight = 12.5,
                Duration = 3
            },
            {
                Key = "C",
                Name = "C - 2s POV",
                Weight = 12.5,
                Duration = 2
            }
        }
    },
    Training = {
        RepInterval = 0.5,
        KeepHandsOnBar = true,
        RigBodyOffset = Vector3.new(0, 0, 0.35),
        TapBonus = {
            Image = "",
            MinDelay = 4,
            MaxDelay = 6,
            Lifetime = 5,
            ExtraReps = 1,
            SpreadX = 0.2,
            SpreadY = 0.16,
            Size = 0.2,
            Color = Color3.fromRGB(196, 72, 255)
        }
    },
    LuckyCatch = {
        MaxChance = 0.05,
        AnnounceBelow = 0.005,
        AllServers = false,
        Exponent = 2,
        POVShare = 0.35,
        Pause = 0.9,
        ExtraZoom = 3,
        ShowTimeBonus = 2,
        ContinueDelay = 2.5,
        Tiers = {
            {
                Name = "LUCKY!",
                Chance = 0.05,
                Colors = {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(255, 160, 20)
                }
            },
            {
                Name = "SUPER LUCKY!",
                Chance = 0.02,
                Colors = {
                    Color3.fromRGB(255, 0, 111),
                    Color3.fromRGB(255, 0, 4)
                }
            },
            {
                Name = "INSANE LUCK!",
                Chance = 0.01,
                Colors = {
                    Color3.fromRGB(0, 195, 255),
                    Color3.fromRGB(0, 255, 0)
                }
            },
            {
                Name = "LEGENDARY LUCK!!",
                Chance = 0.002,
                Rainbow = true,
                Colors = {
                    Color3.fromRGB(255, 94, 0),
                    Color3.fromRGB(191, 0, 255)
                }
            },
            {
                Name = "GODLY LUCK!!!",
                Chance = 2E-04,
                Rainbow = true,
                Colors = {
                    Color3.fromRGB(102, 0, 255),
                    Color3.fromRGB(255, 72, 0)
                }
            },
            {
                Name = "IMPOSSIBLE!!!",
                Chance = 1E-05,
                Rainbow = true,
                Colors = {
                    Color3.fromRGB(0, 0, 0),
                    Color3.fromRGB(255, 255, 255)
                }
            }
        }
    },
    Leaderboards = {
        Rows = 10,
        RefreshInterval = 60,
        LiveInterval = 10,
        SaveInterval = 120,
        StoreVersion = "v1"
    }
}
