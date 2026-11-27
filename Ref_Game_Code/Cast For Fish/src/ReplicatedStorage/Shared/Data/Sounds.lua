-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    List = {
        Click = {
            id = 15675059323,
            volume = 0.45,
            vary = 0.04
        },
        Hover = {
            id = 139800881181209,
            volume = 0.18,
            vary = 0.05
        },
        WindowOpen = {
            id = 106984966606682,
            volume = 0.5,
            pitch = 0.9
        },
        WindowClose = {
            id = 106984966606682,
            volume = 0.35,
            pitch = 0.7
        },
        ToastSuccess = {
            id = 130378474223829,
            volume = 0.4,
            pitch = 1.1
        },
        ToastGold = {
            id = 134810204798705,
            volume = 0.5
        },
        ToastError = {
            id = 91501650514390,
            volume = 0.4
        },
        ToastInfo = {
            id = 106984966606682,
            volume = 0.4,
            pitch = 1.2
        },
        Cash = {
            id = 134810204798705,
            volume = 0.5,
            vary = 0.04
        },
        Coin = {
            id = 130378474223829,
            volume = 0.12,
            vary = 0.1
        },
        Unlock = {
            id = 106879573498735,
            volume = 0.55
        },
        TutorialStep = {
            id = 106879573498735,
            volume = 0.4,
            pitch = 1.25
        },
        MeterShow = {
            id = 106984966606682,
            volume = 0.35,
            pitch = 1.1
        },
        MeterTick = {
            id = 88442833509532,
            volume = 0.14
        },
        MeterLock = {
            id = 15675059323,
            volume = 0.7,
            pitch = 0.8
        },
        MeterPerfect = {
            id = 4612374495,
            volume = 0.7
        },
        CastWindup = {
            id = 123796710194563,
            volume = 0.35,
            pitch = 0.7
        },
        CastRelease = {
            id = 138890894929151,
            volume = 0.9,
            vary = 0.05
        },
        Flight = {
            id = 127183292018512,
            volume = 0.35
        },
        LuckTick = {
            id = 88442833509532,
            volume = 0.16
        },
        ZoneChange = {
            id = 106984966606682,
            volume = 0.5,
            pitch = 1.4
        },
        Splash = {
            id = 9125703162,
            volume = 0.95,
            pitch = 0.85,
            vary = 0.05
        },
        PovStart = {
            id = 9112889917,
            volume = 0.5,
            loop = true
        },
        PovPulse = {
            id = 106984966606682,
            volume = 0.16,
            pitch = 0.4
        },
        CloseUp = {
            id = 123796710194563,
            volume = 0.5,
            pitch = 1.2
        },
        LetterPop = {
            id = 109359226723492,
            volume = 0.45
        },
        Riser = {
            id = 94077390731779,
            volume = 0.5,
            pitch = 2.05
        },
        Reveal = {
            id = 4612374495,
            volume = 0.7
        },
        RevealGood = {
            id = 134821092416328,
            volume = 0.75
        },
        RevealRare = {
            id = 81614326929268,
            volume = 0.8
        },
        Continue = {
            id = 15675059323,
            volume = 0.45
        },
        EggStart = {
            id = 106879573498735,
            volume = 0.5,
            pitch = 0.85
        },
        EggRise = {
            id = 94077390731779,
            volume = 0.55,
            pitch = 0.82
        },
        EggShake = {
            id = 106984966606682,
            volume = 0.3
        },
        EggCrack = {
            id = 109359226723492,
            volume = 0.65,
            pitch = 0.7
        },
        EggBurst = {
            id = 138890894929151,
            volume = 0.9,
            pitch = 0.8
        },
        EggShine = {
            id = 4612374495,
            volume = 0.75
        },
        TrainStart = {
            id = 106984966606682,
            volume = 0.45
        },
        Rep1 = {
            id = 88442833509532,
            volume = 0.3,
            pitch = 1,
            vary = 0.03
        },
        Rep2 = {
            id = 88442833509532,
            volume = 0.3,
            pitch = 1.2,
            vary = 0.03
        },
        LevelUp = {
            id = 112485797063762,
            volume = 0.55
        },
        Music = {
            id = 1845913205,
            volume = 0.16,
            loop = true,
            group = "music"
        },
        Waves = {
            id = 93281700241946,
            volume = 0.3,
            loop = true,
            group = "ambience"
        },
        EventStart = {
            id = 9125585534,
            volume = 0.55
        },
        EventMutate = {
            id = 4612374495,
            volume = 0.75,
            pitch = 1.25
        },
        Thunder = {
            id = 135035379441832,
            volume = 0.7,
            vary = 0.12,
            group = "ambience"
        },
        AmbRain = {
            id = 5911952995,
            volume = 0.32,
            loop = true,
            group = "ambience"
        },
        AmbWind = {
            id = 9113286969,
            volume = 0.3,
            pitch = 0.92,
            loop = true,
            group = "ambience"
        },
        AmbShimmer = {
            id = 1845406056,
            volume = 0.3,
            loop = true,
            group = "ambience"
        },
        AmbLava = {
            id = 9112823199,
            volume = 0.4,
            loop = true,
            group = "ambience"
        },
        AmbGrowl = {
            id = 9112863181,
            volume = 0.4,
            loop = true,
            group = "ambience"
        }
    },
    EventLoop = {
        rain = "AmbRain",
        snow = "AmbWind",
        storm = "AmbRain",
        aurora = "AmbShimmer",
        meteor = "AmbLava",
        bloodmoon = "AmbGrowl",
        eclipse = "AmbGrowl",
        meteorstrike = "AmbLava",
        lightningrodeo = "AmbRain"
    }
}

