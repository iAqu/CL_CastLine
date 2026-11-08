-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TreadmillProgression = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).TreadmillProgression
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Trails = require(ReplicatedStorage.Data.Trails)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

local function refreshBalanceExports() -- line: 29
    -- upvalues: TreadmillProgression (copy), t1 (copy)
    t1.DEFAULT_BASE_SPEED_POWER = TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    t1.DEFAULT_BASE_SPEED_POWER_PER_STEP = TreadmillProgression.DEFAULT_BASE_SPEED_POWER_PER_STEP
    t1.DEFAULT_SPEED_STEP_MULTIPLIER = TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
    t1.TREADMILL_SPEED_GAIN_INTERVAL = TreadmillProgression.TREADMILL_SPEED_GAIN_INTERVAL
    t1.MAX_WALK_SPEED = TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED
    t1.MAX_SPEED_BOOST_TIER_INDEX = #TreadmillProgression.SPEED_BOOST_MULTIPLIERS_BY_TIER
end

t1.DEFAULT_BASE_SPEED_POWER = TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
t1.DEFAULT_BASE_SPEED_POWER_PER_STEP = TreadmillProgression.DEFAULT_BASE_SPEED_POWER_PER_STEP
t1.DEFAULT_SPEED_STEP_MULTIPLIER = TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
t1.TREADMILL_SPEED_GAIN_INTERVAL = TreadmillProgression.TREADMILL_SPEED_GAIN_INTERVAL
t1.MAX_WALK_SPEED = TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED
t1.MAX_SPEED_BOOST_TIER_INDEX = #TreadmillProgression.SPEED_BOOST_MULTIPLIERS_BY_TIER
require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(refreshBalanceExports)

local function resolveCurveLevelFromCurveProgress(p1) -- line: 46
    -- upvalues: TreadmillProgression (copy)
    if p1 <= 0 then
        return 0
    end

    local v1 = 1 + (TreadmillProgression.CURVE_XP_GROWTH - 1) * p1 / TreadmillProgression.CURVE_BASE_XP

    if v1 <= 1 then
        return 0
    end

    return math.log(v1) / math.log(TreadmillProgression.CURVE_XP_GROWTH)
end

local function resolveReferenceWalkSpeed(p2) -- line: 60
    -- upvalues: TreadmillProgression (copy)
    if p2 <= 0 then
        return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    end

    return (math.min(TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + p2 * TreadmillProgression.CURVE_SPEED_GAIN_PER_LEVEL, TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED))
end

local function resolveCurveProgress(p3) -- line: 72
    -- upvalues: TreadmillProgression (copy)
    return (math.max(p3 - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED, 0))
end

local function resolveWalkSpeed(p4) -- line: 76
    -- upvalues: TreadmillProgression (copy)
    if p4 <= 0 then
        return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    end

    local v5

    if p4 <= 0 then
        v5 = 0
    else
        local v6 = 1 + (TreadmillProgression.CURVE_XP_GROWTH - 1) * p4 / TreadmillProgression.CURVE_BASE_XP

        v5 = if v6 <= 1 then 0 else math.log(v6) / math.log(TreadmillProgression.CURVE_XP_GROWTH)
    end

    if v5 <= 0 then
        return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    end

    return (math.min(TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + v5 * TreadmillProgression.CURVE_SPEED_GAIN_PER_LEVEL, TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED))
end

local function remapProgressionWalkSpeedToAppliedWalkSpeed(p5) -- line: 86
    -- upvalues: TreadmillProgression (copy), Constants (copy)
    local v10 = math.clamp((p5 - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED) / (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED), 0, 1)

    return Constants.BASE_WALK_SPEED + v10 * (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - Constants.BASE_WALK_SPEED)
end

local function remapAppliedWalkSpeedToProgressionWalkSpeed(p6) -- line: 101
    -- upvalues: TreadmillProgression (copy), Constants (copy)
    local v12 = math.clamp((p6 - Constants.BASE_WALK_SPEED) / (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - Constants.BASE_WALK_SPEED), 0, 1)

    return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + v12 * (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED)
