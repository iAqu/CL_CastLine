-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(70, 255, 90)
local v3 = Color3.fromRGB(20, 210, 60)
local v4 = Color3.fromRGB(170, 255, 60)
local t1 = {}
local t2 = {}

t2.__index = t2

local function asset(...) -- line: 87
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v5 in { ... } do
        Assets = if Assets then Assets:FindFirstChild(v5) else nil
    end

    return if Assets and Assets:IsA("Sound") then Assets else nil
end

local function ease(p1, p2, p3, p4) -- line: 95
    return p1 + (p2 - p1) * (1 - math.exp(-p3 * p4))
end

local function fade(p5, p6) -- line: 99
    local t3 = {}

    for v8, v9 in p5 do
        local v10 = (v8 - 1) / (#p5 - 1)

        table.insert(t3, NumberSequenceKeypoint.new(v10, 1 - (1 - v9) * p6))
    end

    return NumberSequence.new(t3)
end

local function newBeam(p7, p8, p9) -- line: 108
    local Beam = Instance.new("Beam")

    Beam.Name = p8
    Beam.Attachment0 = p7
    Beam.Texture = p9
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.FaceCamera = true
    Beam.LightEmission = 0.35
    Beam.LightInfluence = 0
    Beam.Segments = 24
    Beam.Enabled = false
    Beam.Parent = p7

    return Beam
end

local function newEmitter(p10, p11, p12) -- line: 123
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = p11
    ParticleEmitter.Texture = p12
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = p10

    return ParticleEmitter
end

local function catchEmitters() -- line: 135
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local VFX = Assets and Assets:FindFirstChild("VFX")
    local Butterflies = VFX and VFX:FindFirstChild("Butterflies")
    local Catch = Butterflies and Butterflies:FindFirstChild("Catch")
    local t4 = {}

    if Catch ~= nil then
        for _, descendant in Catch:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                table.insert(t4, descendant)
            end
        end
    end

    return t4
end

local function mouthFor(p13) -- line: 152
    -- upvalues: Audio (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy)
    local v12 = t1[p13]

    if v12 and v12.Attachment.Parent ~= nil then
        return v12
    end

    if v12 then
        v12.Trove:Destroy()
        t1[p13] = nil
    end

    local Parent = p13.Parent
    local v13, v14, t5, v15

    if Parent ~= nil then
        if Parent:IsA("BasePart") then
            v13 = Trove.new()
            v14 = v13:Add(Instance.new("Attachment"))
            v14.Name = "GhostSuctionMouth"
            v14.CFrame = p13.CFrame
            v14.Parent = Parent

            local PointLight = Instance.new("PointLight")

            PointLight.Name = "SuctionGlow"
            PointLight.Color = v2
            PointLight.Brightness = 0
            PointLight.Range = 10
            PointLight.Shadows = false
            PointLight.Parent = v14

            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Name = "SuctionVortex"
            ParticleEmitter.Texture = "rbxassetid://109600784699514"
            ParticleEmitter.LightEmission = 0.5
            ParticleEmitter.LightInfluence = 0
            ParticleEmitter.Rate = 0
            ParticleEmitter.Enabled = false
            ParticleEmitter.Parent = v14
            ParticleEmitter.Color = ColorSequence.new(v2, v4)
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.8),
                NumberSequenceKeypoint.new(1, 0.15)
            })
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.25, 0.25),
                NumberSequenceKeypoint.new(1, 0.5)
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.3, 0.38)
            ParticleEmitter.Speed = NumberRange.new(0)
            ParticleEmitter.Rotation = NumberRange.new(0, 360)
            ParticleEmitter.RotSpeed = NumberRange.new(-420, -260)
            ParticleEmitter.LockedToPart = true

            local ParticleEmitter2 = Instance.new("ParticleEmitter")

            ParticleEmitter2.Name = "SuctionSparks"
            ParticleEmitter2.Texture = "rbxassetid://6749866161"
            ParticleEmitter2.LightEmission = 0.5
            ParticleEmitter2.LightInfluence = 0
            ParticleEmitter2.Rate = 0
            ParticleEmitter2.Enabled = false
            ParticleEmitter2.Parent = v14
            ParticleEmitter2.Color = ColorSequence.new(v2:Lerp(v1, 0.35), v3)
            ParticleEmitter2.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.25),
                NumberSequenceKeypoint.new(1, 0)
            })
            ParticleEmitter2.Lifetime = NumberRange.new(0.15, 0.25)
            ParticleEmitter2.Speed = NumberRange.new(0.5, 2)
            ParticleEmitter2.SpreadAngle = Vector2.new(180, 180)
            ParticleEmitter2.LockedToPart = true
            t5 = {
                Startup = nil,
                Hum = nil,
                Intensity = 0,
                Progress = 0,
                Angle = 0,
                Fed = false,
                Nozzle = p13,
                Attachment = v14,
                Light = PointLight,
                Vortex = ParticleEmitter,
                Inflow = ParticleEmitter2,
                Born = os.clock(),
                Trove = v13
            }

            local v16 = Audio.Play(114059897952698, v14, {
                Volume = 0.5,
                MaxDistance = 60
            })

            if v16 then
                t5.Startup = v13:Add(v16)
            else
                t5.Born -= 2.2
            end

            v15 = false
        else
            v15 = true
        end
    else
        v15 = true
    end

    if v15 then
        return nil
    end

    local v17 = Audio.Play(100665426632741, v14, {
        Looped = true,
        Volume = 0,
        MaxDistance = 60
    })

    if v17 then
        t5.Hum = v13:Add(v17)
    end

    t1[p13] = t5

    return t5
