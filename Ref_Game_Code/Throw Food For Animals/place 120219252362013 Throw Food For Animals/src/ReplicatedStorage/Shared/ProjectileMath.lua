-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local t1 = {}

function t1.FlightTime(p1) -- line: 14
    -- upvalues: GameConfig (copy)
    local Throw = GameConfig.Throw
    local v1 = math.max(p1, 1) / Throw.FirstThrowDistance

    return (math.min(Throw.BaseFlightTime * v1 ^ Throw.FlightTimeExponent, Throw.MaxFlightTime))
end

function t1.GravityFor(p2, p3) -- line: 21
    -- upvalues: GameConfig (copy)
    local Throw = GameConfig.Throw

    return math.clamp(p2 * Throw.ApexHeightFactor, Throw.ApexHeightMin, Throw.ApexHeightMax) * 8 / (p3 * p3)
end

function t1.CreateArc(p4, p5, p6, p7) -- line: 29
    -- upvalues: t1 (copy)
    local v4

    if p7 then
        v4 = p7
    else
        local Magnitude = (Vector3.new(p5.X, 0, p5.Z) - Vector3.new(p4.X, 0, p4.Z)).Magnitude

        v4 = t1.GravityFor(Magnitude, p6)
    end

    local v7 = Vector3.new(0, -v4, 0)
    local v8 = math.max(p6, 0.05)
    local v9 = (p5 - p4 - v7 * 0.5 * v8 * v8) / v8
    local t2 = {
        Start = p4,
        Target = p5,
        Duration = v8,
        Gravity = v7,
        V0 = v9,
        PositionAt = function(p8, p9) -- PositionAt | line: 44
            local v10 = math.clamp(p9, 0, p8.Duration)

            return p8.Start + p8.V0 * v10 + 0.5 * p8.Gravity * v10 * v10
        end,
        VelocityAt = function(p10, p11) -- VelocityAt | line: 48
            local v11 = math.clamp(p11, 0, p10.Duration)

            return p10.V0 + p10.Gravity * v11
        end
    }
    local v13 = math.clamp(v9.Y / v4, 0, v8)

    t2.ApexTime = v13
    t2.Apex = t2:PositionAt(v13)

    return t2
end

return t1
