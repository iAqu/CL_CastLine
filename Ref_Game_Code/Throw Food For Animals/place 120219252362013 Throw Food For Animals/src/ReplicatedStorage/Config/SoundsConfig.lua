-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Library = {
        ButtonHover = {
            Id = 10066936758,
            Volume = 0.35,
            Pitch = { 1, 1.08 }
        },
        ButtonClick = {
            Id = 113397864512278,
            Volume = 0.55,
            Pitch = { 0.97, 1.03 }
        },
        PurchaseSuccess = {
            Id = 17403146731,
            Volume = 0.7
        },
        PurchaseFail = {
            Id = 9119144736,
            Volume = 0.6
        },
        Pop = {
            Id = 113397864512278,
            Volume = 0.45,
            Pitch = { 1.25, 1.45 }
        },
        Slide = {
            Id = 9126233950,
            Volume = 0.25,
            Pitch = { 1.35, 1.5 }
        },
        ThrowMeterTick = {
            Id = 137872392480008,
            Volume = 0.3
        },
        GroundSmash = {
            Id = 9118614058,
            Volume = 0.9,
            Pitch = { 0.9, 1 }
        },
        SpinWhoosh = {
            Id = 134012322,
            Volume = 0.7
        },
        ThrowWhoosh = {
            Id = 231731980,
            Volume = 0.85
        },
        ThrowImpact = {
            Id = 9118614058,
            Volume = 0.8,
            Pitch = { 0.75, 0.85 }
        },
        WindLoop = {
            Id = 3308152153,
            Volume = 0,
            Looped = true
        },
        LuckTick = {
            Id = 137872392480008,
            Volume = 0.3
        },
        LuckWhole = {
            Id = 113397864512278,
            Volume = 0.85,
            Pitch = 1.25
        },
        LandingHard = {
            Id = 9118614058,
            Volume = 1,
            Pitch = { 0.85, 0.95 }
        },
        CameraWhoosh = {
            Id = 9126233950,
            Volume = 0.6,
            Pitch = { 0.95, 1.05 }
        },
        FOVImpact = {
            Id = 9120705982,
            Volume = 0.8
        },
        BassHit = {
            Id = 139520673393967,
            Volume = 0.9
        },
        Riser = {
            Id = 101937236820642,
            Volume = 0.8
        },
        Footstep = {
            Id = 131412978408311,
            Volume = 0.6
        },
        WingFlap = {
            Id = 139887585493497,
            Volume = 0.6
        },
        SwimLoop = {
            Id = 95093076508975,
            Volume = 0.35,
            Looped = true,
            Pitch = 0.55
        },
        SlitherLoop = {
            Id = 135446324303740,
            Volume = 0.25,
            Looped = true,
            Pitch = 1.3
        },
        LetterTick = {
            Id = 137872392480008,
            Volume = 0.22
        },
        Reveal = {
            Id = 96102213526905,
            Volume = 0.8
        },
        RareReveal = {
            Id = 96102213526905,
            Volume = 1,
            Pitch = 0.8
        },
        LevelUp = {
            Id = 112485797063762,
            Volume = 0.9
        },
        MoneyReward = {
            Id = 79392333090964,
            Volume = 0.7,
            Pitch = { 0.95, 1.05 }
        },
        XpTick = {
            Id = 140323850218372,
            Volume = 0.25,
            Pitch = { 1.1, 1.3 }
        },
        TapBonusAppear = {
            Id = 113397864512278,
            Volume = 0.4,
            Pitch = { 1.6, 1.8 }
        },
        TapBonusClaim = {
            Id = 96102213526905,
            Volume = 0.75,
            Pitch = 1.35
        },
        TapBonusBurst = {
            Id = 9118614058,
            Volume = 0.6,
            Pitch = { 1.7, 1.9 }
        },
        TapBonusXp = {
            Id = 140323850218372,
            Volume = 0.4,
            Pitch = { 1.55, 1.7 }
        },
        ShopOpen = {
            Id = 9126233950,
            Volume = 0.35,
            Pitch = 1.25
        },
        ShopClose = {
            Id = 9126233950,
            Volume = 0.25,
            Pitch = 1.6
        },
        CardPop = {
            Id = 113397864512278,
            Volume = 0.22,
            Pitch = { 1.5, 1.7 }
        },
        Purchase = {
            Id = 17403146731,
            Volume = 0.8,
            Pitch = 1.05
        },
        RewardShine = {
            Id = 96102213526905,
            Volume = 0.75,
            Pitch = 1.15
        },
        CoinBurst = {
            Id = 79392333090964,
            Volume = 0.8,
            Pitch = { 1.05, 1.15 }
        },
        Announce = {
            Id = 112485797063762,
            Volume = 0.85,
            Pitch = 1.1
        },
        AnnounceBass = {
            Id = 139520673393967,
            Volume = 0.7,
            Pitch = 1.1
        },
        LuckUp = {
            Id = 101937236820642,
            Volume = 0.55,
            Pitch = 1.6
        },
        GiftChime = {
            Id = 112485797063762,
            Volume = 0.6,
            Pitch = 1.4
        },
        GiftSent = {
            Id = 17403146731,
            Volume = 0.8,
            Pitch = 1.2
        },
        Deny = {
            Id = 9119144736,
            Volume = 0.5,
            Pitch = 0.9
        },
        TimerTick = {
            Id = 137872392480008,
            Volume = 0.18,
            Pitch = 1.6
        },
        LuckyTick = {
            Id = 137872392480008,
            Volume = 0.32,
            Pitch = 1.1
        },
        LuckyDigit = {
            Id = 113397864512278,
            Volume = 0.7,
            Pitch = 1.2
        },
        LuckyTierUp = {
            Id = 112485797063762,
            Volume = 0.9,
            Pitch = 1.05
        },
        LuckyTierBass = {
            Id = 139520673393967,
            Volume = 0.85,
            Pitch = 1
        },
        LuckyHeartbeat = {
            Id = 139520673393967,
            Volume = 0.55,
            Pitch = 0.55
        },
        LuckyRiser = {
            Id = 101937236820642,
            Volume = 0.75,
            Pitch = 1.25
        },
        LuckySlam = {
            Id = 139520673393967,
            Volume = 1,
            Pitch = 0.8
        },
        LuckyBurst = {
            Id = 9118614058,
            Volume = 0.9,
            Pitch = { 0.7, 0.75 }
        },
        LuckyShine = {
            Id = 96102213526905,
            Volume = 1,
            Pitch = 1.25
        },
        LuckyAnnounce = {
            Id = 112485797063762,
            Volume = 0.7,
            Pitch = 1.2
        },
        SuperAppear = {
            Id = 113397864512278,
            Volume = 0.3,
            Pitch = { 1.55, 1.65 }
        },
        SuperRiser = {
            Id = 101937236820642,
            Volume = 0.8,
            Pitch = 1.5
        },
        SuperSlam = {
            Id = 139520673393967,
            Volume = 1,
            Pitch = 0.85
        },
        SuperChime = {
            Id = 112485797063762,
            Volume = 0.9,
            Pitch = 1.3
        },
        SuperShine = {
            Id = 96102213526905,
            Volume = 0.9,
            Pitch = 1.35
        },
        SuperBurst = {
            Id = 9118614058,
            Volume = 0.85,
            Pitch = { 0.65, 0.7 }
        },
        SuperWhoosh = {
            Id = 231731980,
            Volume = 1,
            Pitch = 0.8
        },
        EggLand = {
            Id = 9118614058,
            Volume = 0.5,
            Pitch = { 1.35, 1.45 }
        },
        EggWobble = {
            Id = 137872392480008,
            Volume = 0.35,
            Pitch = 1
        },
        EggCrack = {
            Id = 113397864512278,
            Volume = 0.6,
            Pitch = { 0.6, 0.7 }
        },
        EggRiser = {
            Id = 101937236820642,
            Volume = 0.7,
            Pitch = 1.15
        },
        EggBurst = {
            Id = 139520673393967,
            Volume = 1,
            Pitch = 0.95
        },
        EggPop = {
            Id = 9118614058,
            Volume = 0.7,
            Pitch = { 1.6, 1.8 }
        }
    }
}

function t1.Get(p1) -- line: 109
    -- upvalues: t1 (copy)
    return t1.Library[p1]
end

return t1