end

local function feed(p14, p15) -- line: 243
    -- upvalues: mouthFor (copy)
    local v18 = mouthFor(p14)

    if v18 == nil then
        return nil
    end

    v18.Fed = true
    v18.Progress = p15

    return v18.Attachment
end

function t2.Step(p16) -- line: 253
    -- upvalues: v1 (copy), v2 (copy), t1 (copy)
    local elapsed = os.clock()

    for v19, v20 in t1 do
        if v20.Attachment.Parent == nil or v19.Parent == nil then
            v20.Trove:Destroy()
            t1[v19] = nil
        else
            local Intensity = v20.Intensity
            local v21 = if v20.Fed then 1 else 0
            local v22 = if v20.Fed then 14 else 8

            v20.Intensity = Intensity + (v21 - Intensity) * (1 - math.exp(-v22 * p16))

            if not v20.Fed then
                local Progress = v20.Progress

                v20.Progress = Progress + (0 - Progress) * (1 - math.exp(p16 * -6))
            end

            local Intensity2, Progress = v20.Intensity, v20.Progress

            v20.Angle = (v20.Angle + p16 * (Progress * 14 + 5)) % 6.283185307179586
            v20.Attachment.CFrame = v19.CFrame * CFrame.Angles(0, 0, v20.Angle)
            v20.Light.Brightness = (Progress * 3.5 + 2.5 + math.sin(elapsed * 22) * 0.6) * Intensity2
            v20.Light.Range = Progress * 8 + 8
            v20.Light.Color = v2:Lerp(v1, Progress * 0.5)
            v20.Vortex.Enabled = Intensity2 > 0.05
            v20.Vortex.Rate = (Progress * 10 + 7) * Intensity2
            v20.Inflow.Enabled = Intensity2 > 0.05
            v20.Inflow.Rate = (Progress * 40 + 20) * Intensity2

            local Startup = v20.Startup

            if Startup and Startup.Parent ~= nil then
                Startup.Volume = math.min(Intensity2 * 4, 1) * 0.5
            end

            local Hum = v20.Hum

            if Hum then
                local v31 = math.clamp((elapsed - v20.Born - 1.4) / 0.8, 0, 1)

                Hum.Volume = (Progress * 0.13 + 0.42) * Intensity2 * v31
                Hum.PlaybackSpeed = Progress * 0.15 + 0.95
            end

            if v20.Fed then
                v20.Fed = false
            elseif Intensity2 < 0.01 then
                v20.Trove:Destroy()
                t1[v19] = nil
            else
                v20.Fed = false
            end
        end
    end
