-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function flag(p1, p2, p3) -- line: 6
    -- upvalues: FastFlags (copy)
    return FastFlags.Replicated(("Game.TrainEvent.%*"):format(p1), p2, p3)
end

local function seconds(p4, p5) -- line: 9
    -- upvalues: Asserts (copy), flag (copy)
    return flag(p4, Asserts.FinitePositive, p5)
end

local function whole(p6, p7) -- line: 12
    -- upvalues: Asserts (copy), flag (copy)
    return flag(p6, Asserts.IntegerNonNegative, p7)
end

local freeze = table.freeze
local v1 = Asserts.Range(10, 60)
local t1 = {}

t1.ReturnRecoverySeconds = FastFlags.Replicated("Game.TrainEvent.ReturnRecoverySeconds", v1, 30)

local v2 = Asserts.Range(2, 12)

t1.TravelReadySeconds = FastFlags.Replicated("Game.TrainEvent.TravelReadySeconds", v2, 6)

local v3 = Asserts.Range(1, 8)

t1.TravelSettleSeconds = FastFlags.Replicated("Game.TrainEvent.TravelSettleSeconds", v3, 4)

local v4 = Asserts.Range(1, 3)

t1.ReturnAttemptLimit = FastFlags.Replicated("Game.TrainEvent.ReturnAttemptLimit", v4, 2)

local v5 = Asserts.Range(1, 4)

t1.DeathTransitionDelaySeconds = FastFlags.Replicated("Game.TrainEvent.DeathTransitionDelaySeconds", v5, 2)

local v6 = Asserts.Range(5, 60)

t1.TrainSpeedStuds = FastFlags.Replicated("Game.TrainEvent.TrainSpeedStuds", v6, 45)

local v7 = Asserts.Range(0, 1)

t1.VacuumSafeCaptureProgress = FastFlags.Replicated("Game.TrainEvent.VacuumSafeCaptureProgress", v7, 0.5)

local v8 = Asserts.Range(0.25, 4)

t1.VacuumCaptureRate = FastFlags.Replicated("Game.TrainEvent.VacuumCaptureRate", v8, 1.23)

local v9 = Asserts.Range(0, 8)

t1.VacuumCloseRangeStuds = FastFlags.Replicated("Game.TrainEvent.VacuumCloseRangeStuds", v9, 5)

local v10 = Asserts.Range(1, 12)

t1.VacuumVerticalToleranceStuds = FastFlags.Replicated("Game.TrainEvent.VacuumVerticalToleranceStuds", v10, 6)

local FinitePositive = Asserts.FinitePositive

t1.VacuumPullSpeedStuds = FastFlags.Replicated("Game.TrainEvent.VacuumPullSpeedStuds", FinitePositive, 12)

local FinitePositive2 = Asserts.FinitePositive

t1.VacuumBackpackHeightStuds = FastFlags.Replicated("Game.TrainEvent.VacuumBackpackHeightStuds", FinitePositive2, 1.8)

local v11 = Asserts.Range(0.75, 2)

t1.TravelCoverSeconds = FastFlags.Replicated("Game.TrainEvent.TravelCoverSeconds", v11, 0.75)

local v12 = Asserts.Range(0.05, 0.3)

t1.GhostSnapshotSeconds = FastFlags.Replicated("Game.TrainEvent.GhostSnapshotSeconds", v12, 0.075)

local v13 = Asserts.Range(0.05, 0.4)

t1.GhostInterpolationSeconds = FastFlags.Replicated("Game.TrainEvent.GhostInterpolationSeconds", v13, 0.16)

local v14 = Asserts.Range(0.5, 3)

t1.GhostSizeMultiplier = FastFlags.Replicated("Game.TrainEvent.GhostSizeMultiplier", v14, 1.35)

local v15 = Asserts.Range(0.1, 3)

t1.GhostRecoverySeconds = FastFlags.Replicated("Game.TrainEvent.GhostRecoverySeconds", v15, 0.65)

local v16 = Asserts.Range(0.2, 3)

t1.GhostFadeSeconds = FastFlags.Replicated("Game.TrainEvent.GhostFadeSeconds", v16, 0.75)

local IntegerNonNegative = Asserts.IntegerNonNegative

t1.MaxActiveGhosts = FastFlags.Replicated("Game.TrainEvent.MaxActiveGhosts", IntegerNonNegative, 3)

