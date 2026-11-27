-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared").GameConfig)
local UIKit = require(script.Parent.UIKit)
local fromRGB, new, CurrentCamera = Color3.fromRGB, Vector3.new, workspace.CurrentCamera
local t1 = {}

t1.Active = false
t1.Tracking = false
t1.Hidden = 0
t1.Rays = 0

local Folder, Part, ParticleEmitter, DepthOfFieldEffect, Part2, PointLight
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6

local function part(p1, p2) -- line: 31
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Name = p1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = p2 or Vector3.new(1, 1, 1)
    Part.Parent = Folder

    return Part
end

function t1.DeepColor(p3) -- line: 46
    -- upvalues: fromRGB (copy)
    return p3:Lerp(fromRGB(3, 8, 26), 0.5)
end

function t1.Begin(p4, p5) -- line: 51
    -- upvalues: GameConfig (copy), UIKit (copy), t1 (copy), fromRGB (copy), new (copy), Folder (ref), Part (ref), ParticleEmitter (ref), t2 (copy), t4 (copy), t5 (copy), t6 (ref)
    t1.End()
    t6 = {
        track = nil,
        B = p4,
        deep = t1.DeepColor(p5),
        light = p5:Lerp(fromRGB(255, 255, 255), 0.7),
        t0 = os.clock()
    }
    t1.Active = true
    Folder = Instance.new("Folder")
    Folder.Name = "DeepSea"
    Folder.Parent = workspace

    local v1 = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Lane")
    local _ipairs = ipairs
    local v2 = if v1 then v1:GetDescendants() else {}

    for _, v3 in _ipairs(v2) do
        if v3:IsA("Texture") and v3.Face == Enum.NormalId.Bottom and v3.Parent and v3.Parent.Name == "Water" then
            table.insert(t4, {
                v3,
                v3.Transparency
            })
            v3.Transparency = 0.9
        elseif v3:IsA("BasePart") and v3.Name == "DeepWall" and math.abs(v3.Position.Z - p4.Z) < v3.Size.Z / 2 + 700 then
            table.insert(t5, {
                v3,
                v3.Color,
                v3.MaterialVariant
            })
            v3.Color = t6.deep
            v3.MaterialVariant = ""
        end
    end

    local Part2 = Instance.new("Part")

    Part2.Name = "Rays"
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Transparency = 1
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Parent = Folder
    Part2.CFrame = CFrame.new(p4)

    local v5 = Random.new()
    local Unit = (Vector3.new(0.24, -1, 0.14)).Unit

    table.clear(t2)

    for i = 1, 10 do
        local v6 = i / 10 * 3.141592653589793 * 2 + v5:NextNumber(-0.25, 0.25)
        local v7 = v5:NextNumber(10, 58)
        local v11 = new(p4.X + math.cos(v6) * v7, GameConfig.WATER_Y - 0.4, p4.Z + math.sin(v6) * v7)
        local v12 = v5:NextNumber(75, 130)
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part2
        Attachment.WorldPosition = v11

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = Part2
        Attachment2.WorldPosition = v11 + Unit * v12

        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2

        local v13 = v5:NextNumber(1.2, 3.6)

        Beam.Width0 = v13
        Beam.Width1 = v13 * v5:NextNumber(2.4, 3.6)
        Beam.FaceCamera = true
        Beam.LightEmission = 0.75
        Beam.LightInfluence = 0
        Beam.Color = ColorSequence.new(t6.light)

        local v14 = v5:NextNumber(0.78, 0.88)

        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v14),
            NumberSequenceKeypoint.new(0.45, (v14 + 1) / 2),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Segments = 1
        Beam.Parent = Part2
        table.insert(t2, {
            beam = Beam,
            a0 = Attachment,
            a1 = Attachment2,
            top = v11,
            bottom = v11 + Unit * v12,
            phase = v5:NextNumber(0, 6.283185307179586),
            speed = v5:NextNumber(0.18, 0.4)
        })
    end

    t1.Rays = #t2

    local Part3 = Instance.new("Part")

    Part3.Name = "Snow"
    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanQuery = false
    Part3.CanTouch = false
    Part3.CastShadow = false
    Part3.Transparency = 1
    Part3.Size = Vector3.new(64, 40, 64)
    Part3.Parent = Folder
    Part = Part3
    ParticleEmitter = Instance.new("ParticleEmitter")
    ParticleEmitter.Name = "Snow"
    ParticleEmitter.Texture = UIKit.Art.Glow
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Color = ColorSequence.new(t6.light)
    ParticleEmitter.LightEmission = 0.6
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.12),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.35),
        NumberSequenceKeypoint.new(0.8, 0.45),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(5, 9)
    ParticleEmitter.Speed = NumberRange.new(0.2, 0.9)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Acceleration = Vector3.new(0, -0.12, 0)
    ParticleEmitter.RotSpeed = NumberRange.new(-20, 20)
    ParticleEmitter.Rate = 70
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = Part
    t1.Step()