end

function t2.new(p17) -- line: 296
    -- upvalues: Workspace (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t2 (copy)
    local v32 = Trove.new()

    v32:Connect(p17.Destroying, function() -- line: 298
        -- upvalues: v32 (copy)
        v32:Destroy()
    end)

    local v33 = v32:Add(Instance.new("Attachment"))

    v33.Name = "GhostSuctionPoint"
    v33.WorldCFrame = p17:GetPivot()
    v33.Parent = Workspace.Terrain

    local Beam = Instance.new("Beam")

    Beam.Name = "SuctionVortex"
    Beam.Attachment0 = v33
    Beam.Texture = "rbxassetid://18925205019"
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.FaceCamera = true
    Beam.LightEmission = 0.35
    Beam.LightInfluence = 0
    Beam.Segments = 24
    Beam.Enabled = false
    Beam.Parent = v33
    Beam.TextureLength = 4
    Beam.TextureSpeed = 2.6
    Beam.Brightness = 3
    Beam.LightEmission = 0.35
    Beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v3),
        ColorSequenceKeypoint.new(0.5, v2),
        ColorSequenceKeypoint.new(1, v4)
    })

    local Beam2 = Instance.new("Beam")

    Beam2.Name = "SuctionCore"
    Beam2.Attachment0 = v33
    Beam2.Texture = "rbxassetid://15939596990"
    Beam2.TextureMode = Enum.TextureMode.Wrap
    Beam2.FaceCamera = true
    Beam2.LightEmission = 0.35
    Beam2.LightInfluence = 0
    Beam2.Segments = 24
    Beam2.Enabled = false
    Beam2.Parent = v33
    Beam2.TextureLength = 2
    Beam2.TextureSpeed = 5
    Beam2.Brightness = 6
    Beam2.ZOffset = 0.1
    Beam2.Color = ColorSequence.new(Color3.fromRGB(40, 150, 50), Color3.fromRGB(15, 120, 30))

    local t6 = {}

    for i = 1, 2 do
        local v34 = "SuctionRibbon" .. i
        local Beam = Instance.new("Beam")

        Beam.Name = v34
        Beam.Attachment0 = v33
        Beam.Texture = "rbxassetid://14261159751"
        Beam.TextureMode = Enum.TextureMode.Wrap
        Beam.FaceCamera = true
        Beam.LightEmission = 0.35
        Beam.LightInfluence = 0
        Beam.Segments = 24
        Beam.Enabled = false
        Beam.Parent = v33
        Beam.TextureLength = 3
        Beam.TextureSpeed = i + 3.5
        Beam.Brightness = 4
        Beam.ZOffset = 0.05
        Beam.Color = ColorSequence.new(v2, v4)
        table.insert(t6, Beam)
    end

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "SuctionMotes"
    ParticleEmitter.Texture = "rbxassetid://6749866161"
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = v33
    ParticleEmitter.Color = ColorSequence.new(v2:Lerp(v1, 0.35), v2)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.65),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    ParticleEmitter.Transparency = NumberSequence.new(0.1, 0.4)
    ParticleEmitter.Lifetime = NumberRange.new(0.32)
    ParticleEmitter.SpreadAngle = Vector2.new(14, 14)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Front

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "SuctionSouls"
    ParticleEmitter2.Texture = "rbxassetid://15580440964"
    ParticleEmitter2.LightEmission = 0.5
    ParticleEmitter2.LightInfluence = 0
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Enabled = false
    ParticleEmitter2.Parent = v33
    ParticleEmitter2.Color = ColorSequence.new(v3, v2)
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.1),
        NumberSequenceKeypoint.new(1, 0.15)
    })
    ParticleEmitter2.Transparency = NumberSequence.new(0, 0.3)
    ParticleEmitter2.Lifetime = NumberRange.new(0.32)
    ParticleEmitter2.Rotation = NumberRange.new(0, 360)
    ParticleEmitter2.RotSpeed = NumberRange.new(-300, 300)
    ParticleEmitter2.SpreadAngle = Vector2.new(22, 22)
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Front

    local ParticleEmitter3 = Instance.new("ParticleEmitter")

    ParticleEmitter3.Name = "SuctionWisps"
    ParticleEmitter3.Texture = "rbxassetid://84182473776460"
    ParticleEmitter3.LightEmission = 0.5
    ParticleEmitter3.LightInfluence = 0
    ParticleEmitter3.Rate = 0
    ParticleEmitter3.Enabled = false
    ParticleEmitter3.Parent = v33
    ParticleEmitter3.Color = ColorSequence.new(v2, v3)
    ParticleEmitter3.LightEmission = 0.6
    ParticleEmitter3.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.4),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    ParticleEmitter3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter3.Lifetime = NumberRange.new(0.4, 0.55)
    ParticleEmitter3.Rotation = NumberRange.new(0, 360)
    ParticleEmitter3.RotSpeed = NumberRange.new(-120, 120)
    ParticleEmitter3.SpreadAngle = Vector2.new(55, 55)
    ParticleEmitter3.EmissionDirection = Enum.NormalId.Front

    return (setmetatable({
        Highlight = nil,
        Mouth = nil,
        Pull = nil,
        Intensity = 0,
        Spin = 0,
        SpinRate = 0,
        Clock = 0,
        Model = p17,
        Trove = v32,
        Point = v33,
        Vortex = Beam,
        Core = Beam2,
        Ribbons = t6,
        Motes = ParticleEmitter,
        Souls = ParticleEmitter2,
        Wisps = ParticleEmitter3
    }, t2))
