-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Data.BeanstalkEvent)

local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)

require(ReplicatedStorage.Packages.Trove)

local v1 = CameraShaker.new()

local function buildObstacles(p1) -- line: 83
    local t1 = {}

    for _, v2 in p1 do
        local BoundingBox, BoundingBox2 = v2:GetBoundingBox()

        table.insert(t1, {
            Hit = false,
            Model = v2,
            Box = BoundingBox,
            HalfSize = BoundingBox2 * 0.5 + Vector3.new(1.5, 1.5, 1.5)
        })
    end

    return t1
end

local function touches(p2, p3) -- line: 97
    local v3 = p2.Box:PointToObjectSpace(p3)
    local HalfSize = p2.HalfSize

    if math.abs(v3.X) <= HalfSize.X then
        if not (math.abs(v3.Y) <= HalfSize.Y) then
            return false
        end

        return math.abs(v3.Z) <= HalfSize.Z
    end

    return false
end

local t3 = {}

function t3.Shake(p4) -- line: 109
    -- upvalues: v1 (copy)
    v1:ShakeOnce(p4, 12, 0, 0.6)
end

function t3.Run(p5, p6) -- line: 114
    -- upvalues: Workspace (copy), CameraShakerDriver (copy), v1 (copy), buildObstacles (copy), t3 (copy)
    local v4 = p5:Extend()
    local Rig = p6.Rig
    local CurrentCamera = Workspace.CurrentCamera
    local v5 = buildObstacles(p6.Obstacles)
    local v6 = false

    Rig.Humanoid.PlatformStand = true
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local FieldOfView = CurrentCamera.FieldOfView

    CurrentCamera.FieldOfView = p6.FieldOfView or FieldOfView
    CameraShakerDriver.Start(v1, Enum.RenderPriority.Camera.Value + 2)
    v4:Add(function() -- line: 126
        -- upvalues: p6 (copy), Rig (copy), CurrentCamera (copy), v6 (ref), FieldOfView (copy), CameraShakerDriver (copy), v1 (copy)
        v6 = true
        Rig.Humanoid.PlatformStand = false
        Rig.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        Rig.Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        CameraShakerDriver.Stop(v1)

        if p6.KeepCamera then
            return
        end

        CurrentCamera.FieldOfView = FieldOfView
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.CameraSubject = Rig.Humanoid
    end)

    local CFrame = Rig.Root.CFrame
    local elapsed = os.clock()
    local v7 = p6.Length / p6.Seconds
    local v8 = p6.StartDistance or 0
    local v9 = p6.BlendSeconds or 1
    local n1 = 0
    local n2 = (-1e999)
    local v10 = p6.SteerSpeed or 30
    local LaneSpacing = p6.LaneSpacing
    local v11 = if LaneSpacing then math.max(math.floor(p6.Lateral / LaneSpacing), 0) else 0
    local n3 = 0
    local v14 = false

    v4:BindToRenderStep("BeanstalkRailRide", Enum.RenderPriority.Camera.Value + 1, function(p7) -- line: 170
        -- upvalues: p6 (copy), Rig (copy), CurrentCamera (copy), v5 (copy), v6 (ref), CFrame (copy), elapsed (copy), v7 (copy), v8 (ref), v9 (copy), n1 (ref), n2 (ref), v10 (copy), LaneSpacing (copy), n3 (ref), v14 (ref), v11 (copy), t3 (copy)
        local v15 = v8 / p6.Length
        local v18 = v7 * (if p6.SpeedScale then p6.SpeedScale(v15) else 1)
        local v19 = os.clock() - n2

        if v19 < p6.BumpSeconds then
            local v20 = p6.BumpSpeedScale or 0.2

            v18 *= v20 + (1 - v20) * v19 / p6.BumpSeconds
        end

        local v22 = v8

        v8 = math.min(v22 + v18 * p7, p6.Length)

        local v23 = p6.Path(v8)

        if p6.SteerLocked and p6.SteerLocked(v15) then
            n3 = 0
            n1 -= n1 * math.min(p7 * 3, 1)
        elseif LaneSpacing then
            local v27 = CurrentCamera.CFrame.RightVector * Vector3.new(1, 0, 1)
            local v28 = if v27.Magnitude > 0.01 then Rig.Humanoid.MoveDirection:Dot(v27.Unit) else 0
            local v29, v30, v31

            if v14 then
                v31 = true
            elseif math.abs(v28) >= 0.5 then
                v14 = true
                v29 = n3
                v30 = if v28 > 0 then 1 else -1
                v31 = false
            else
                v31 = true
            end

            if v31 then
                if v14 and math.abs(v28) <= 0.25 then
                    v14 = false
                end
            else
                n3 = math.clamp(v29 + v30, -v11, v11)
            end

            n1 += (n3 * LaneSpacing - n1) * math.min(p7 * 14, 1)
        else
            local v37 = CurrentCamera.CFrame.RightVector * Vector3.new(1, 0, 1)
            local v38 = if v37.Magnitude > 0.01 then Rig.Humanoid.MoveDirection:Dot(v37.Unit) else 0
            local v40 = n1

            n1 = math.clamp(v40 + v38 * v10 * p7, -p6.Lateral, p6.Lateral)
        end

        local v42 = v23 + v23.RightVector * n1

        if p6.Lift then
            v42 += Vector3.new(0, 1, 0) * p6.Lift(n1)
        end

        local v43 = (os.clock() - elapsed) / v9

        if v43 < 1 then
            v42 = CFrame:Lerp(v42, v43 * v43 * (3 - 2 * v43))
        end

        local Root = Rig.Root

        if p6.Mount then
            Root.CFrame = p6.Mount(v42)
        else
            Root.CFrame = v42
        end

        Rig.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        Rig.Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        CurrentCamera.CFrame = p6.Camera(v23, v42)

        local v44 = v18 / v7
        local FieldOfView = p6.FieldOfView

        if FieldOfView ~= nil then
            local v46 = math.clamp(FieldOfView + (v44 - 1) * (p6.FieldOfViewPerSpeed or 0), 40, 110)

            CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (v46 - CurrentCamera.FieldOfView) * math.min(p7 * 6, 1)
        end

        for _, v49 in v5 do
            if not v49.Hit then
                local Position = v42.Position
                local v50 = v49.Box:PointToObjectSpace(Position)
                local HalfSize = v49.HalfSize

                if math.abs(v50.X) <= HalfSize.X and math.abs(v50.Y) <= HalfSize.Y and math.abs(v50.Z) <= HalfSize.Z then
                    v49.Hit = true

                    if not (os.clock() - n2 < (p6.HitCooldownSeconds or 0)) and (not p6.CanHit or p6.CanHit()) then
                        local BoxPosition = v49.Box.Position

                        n2 = os.clock()

                        local v55 = v23.RightVector:Dot(v42.Position - BoxPosition)
                        local v56 = n1

                        n1 = math.clamp(v56 + (if v55 >= 0 then 1 else -1) * 6, -p6.Lateral, p6.Lateral)
                        t3.Shake(4)

                        if p6.OnHit then
                            p6.OnHit(v49.Model)
                        end
                    end
                end
            end
        end

        local Probe = p6.Probe
        local v59, v60

        if Probe then
            local v61 = Probe(v8, v42)

            if v61 then
                n2 = os.clock()

                local v62 = v23.RightVector:Dot(v42.Position - v61)

                v59 = n1
                v60 = if v62 >= 0 then 1 else -1
                n1 = math.clamp(v59 + v60 * 6, -p6.Lateral, p6.Lateral)
                t3.Shake(4)
            end
        end

        if p6.OnStep then
            p6.OnStep(v8, v42, v44)
        end

        if v8 >= p6.Length or p6.Stop ~= nil and p6.Stop() then
            v6 = true
        end
    end)

    while not v6 do
        task.wait()
    end

    v4:Clean()
end

return t3
