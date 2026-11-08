-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function isEnabledByDefault() -- line: 10
    -- upvalues: RunService (copy), Environment (copy)
    return Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
end

local function isScheduledByDefault() -- line: 14
    -- upvalues: RunService (copy), Environment (copy)
    local v1 = Environment.IsDevPlace()
    local v2 = if not v1 then Environment.IsTestPlace() else nil

    if v1 or v2 then
        v2 = not RunService:IsStudio()
    end

    return v2
end

local freeze = table.freeze
local t1 = {
    ContentEnabled = FastFlags.Replicated("Game.RaceRally.ContentEnabled", Asserts.Boolean, false)
}
local Replicated = FastFlags.Replicated
local Boolean = Asserts.Boolean
local v3 = Environment.IsDevPlace()
local v4 = if not v3 then Environment.IsTestPlace() else nil

if v3 or v4 then
    v4 = not RunService:IsStudio()
end

t1.ScheduleEnabled = Replicated("Game.RaceRally.ScheduleEnabled", Boolean, v4)
t1.ScheduleIntervalSeconds = FastFlags.Replicated("Game.RaceRally.ScheduleIntervalSeconds", Asserts.IntegerRange(300, 86400), 1800)
t1.ScheduleOffsetSeconds = FastFlags.Replicated("Game.RaceRally.ScheduleOffsetSeconds", Asserts.IntegerNonNegative, 0)
t1.JoinSeconds = FastFlags.Replicated("Game.RaceRally.JoinSeconds", Asserts.IntegerPositive, 300)
t1.HeatJoinSeconds = FastFlags.Replicated("Game.RaceRally.HeatJoinSeconds", Asserts.IntegerPositive, 30)
t1.MaxConcurrentHeats = FastFlags.Replicated("Game.RaceRally.MaxConcurrentHeats", Asserts.IntegerRange(1, 8), 4)
t1.OneRacePerWindow = FastFlags.Replicated("Game.RaceRally.OneRacePerWindow", Asserts.Boolean, true)
t1.Laps = FastFlags.Replicated("Game.RaceRally.Laps", Asserts.IntegerPositive, 3)
t1.RacersWithBots = FastFlags.Replicated("Game.RaceRally.RacersWithBots", Asserts.IntegerNonNegative, 6)
t1.TimerLeadSeconds = FastFlags.Replicated("Game.RaceRally.TimerLeadSeconds", Asserts.IntegerNonNegative, 300)
t1.NitroSuccessPercent = FastFlags.Replicated("Game.RaceRally.NitroSuccessPercent", Asserts.Range(0, 100), 10)
t1.SpeedPowerRequirement = FastFlags.Replicated("Game.RaceRally.SpeedPowerRequirement", Asserts.FiniteNonNegative, 2500000)
t1.DoubleTrophiesMultiplier = FastFlags.Replicated("Game.RaceRally.DoubleTrophiesMultiplier", Asserts.IntegerRange(1, 10), 2)

return freeze(t1)