end

function t2.Scale(p18, p19) -- line: 398
    local v36 = math.sin(p18.Clock * (p19 * 22 + 10)) * 0.05 * p18.Intensity

    return (1 - p19 * 0.82) * (1 + v36)
end

function t2.Pose(p20, p21, p22, p23, p24) -- line: 403
    p20.Clock += p24

    local v37 = if p22 then p23 ^ 1.3 * 24 + 2 else 0
    local SpinRate = p20.SpinRate
    local v38 = if p22 then 6 else 4

    p20.SpinRate = SpinRate + (v37 - SpinRate) * (1 - math.exp(-v38 * p24))
    p20.Spin = (p20.Spin + p20.SpinRate * p24) % 6.283185307179586

    if p22 == nil and p20.SpinRate < 1.5 then
        local Spin = p20.Spin

        p20.Spin = Spin + ((if p20.Spin > 3.141592653589793 then 6.283185307179586 else 0) - Spin) * (1 - math.exp(p24 * -8))
    end

    if p22 then
        p20.Pull = p22.WorldPosition
    elseif p23 < 0.001 then
        p20.Pull = nil
    end

    local Position = p21.Position
    local Pull = p20.Pull

    if Pull then
        Position = Position:Lerp(Pull, p23 * 0.8)
    end

    local v43

    if not p22 then
        v43 = 0

        return CFrame.new(Position) * p21.Rotation * CFrame.Angles(0, p20.Spin, v43)
    end

    local v44 = (p23 * 0.22 + 0.04) * p20.Intensity
    local v45 = p20.Clock * 11

    Position += Vector3.new(math.noise(v45, 1.3), math.noise(v45, 2.7), math.noise(v45, 4.1)) * v44
    v43 = math.sin(p20.Clock * 15) * (p23 * 0.1 + 0.07)

    return CFrame.new(Position) * p21.Rotation * CFrame.Angles(0, p20.Spin, v43)
