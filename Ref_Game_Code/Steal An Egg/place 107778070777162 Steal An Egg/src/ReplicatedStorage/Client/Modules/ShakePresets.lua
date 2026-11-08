-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Shake = require(ReplicatedStorage.Packages.Shake)
local t1 = {}

for _, v1 in {
        { "Bump", 2.5, 0.25, 0.1, 0.75, Vector3.new(0.15, 0.15, 0.15), (Vector3.new(1, 1, 1)) },
        { "BumpS", 1.5, 0.25, 0.1, 0.75, Vector3.new(0.15, 0.15, 0.15), (Vector3.new(1, 1, 1)) },
        { "Explosion", 5, 0.1, 0, 1.5, Vector3.new(0.25, 0.25, 0.25), (Vector3.new(4, 1, 1)) },
        { "Earthquake", 0.6, 0.2857142857142857, 2, 10, Vector3.new(0.25, 0.25, 0.25), (Vector3.new(1, 1, 4)) },
        { "BadTrip", 10, 6.666666666666667, 5, 10, Vector3.new(0, 0, 0.15), (Vector3.new(2, 1, 4)) },
        { "HandheldCamera", 1, 0.25, 5, 10, Vector3.new(0, 0, 0), (Vector3.new(1, 0.5, 0.5)) },
        { "Vibration", 0.4, 0.05, 2, 2, Vector3.new(0, 0.15, 0), (Vector3.new(1.25, 0, 4)) },
        { "RoughDriving", 1, 0.5, 1, 1, Vector3.new(0, 0, 0), (Vector3.new(1, 1, 1)) }
    } do
    local v2 = Shake.new()

    v2.Amplitude = v1[2]
    v2.Frequency = v1[3]
    v2.FadeInTime = v1[4]
    v2.FadeOutTime = v1[5]
    v2.PositionInfluence = v1[6]
    v2.RotationInfluence = v1[7]
    t1[v1[1]] = v2
end

function t1.DriveCamera(p1, p2) -- line: 104
    -- upvalues: RunService (copy), Shake (copy)
    local v3 = p2 or workspace.CurrentCamera

    assert(v3, "no camera to attach a shake to")

    local _CFrame, connection
    local v4 = true

    p1:BindToRenderStep(Shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p3, p4, p5) -- line: 115
        -- upvalues: v3 (copy), _CFrame (ref), connection (ref), v4 (ref)
        _CFrame = v3.CFrame
        v3.CFrame = v3.CFrame * (CFrame.new(p3) * CFrame.Angles(0, math.rad(p4.Y), 0) * CFrame.Angles(math.rad(p4.X), 0, (math.rad(p4.Z))))

        if p5 then
            v4 = false

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)

    if v4 then
        connection = RunService.PostSimulation:Connect(function() -- line: 135
            -- upvalues: v3 (copy), _CFrame (ref)
            if _CFrame then
                v3.CFrame = _CFrame
            end
        end)
    end

    return function() -- line: 142
        -- upvalues: p1 (copy), connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end

        p1:Destroy()
    end
end

return t1