end

local function formatDurationProductLabel(p7, p8) -- line: 119
    -- upvalues: t (copy)
    t.strict(t.number)(p7)
    t.strict(t.boolean)(p8)

    local v14 = math.max(math.floor(p7), 0) // 60
    local v15 = if v14 == 1 then "Minute" else "Minutes"

    if v14 >= 60 and v14 % 60 == 0 then
        v14 //= 60
        v15 = if v14 == 1 then "Hour" else "Hours"
    end

    if p8 then
        v15 = string.upper(v15)
    end

    return (("%* %*"):format(v14, v15))
end

function t1.NormalizeSpeedPower(p9) -- line: 140
    -- upvalues: t (copy), t1 (copy)
    if p9 == nil then
        return t1.DEFAULT_BASE_SPEED_POWER
    end

    t.strict(t.number)(p9)

    return p9
end

function t1.SpeedPowerToWalkSpeed(p10) -- line: 152
    -- upvalues: TreadmillProgression (copy), Constants (copy), t1 (copy)
    local v17 = math.clamp((t1.SpeedPowerToProgressionWalkSpeed(p10) - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED) / (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED), 0, 1)

    return Constants.BASE_WALK_SPEED + v17 * (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - Constants.BASE_WALK_SPEED)
end

function t1.SpeedPowerToProgressionWalkSpeed(p11) -- line: 158
    -- upvalues: TreadmillProgression (copy), t1 (copy)
    local v19 = math.max(t1.NormalizeSpeedPower(p11) - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED, 0)

    if v19 <= 0 then
        return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    end

    local v20

    if v19 <= 0 then
        v20 = 0
    else
        local v21 = 1 + (TreadmillProgression.CURVE_XP_GROWTH - 1) * v19 / TreadmillProgression.CURVE_BASE_XP

        v20 = if v21 <= 1 then 0 else math.log(v21) / math.log(TreadmillProgression.CURVE_XP_GROWTH)
    end

    if v20 <= 0 then
        return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED
    end

    return (math.min(TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + v20 * TreadmillProgression.CURVE_SPEED_GAIN_PER_LEVEL, TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED))
end

function t1.WalkSpeedToSpeedPower(p12) -- line: 165
    -- upvalues: TreadmillProgression (copy), Constants (copy), t (copy)
    t.strict(t.number)(p12)

    local v25 = math.clamp((p12 - Constants.BASE_WALK_SPEED) / (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - Constants.BASE_WALK_SPEED), 0, 1)
    local v27 = math.max(TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + v25 * (TreadmillProgression.CURVE_REFERENCE_MAX_WALK_SPEED - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED) - TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED, 0) / TreadmillProgression.CURVE_SPEED_GAIN_PER_LEVEL
    local v28 = TreadmillProgression.CURVE_BASE_XP * (TreadmillProgression.CURVE_XP_GROWTH ^ v27 - 1) / (TreadmillProgression.CURVE_XP_GROWTH - 1)

    return TreadmillProgression.CURVE_REFERENCE_BASE_WALK_SPEED + v28
end

function t1.RoundSpeedPowerRequirement(p13) -- line: 179
    -- upvalues: t (copy)
    t.strict(t.number)(p13)

    if p13 <= 0 then
        return 0
    end

    local v30 = 10 ^ math.floor((math.log10(p13)))
    local v31 = p13 / v30
    local v32 = if v31 < 2 then 0.1 elseif v31 < 5 then 0.5 else 1

    return math.ceil(v31 / v32) * v32 * v30
end

function t1.FormatSpeedPower(p14) -- line: 195
    -- upvalues: Simple (copy), t1 (copy)
    return Simple.FormatCompact(t1.NormalizeSpeedPower(p14), ".#")
end

function t1.FormatSpeedPowerPerStep(p15) -- line: 199
    -- upvalues: Simple (copy), t (copy)
    t.strict(t.number)(p15)

    return (("+%*/step"):format((Simple.FormatCompact(p15, ".#"))))
