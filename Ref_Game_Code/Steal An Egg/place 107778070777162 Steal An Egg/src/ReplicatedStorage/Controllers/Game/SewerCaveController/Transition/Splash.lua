-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Kit = require(script.Parent.Kit)

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(190, 250, 240)
local t1 = {}

function t1.Build(p1, p2, p3) -- line: 48
    -- upvalues: Kit (copy), v1 (copy)
    local v2 = p1:Add(Kit.Part({
        Name = "SewerDrainSplash",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    }))
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Burst"
    Attachment.Parent = v2

    local v3 = if p3 then 0.6 else 1
    local v4 = Kit.Emitter({
        Name = "Droplets",
        Texture = "rbxassetid://8084996370",
        LightEmission = 0.3,
        LightInfluence = 0.4,
        Acceleration = Vector3.new(0, -110, 0),
        Drag = 0.6,
        Color = ColorSequence.new(v1),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0.25)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.8, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.7, 1.1),
        Speed = NumberRange.new(26, 44),
        SpreadAngle = Vector2.new(38, 38),
        EmissionDirection = Enum.NormalId.Top,
        Orientation = Enum.ParticleOrientation.VelocityParallel
    })

    v4.Parent = Attachment

    local v5 = Kit.Emitter({
        Name = "Mist",
        Texture = "rbxassetid://11799239106",
        LightEmission = 0.1,
        LightInfluence = 0.2,
        Drag = 3,
        Color = ColorSequence.new(Color3.fromRGB(225, 255, 250)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 9)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.6, 1.1),
        Speed = NumberRange.new(4, 10),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-40, 40)
    })

    v5.Parent = Attachment

    local v6 = Kit.Emitter({
        Name = "Column",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        LightEmission = 0.15,
        LightInfluence = 0.15,
        Acceleration = Vector3.new(0, -70, 0),
        Drag = 1.5,
        Color = ColorSequence.new(Color3.fromRGB(200, 245, 238), Color3.fromRGB(110, 200, 190)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.5),
            NumberSequenceKeypoint.new(0.4, 4.5),
            NumberSequenceKeypoint.new(1, 6)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(0.6, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.55, 0.85),
        Speed = NumberRange.new(24, 38),
        SpreadAngle = Vector2.new(10, 10),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-90, 90)
    })

    v6.Parent = Attachment

    local v7 = Kit.Emitter({
        Name = "Core",
        Texture = "rbxasset://textures/particles/explosion01_core_main.dds",
        LightEmission = 0.6,
        LightInfluence = 0,
        Color = ColorSequence.new(Color3.fromRGB(220, 255, 248)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 8)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.25, 0.35),
        Speed = NumberRange.new(0, 2)
    })

    v7.Parent = Attachment

    local v8 = Kit.Emitter({
        Name = "Ring",
        Texture = "rbxassetid://109600784699514",
        LightEmission = 0.4,
        LightInfluence = 0,
        Color = ColorSequence.new(Color3.fromRGB(160, 240, 225)),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 24)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.7, 0.7),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.6)
    })

    v8.Parent = Attachment

    local v9 = Kit.Emitter({
        Name = "Ripples",
        Texture = "rbxassetid://9216446257",
        LightEmission = 0.3,
        LightInfluence = 0.3,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(Color3.fromRGB(220, 255, 250)),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Size = NumberSequence.new(10, 14),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.9, 1.3),
        SpreadAngle = Vector2.new(0, 0)
    })

    v9.Parent = Attachment

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "JetFrom"
    Attachment2.Parent = v2

    local Attachment3 = Instance.new("Attachment")

    Attachment3.Name = "JetTo"
    Attachment3.Parent = v2

    local t2 = {
        Kit.Beam({
            Name = "JetShine",
            Texture = "rbxassetid://11799004744",
            TextureLength = 5,
            TextureSpeed = 4,
            LightEmission = 1,
            Width0 = 2.6,
            Width1 = 1.2,
            FaceCamera = true,
            Enabled = false,
            Attachment0 = Attachment2,
            Attachment1 = Attachment3,
            TextureMode = Enum.TextureMode.Wrap,
            Color = ColorSequence.new(Color3.new(1, 1, 1)),
            Transparency = NumberSequence.new(0.3, 1)
        })
    }

    for _, v10 in t2 do
        v10.Parent = v2
    end

    local Attachment4 = Instance.new("Attachment")

    Attachment4.Name = "GushAt"
    Attachment4.Parent = v2

    local v11 = Kit.Emitter({
        Name = "Gush",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        LightEmission = 0.25,
        LightInfluence = 0.3,
        Acceleration = Vector3.new(0, -60, 0),
        Drag = 1,
        Color = ColorSequence.new(Color3.fromRGB(215, 252, 245), Color3.fromRGB(120, 210, 196)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.6),
            NumberSequenceKeypoint.new(0.5, 2.6),
            NumberSequenceKeypoint.new(1, 3.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.7, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.35, 0.5),
        Speed = NumberRange.new(30, 40),
        SpreadAngle = Vector2.new(7, 7),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-120, 120)
    })

    v11.Parent = Attachment4

    local v12 = Kit.Emitter({
        Name = "Spray",
        Texture = "rbxassetid://8084996370",
        LightEmission = 0.3,
        LightInfluence = 0.4,
        Acceleration = Vector3.new(0, -90, 0),
        Color = ColorSequence.new(v1),
        Size = NumberSequence.new(0.5, 0.2),
        Transparency = NumberSequence.new(0.1, 1),
        Lifetime = NumberRange.new(0.4, 0.6),
        Speed = NumberRange.new(28, 42),
        SpreadAngle = Vector2.new(14, 14),
        EmissionDirection = Enum.NormalId.Top,
        Orientation = Enum.ParticleOrientation.VelocityParallel
    })

    v12.Parent = Attachment4
    v2.Parent = p2

    return {
        Hub = v2,
        Burst = Attachment,
        Droplets = v4,
        Mist = v5,
        Column = v6,
        Core = v7,
        Ring = v8,
        Ripples = v9,
        JetFrom = Attachment2,
        JetTo = Attachment3,
        Jet = t2,
        GushAt = Attachment4,
        Gush = v11,
        Spray = v12,
        Scale = v3
    }
