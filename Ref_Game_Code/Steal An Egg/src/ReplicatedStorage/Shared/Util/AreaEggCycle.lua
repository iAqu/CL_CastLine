-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AreaEggCycle = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).AreaEggCycle
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Globals.Constants)

local t = require(ReplicatedStorage.Packages.t)

local function periodSeconds() -- line: 15
    -- upvalues: AreaEggCycle (copy), Workspace (copy)
    return Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS
end

local function defaultNightSeconds() -- line: 19
    -- upvalues: AreaEggCycle (copy), Workspace (copy)
    return Workspace:GetAttribute("AreaEggCycleDefaultNightSeconds") or AreaEggCycle.NIGHT_SECONDS_DEFAULT
end

local v1 = t.strict(t.boolean)
local v2 = t.strict(t.optional(t.number))
local v3 = t.strict(t.number)
local t1 = {
    EndingSoonSeconds = 20,
    FinalBlinkSeconds = 10,
    SchedulePollSeconds = 0.25,
    ResetPeriodSeconds = Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS,
    NightGrowthSkipSeconds = AreaEggCycle.NIGHT_SKIP_SECONDS,
    MinNightDurationSeconds = AreaEggCycle.NIGHT_SECONDS_FLOOR
}

local function scheduleNumber(p1, p2) -- line: 48
    -- upvalues: Workspace (copy)
    local Attribute = Workspace:GetAttribute(p1)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p2
end

local function frozenAt(p3) -- line: 60
    -- upvalues: Workspace (copy)
    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p3
    end

    return (math.min(p3, AreaEggCycleDisabledAt))
end

local function requireServer() -- line: 64
    -- upvalues: RunService (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
end

local function requireLegalNightLength(p4) -- line: 68
    -- upvalues: AreaEggCycle (copy), Workspace (copy)
    assert(AreaEggCycle.NIGHT_SECONDS_FLOOR <= p4 and p4 <= (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS), (("A night of %*s falls outside %*..%*"):format(p4, AreaEggCycle.NIGHT_SECONDS_FLOOR, Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)))
end

function t1.NightLengthSeconds() -- line: 75
    -- upvalues: AreaEggCycle (copy), Workspace (copy)
    local v7 = Workspace:GetAttribute("AreaEggCycleDefaultNightSeconds") or AreaEggCycle.NIGHT_SECONDS_DEFAULT
    local AreaEggCycleNightSeconds = Workspace:GetAttribute("AreaEggCycleNightSeconds")

    if type(AreaEggCycleNightSeconds) ~= "number" then
        AreaEggCycleNightSeconds = v7
    end

    return (math.clamp(AreaEggCycleNightSeconds, AreaEggCycle.NIGHT_SECONDS_FLOOR, Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS))
end

function t1.NightGrowthRate() -- line: 83
    -- upvalues: AreaEggCycle (copy), t1 (copy)
    return AreaEggCycle.NIGHT_SKIP_SECONDS / t1.NightLengthSeconds()
end

function t1.IsRunning() -- line: 87
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("AreaEggCycleDisabledAt") == nil
end

function t1.HasScheduleOverride() -- line: 91
    -- upvalues: Workspace (copy), t1 (copy)
    if Workspace:GetAttribute("AreaEggCycleAnchorAt") == nil and Workspace:GetAttribute("AreaEggCycleNightSeconds") == nil then
        return not t1.IsRunning()
    end

    return true
end

function t1.PeriodStartTime(p5) -- line: 103
    -- upvalues: AreaEggCycle (copy), Workspace (copy), v3 (copy)
    v3(p5)

    local AreaEggCycleAnchorIndex = Workspace:GetAttribute("AreaEggCycleAnchorIndex")

    if type(AreaEggCycleAnchorIndex) ~= "number" then
        AreaEggCycleAnchorIndex = 0
    end

    local AreaEggCycleAnchorAt = Workspace:GetAttribute("AreaEggCycleAnchorAt")

    if type(AreaEggCycleAnchorAt) ~= "number" then
        AreaEggCycleAnchorAt = 0
    end

    return AreaEggCycleAnchorAt + (p5 - AreaEggCycleAnchorIndex) * (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)
end

function t1.PeriodIndexAt(p6) -- line: 111
    -- upvalues: AreaEggCycle (copy), Workspace (copy), v3 (copy)
    v3(p6)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p6
    end

    local v9 = math.min(p6, AreaEggCycleDisabledAt)
    local AreaEggCycleAnchorAt = Workspace:GetAttribute("AreaEggCycleAnchorAt")

    if type(AreaEggCycleAnchorAt) ~= "number" then
        AreaEggCycleAnchorAt = 0
    end

    local v10 = v9 - AreaEggCycleAnchorAt
    local AreaEggCycleAnchorIndex = Workspace:GetAttribute("AreaEggCycleAnchorIndex")

    if type(AreaEggCycleAnchorIndex) ~= "number" then
        AreaEggCycleAnchorIndex = 0
    end

    return (math.max(AreaEggCycleAnchorIndex + math.floor(v10 / (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)), 0))
end

function t1.NextResetTime(p7) -- line: 121
    -- upvalues: v3 (copy), t1 (copy)
    v3(p7)

    return t1.PeriodStartTime(t1.PeriodIndexAt(p7) + 1)
end

function t1.SecondsUntilReset(p8) -- line: 127
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p8)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p8
    end

    local v13 = math.min(p8, AreaEggCycleDisabledAt)

    return (math.max(0, t1.NextResetTime(v13) - v13))
