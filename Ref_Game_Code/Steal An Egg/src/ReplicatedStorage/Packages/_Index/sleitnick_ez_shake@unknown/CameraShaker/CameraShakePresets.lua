-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local CameraShakeInstance = require(script.Parent.CameraShakeInstance)
local t1 = {
    Bump = function() -- Bump | line: 35
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75)

        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v1.RotationInfluence = Vector3.new(1, 1, 1)

        return v1
    end,
    Explosion = function() -- Explosion | line: 44
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(5, 10, 0, 1.5)

        v2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v2.RotationInfluence = Vector3.new(4, 1, 1)

        return v2
    end,
    Earthquake = function() -- Earthquake | line: 53
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(0.6, 3.5, 2, 10)

        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v3.RotationInfluence = Vector3.new(1, 1, 4)

        return v3
    end,
    BadTrip = function() -- BadTrip | line: 62
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(10, 0.15, 5, 10)

        v4.PositionInfluence = Vector3.new(0, 0, 0.15)
        v4.RotationInfluence = Vector3.new(2, 1, 4)

        return v4
    end,
    HandheldCamera = function() -- HandheldCamera | line: 71
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(1, 0.25, 5, 10)

        v5.PositionInfluence = Vector3.new(0, 0, 0)
        v5.RotationInfluence = Vector3.new(1, 0.5, 0.5)

        return v5
    end,
    Vibration = function() -- Vibration | line: 80
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(0.4, 20, 2, 2)

        v6.PositionInfluence = Vector3.new(0, 0.15, 0)
        v6.RotationInfluence = Vector3.new(1.25, 0, 4)

        return v6
    end,
    RoughDriving = function() -- RoughDriving | line: 89
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(1, 2, 1, 1)

        v7.PositionInfluence = Vector3.new(0, 0, 0)
        v7.RotationInfluence = Vector3.new(1, 1, 1)

        return v7
    end,
    WeakEarthquake = function() -- WeakEarthquake | line: 96
        -- upvalues: CameraShakeInstance (copy)
        local v8 = CameraShakeInstance.new(0.3, 1.5, 1, 5)

        v8.PositionInfluence = Vector3.new(0.2, 0.2, 0.2)
        v8.RotationInfluence = Vector3.new(0.5, 0.5, 1)

        return v8
    end
}

return (setmetatable({
    _allPresetsLiteral = t.union(t.literal("Bump"), t.literal("Explosion"), t.literal("Earthquake"), t.literal("BadTrip"), t.literal("HandheldCamera"), t.literal("Vibration"), t.literal("RoughDriving"))
}, {
    __index = function(_, p2) -- __index | line: 115
        -- upvalues: t1 (copy)
        local v9 = t1[p2]

        if type(v9) == "function" then
            return v9()
        end

        error("No preset found with index \"" .. p2 .. "\"")
    end
}))
