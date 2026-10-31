-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    zAngleDegrees = 0
}

return {
    flightSteeringDeadzone = 0.15,
    flightSteeringMaxSpeed = 120,
    flightSteeringMinOffset = 8,
    flightSteeringMaxOffset = 300,
    flightSteeringOffsetRatio = 0.12,
    getCastRightDirection = function(p1) -- getCastRightDirection | line: 17
        local v1 = Vector3.new(p1.X, 0, p1.Z)

        if v1.Magnitude < 0.001 then
            return (Vector3.new(1, 0, 0))
        end

        local Unit = v1.Unit

        return (Vector3.new(-Unit.Z, 0, Unit.X))
    end,
    maxFlightLateralOffsetFromDistance = function(p2) -- maxFlightLateralOffsetFromDistance | line: 25
        return (math.clamp(p2 * 0.12, 8, 300))
    end,
    remapFlightSteeringInput = function(p3) -- remapFlightSteeringInput | line: 28
        local v4 = math.clamp(p3, -1, 1)
        local v5 = math.abs(v4)

        if v5 <= 0.15 then
            return 0
        end

        local v6 = (v5 - 0.15) / 0.85

        return math.sign(v4) * v6
    end,
    flightLateralSpeedFromInput = function(p4) -- flightLateralSpeedFromInput | line: 38
        local v7 = math.clamp(p4, -1, 1)
        local v8 = math.abs(v7)
        local v9

        if v8 <= 0.15 then
            v9 = 0
        else
            local v10 = (v8 - 0.15) / 0.85

            v9 = math.sign(v7) * v10
        end

        return v9 * 120
    end,
    flightLateralOffsetLimit = function(p5, p6) -- flightLateralOffsetLimit | line: 41
        local v11 = math.clamp(p5, 0, 1)

        return p6 * (v11 * v11 * (3 - v11 * 2))
    end,
    flightSteeringCameraConfig = t1
}