end

function t1.ResolveEquippedTrailSpeedStepMultiplier(p16) -- line: 205
    -- upvalues: TreadmillProgression (copy), Trails (copy)
    if p16 == nil then
        return TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
    end

    local EquippedTrail = p16.EquippedTrail

    if EquippedTrail == nil or p16.TrailInventory[EquippedTrail] ~= true or not Trails.TrailNameExists(EquippedTrail) then
        return TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
    end

    return (math.max(Trails.Directory[EquippedTrail].SpeedMultiplier, TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER))
end

function t1.ResolveFinalWalkSpeed(p17, p18) -- line: 228
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.optional(t.number))(p17)
    t.strict(t.optional(t.number))(p18)
    p18 = p18 or 1
    assert(p18 > 0 and p18 <= 1, "Walk speed multiplier must be within (0, 1]")

    return t1.SpeedPowerToWalkSpeed(p17) * p18
end

function t1.ResolveEffectiveSpeedPower(p19, p20) -- line: 245
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.optional(t.number))(p20)

    local v36 = t1.NormalizeSpeedPower(p19)

    p20 = p20 or 1
    assert(p20 > 0 and p20 <= 1, "Walk speed multiplier must be within (0, 1]")

    if p20 == 1 then
        return v36
    end

    return t1.WalkSpeedToSpeedPower(t1.ResolveFinalWalkSpeed(v36, p20))
end

function t1.FormatSpeedMultiplierValue(p21) -- line: 268
    -- upvalues: Simple (copy), t (copy)
    t.strict(t.number)(p21)

    return (("x%*"):format((Simple.FormatCompact(p21, ".#"))))
end

function t1.FormatSpeedMultiplier(p22) -- line: 274
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.number)(p22)

    return (("%* Speed"):format((t1.FormatSpeedMultiplierValue(p22))))
end

function t1.FormatTemporarySpeedBoostProductDuration(p23) -- line: 280
    -- upvalues: formatDurationProductLabel (copy)
    return (formatDurationProductLabel(p23, true))
end

function t1.FormatTreadmillSpeedEquivalentDuration(p24) -- line: 284
    -- upvalues: formatDurationProductLabel (copy)
    return (formatDurationProductLabel(p24, false))
end

function t1.GetSpeedBoostMultiplierForTierIndex(p25) -- line: 288
    -- upvalues: TreadmillProgression (copy), t (copy)
    t.strict(t.number)(p25)

    return TreadmillProgression.SPEED_BOOST_MULTIPLIERS_BY_TIER[p25] or TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
end

function t1.ResolveSpeedBoostTierIndex(p26) -- line: 295
    -- upvalues: t1 (copy)
    if p26 == nil then
        return 0
    end

    return (math.clamp(math.floor(p26.SpeedBoostTierIndex), 0, t1.MAX_SPEED_BOOST_TIER_INDEX))
end

function t1.ResolveSpeedBoostSpeedStepMultiplier(p27) -- line: 307
    -- upvalues: t1 (copy)
    return t1.GetSpeedBoostMultiplierForTierIndex(t1.ResolveSpeedBoostTierIndex(p27))
end

function t1.ResolveTemporarySpeedBoostRemainingSeconds(p28, p29) -- line: 313
    -- upvalues: t (copy)
    t.strict(t.optional(t.number))(p29)

    if p28 == nil then
        return 0
    end

    local v40 = math.max(p28.TemporarySpeedBoostRemainingSeconds, 0)
    local TemporarySpeedBoostActiveStartedAt = p28.TemporarySpeedBoostActiveStartedAt

    if TemporarySpeedBoostActiveStartedAt > 0 then
        v40 -= math.max((if p29 == nil then workspace:GetServerTimeNow() else p29) - TemporarySpeedBoostActiveStartedAt, 0)
    end

    return (math.max(v40, 0))
end

