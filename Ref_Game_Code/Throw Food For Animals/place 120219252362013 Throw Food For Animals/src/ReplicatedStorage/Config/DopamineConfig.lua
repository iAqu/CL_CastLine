-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Enabled = true,
    TestSplit = false,
    LateFade = {
        Enabled = true,
        Share = 0.75,
        StudioForce = nil,
        From = {
            Area = "AncientRuins",
            Depth = 0.5
        },
        To = {
            Area = "MythicalParadise",
            Depth = 0.5
        },
        TagFrom = {
            Area = "AncientRuins",
            Depth = 0
        }
    },
    Start = 50,
    FadeTime = 180,
    Points = {
        NewAnimal = 30,
        NewSubArea = 15,
        BestSize = 7,
        Purchase = 6,
        HatchShare = 0.5,
        Lucky = { 16, 22, 28, 36, 44, 52 },
        BetterMutation = {
            Gold = 10,
            Diamond = 14,
            Emerald = 18,
            Ruby = 24,
            Rainbow = 32
        }
    },
    Habituation = 0.45,
    HabituationHalfLife = 240,
    SkipPenalty = 8,
    SkipPenaltyStreak = 4,
    AssistFrom = 38,
    GuaranteeAt = 8,
    Curve = 1.5,
    MaxSkipsInARow = 2,
    Upgrades = {
        BetterMutation = true,
        BestSize = true,
        Lucky = {
            {
                Mutation = false,
                SizeSteps = 2
            },
            {
                Mutation = "Gold",
                SizeSteps = 1
            },
            {
                Mutation = "Diamond",
                SizeSteps = 0
            }
        }
    },
    Debug = false
}
