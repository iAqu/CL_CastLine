-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Shapes = require(script.Parent.Shapes)

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(255, 236, 252)
local t1 = {}

local function rainbow() -- line: 62
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 220)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(90, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 255, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 230, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
end

local function fadeOut(p1) -- line: 72
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p1),
        NumberSequenceKeypoint.new(0.7, p1),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function arm(p2, p3, p4) -- line: 82
    local v2 = (p3 - 1) / 7 * 3.141592653589793 * 2
    local v5 = Vector3.new(math.cos(v2), math.sin(v2), 0)
    local v8 = Vector3.new(-math.sin(v2), math.cos(v2), 0)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = ("Rim%*"):format(p3)
    Attachment.CFrame = CFrame.fromMatrix(v5 * 36 * 0.9, v8, v5)
    Attachment.Parent = p2

    local v9 = v2 + 1.9
    local v12 = Vector3.new(math.cos(v9), math.sin(v9), 0)
    local v15 = Vector3.new(-math.sin(v9), math.cos(v9), 0)
    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = ("Eye%*"):format(p3)
    Attachment2.CFrame = CFrame.fromMatrix(v12 * 1.2, -v12, v15)
    Attachment2.Parent = p2

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.CurveSize0 = 19.8
    Beam.CurveSize1 = 10.799999999999999
    Beam.FaceCamera = true
    Beam.Segments = 16
    Beam.Width0 = 3.2
    Beam.Width1 = 0.35
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Brightness = 1.6
    Beam.Color = ColorSequence.new(p4, Color3.new(1, 1, 1))
    Beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    Beam.Enabled = false
    Beam.Parent = p2

    return Beam
end

local function sparkles(p5) -- line: 120
    -- upvalues: rainbow (copy), fadeOut (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Sparkles"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Cylinder
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
    ParticleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward
    ParticleEmitter.Rate = 0
    ParticleEmitter.Speed = NumberRange.new(30, 46)
    ParticleEmitter.Lifetime = NumberRange.new(0.75, 1.05)
    ParticleEmitter.LockedToPart = true
    ParticleEmitter.Size = NumberSequence.new(1, 0.15)
    ParticleEmitter.Transparency = fadeOut(0)
    ParticleEmitter.Color = rainbow()
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Brightness = 2
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-180, 180)
    ParticleEmitter.Parent = p5

    return ParticleEmitter
end

local function flare(p6) -- line: 144
    -- upvalues: v1 (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Flare"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.Speed = NumberRange.new(0)
    ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.5)
    ParticleEmitter.LockedToPart = true
    ParticleEmitter.Size = NumberSequence.new(5.3999999999999995, 9)
    ParticleEmitter.Transparency = NumberSequence.new(0.3, 1)
    ParticleEmitter.Color = ColorSequence.new(v1)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Brightness = 3
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-240, 240)
    ParticleEmitter.Parent = p6

    return ParticleEmitter
end

function t1.Build(p7, p8, p9) -- line: 163
    -- upvalues: Shapes (copy), v1 (copy), arm (copy), sparkles (copy), flare (copy)
    local v16 = p7:Add(Shapes.Part("WhirlpoolFloor", (Vector3.new(0, 0, 0))))

    v16.Shape = Enum.PartType.Cylinder

    local v17 = p7:Add(Shapes.Part("WhirlpoolEye", (Vector3.new(0, 0, 0))))

    v17.Shape = Enum.PartType.Ball
    v17.Color = v1

    local t2 = {}

    for i = 1, 6 do
        local v18 = Shapes.Circle(("WhirlpoolRing%*"):format(i), 0.1)

        p7:Add(v18.Hub)
        Shapes.Paint(v18, (i - 1) / 6, 0.45)
        table.insert(t2, v18)
    end

    local v19 = p7:Add(Shapes.Part("WhirlpoolArms", (Vector3.new(1, 1, 1))))

    v19.Transparency = 1

    local t3 = {}

    for i = 1, 7 do
        table.insert(t3, (arm(v19, i, p9[(i - 1) % #p9 + 1])))
    end

    local v22 = p7:Add(Shapes.Part("WhirlpoolPull", (Vector3.new(68.4, 3, 68.4))))

    v22.Transparency = 1

    local t4 = {
        v16,
        v17,
        v19,
        v22
    }

    for _, v23 in t2 do
        table.insert(t4, v23.Hub)
    end

    for _, v24 in t4 do
        v24.Parent = p8
    end

    return {
        Floor = v16,
        Eye = v17,
        Rings = t2,
        Arms = v19,
        ArmBeams = t3,
        Pull = v22,
        Sparkles = sparkles(v22),
        Flare = flare(v17),
        Moving = t4,
        Frames = table.create(#t4)
    }
end

function t1.Step(p10, p11, p12, p13, p14) -- line: 214
    -- upvalues: TweenService (copy), Workspace (copy), Shapes (copy)
    local v25 = CFrame.new(p11) * CFrame.Angles(-1.5707963267948966, 0, 0)
    local Frames = p10.Frames
    local v26 = math.clamp(p13, 0, 1) * 72

    p10.Floor.Size = Vector3.new(0.6, v26, v26)
    p10.Floor.Color = Color3.fromHSV(math.sin(p12 * 1.3) * 0.06 + 0.8, 0.9, 0.42)
    Frames[1] = CFrame.new(p11) * CFrame.Angles(0, 0, 1.5707963267948966)

    local v29 = math.sin(p12 * 14) * 0.08 + 1
    local v31 = math.lerp(p13 * 4.5, 7, p14) * v29

    p10.Eye.Size = Vector3.new(1, 1, 1) * math.max(v31, 0.05)
    Frames[2] = CFrame.new(p11 + Vector3.new(0, 1, 0))
    Frames[3] = v25 * CFrame.new(0, 0, 0.5) * CFrame.Angles(0, 0, p12 * -2.6)
    Frames[4] = CFrame.new(p11 + Vector3.new(0, 1, 0)) * CFrame.Angles(0, p12 * 0.9, 0)

    for v32, v33 in p10.Rings do
        local v34 = (v32 - 1) / 5
        local Value = TweenService:GetValue(math.clamp(p13 * 1.5 - (v32 - 1) * 0.12, 0, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v37 = math.sin(p12 * 5 + v32) * 0.06 + 1
        local v38 = math.lerp(5, 33.120000000000005, v34)

        Shapes.Resize(v33, (math.max(v38 * Value * v37, 0.05)))
        Shapes.SetWidth(v33, math.clamp(Value, 0, 1) * 1.2)

        local v40 = p12 * 1.6 * (if v32 % 2 == 0 then 1 else -1)

        Frames[v32 + 4] = v25 * CFrame.new(0, 0, 0.4) * CFrame.Angles(0, 0, v40)
    end

    local v41 = p13 >= 0.25

    for _, v42 in p10.ArmBeams do
        v42.Enabled = v41
    end

    p10.Sparkles.Rate = p13 * 150
    p10.Flare.Rate = p13 * 24
    Workspace:BulkMoveTo(p10.Moving, Frames, Enum.BulkMoveMode.FireCFrameChanged)
end

return table.freeze(t1)