local v17 = Asserts.IntegerRange(0, 500)

t1.MaxActiveGhostsServer = FastFlags.Replicated("Game.TrainEvent.MaxActiveGhostsServer", v17, 30)

local v18 = Asserts.Range(0, 60)

t1.GhostSpawnDelayMin = FastFlags.Replicated("Game.TrainEvent.GhostSpawnDelayMin", v18, 0.5)

local v19 = Asserts.Range(0, 60)

t1.GhostSpawnDelayMax = FastFlags.Replicated("Game.TrainEvent.GhostSpawnDelayMax", v19, 1.5)

local FinitePositive3 = Asserts.FinitePositive

t1.VacuumInputTimeoutSeconds = FastFlags.Replicated("Game.TrainEvent.VacuumInputTimeoutSeconds", FinitePositive3, 0.8)

local FinitePositive4 = Asserts.FinitePositive

t1.GhostAttackDistanceStuds = FastFlags.Replicated("Game.TrainEvent.GhostAttackDistanceStuds", FinitePositive4, 4)

local FinitePositive5 = Asserts.FinitePositive

t1.GhostAttackCooldownSeconds = FastFlags.Replicated("Game.TrainEvent.GhostAttackCooldownSeconds", FinitePositive5, 1.5)

local v20 = Asserts.Range(0, 600)

t1.GhostLifetimeSeconds = FastFlags.Replicated("Game.TrainEvent.GhostLifetimeSeconds", v20, 25)

local v21 = Asserts.Range(0, 10)

t1.GhostChaseDelaySeconds = FastFlags.Replicated("Game.TrainEvent.GhostChaseDelaySeconds", v21, 0.6)

local v22 = Asserts.Range(0, 20)

t1.GhostStopDistanceStuds = FastFlags.Replicated("Game.TrainEvent.GhostStopDistanceStuds", v22, 3)

local v23 = Asserts.Range(0, 100)

t1.GhostTurnRate = FastFlags.Replicated("Game.TrainEvent.GhostTurnRate", v23, 8)

local v24 = Asserts.Range(0.5, 3)

t1.GhostStrikeReachMultiplier = FastFlags.Replicated("Game.TrainEvent.GhostStrikeReachMultiplier", v24, 1.3)

local v25 = Asserts.Range(0, 1)

t1.GhostHitChance = FastFlags.Replicated("Game.TrainEvent.GhostHitChance", v25, 0.85)

local v26 = Asserts.Range(0.1, 5)

t1.GhostSwipeSpeed = FastFlags.Replicated("Game.TrainEvent.GhostSwipeSpeed", v26, 1)

local v27 = Asserts.Range(0, 10)

t1.GhostRagdollSeconds = FastFlags.Replicated("Game.TrainEvent.GhostRagdollSeconds", v27, 0)

local v28 = Asserts.Range(0, 5)

t1.GhostKnockbackMultiplier = FastFlags.Replicated("Game.TrainEvent.GhostKnockbackMultiplier", v28, 1)

local FinitePositive6 = Asserts.FinitePositive

t1.VengefulInterruptSeconds = FastFlags.Replicated("Game.TrainEvent.VengefulInterruptSeconds", FinitePositive6, 1)

local FinitePositive7 = Asserts.FinitePositive

t1.GhostAggroStuds = FastFlags.Replicated("Game.TrainEvent.GhostAggroStuds", FinitePositive7, 35)

local Boolean = Asserts.Boolean

t1.GhostIntroSpawnsEnabled = FastFlags.Replicated("Game.TrainEvent.GhostIntroSpawnsEnabled", Boolean, true)

local v29 = Asserts.Range(0, 100)

t1.GhostSpawnMinDistanceStuds = FastFlags.Replicated("Game.TrainEvent.GhostSpawnMinDistanceStuds", v29, 12)

local v30 = Asserts.Range(0.1, 60)

t1.GhostRoamTurnSeconds = FastFlags.Replicated("Game.TrainEvent.GhostRoamTurnSeconds", v30, 3)

local v31 = Asserts.Range(0.1, 5)

t1.HauntedSpiritChaseSpeedMultiplier = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritChaseSpeedMultiplier", v31, 1.5)

local v32 = Asserts.Range(0, 100)

t1.HauntedSpiritChaseMinDistanceStuds = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritChaseMinDistanceStuds", v32, 8)

local FinitePositive8 = Asserts.FinitePositive