t1.List.StingHit = {
    id = 1844539433,
    volume = 0.6
}
t1.List.StingSweep = {
    id = 1844645996,
    volume = 0.55
}
t1.List.StingChoir = {
    id = 87681931953984,
    volume = 0.6
}
t1.List.DeepRumble = {
    id = 9118748998,
    volume = 0.7
}
t1.List.DeepWhoosh = {
    id = 9125357797,
    volume = 0.6
}
t1.List.GlassBoom = {
    id = 9114588782,
    volume = 0.85
}
t1.List.BiteHit = {
    id = 86422018798772,
    volume = 0.7
}
t1.List.Twinkle = {
    id = 135385970610304,
    volume = 0.5
}
t1.List.WindChime = {
    id = 124113820339492,
    volume = 0.5
}
t1.List.Coins = {
    id = 133570405319995,
    volume = 0.6
}
t1.List.Reel = {
    id = 79404754846319,
    volume = 0.3,
    loop = true
}
t1.List.ReelBurst = {
    id = 79404754846319,
    volume = 0.5
}
t1.List.Heartbeat = {
    id = 9043365842,
    volume = 0.75,
    loop = true
}
t1.List.DrumRoll = {
    id = 1848358941,
    volume = 0.5,
    loop = true
}
t1.List.TensionRiser = {
    id = 1843490542,
    volume = 0.55,
    held = true
}
t1.List.NoiseBuild = {
    id = 1837834284,
    volume = 0.6,
    held = true
}
t1.List.ReverseSwell = {
    id = 1843029045,
    volume = 0.6,
    held = true
}
t1.List.WaterSurge = {
    id = 1841351295,
    volume = 0.6,
    held = true
}
t1.List.SubBoom = {
    id = 9043341776,
    volume = 0.9
}
t1.List.SonicBoom = {
    id = 9120769331,
    volume = 0.55
}
t1.List.Braam = {
    id = 131557850414701,
    volume = 0.6
}
t1.List.BraamCosmic = {
    id = 140528689236462,
    volume = 0.6
}
t1.List.OmenHit = {
    id = 9046338796,
    volume = 0.6
}
t1.List.DeepRoar = {
    id = 9113972148,
    volume = 0.8,
    pitch = 0.5
}
t1.List.Zap = {
    id = 9114277757,
    volume = 0.35,
    vary = 0.25
}

return t1