function t1.ResolveTemporarySpeedBoostSpeedStepMultiplier(p30, p31) -- line: 335
    -- upvalues: TreadmillProgression (copy), BossMasteryFlags (copy), t1 (copy)
    if t1.ResolveTemporarySpeedBoostRemainingSeconds(p30, p31) <= 0 then
        return TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER
    end

    return BossMasteryFlags.TreadmillBoostMultiplier:Get()
end

function t1.GetTemporarySpeedBoostMultiplier() -- line: 346
    -- upvalues: BossMasteryFlags (copy)
    return BossMasteryFlags.TreadmillBoostMultiplier:Get()
end

function t1.ResolveAdditiveSpeedStepMultiplier(p32, p33) -- line: 350
    -- upvalues: TreadmillProgression (copy), t (copy)
    t.strict(t.optional(t.number))(p32)
    t.strict(t.optional(t.number))(p33)

    local v42 = if p32 == nil then TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER else p32
    local v43 = if p33 == nil then TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER else p33
    local v45 = math.max(v42 - TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER, 0)
    local v47 = math.max(v43 - TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER, 0)

    return TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER + v45 + v47
end

function t1.ResolveTreadmillSpeedPowerDelta(p34, p35, p36, p37) -- line: 371
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.number)(p34)
    t.strict(t.number)(p35)
    t.strict(t.optional(t.number))(p36)
    t.strict(t.optional(t.number))(p37)

    local v48 = if p37 == nil then 1 else math.max(p37, 0)
    local v49 = t1.ResolveAdditiveSpeedStepMultiplier(p35, p36)

    return math.max(p34, 0) * v49 * v48
end

function t1.ResolveSpeedPowerPerStep(p38, p39, p40, p41) -- line: 391
    -- upvalues: TreadmillProgression (copy), t (copy), t1 (copy)
    t.strict(t.optional(t.number))(p39)
    t.strict(t.optional(t.number))(p40)
    t.strict(t.optional(t.number))(p41)

    local v50 = t1.ResolveSpeedBoostSpeedStepMultiplier(p38)
    local v51 = t1.ResolveTemporarySpeedBoostSpeedStepMultiplier(p38, p40)
    local v52 = t1.ResolveEquippedTrailSpeedStepMultiplier(p38)
    local v53 = t1.ResolveTreadmillSpeedPowerDelta(TreadmillProgression.DEFAULT_BASE_SPEED_POWER_PER_STEP, p39 or TreadmillProgression.DEFAULT_SPEED_STEP_MULTIPLIER, nil)
    local v54 = t1.ResolveAdditiveSpeedStepMultiplier(v50, v51)
    local v55 = t1.ResolveAdditiveSpeedStepMultiplier(v54, v52)

    return v53 * t1.ResolveAdditiveSpeedStepMultiplier(v55, p41)
end

function t1.ResolveSpeedPowerPerSecond(p42, p43, p44) -- line: 426
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.table)(p42)
    t.strict(t.number)(p43)
    t.strict(t.optional(t.number))(p44)

    local v56 = t1.ResolveSpeedPowerPerStep(p42, p43, p44)
    local v57 = t1.SpeedPowerToProgressionWalkSpeed(p42.SpeedPower)

    return v56 / t1.ResolveWalkSpeedPowerAwardInterval(v57)
end

function t1.ResolveTreadmillEquivalentSpeedPower(p45, p46, p47, p48) -- line: 442
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.table)(p45)
    t.strict(t.number)(p46)
    t.strict(t.number)(p47)
    t.strict(t.optional(t.number))(p48)
    assert(p47 > 0, "Treadmill equivalent duration must be positive")

    return t1.ResolveSpeedPowerPerSecond(p45, p46, p48) * p47
end

function t1.ResolveNextTreadmillSpeedGainAt(p49) -- line: 457
    -- upvalues: TreadmillProgression (copy), t (copy)
    t.strict(t.number)(p49)

    return p49 + TreadmillProgression.TREADMILL_SPEED_GAIN_INTERVAL
end

