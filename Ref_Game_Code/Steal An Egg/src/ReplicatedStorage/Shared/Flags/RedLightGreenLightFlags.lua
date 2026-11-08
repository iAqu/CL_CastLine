-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function positive(p1, p2) -- line: 8
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.RedLightGreenLight.%*"):format(p1), Asserts.FinitePositive, p2)
end

local function chance(p3, p4) -- line: 12
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.RedLightGreenLight.%*"):format(p3), Asserts.Range(0, 1), p4)
end

local function whole(p5, p6) -- line: 16
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(("Game.RedLightGreenLight.%*"):format(p5), Asserts.IntegerNonNegative, p6)
end

return table.freeze({
    GreenMinSeconds = FastFlags.Replicated("Game.RedLightGreenLight.GreenMinSeconds", Asserts.FinitePositive, 1.4),
    GreenMaxSeconds = FastFlags.Replicated("Game.RedLightGreenLight.GreenMaxSeconds", Asserts.FinitePositive, 4.2),
    RedMinSeconds = FastFlags.Replicated("Game.RedLightGreenLight.RedMinSeconds", Asserts.FinitePositive, 2.6),
    RedMaxSeconds = FastFlags.Replicated("Game.RedLightGreenLight.RedMaxSeconds", Asserts.FinitePositive, 4.4),
    TurnSeconds = FastFlags.Replicated("Game.RedLightGreenLight.TurnSeconds", Asserts.FinitePositive, 0.35),
    GraceSeconds = FastFlags.Replicated("Game.RedLightGreenLight.GraceSeconds", Asserts.FinitePositive, 0.85),
    PingAllowanceMaxSeconds = FastFlags.Replicated("Game.RedLightGreenLight.PingAllowanceMaxSeconds", Asserts.FinitePositive, 0.3),
    MoveToleranceStuds = FastFlags.Replicated("Game.RedLightGreenLight.MoveToleranceStuds", Asserts.FinitePositive, 5),
    FakeTurnChance = FastFlags.Replicated("Game.RedLightGreenLight.FakeTurnChance", Asserts.Range(0, 1), 0.3),
    Lives = FastFlags.Replicated("Game.RedLightGreenLight.Lives", Asserts.IntegerNonNegative, 2),
    LaserDelaySeconds = FastFlags.Replicated("Game.RedLightGreenLight.LaserDelaySeconds", Asserts.FinitePositive, 0.55),
    KnockbackSpeed = FastFlags.Replicated("Game.RedLightGreenLight.KnockbackSpeed", Asserts.FinitePositive, 140),
    KnockbackLift = FastFlags.Replicated("Game.RedLightGreenLight.KnockbackLift", Asserts.FinitePositive, 85),
    RagdollSeconds = FastFlags.Replicated("Game.RedLightGreenLight.RagdollSeconds", Asserts.FinitePositive, 1.6),
    CarrierSpeedMalus = FastFlags.Replicated("Game.RedLightGreenLight.CarrierSpeedMalus", Asserts.Range(-0.95, 0), -0.5),
    EggScale = FastFlags.Replicated("Game.RedLightGreenLight.EggScale", Asserts.FinitePositive, 2),
    RewardScale = FastFlags.Replicated("Game.RedLightGreenLight.RewardScale", Asserts.FinitePositive, 1),
    EggZonesAfter = FastFlags.Replicated("Game.RedLightGreenLight.EggZonesAfter", Asserts.String, "Volcano")
})