end

local function count(p4, p5) -- line: 278
    return (math.max(math.floor(p5 * p4.Scale + 0.5), 1))
end

function t1.Big(p6, p7) -- line: 282
    p6.Burst.WorldCFrame = CFrame.new(p7)
    p6.Droplets:Emit((math.max(math.floor(p6.Scale * 30 + 0.5), 1)))
    p6.Column:Emit((math.max(math.floor(p6.Scale * 14 + 0.5), 1)))
    p6.Core:Emit(2)
    p6.Mist:Emit((math.max(math.floor(p6.Scale * 6 + 0.5), 1)))
    p6.Ring:Emit(1)
    p6.Ripples:Emit(2)
end

function t1.Small(p8, p9) -- line: 292
    p8.Burst.WorldCFrame = CFrame.new(p9)
    p8.Droplets:Emit((math.max(math.floor(p8.Scale * 12 + 0.5), 1)))
    p8.Ripples:Emit(1)
end

function t1.Land(p10, p11) -- line: 298
    p10.Burst.WorldCFrame = CFrame.new(p11)
    p10.Droplets:Emit((math.max(math.floor(p10.Scale * 10 + 0.5), 1)))
    p10.Mist:Emit((math.max(math.floor(p10.Scale * 2 + 0.5), 1)))
end

function t1.Crown(p12, p13) -- line: 304
    p12.Burst.WorldCFrame = p13
    p12.Droplets:Emit((math.max(math.floor(p12.Scale * 20 + 0.5), 1)))
end

function t1.Jet(p14, p15, p16, p17) -- line: 309
    local v29 = p17 > 0.001

    p14.JetFrom.WorldPosition = p15
    p14.JetTo.WorldPosition = p15:Lerp(p16, (math.clamp(p17, 0, 1)))

    for _, v30 in p14.Jet do
        v30.Enabled = v29
    end

    if (p16 - p15).Magnitude > 0.01 then
        p14.GushAt.WorldCFrame = CFrame.lookAt(p15, p16) * CFrame.Angles(-1.5707963267948966, 0, 0)
    end

    local v31 = if v29 then p14.Scale * 70 * math.clamp(p17, 0, 1) else 0

    p14.Gush.Rate = v31
    p14.Spray.Rate = v31 * 0.6
end

function t1.Drips(p18, p19, p20) -- line: 325
    -- upvalues: Kit (copy)
    local v32 = p18:Add(Instance.new("Attachment"))

    v32.Name = "SewerDrainDrips"
    v32.Position = Vector3.new(0, p19.Size.Y * 0.3, 0)
    v32.Parent = p19

    local v34 = Kit.Emitter({
        Name = "Drips",
        Texture = "rbxassetid://7027357365",
        LightEmission = 0.25,
        LightInfluence = 0.6,
        Acceleration = Vector3.new(0, -60, 0),
        Rate = 9,
        Color = ColorSequence.new(Color3.fromRGB(205, 250, 245)),
        Size = NumberSequence.new(0.22, 0.12),
        Transparency = NumberSequence.new(0.15, 0.6),
        Lifetime = NumberRange.new(0.5, 0.7),
        Speed = NumberRange.new(0, 1),
        SpreadAngle = Vector2.new(60, 60),
        EmissionDirection = Enum.NormalId.Bottom,
        Orientation = Enum.ParticleOrientation.VelocityParallel
    })

    v34.Parent = v32
    p18:Add(task.delay(p20, function() -- line: 347
        -- upvalues: v34 (copy)
        v34.Enabled = false
    end))
end

return table.freeze(t1)