end

function t2.Update(p25, p26, p27, p28) -- line: 437
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), fade (copy), mouthFor (copy)
    local Attachment

    if p26 then
        local v49 = mouthFor(p26)

        if v49 ~= nil then
            v49.Fed = true
            v49.Progress = p27
            Attachment = v49.Attachment
        end
    end

    if Attachment then
        p25.Mouth = Attachment
    end

    local v50 = Attachment ~= nil
    local Intensity = p25.Intensity
    local v52 = if v50 then 1 else 0
    local v51 = if v50 then 14 else 9

    p25.Intensity = Intensity + (v52 - Intensity) * (1 - math.exp(-v51 * p28))

    local Intensity2, Mouth = p25.Intensity, p25.Mouth
    local t8 = {
        p25.Vortex,
        p25.Core,
        p25.Ribbons[1],
        p25.Ribbons[2]
    }
    local t9 = {
        p25.Motes,
        p25.Souls,
        p25.Wisps
    }

    if not (Intensity2 < 0.01) and Mouth ~= nil and Mouth.Parent ~= nil then
        local Clock = p25.Clock
        local Position = p25.Model:GetPivot().Position
        local WorldPosition = Mouth.WorldPosition
        local Magnitude = (WorldPosition - Position).Magnitude

        p25.Point.WorldCFrame = CFrame.lookAt(Position, WorldPosition) * CFrame.Angles(0, 0, Clock * 6)

        local v56 = math.sin(Clock * (p27 * 16 + 12)) * 0.15 + 1
        local v57 = 1 - p27

        for _, v58 in t8 do
            v58.Attachment1 = Mouth
            v58.Enabled = true
        end

        p25.Vortex.Width0 = (v57 * 2.8 + 0.9) * v56
        p25.Vortex.Width1 = p27 * 0.4 + 0.8
        p25.Vortex.CurveSize0 = math.sin(Clock * 7) * 0.5
        p25.Vortex.CurveSize1 = math.cos(Clock * 5) * 0.3
        p25.Vortex.Transparency = fade({ 0.2, 0.05, 0 }, Intensity2)
        p25.Core.Width0 = (v57 * 1.1 + 0.35) * v56
        p25.Core.Width1 = p27 * 0.2 + 0.3
        p25.Core.Transparency = fade({ 0.35, 0.1, 0 }, Intensity2)

        local v62 = math.min(Magnitude * 0.35, 3) * (1 - p27 * 0.5)

        for v63, v64 in p25.Ribbons do
            local v65 = if v63 == 1 then 1 else -1

            v64.Width0 = v57 * 0.5 + 0.15
            v64.Width1 = 0.12
            v64.CurveSize0 = v65 * v62 * math.sin(Clock * 9 + v63)
            v64.CurveSize1 = -v65 * v62 * 0.45 * math.cos(Clock * 9 + v63)
            v64.Transparency = fade({ 0.6, 0.15, 0.3 }, Intensity2)
        end

        local v71 = math.clamp(Magnitude / 0.32, 4, 80)

        p25.Motes.Speed = NumberRange.new(v71 * 0.85, v71)
        p25.Motes.Rate = (p27 * 60 + 45) * Intensity2
        p25.Souls.Speed = NumberRange.new(v71 * 0.8, v71)
        p25.Souls.Rate = (p27 * 14 + 8) * Intensity2
        p25.Wisps.Speed = NumberRange.new(v71 * 0.35, v71 * 0.6)
        p25.Wisps.Rate = (p27 * 18 + 10) * Intensity2

        for _, v72 in t9 do
            v72.Enabled = v50
        end

        local Highlight = p25.Highlight

        if Highlight == nil then
            Highlight = p25.Trove:Add(Instance.new("Highlight"))
            Highlight.Name = "GhostSuctionGlow"
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Adornee = p25.Model
            Highlight.Parent = p25.Model
            p25.Highlight = Highlight
        end

        local v74 = math.sin(Clock * (p27 * 16 + 7)) * 0.5 + 0.5

        Highlight.FillColor = v2:Lerp(v1, (math.min(p27 * 0.6 + v74 * 0.25, 1)))
        Highlight.OutlineColor = v1:Lerp(v3, v74 * 0.6)
        Highlight.FillTransparency = 1 - math.clamp(v74 * 0.3 + 0.12 + p27 * 0.18, 0, 0.6) * Intensity2
        Highlight.OutlineTransparency = 1 - (v74 * 0.45 + 0.55) * Intensity2
    else
        for _, v77 in t8 do
            v77.Enabled = false
        end

        for _, v78 in t9 do
            v78.Enabled = false
        end

        local Highlight = p25.Highlight

        if Highlight then
            p25.Highlight = nil
            p25.Trove:Remove(Highlight)
        end

        if not v50 then
            p25.Mouth = nil
        end
    end
