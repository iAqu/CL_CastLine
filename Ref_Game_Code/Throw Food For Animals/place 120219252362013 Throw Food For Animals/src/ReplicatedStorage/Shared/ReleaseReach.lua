-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local LevelConfig = require(ReplicatedStorage.Config.LevelConfig)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local t1 = {}

local function reach(p1) -- line: 24
    -- upvalues: LevelConfig (copy), GameConfig (copy)
    return LevelConfig.ThrowPowerForLevel((math.max(1, tonumber(p1) or 1))) + (GameConfig.Throw.MeterBonusStuds or 0)
end

function t1.AreaForLevel(p2) -- line: 28
    -- upvalues: AreasConfig (copy), LevelConfig (copy), GameConfig (copy)
    local v3 = LevelConfig.ThrowPowerForLevel((math.max(1, tonumber(p2) or 1))) + (GameConfig.Throw.MeterBonusStuds or 0)
    local n1 = 1

    for v4, v5 in ipairs(AreasConfig.All) do
        if (v5.StartDistance or 1e999) <= v3 then
            n1 = v4
        end
    end

    return n1
end

function t1.Reaches(p3, p4) -- line: 37
    -- upvalues: t1 (copy)
    return t1.AreaForLevel(p3) >= (p4 or 1)
end

function t1.Distance(p5) -- line: 41
    -- upvalues: LevelConfig (copy), GameConfig (copy)
    return LevelConfig.ThrowPowerForLevel((math.max(1, tonumber(p5) or 1))) + (GameConfig.Throw.MeterBonusStuds or 0)
end

return t1