end

function t1.NightStartTime(p9) -- line: 135
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p9)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p9
    end

    local v15 = math.min(p9, AreaEggCycleDisabledAt)

    return t1.NextResetTime(v15) - t1.NightLengthSeconds()
end

function t1.IsNightPhase(p10) -- line: 143
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p10)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p10
    end

    local v16 = math.min(p10, AreaEggCycleDisabledAt)

    return t1.SecondsUntilReset(v16) <= t1.NightLengthSeconds()
end

function t1.NightTransitionStartTime(p11, p12, p13) -- line: 151
    -- upvalues: v3 (copy), t1 (copy)
    v3(p11)
    v3(p12)
    v3(p13)

    return t1.NightStartTime(p11) - p12 + p13
end

function t1.IsWithinNightTransition(p14, p15, p16) -- line: 163
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p14)
    v3(p15)
    v3(p16)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p14
    end

    local v17 = math.min(p14, AreaEggCycleDisabledAt)

    if t1.IsNightPhase(v17) then
        return false
    end

    return t1.NightTransitionStartTime(v17, p15, p16) <= v17
end

function t1.ActivePeriodIndexAt(p17) -- line: 183
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p17)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p17
    end

    local v18 = math.min(p17, AreaEggCycleDisabledAt)
    local v19 = t1.PeriodIndexAt(v18)

    if t1.IsNightPhase(v18) then
        return v19 + 1
    end

    return v19
end

function t1.SecondsUntilPhaseEnd(p18) -- line: 196
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p18)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p18
    end

    local v20 = math.min(p18, AreaEggCycleDisabledAt)
    local v21 = t1.SecondsUntilReset(v20)

    if t1.IsNightPhase(v20) then
        return v21
    end

    return (math.max(0, v21 - t1.NightLengthSeconds()))
end

function t1.NextNightTime(p19) -- line: 209
    -- upvalues: AreaEggCycle (copy), Workspace (copy), v3 (copy), t1 (copy)
    v3(p19)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p19
    end

    local v23 = math.min(p19, AreaEggCycleDisabledAt)
    local v24 = t1.NightStartTime(v23)

    if v23 < v24 then
        return v24
    end

    return v24 + (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)
end

function t1.NightGrowthCreditAt(p20, p21) -- line: 222
    -- upvalues: Workspace (copy), v3 (copy), t1 (copy)
    v3(p20)
    v3(p21)

    local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

    if type(AreaEggCycleDisabledAt) ~= "number" then
        AreaEggCycleDisabledAt = p20
    end

    return math.clamp(math.min(p20, AreaEggCycleDisabledAt) - p21, 0, t1.NightLengthSeconds()) * t1.NightGrowthRate()