function t1.ResolveElapsedTreadmillSpeedGainTicks(p50, p51) -- line: 463
    -- upvalues: TreadmillProgression (copy), t (copy)
    t.strict(t.number)(p50)
    t.strict(t.number)(p51)

    if p51 < p50 then
        return 0
    end

    return math.floor((p51 - p50) / TreadmillProgression.TREADMILL_SPEED_GAIN_INTERVAL) + 1
end

function t1.ResolveWalkSpeedPowerAwardInterval(p52) -- line: 477
    -- upvalues: TreadmillProgression (copy), t (copy)
    t.strict(t.number)(p52)

    local v61 = math.clamp((p52 - TreadmillProgression.WALK_GAIN_INTERVAL_MIN_SPEED) / (TreadmillProgression.WALK_GAIN_INTERVAL_MAX_SPEED - TreadmillProgression.WALK_GAIN_INTERVAL_MIN_SPEED), 0, 1)

    return TreadmillProgression.WALK_GAIN_INTERVAL_SLOWEST - v61 * (TreadmillProgression.WALK_GAIN_INTERVAL_SLOWEST - TreadmillProgression.WALK_GAIN_INTERVAL_FASTEST)
end

local function findOptionalPresentationPart(p53, p54) -- line: 497
    local v62 = p53:FindFirstChild(p54, true)

    if v62 == nil then
        return nil
    end

    assert(v62:IsA("BasePart"), (("Treadmill \"%*\" %* must be a BasePart"):format(p53.Name, p54)))

    return v62
end

function t1.FindVideoFeedScreenPart(p55) -- line: 512
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Tool"))(p55)

    local v64 = p55:FindFirstChild("VideoFeedScreen", true)

    if v64 == nil then
        return nil
    end

    assert(v64:IsA("BasePart"), (("Treadmill \"%*\" VideoFeedScreen must be a BasePart"):format(p55.Name)))

    return v64
end

function t1.FindVideoPlayerFolder(p56) -- line: 518
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Tool"))(p56)

    local v66 = t1.FindVideoFeedScreenPart(p56)

    if v66 == nil then
        return nil
    end

    local Folder = v66:FindFirstAncestorOfClass("Folder")

    return if Folder ~= nil and Folder:IsDescendantOf(p56) then Folder else nil
end

function t1.FindVideoPresentationParts(p57) -- line: 535
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Tool"))(p57)

    local v67 = t1.FindVideoFeedScreenPart(p57)
    local v68 = p57:FindFirstChild("SwapLeft", true)

    if v68 ~= nil then
        assert(v68:IsA("BasePart"), (("Treadmill \"%*\" SwapLeft must be a BasePart"):format(p57.Name)))
    end

    local v70 = p57:FindFirstChild("SwapRight", true)

    if v70 ~= nil then
        assert(v70:IsA("BasePart"), (("Treadmill \"%*\" SwapRight must be a BasePart"):format(p57.Name)))
    end

    if v67 ~= nil and v68 ~= nil and v70 ~= nil then
        return v67, v68, v70
    end

    return nil, nil, nil
end

function t1.ResolveGroundedToolRootCFrameAtLocation(p58, p59) -- line: 550
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("BasePart"))(p58)
    t.strict(t.instanceIsA("Tool"))(p59)

    local Root = p59.Root

    assert(Root:IsA("BasePart"), (("Treadmill \"%*\" Root must be a BasePart"):format(p59.Name)))

    local BoundingBoxPart = p59.BoundingBoxPart

    assert(BoundingBoxPart:IsA("BasePart"), (("Treadmill \"%*\" BoundingBoxPart must be a BasePart"):format(p59.Name)))

    local v74 = Root.CFrame:PointToObjectSpace(BoundingBoxPart.CFrame.Position)
    local v75 = p59:GetAttribute("Offset") or 0
    local v77 = p58.Position + Vector3.new(0, BoundingBoxPart.Size.Y * 0.5 + v75, 0)

    return CFrame.new(v77) * p58.CFrame.Rotation * CFrame.new(-v74)
end

return t1
