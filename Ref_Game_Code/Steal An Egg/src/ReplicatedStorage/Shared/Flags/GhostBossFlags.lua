-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function isEnabledByDefault() -- line: 12
    -- upvalues: RunService (copy), Environment (copy)
    return Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
end

local function flag(p1, p2, p3) -- line: 16
    -- upvalues: FastFlags (copy)
    return FastFlags.Replicated(("Game.GhostBoss.%*"):format(p1), p2, p3)
end

local function oneOf(p4) -- line: 20
    return function(p5) -- line: 21
        -- upvalues: p4 (copy)
        if type(p5) ~= "string" then
            error("string", 2)
        end

        if table.find(p4, p5) == nil then
            error(("OneOf(%*)"):format((table.concat(p4, ","))), 2)
        end

        return p5
    end
end

local freeze = table.freeze
local Boolean = Asserts.Boolean
local v1 = Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
local t1 = {}

t1.Enabled = FastFlags.Replicated("Game.GhostBoss.Enabled", Boolean, v1)

local v2 = Asserts.Range(0, 1)

t1.SpawnChancePerCycle = FastFlags.Replicated("Game.GhostBoss.SpawnChancePerCycle", v2, 0.3)

local v3 = Asserts.IntegerRange(0, 20)

t1.MaxSpawnsPerEvent = FastFlags.Replicated("Game.GhostBoss.MaxSpawnsPerEvent", v3, 1)

local v4 = Asserts.Range(0, 240)

t1.SpawnDelayMinSeconds = FastFlags.Replicated("Game.GhostBoss.SpawnDelayMinSeconds", v4, 20)

local v5 = Asserts.Range(0, 240)

t1.SpawnDelayMaxSeconds = FastFlags.Replicated("Game.GhostBoss.SpawnDelayMaxSeconds", v5, 90)

local v6 = Asserts.Range(0, 2000)

t1.SpawnDistanceMinStuds = FastFlags.Replicated("Game.GhostBoss.SpawnDistanceMinStuds", v6, 140)

local v7 = Asserts.Range(0, 2000)

t1.SpawnDistanceMaxStuds = FastFlags.Replicated("Game.GhostBoss.SpawnDistanceMaxStuds", v7, 260)

local v8 = Asserts.Range(0, 500)

t1.SpawnLateralStuds = FastFlags.Replicated("Game.GhostBoss.SpawnLateralStuds", v8, 40)

local v9 = Asserts.Range(0.5, 10)

t1.SpawnSeconds = FastFlags.Replicated("Game.GhostBoss.SpawnSeconds", v9, 3)

local v10 = Asserts.Range(30, 900)

t1.LifetimeSeconds = FastFlags.Replicated("Game.GhostBoss.LifetimeSeconds", v10, 240)

local v11 = Asserts.Range(0.5, 8)

t1.CaptureSeconds = FastFlags.Replicated("Game.GhostBoss.CaptureSeconds", v11, 2.4)

local v12 = Asserts.IntegerRange(1, 1E+07)

t1.BaseHealth = FastFlags.Replicated("Game.GhostBoss.BaseHealth", v12, 300)

local v13 = Asserts.IntegerRange(0, 1E+07)

t1.HealthPerPlayer = FastFlags.Replicated("Game.GhostBoss.HealthPerPlayer", v13, 200)

local v14 = Asserts.Range(0.1, 1E+05)

t1.DamagePerSecond = FastFlags.Replicated("Game.GhostBoss.DamagePerSecond", v14, 10)

local v15 = Asserts.Range(0.01, 0.9)

t1.CaptureHealthFraction = FastFlags.Replicated("Game.GhostBoss.CaptureHealthFraction", v15, 0.15)

local v16 = Asserts.Range(1, 4)

t1.StartScale = FastFlags.Replicated("Game.GhostBoss.StartScale", v16, 2)

local v17 = Asserts.Range(0, 40)

t1.HoverStuds = FastFlags.Replicated("Game.GhostBoss.HoverStuds", v17, 5)

local v18 = Asserts.Range(0, 40)

t1.WanderStudsPerSecond = FastFlags.Replicated("Game.GhostBoss.WanderStudsPerSecond", v18, 6)

local v19 = Asserts.Range(0, 300)

t1.WanderRadiusStuds = FastFlags.Replicated("Game.GhostBoss.WanderRadiusStuds", v19, 50)

local v20 = Asserts.Range(0, 1)

t1.SuckedSpeedMultiplier = FastFlags.Replicated("Game.GhostBoss.SuckedSpeedMultiplier", v20, 0.25)

local v21 = Asserts.Range(0.5, 60)

t1.AttackMinSeconds = FastFlags.Replicated("Game.GhostBoss.AttackMinSeconds", v21, 4)