end

function t1.IsCloseToReset(p22) -- line: 232
    -- upvalues: v3 (copy)
    v3(p22)

    return p22 <= 20
end

function t1.IsInFinalBlink(p23) -- line: 238
    -- upvalues: v3 (copy)
    v3(p23)

    return p23 <= 10
end

function t1.IsBlinkOnRedFrame(p24) -- line: 244
    -- upvalues: v3 (copy)
    v3(p24)

    return math.ceil(p24) % 2 == 0
end

function t1.IsNearResetBoundary(p25, p26) -- line: 250
    -- upvalues: AreaEggCycle (copy), Workspace (copy), v3 (copy), t1 (copy)
    v3(p25)
    v3(p26)

    local v26 = t1.NextNightTime(p25)

    if v26 - p25 <= p26 then
        return true
    end

    return p25 - (v26 - (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)) <= p26
end

function t1.SetRunning(p27) -- line: 263
    -- upvalues: RunService (copy), Workspace (copy), v1 (copy), t1 (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    v1(p27)

    if t1.IsRunning() ~= p27 then
        Workspace:SetAttribute("AreaEggCycleDisabledAt", if p27 then nil else Workspace:GetServerTimeNow())
    end
end

function t1.OverrideNightLength(p28) -- line: 274
    -- upvalues: AreaEggCycle (copy), RunService (copy), Workspace (copy), v2 (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    v2(p28)

    if p28 ~= nil then
        assert(AreaEggCycle.NIGHT_SECONDS_FLOOR <= p28 and p28 <= (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS), (("A night of %*s falls outside %*..%*"):format(p28, AreaEggCycle.NIGHT_SECONDS_FLOOR, Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)))
    end

    Workspace:SetAttribute("AreaEggCycleNightSeconds", p28)
end

function t1.BeginNight(p29, p30) -- line: 285
    -- upvalues: AreaEggCycle (copy), RunService (copy), Workspace (copy), v2 (copy), v3 (copy), t1 (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    v3(p29)
    v2(p30)

    if t1.IsNightPhase(p29) then
        return false, "Night is already running"
    end

    p30 = p30 or t1.NightLengthSeconds()
    assert(AreaEggCycle.NIGHT_SECONDS_FLOOR <= p30 and p30 <= (Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS), (("A night of %*s falls outside %*..%*"):format(p30, AreaEggCycle.NIGHT_SECONDS_FLOOR, Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS)))

    local v36 = t1.PeriodIndexAt(p29)

    Workspace:SetAttribute("AreaEggCycleNightSeconds", p30)
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", v36 + 1)
    Workspace:SetAttribute("AreaEggCycleAnchorAt", p29 + p30)

    return true, nil
end

function t1.FinishNight(p31) -- line: 308
    -- upvalues: RunService (copy), Workspace (copy), v3 (copy), t1 (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    v3(p31)

    if not t1.IsNightPhase(p31) then
        return false, "Night is not running"
    end

    Workspace:SetAttribute("AreaEggCycleAnchorIndex", t1.ActivePeriodIndexAt(p31))
    Workspace:SetAttribute("AreaEggCycleAnchorAt", p31)

    return true, nil
end

function t1.PostponeReset(p32) -- line: 323
    -- upvalues: RunService (copy), Workspace (copy), v3 (copy), t1 (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    v3(p32)
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", t1.PeriodIndexAt(p32))
    Workspace:SetAttribute("AreaEggCycleAnchorAt", p32)
end

function t1.ResetSchedule() -- line: 331
    -- upvalues: RunService (copy), Workspace (copy)
    assert(RunService:IsServer(), "Only the server may rewrite the area egg schedule")
    Workspace:SetAttribute("AreaEggCycleAnchorAt", nil)
    Workspace:SetAttribute("AreaEggCycleAnchorIndex", nil)
    Workspace:SetAttribute("AreaEggCycleNightSeconds", nil)
    Workspace:SetAttribute("AreaEggCycleDisabledAt", nil)
end

local NIGHT_SECONDS_FLOOR = AreaEggCycle.NIGHT_SECONDS_FLOOR

local function refreshScheduleBalance(p33) -- line: 342
    -- upvalues: AreaEggCycle (copy), RunService (copy), Workspace (copy), t1 (copy), NIGHT_SECONDS_FLOOR (ref)
    if p33 ~= "Game.Balance.AreaEggCycle" then
        return
    end

    if RunService:IsServer() then
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local AreaEggCycleDisabledAt = Workspace:GetAttribute("AreaEggCycleDisabledAt")

        if type(AreaEggCycleDisabledAt) ~= "number" then
            AreaEggCycleDisabledAt = ServerTimeNow
        end

        local v40 = math.min(ServerTimeNow, AreaEggCycleDisabledAt)
        local v41 = Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS
        local v42 = Workspace:GetAttribute("AreaEggCycleDefaultNightSeconds") or AreaEggCycle.NIGHT_SECONDS_DEFAULT
        local AreaEggCycleNightSeconds = Workspace:GetAttribute("AreaEggCycleNightSeconds")

        if type(AreaEggCycleNightSeconds) ~= "number" then
            AreaEggCycleNightSeconds = v42
        end

        local v44 = math.clamp(AreaEggCycleNightSeconds, math.min(NIGHT_SECONDS_FLOOR, v41), v41)
        local PERIOD_SECONDS, NIGHT_SECONDS_DEFAULT = AreaEggCycle.PERIOD_SECONDS, AreaEggCycle.NIGHT_SECONDS_DEFAULT
        local AreaEggCycleNightSeconds2 = Workspace:GetAttribute("AreaEggCycleNightSeconds")

        if type(AreaEggCycleNightSeconds2) ~= "number" then
            AreaEggCycleNightSeconds2 = NIGHT_SECONDS_DEFAULT
        end

        local v45 = math.clamp(AreaEggCycleNightSeconds2, AreaEggCycle.NIGHT_SECONDS_FLOOR, PERIOD_SECONDS)

        if v41 ~= PERIOD_SECONDS or v44 ~= v45 then
            local v46 = t1.PeriodIndexAt(v40)
            local v48 = math.clamp(v40 - t1.PeriodStartTime(v46), 0, v41)
            local v49 = if v41 - v44 <= v48 then PERIOD_SECONDS - v45 + (v48 - (v41 - v44)) / v44 * v45 else v48 / (v41 - v44) * (PERIOD_SECONDS - v45)

            Workspace:SetAttribute("AreaEggCycleAnchorIndex", v46)
            Workspace:SetAttribute("AreaEggCycleAnchorAt", v40 - v49)
        end

        Workspace:SetAttribute("AreaEggCyclePeriodSeconds", PERIOD_SECONDS)
        Workspace:SetAttribute("AreaEggCycleDefaultNightSeconds", AreaEggCycle.NIGHT_SECONDS_DEFAULT)
    end

    NIGHT_SECONDS_FLOOR = AreaEggCycle.NIGHT_SECONDS_FLOOR
    t1.ResetPeriodSeconds = Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS
    t1.NightGrowthSkipSeconds = AreaEggCycle.NIGHT_SKIP_SECONDS
    t1.MinNightDurationSeconds = AreaEggCycle.NIGHT_SECONDS_FLOOR
end

if RunService:IsServer() then
    Workspace:SetAttribute("AreaEggCyclePeriodSeconds", AreaEggCycle.PERIOD_SECONDS)
    Workspace:SetAttribute("AreaEggCycleDefaultNightSeconds", AreaEggCycle.NIGHT_SECONDS_DEFAULT)
end

require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(refreshScheduleBalance)
Workspace:GetAttributeChangedSignal("AreaEggCyclePeriodSeconds"):Connect(function() -- line: 398
    -- upvalues: AreaEggCycle (copy), Workspace (copy), t1 (copy)
    t1.ResetPeriodSeconds = Workspace:GetAttribute("AreaEggCyclePeriodSeconds") or AreaEggCycle.PERIOD_SECONDS
end)

return t1
