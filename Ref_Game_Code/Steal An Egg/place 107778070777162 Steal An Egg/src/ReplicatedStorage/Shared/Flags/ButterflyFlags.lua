-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function chance(p1, p2) -- line: 8
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.Butterflies.%*"):format(p1), Asserts.Range(0, 1), p2)
end

local function whole(p3, p4) -- line: 12
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.Butterflies.%*"):format(p3), Asserts.IntegerNonNegative, p4)
end

local function seconds(p5, p6) -- line: 16
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.Butterflies.%*"):format(p5), Asserts.FinitePositive, p6)
end

return table.freeze({
    Enabled = FastFlags.Replicated("Game.Butterflies.Enabled", Asserts.Boolean, false),
    GapMinSeconds = FastFlags.Replicated("Game.Butterflies.GapMinSeconds", Asserts.FinitePositive, 5400),
    GapMaxSeconds = FastFlags.Replicated("Game.Butterflies.GapMaxSeconds", Asserts.FinitePositive, 10800),
    DurationSeconds = FastFlags.Replicated("Game.Butterflies.DurationSeconds", Asserts.FinitePositive, 300),
    MaxActive = FastFlags.Replicated("Game.Butterflies.MaxActive", Asserts.IntegerNonNegative, 36),
    SpawnDelayMin = FastFlags.Replicated("Game.Butterflies.SpawnDelayMin", Asserts.FinitePositive, 0.5),
    SpawnDelayMax = FastFlags.Replicated("Game.Butterflies.SpawnDelayMax", Asserts.FinitePositive, 1),
    LifetimeSeconds = FastFlags.Replicated("Game.Butterflies.LifetimeSeconds", Asserts.FinitePositive, 75),
    NetReach = FastFlags.Replicated("Game.Butterflies.NetReach", Asserts.FinitePositive, 14),
    SwingCooldownSeconds = FastFlags.Replicated("Game.Butterflies.SwingCooldownSeconds", Asserts.FinitePositive, 0.45),
    AutoSwing = FastFlags.Replicated("Game.Butterflies.AutoSwing", Asserts.Boolean, true),
    AutoSwingCooldownSeconds = FastFlags.Replicated("Game.Butterflies.AutoSwingCooldownSeconds", Asserts.FinitePositive, 0.6),
    DodgeRadius = FastFlags.Replicated("Game.Butterflies.DodgeRadius", Asserts.FinitePositive, 9),
    DodgeCooldownSeconds = FastFlags.Replicated("Game.Butterflies.DodgeCooldownSeconds", Asserts.FinitePositive, 3),
    EscapeDistanceMin = FastFlags.Replicated("Game.Butterflies.EscapeDistanceMin", Asserts.FinitePositive, 15),
    EscapeDistanceMax = FastFlags.Replicated("Game.Butterflies.EscapeDistanceMax", Asserts.FinitePositive, 20),
    GreenCruiseSpeed = FastFlags.Replicated("Game.Butterflies.GreenCruiseSpeed", Asserts.FinitePositive, 120),
    BlueCruiseSpeed = FastFlags.Replicated("Game.Butterflies.BlueCruiseSpeed", Asserts.FinitePositive, 150),
    PurpleCruiseSpeed = FastFlags.Replicated("Game.Butterflies.PurpleCruiseSpeed", Asserts.FinitePositive, 180),
    GoldenCruiseSpeed = FastFlags.Replicated("Game.Butterflies.GoldenCruiseSpeed", Asserts.FinitePositive, 220),
    GreenWeight = FastFlags.Replicated("Game.Butterflies.GreenWeight", Asserts.IntegerNonNegative, 62),
    BlueWeight = FastFlags.Replicated("Game.Butterflies.BlueWeight", Asserts.IntegerNonNegative, 28),
    PurpleWeight = FastFlags.Replicated("Game.Butterflies.PurpleWeight", Asserts.IntegerNonNegative, 11),
    GoldenWeight = FastFlags.Replicated("Game.Butterflies.GoldenWeight", Asserts.IntegerNonNegative, 0),
    MaxGolden = FastFlags.Replicated("Game.Butterflies.MaxGolden", Asserts.IntegerNonNegative, 1),
    GoldenSpawnChancePerEvent = FastFlags.Replicated("Game.Butterflies.GoldenSpawnChancePerEvent", Asserts.Range(0, 1), 0.5),
    GreenCatchChance = FastFlags.Replicated("Game.Butterflies.GreenCatchChance", Asserts.Range(0, 1), 1),
    BlueCatchChance = FastFlags.Replicated("Game.Butterflies.BlueCatchChance", Asserts.Range(0, 1), 0.75),
    PurpleCatchChance = FastFlags.Replicated("Game.Butterflies.PurpleCatchChance", Asserts.Range(0, 1), 0.45),
    GoldenCatchChance = FastFlags.Replicated("Game.Butterflies.GoldenCatchChance", Asserts.Range(0, 1), 0.25),
    GreenToBlueCost = FastFlags.Replicated("Game.Butterflies.GreenToBlueCost", Asserts.IntegerNonNegative, 10),
    BlueToPurpleCost = FastFlags.Replicated("Game.Butterflies.BlueToPurpleCost", Asserts.IntegerNonNegative, 10),
    PurpleToGoldenCost = FastFlags.Replicated("Game.Butterflies.PurpleToGoldenCost", Asserts.IntegerNonNegative, 50),
    EssenceGreen = FastFlags.Replicated("Game.Butterflies.EssenceGreen", Asserts.IntegerNonNegative, 240),
    EssenceBlue = FastFlags.Replicated("Game.Butterflies.EssenceBlue", Asserts.IntegerNonNegative, 115),
    EssencePurple = FastFlags.Replicated("Game.Butterflies.EssencePurple", Asserts.IntegerNonNegative, 40),
    EssenceGolden = FastFlags.Replicated("Game.Butterflies.EssenceGolden", Asserts.IntegerNonNegative, 1)
})