end

function t2.Destroy(p29) -- line: 525
    p29.Highlight = nil
    p29.Mouth = nil
    p29.Trove:Destroy()
end

function t2.Captured(p30, p31) -- line: 531
    -- upvalues: TweenService (copy), Audio (copy), v1 (copy), v2 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "GhostCaptureFlash"
    Highlight.FillColor = v1
    Highlight.FillTransparency = 0
    Highlight.OutlineColor = v2
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Adornee = p30
    Highlight.Parent = p30
    TweenService:Create(Highlight, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        FillTransparency = 0.5,
        FillColor = v2
    }):Play()

    local v79 = if not p31 or p31.Parent == nil then p30:GetPivot() else p31

    Audio.Play(83010339546205, v79, {
        Volume = 0.65,
        MaxDistance = 60
    })
end

function t2.CaptureSpin(p32) -- line: 551
    return p32 * 6.283185307179586 * 3
end

function t2.Burst(p33, p34) -- line: 555
    -- upvalues: TweenService (copy), Workspace (copy), Audio (copy), Flash (copy), Shake (copy), VFX (copy), v1 (copy), v2 (copy), asset (copy), catchEmitters (copy)
    local WorldPosition = p33.WorldPosition

    VFX.EmitAt(WorldPosition, catchEmitters(), function(p35) -- line: 557
        -- upvalues: v1 (copy), v2 (copy)
        if p35:GetAttribute("TierTint") == true then
            p35.Color = ColorSequence.new(v1, v2)
        end
    end)

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "GhostCaptureBurst"
    Attachment.WorldPosition = WorldPosition
    Attachment.Parent = Workspace.Terrain

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Brightness = 9
    PointLight.Range = 18
    PointLight.Shadows = false
    PointLight.Parent = Attachment
    TweenService:Create(PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Range = 6
    }):Play()
    VFX.Discard(Attachment, 0.4)

    local v80 = if p34 then nil else asset("ShootingStar", "Sounds", "BuddyPop")

    if v80 then
        Audio.Play(v80, WorldPosition, {
            Volume = 0.85,
            MaxDistance = 60,
            PlaybackSpeed = { 1, 1.15 }
        })
    end

    local v81 = if p34 then nil else asset("HalloweenDimension", "Sounds", "PumpkinCatch")

    if v81 then
        Audio.Play(v81, WorldPosition, {
            Volume = 0.5,
            MaxDistance = 60,
            PlaybackSpeed = { 0.95, 1.05 }
        })
    end

    Flash.Play({
        Attack = 0.02,
        Decay = 0.28,
        Opacity = 0.18,
        Tint = v2
    })
    Shake.Play({
        Seconds = 0.22,
        Magnitude = 0.3,
        Shape = "Fade"
    })
end

return t2