t1.LostSpiritSpeedStuds = FastFlags.Replicated("Game.TrainEvent.LostSpiritSpeedStuds", FinitePositive8, 2.5)

local IntegerNonNegative2 = Asserts.IntegerNonNegative

t1.LostSpiritDamage = FastFlags.Replicated("Game.TrainEvent.LostSpiritDamage", IntegerNonNegative2, 6)

local IntegerNonNegative3 = Asserts.IntegerNonNegative

t1.LostSpiritSpawnWeight = FastFlags.Replicated("Game.TrainEvent.LostSpiritSpawnWeight", IntegerNonNegative3, 60)

local FinitePositive9 = Asserts.FinitePositive

t1.HauntedSpiritSpeedStuds = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritSpeedStuds", FinitePositive9, 6.25)

local IntegerNonNegative4 = Asserts.IntegerNonNegative

t1.HauntedSpiritDamage = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritDamage", IntegerNonNegative4, 9)

local IntegerNonNegative5 = Asserts.IntegerNonNegative

t1.HauntedSpiritSpawnWeight = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritSpawnWeight", IntegerNonNegative5, 30)

local FinitePositive10 = Asserts.FinitePositive

t1.VengefulSpiritSpeedStuds = FastFlags.Replicated("Game.TrainEvent.VengefulSpiritSpeedStuds", FinitePositive10, 10)

local IntegerNonNegative6 = Asserts.IntegerNonNegative

t1.VengefulSpiritDamage = FastFlags.Replicated("Game.TrainEvent.VengefulSpiritDamage", IntegerNonNegative6, 12)

local IntegerNonNegative7 = Asserts.IntegerNonNegative

t1.VengefulSpiritSpawnWeight = FastFlags.Replicated("Game.TrainEvent.VengefulSpiritSpawnWeight", IntegerNonNegative7, 10)

local v33 = Asserts.Range(14, 50)

t1.ReturnPromptReachStuds = FastFlags.Replicated("Game.TrainEvent.ReturnPromptReachStuds", v33, 40)

local FinitePositive11 = Asserts.FinitePositive

t1.InteractionReachStuds = FastFlags.Replicated("Game.TrainEvent.InteractionReachStuds", FinitePositive11, 14)

local v34 = Asserts.Range(1, 50)

t1.SoulShopReachStuds = FastFlags.Replicated("Game.TrainEvent.SoulShopReachStuds", v34, 24)

local FinitePositive12 = Asserts.FinitePositive

t1.BoardedMaxDistanceStuds = FastFlags.Replicated("Game.TrainEvent.BoardedMaxDistanceStuds", FinitePositive12, 60)

local v35 = Asserts.Range(-50000, 50000)

t1.PrototypeStationX = FastFlags.Replicated("Game.TrainEvent.PrototypeStationX", v35, -12000)

local v36 = Asserts.Range(-50000, 50000)

t1.PrototypeStationZ = FastFlags.Replicated("Game.TrainEvent.PrototypeStationZ", v36, -2000)

local FiniteNonNegative = Asserts.FiniteNonNegative

t1.PrototypeFloorY = FastFlags.Replicated("Game.TrainEvent.PrototypeFloorY", FiniteNonNegative, 100)

local IntegerNonNegative8 = Asserts.IntegerNonNegative

t1.AdminSoulGrantMax = FastFlags.Replicated("Game.TrainEvent.AdminSoulGrantMax", IntegerNonNegative8, 1E+09)

local IntegerNonNegative9 = Asserts.IntegerNonNegative

t1.AdminTicketGrantMax = FastFlags.Replicated("Game.TrainEvent.AdminTicketGrantMax", IntegerNonNegative9, 1000)

local Boolean2 = Asserts.Boolean

t1.Enabled = FastFlags.Replicated("Game.TrainEvent.Enabled", Boolean2, true)

local Boolean3 = Asserts.Boolean

t1.RewardsEnabled = FastFlags.Replicated("Game.TrainEvent.RewardsEnabled", Boolean3, true)

local Boolean4 = Asserts.Boolean

t1.HideSewerWhirlpool = FastFlags.Replicated("Game.TrainEvent.HideSewerWhirlpool", Boolean4, false)

local v37 = Asserts.Range(0, 1)

t1.SpawnChancePerNight = FastFlags.Replicated("Game.TrainEvent.SpawnChancePerNight", v37, 0.25)

