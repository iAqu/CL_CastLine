-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)

local function isEnabledByDefault() -- line: 11
    -- upvalues: RunService (copy), Environment (copy)
    return Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
end

local function isScheduledByDefault() -- line: 15
    -- upvalues: RunService (copy), Environment (copy)
    local v1 = Environment.IsDevPlace()
    local v2 = if not v1 then Environment.IsTestPlace() else nil

    if v1 or v2 then
        v2 = not RunService:IsStudio()
    end

    return v2
end

local t1 = {
    ContentEnabled = FastFlags.Replicated("Game.ScrambleBoss.ContentEnabled", Asserts.Boolean, Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()),
    BossMaxHealth = FastFlags.Replicated("Game.ScrambleBoss.BossMaxHealth", Asserts.FinitePositive, 9000),
    HealthPerExtraPlayer = FastFlags.Replicated("Game.ScrambleBoss.HealthPerExtraPlayer", Asserts.Range(0, 10), 0.45),
    PlayerHitDamage = FastFlags.Replicated("Game.ScrambleBoss.PlayerHitDamage", Asserts.FinitePositive, 60),
    OverheatDamageMultiplier = FastFlags.Replicated("Game.ScrambleBoss.OverheatDamageMultiplier", Asserts.Range(1, 20), 3),
    OverheatSeconds = FastFlags.Replicated("Game.ScrambleBoss.OverheatSeconds", Asserts.Range(2, 30), 8),
    PhaseTwoHealthFraction = FastFlags.Replicated("Game.ScrambleBoss.PhaseTwoHealthFraction", Asserts.Range(0.05, 0.95), 0.5),
    HazardDamage = FastFlags.Replicated("Game.ScrambleBoss.HazardDamage", Asserts.Range(0, 100), 8.333333333333334),
    CrocTargets = FastFlags.Replicated("Game.ScrambleBoss.CrocTargets", Asserts.IntegerRange(1, 10), 3),
    CrocChaseSeconds = FastFlags.Replicated("Game.ScrambleBoss.CrocChaseSeconds", Asserts.Range(1, 30), 6),
    DronesPerPlayer = FastFlags.Replicated("Game.ScrambleBoss.DronesPerPlayer", Asserts.IntegerRange(0, 10), 2),
    BallTargetSeconds = FastFlags.Replicated("Game.ScrambleBoss.BallTargetSeconds", Asserts.Range(1, 30), 5),
    BallSpeedFraction = FastFlags.Replicated("Game.ScrambleBoss.BallSpeedFraction", Asserts.Range(0.1, 3), 0.9),
    BallStunSeconds = FastFlags.Replicated("Game.ScrambleBoss.BallStunSeconds", Asserts.Range(1, 60), 30),
    GlassHitsPerPlayer = FastFlags.Replicated("Game.ScrambleBoss.GlassHitsPerPlayer", Asserts.IntegerRange(1, 100), 3),
    GlassCrashes = FastFlags.Replicated("Game.ScrambleBoss.GlassCrashes", Asserts.IntegerRange(1, 10), 3),
    HumanHits = FastFlags.Replicated("Game.ScrambleBoss.HumanHits", Asserts.IntegerRange(1, 10), 3),
    SamplesReward = FastFlags.Replicated("Game.ScrambleBoss.SamplesReward", Asserts.IntegerRange(0, 1E+06), 1750)
}
local Replicated = FastFlags.Replicated
local v3 = "Game.ScrambleBoss.ScheduleEnabled"
local Boolean = Asserts.Boolean
local v4 = Environment.IsDevPlace()
local v5 = if not v4 then Environment.IsTestPlace() else nil

if v4 or v5 then
    v5 = not RunService:IsStudio()
end

t1.ScheduleEnabled = Replicated(v3, Boolean, v5)
t1.ScheduleIntervalSeconds = FastFlags.Replicated("Game.ScrambleBoss.ScheduleIntervalSeconds", Asserts.IntegerRange(300, 86400), 1800)
t1.PortalSpawnFrom = FastFlags.Replicated("Game.ScrambleBoss.PortalSpawnFrom", Asserts.String, "Volcano")
t1.PortalSpawnTo = FastFlags.Replicated("Game.ScrambleBoss.PortalSpawnTo", Asserts.String, "Titan Temple")
t1.PortalIdleCloseSeconds = FastFlags.Replicated("Game.ScrambleBoss.PortalIdleCloseSeconds", Asserts.Range(30, 3600), 300)
t1.SamplesWalletId = FastFlags.Replicated("Game.ScrambleBoss.SamplesWalletId", Asserts.AllOf(Asserts.ASCIIRange(0, 64), Asserts.Pattern("^[%w_%-]*$")), "DrScrambleBoss")
t1.RemovalAt = FastFlags.Replicated("Game.ScrambleBoss.RemovalAt", Asserts.IntegerRange(0, 4102444800), 1791644400)

return table.freeze(t1)
