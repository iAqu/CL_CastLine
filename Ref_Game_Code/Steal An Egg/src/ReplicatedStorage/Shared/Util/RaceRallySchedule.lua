-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local t1 = {}

function t1.IsScheduled() -- line: 11
    -- upvalues: RaceRallyFlags (copy)
    return RaceRallyFlags.ContentEnabled:Get() and RaceRallyFlags.ScheduleEnabled:Get()
end

function t1.Window(p1) -- line: 16
    -- upvalues: RaceRallyFlags (copy)
    local v1 = RaceRallyFlags.ScheduleIntervalSeconds:Get()
    local v2 = RaceRallyFlags.ScheduleOffsetSeconds:Get()
    local v3 = (p1 - v2) // v1
    local v4 = v3 * v1 + v2

    return v3, v4, v4 + RaceRallyFlags.JoinSeconds:Get()
end

function t1.NextOpening(p2) -- line: 25
    -- upvalues: RaceRallyFlags (copy), t1 (copy)
    local _, v5, v6 = t1.Window(p2)

    if p2 < v6 then
        return v5, v6
    end

    local v7 = v5 + RaceRallyFlags.ScheduleIntervalSeconds:Get()

    return v7, v7 + RaceRallyFlags.JoinSeconds:Get()
end

function t1.ClaimsBoundary(p3) -- line: 35
    -- upvalues: RaceRallyFlags (copy), t1 (copy)
    return t1.IsScheduled() and (p3 - RaceRallyFlags.ScheduleOffsetSeconds:Get()) % RaceRallyFlags.ScheduleIntervalSeconds:Get() == 0
end

return table.freeze(t1)