end

local function clearAround(p6, p7) -- line: 139
    -- upvalues: GameConfig (copy), t1 (copy), t3 (copy)
    local World = workspace:FindFirstChild("World")
    local Props = World and World:FindFirstChild("Props")

    if not Props then
        return
    end

    local t11 = {}

    for _, child in ipairs(Props:GetChildren()) do
        for _, child in ipairs(child:GetChildren()) do
            if child:IsA("Folder") then
                for _, child in ipairs(child:GetChildren()) do
                    table.insert(t11, child)
                end
            else
                table.insert(t11, child)
            end
        end
    end

    for _, v15 in ipairs(t11) do
        local BoundingBox, Position

        if v15:IsA("Model") then
            local BoundingBox2

            BoundingBox2, BoundingBox = v15:GetBoundingBox()
            Position = BoundingBox2.Position
        elseif v15:IsA("BasePart") then
            Position = v15.Position
            BoundingBox = v15.Size
        end

        if Position and Position.Y - BoundingBox.Y / 2 < GameConfig.WATER_Y then
            local v18 = math.max(math.abs(Position.X - p6.X) - BoundingBox.X / 2, 0)
            local v21 = math.max(math.abs(Position.Z - p6.Z) - BoundingBox.Z / 2, 0)

            if math.sqrt(v18 * v18 + v21 * v21) < p7 then
                local t12 = if v15:IsA("BasePart") then { v15 } else {}

                for _, descendant in ipairs(v15:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        table.insert(t12, descendant)
                    end
                end

                for _, v23 in ipairs(t12) do
                    if v23.LocalTransparencyModifier < 1 then
                        v23.LocalTransparencyModifier = 1
                        table.insert(t3, v23)
                    end
                end
            end
        end
    end

    t1.Hidden = #t3
end

function t1.Track(p8, p9, p10, p11) -- line: 189
    -- upvalues: Lighting (copy), t1 (copy), Folder (ref), DepthOfFieldEffect (ref), Part2 (ref), PointLight (ref), t6 (ref), clearAround (copy)
    if not t6 then
        return
    end

    t6.track = {
        model = p8,
        offset = p9,
        radius = math.max(p10, 1)
    }
    t1.Tracking = true
    clearAround(t6.B, p11)
    DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")
    DepthOfFieldEffect.Name = "RevealFocus"
    DepthOfFieldEffect.FarIntensity = 0.55
    DepthOfFieldEffect.NearIntensity = 0.12
    DepthOfFieldEffect.Parent = Lighting

    local Part = Instance.new("Part")

    Part.Name = "Rim"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Parent = Folder
    Part2 = Part
    PointLight = Instance.new("PointLight")
    PointLight.Color = t6.light
    PointLight.Brightness = 1.6
    PointLight.Range = math.clamp(p10 * 2.4 + 12, 12, 60)
    PointLight.Shadows = false
    PointLight.Parent = Part2
    t1.Step()
end

function t1.Surface() -- line: 212
    -- upvalues: ParticleEmitter (ref), t2 (copy), t6 (ref)
    if not t6 then
        return
    end

    t6.surface = true

    for _, v25 in ipairs(t2) do
        v25.beam.Enabled = false
    end

    if ParticleEmitter then
        ParticleEmitter.Enabled = false
    end
end

function t1.Darken(p12, p13) -- line: 225
    -- upvalues: fromRGB (copy), t6 (ref)
    if t6 then
        t6.dark = {
            from = t6.deep,
            to = t6.deep:Lerp(fromRGB(0, 0, 0), p12),
            t0 = os.clock(),
            len = math.max(p13, 0.01),
            amount = p12
        }
    end
end

function t1.Step() -- line: 233
    -- upvalues: Lighting (copy), GameConfig (copy), new (copy), CurrentCamera (copy), Part (ref), ParticleEmitter (ref), DepthOfFieldEffect (ref), Part2 (ref), t2 (copy), t6 (ref)
    if not t6 then
        return
    end

    if t6.dark then
        local v27 = math.clamp((os.clock() - t6.dark.t0) / t6.dark.len, 0, 1)

        t6.deep = t6.dark.from:Lerp(t6.dark.to, v27)

        for _, v28 in ipairs(t2) do
            v28.beam.Brightness = 1 - t6.dark.amount * v27
        end

        if ParticleEmitter then
            ParticleEmitter.Brightness = 1 - t6.dark.amount * v27
        end

        Lighting.FogColor = t6.deep
    end

    local _CFrame = CurrentCamera.CFrame
    local CFramePosition = _CFrame.Position
    local v29 = os.clock() - t6.t0
    local v30 = CFramePosition.Y < GameConfig.WATER_Y - 0.3

    if ParticleEmitter then
        Part.CFrame = CFrame.new(CFramePosition + _CFrame.LookVector * 14)
        ParticleEmitter.Enabled = v30 and not t6.surface
    end

    local track = t6.track
    local Position, Magnitude, radius

    if track and track.model.Parent then
        Position = (track.model:GetPivot() * CFrame.new(track.offset)).Position
        Magnitude = (CFramePosition - Position).Magnitude
        radius = track.radius
    end

    if not t6.surface then
        for _, v31 in ipairs(t2) do
            local v36 = new(math.sin(v29 * v31.speed + v31.phase) * 2.2, 0, math.cos(v29 * v31.speed * 0.8 + v31.phase) * 1.6)

            v31.a0.WorldPosition = v31.top + v36
            v31.a1.WorldPosition = v31.bottom + v36 * 3

            if Position then
                local v37 = ((v31.top + v31.bottom) / 2 - CFramePosition):Dot(_CFrame.LookVector)

                v31.beam.Enabled = Magnitude * 0.9 + radius * 0.5 < v37
            else
                v31.beam.Enabled = true
            end
        end
    end

    if Position and v30 then
        Lighting.FogColor = t6.deep
        Lighting.FogStart = Magnitude + radius * 0.25
        Lighting.FogEnd = Magnitude + radius * 1.6 + 55

        if DepthOfFieldEffect then
            DepthOfFieldEffect.FocusDistance = Magnitude
            DepthOfFieldEffect.InFocusRadius = radius + 2
        end

        if Part2 then
            local Unit = (Position - CFramePosition).Unit

            Part2.CFrame = CFrame.new(Position + Unit * (radius * 0.9 + 2) + new(0, radius * 0.7 + 1.5, 0))
        end
    elseif DepthOfFieldEffect then
        DepthOfFieldEffect.FarIntensity = 0
        DepthOfFieldEffect.NearIntensity = 0
    end
end

function t1.End() -- line: 298
    -- upvalues: t1 (copy), Folder (ref), Part (ref), ParticleEmitter (ref), DepthOfFieldEffect (ref), Part2 (ref), PointLight (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (ref)
    for _, v40 in ipairs(t3) do
        if v40.Parent then
            v40.LocalTransparencyModifier = 0
        end
    end

    table.clear(t3)

    for _, v41 in ipairs(t4) do
        if v41[1].Parent then
            v41[1].Transparency = v41[2]
        end
    end

    table.clear(t4)

    for _, v42 in ipairs(t5) do
        if v42[1].Parent then
            v42[1].Color = v42[2]
            v42[1].MaterialVariant = v42[3]
        end
    end

    table.clear(t5)
    table.clear(t2)

    if Folder then
        Folder:Destroy()
        Folder = nil
    end

    if DepthOfFieldEffect then
        DepthOfFieldEffect:Destroy()
        DepthOfFieldEffect = nil
    end

    Part = nil
    ParticleEmitter = nil
    Part2 = nil
    PointLight = nil
    t6 = nil
    t1.Active = false
    t1.Tracking = false
end

return t1