local v22 = Asserts.Range(0.5, 60)

t1.AttackMaxSeconds = FastFlags.Replicated("Game.GhostBoss.AttackMaxSeconds", v22, 7)

local v23 = Asserts.Range(0, 500)

t1.AttackRangeStuds = FastFlags.Replicated("Game.GhostBoss.AttackRangeStuds", v23, 60)

local v24 = Asserts.Range(0.1, 3)

t1.AttackWindupSeconds = FastFlags.Replicated("Game.GhostBoss.AttackWindupSeconds", v24, 0.6)

local v25 = Asserts.Range(1, 200)

t1.ChargeStudsPerSecond = FastFlags.Replicated("Game.GhostBoss.ChargeStudsPerSecond", v25, 45)

local v26 = Asserts.Range(0, 200)

t1.ChargeMaxStuds = FastFlags.Replicated("Game.GhostBoss.ChargeMaxStuds", v26, 30)

local v27 = Asserts.Range(0, 720)

t1.ChargeTurnDegreesPerSecond = FastFlags.Replicated("Game.GhostBoss.ChargeTurnDegreesPerSecond", v27, 60)

local v28 = Asserts.Range(1, 100)

t1.SwingReachStuds = FastFlags.Replicated("Game.GhostBoss.SwingReachStuds", v28, 9)

local v29 = Asserts.Range(10, 360)

t1.SwingConeDegrees = FastFlags.Replicated("Game.GhostBoss.SwingConeDegrees", v29, 140)

local v30 = Asserts.Range(0, 5)

t1.SwingRecoverSeconds = FastFlags.Replicated("Game.GhostBoss.SwingRecoverSeconds", v30, 0.8)

local v31 = Asserts.Range(0, 10)

t1.HitKnockbackMultiplier = FastFlags.Replicated("Game.GhostBoss.HitKnockbackMultiplier", v31, 2)

local v32 = Asserts.Range(0.2, 5)

t1.HitRagdollSeconds = FastFlags.Replicated("Game.GhostBoss.HitRagdollSeconds", v32, 1.2)

local v33 = Asserts.Range(5, 300)

t1.VacuumReachStuds = FastFlags.Replicated("Game.GhostBoss.VacuumReachStuds", v33, 45)

local v34 = Asserts.Range(10, 179)

t1.VacuumConeDegrees = FastFlags.Replicated("Game.GhostBoss.VacuumConeDegrees", v34, 120)

local v35 = Asserts.Range(0.3, 3)

t1.VacuumInputTimeoutSeconds = FastFlags.Replicated("Game.GhostBoss.VacuumInputTimeoutSeconds", v35, 0.8)

local v36 = Asserts.Range(50, 10000)

t1.EngageRadiusStuds = FastFlags.Replicated("Game.GhostBoss.EngageRadiusStuds", v36, 900)

local v37 = Asserts.IntegerRange(0, 1E+07)

t1.SoulPool = FastFlags.Replicated("Game.GhostBoss.SoulPool", v37, 3000)

local t2 = { "DamageContribution", "Equal" }

local function v38(p6) -- line: 21
    -- upvalues: t2 (copy)
    if type(p6) ~= "string" then
        error("string", 2)
    end

    if table.find(t2, p6) == nil then
        error(("OneOf(%*)"):format((table.concat(t2, ","))), 2)
    end

    return p6
end

t1.RewardDistribution = FastFlags.Replicated("Game.GhostBoss.RewardDistribution", v38, "DamageContribution")

local Boolean2 = Asserts.Boolean

t1.RewardOnDefeat = FastFlags.Replicated("Game.GhostBoss.RewardOnDefeat", Boolean2, true)

local v39 = Asserts.IntegerRange(1, 300)

t1.SoulOrbsMinimum = FastFlags.Replicated("Game.GhostBoss.SoulOrbsMinimum", v39, 40)

local v40 = Asserts.IntegerRange(1, 300)

t1.SoulOrbsMaximum = FastFlags.Replicated("Game.GhostBoss.SoulOrbsMaximum", v40, 150)

local v41 = Asserts.Range(1, 1E+06)

t1.SoulsPerOrb = FastFlags.Replicated("Game.GhostBoss.SoulsPerOrb", v41, 4)

local v42 = Asserts.Range(2, 120)

t1.SoulAutoCollectSeconds = FastFlags.Replicated("Game.GhostBoss.SoulAutoCollectSeconds", v42, 14)

local v43 = Asserts.Range(0.5, 40)

t1.SoulPickupRadiusStuds = FastFlags.Replicated("Game.GhostBoss.SoulPickupRadiusStuds", v43, 10)

return freeze(t1)
