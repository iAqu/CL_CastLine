-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AreasConfig = require(script.Parent.AreasConfig)
local ReleaseConfig = require(script.Parent.ReleaseConfig)
local t1 = {
    PowerPerLevel = 5,
    FirstThrowMeter = 15
}

t1.BaseThrowPower = AreasConfig.List[1].StartDistance + AreasConfig.List[1].Length / AreasConfig.SubAreas / 2 - t1.FirstThrowMeter
t1.BaseXp = 32.5
t1.XpPerArea = 4
t1.PaceXp = {
    0.15, 0.08, 0.3, 0.36, 0.42, 0.5, 0.62, 0.75,
    0.9, 1, 1, 1, 1, 1, 1.6, 38.4,
    54
}

function t1.ThrowPowerForLevel(p1) -- line: 74
    -- upvalues: t1 (copy)
    return t1.BaseThrowPower + t1.PowerPerLevel * (p1 - 1)
end

t1.MinThrowPower = t1.BaseThrowPower

function t1.EffectiveThrowPower(p2, p3) -- line: 84
    -- upvalues: t1 (copy)
    local v1 = t1.ThrowPowerForLevel(p2 or 1)

    if not p3 or p3 <= 0 then
        return v1
    end

    return (math.clamp(p3, math.min(t1.MinThrowPower, v1), v1))
end

function t1.PowerRoom(p4) -- line: 92
    -- upvalues: t1 (copy)
    return (math.max(0, ((t1.MaxLevel or 1) - (p4 or 1)) * t1.PowerPerLevel))
end

function t1.LevelForDistance(p5) -- line: 97
    -- upvalues: t1 (copy)
    return (math.max(1, math.ceil((p5 - t1.BaseThrowPower) / t1.PowerPerLevel) + 1))
end

local function refreshMaxLevel() -- line: 103
    -- upvalues: AreasConfig (copy), t1 (copy)
    t1.MaxLevel = t1.LevelForDistance(AreasConfig.TotalDistance)
end

t1.MaxLevel = t1.LevelForDistance(AreasConfig.TotalDistance)
ReleaseConfig.OnChanged(refreshMaxLevel)

local v6 = AreasConfig.ProgressForDistance(t1.ThrowPowerForLevel(1))

function t1.PaceForProgress(p6) -- line: 113
    -- upvalues: t1 (copy)
    local PaceXp = t1.PaceXp
    local v9 = math.clamp(math.floor(p6) + 1, 1, #PaceXp - 1)
    local v11 = math.clamp(p6 - (v9 - 1), 0, 1)

    return (math.exp(math.log(PaceXp[v9]) * (1 - v11) + math.log(PaceXp[v9 + 1]) * v11))
end

function t1.XpForLevel(p7) -- line: 122
    -- upvalues: AreasConfig (copy), t1 (copy), v6 (copy)
    local v16 = AreasConfig.ProgressForDistance(t1.ThrowPowerForLevel(p7))

    return (math.max(1, (math.floor(t1.BaseXp * t1.XpPerArea ^ (v16 - v6) * t1.PaceForProgress(v16) + 0.5))))
end

return t1
