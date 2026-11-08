-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local t1 = {}

local function cycleSeconds() -- line: 9
    -- upvalues: PumpkinBossFlags (copy)
    return PumpkinBossFlags.CycleMinutes:Get() * 60
end

local function windowSeconds() -- line: 13
    -- upvalues: PumpkinBossFlags (copy)
    return (math.min(PumpkinBossFlags.WindowMinutes:Get() * 60, PumpkinBossFlags.CycleMinutes:Get() * 60))
end

local function nextAt(p1, p2, p3) -- line: 17
    local v3 = p1 - p1 % p2 + p3 % p2

    if v3 <= p1 then
        v3 += p2
    end

    return v3
end

local function secondsLeftOpen(p4) -- line: 26
    -- upvalues: PumpkinBossFlags (copy)
    local v4 = PumpkinBossFlags.CycleMinutes:Get() * 60
    local v7 = math.min(PumpkinBossFlags.WindowMinutes:Get() * 60, PumpkinBossFlags.CycleMinutes:Get() * 60)
    local v8

    for _, v9 in PumpkinBossFlags.OpenMinutes:Get() do
        local v10 = (p4 - v9 * 60) % v4

        if v10 < v7 and (v8 == nil or v8 < v7 - v10) then
            v8 = v7 - v10
        end
    end

    return v8
end

function t1.Enabled() -- line: 40
    -- upvalues: PumpkinBossFlags (copy)
    return PumpkinBossFlags.ScheduleEnabled:Get()
end

function t1.IsOpen(p5) -- line: 44
    -- upvalues: t1 (copy), secondsLeftOpen (copy)
    return t1.Enabled() and secondsLeftOpen(p5) ~= nil
end

function t1.NextOpensAt(p6) -- line: 48
    -- upvalues: PumpkinBossFlags (copy)
    local v11 = PumpkinBossFlags.CycleMinutes:Get() * 60
    local v12

    for _, v13 in PumpkinBossFlags.OpenMinutes:Get() do
        local v14 = v13 * 60
        local v15 = p6 - p6 % v11 + v14 % v11

        if v15 <= p6 then
            v15 += v11
        end

        if v12 == nil or v15 < v12 then
            v12 = v15
        end
    end

    return v12 or p6 + v11
end

function t1.ClosesAt(p7) -- line: 61
    -- upvalues: PumpkinBossFlags (copy), t1 (copy), secondsLeftOpen (copy)
    local v16 = secondsLeftOpen(p7)

    if v16 then
        return p7 + v16
    end

    return t1.NextOpensAt(p7) + math.min(PumpkinBossFlags.WindowMinutes:Get() * 60, PumpkinBossFlags.CycleMinutes:Get() * 60)
end

function t1.OpenedAt(p8) -- line: 71
    -- upvalues: PumpkinBossFlags (copy), secondsLeftOpen (copy)
    local v20 = secondsLeftOpen(p8)

    return if v20 ~= nil then p8 + v20 - math.min(PumpkinBossFlags.WindowMinutes:Get() * 60, PumpkinBossFlags.CycleMinutes:Get() * 60) else nil
end

function t1.SecondsUntilOpen(p9) -- line: 79
    -- upvalues: t1 (copy)
    if t1.IsOpen(p9) then
        return 0
    end

    return t1.NextOpensAt(p9) - p9
end

return table.freeze(t1)
