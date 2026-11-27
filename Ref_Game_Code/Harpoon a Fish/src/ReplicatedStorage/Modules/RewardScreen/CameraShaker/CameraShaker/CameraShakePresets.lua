-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CameraShakeInstance = require(script.Parent.CameraShakeInstance)
local t1 = {
    ["Hard Bump"] = function() -- line: 10
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.5)

        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v1.RotationInfluence = Vector3.new(1, 1, 1)

        return v1
    end,
    ["Soft Bump"] = function() -- line: 17
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(0.5, 4, 0.1, 0.5)

        v2.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v2.RotationInfluence = Vector3.new(1, 1, 1)

        return v2
    end,
    Bump = function() -- Bump | line: 24
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(1, 4, 0.1, 0.5)

        v3.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v3.RotationInfluence = Vector3.new(1, 1, 1)

        return v3
    end,
    Explosion = function() -- Explosion | line: 31
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(5, 8, 0, 0.5)

        v4.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v4.RotationInfluence = Vector3.new(4, 1, 1)

        return v4
    end,
    Earthquake = function() -- Earthquake | line: 38
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(0.6, 3.5, 2, 10)

        v5.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v5.RotationInfluence = Vector3.new(1, 1, 4)

        return v5
    end,
    BadTrip = function() -- BadTrip | line: 45
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(10, 0.15, 5, 10)

        v6.PositionInfluence = Vector3.new(0, 0, 0.15)
        v6.RotationInfluence = Vector3.new(2, 1, 4)

        return v6
    end,
    HandheldCamera = function() -- HandheldCamera | line: 53
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(1, 0.25, 5, 10)

        v7.PositionInfluence = Vector3.new(0, 0, 0)
        v7.RotationInfluence = Vector3.new(1, 0.5, 0.5)

        return v7
    end,
    Vibration = function() -- Vibration | line: 60
        -- upvalues: CameraShakeInstance (copy)
        local v8 = CameraShakeInstance.new(0.4, 20, 2, 2)

        v8.PositionInfluence = Vector3.new(0, 0.15, 0)
        v8.RotationInfluence = Vector3.new(1.25, 0, 4)

        return v8
    end,
    RoughDriving = function() -- RoughDriving | line: 67
        -- upvalues: CameraShakeInstance (copy)
        local v9 = CameraShakeInstance.new(1, 2, 1, 1)

        v9.PositionInfluence = Vector3.new(0, 0, 0)
        v9.RotationInfluence = Vector3.new(1, 1, 1)

        return v9
    end
}

return (setmetatable({}, {
    __index = function(_, p2) -- __index | line: 78
        -- upvalues: t1 (copy)
        local v10 = t1[p2]

        if type(v10) == "function" then
            return v10()
        end

        error("No preset found with index \"" .. p2 .. "\"")
    end
}))