local v38 = Asserts.Range(600, 86400)

t1.SpawnIntervalSeconds = FastFlags.Replicated("Game.TrainEvent.SpawnIntervalSeconds", v38, 1800)

local v39 = Asserts.Range(0, 86400)

t1.SpawnOffsetSeconds = FastFlags.Replicated("Game.TrainEvent.SpawnOffsetSeconds", v39, 0)

local FinitePositive13 = Asserts.FinitePositive

t1.BoardingSeconds = FastFlags.Replicated("Game.TrainEvent.BoardingSeconds", FinitePositive13, 180)

local FinitePositive14 = Asserts.FinitePositive

t1.InvasionDelaySeconds = FastFlags.Replicated("Game.TrainEvent.InvasionDelaySeconds", FinitePositive14, 15)

local FinitePositive15 = Asserts.FinitePositive

t1.InvasionSeconds = FastFlags.Replicated("Game.TrainEvent.InvasionSeconds", FinitePositive15, 300)

local IntegerNonNegative10 = Asserts.IntegerNonNegative

t1.CaptureGoal = FastFlags.Replicated("Game.TrainEvent.CaptureGoal", IntegerNonNegative10, 50)

local IntegerNonNegative11 = Asserts.IntegerNonNegative

t1.CompletionBonusSouls = FastFlags.Replicated("Game.TrainEvent.CompletionBonusSouls", IntegerNonNegative11, 500)

local FinitePositive16 = Asserts.FinitePositive

t1.LostSpiritCaptureSeconds = FastFlags.Replicated("Game.TrainEvent.LostSpiritCaptureSeconds", FinitePositive16, 1.5)

local IntegerNonNegative12 = Asserts.IntegerNonNegative

t1.LostSpiritSouls = FastFlags.Replicated("Game.TrainEvent.LostSpiritSouls", IntegerNonNegative12, 20)

local FinitePositive17 = Asserts.FinitePositive

t1.HauntedSpiritCaptureSeconds = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritCaptureSeconds", FinitePositive17, 3)

local IntegerNonNegative13 = Asserts.IntegerNonNegative

t1.HauntedSpiritSouls = FastFlags.Replicated("Game.TrainEvent.HauntedSpiritSouls", IntegerNonNegative13, 50)

local FinitePositive18 = Asserts.FinitePositive

t1.VengefulSpiritCaptureSeconds = FastFlags.Replicated("Game.TrainEvent.VengefulSpiritCaptureSeconds", FinitePositive18, 5)

local IntegerNonNegative14 = Asserts.IntegerNonNegative

t1.VengefulSpiritSouls = FastFlags.Replicated("Game.TrainEvent.VengefulSpiritSouls", IntegerNonNegative14, 110)

local FinitePositive19 = Asserts.FinitePositive

t1.ShopReturnGraceSeconds = FastFlags.Replicated("Game.TrainEvent.ShopReturnGraceSeconds", FinitePositive19, 120)

local FinitePositive20 = Asserts.FinitePositive

t1.VacuumReachStuds = FastFlags.Replicated("Game.TrainEvent.VacuumReachStuds", FinitePositive20, 20)

local v40 = Asserts.Range(1, 179)

t1.VacuumConeDegrees = FastFlags.Replicated("Game.TrainEvent.VacuumConeDegrees", v40, 120)

local v41 = Asserts.Range(0.05, 1)

t1.VacuumMovementScalar = FastFlags.Replicated("Game.TrainEvent.VacuumMovementScalar", v41, 0.5)

local Boolean5 = Asserts.Boolean

t1.SpectralTradeEnabled = FastFlags.Replicated("Game.TrainEvent.SpectralTradeEnabled", Boolean5, true)

local IntegerNonNegative15 = Asserts.IntegerNonNegative

t1.SpectralSoulCost = FastFlags.Replicated("Game.TrainEvent.SpectralSoulCost", IntegerNonNegative15, 1000)

local FinitePositive21 = Asserts.FinitePositive

t1.SpectralEarningsMultiplier = FastFlags.Replicated("Game.TrainEvent.SpectralEarningsMultiplier", FinitePositive21, 1)

local v42 = Asserts.Range(0, 100)

t1.SpectralSuccessPercent = FastFlags.Replicated("Game.TrainEvent.SpectralSuccessPercent", v42, 25)

return freeze(t1)
