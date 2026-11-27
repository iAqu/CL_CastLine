-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local HullRig = require(script.Parent.Parent.Boss.HullRig)
local t1 = {
    MONSTER_SCALE = 3.4,
    FLOOR_Y = -1100,
    CLIFF_X = 9465,
    CRACK_Z = -5840,
    CRACK_HALF = 13,
    CRACK_TOP = -1022,
    PASSAGE_END = 10200
}
local v1 = Color3.fromRGB(26, 36, 56)
local v2 = Color3.fromRGB(34, 42, 62)
local v3 = Color3.fromRGB(18, 22, 36)
local t2 = {
    Color3.fromRGB(80, 235, 255),
    Color3.fromRGB(255, 90, 200),
    Color3.fromRGB(140, 255, 160)
}
local v4 = Random.new(4040)

local function part(p1, p2) -- line: 32
    local v5 = Instance.new(p2.Class or "Part")

    p2.Class = nil
    v5.Anchored = true
    v5.CanCollide = false
    v5.CanQuery = false
    v5.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    v5.TopSurface = Smooth
    v5.BottomSurface = Smooth2
    v5.Material = Enum.Material.Plastic

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p1

    return v5
end

local function box(p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 48
    -- upvalues: part (copy)
    local t3 = {
        Size = Vector3.new(p7 - p4, p8 - p5, p9 - p6),
        CFrame = CFrame.new((p4 + p7) / 2, (p5 + p8) / 2, (p6 + p9) / 2),
        Color = p10
    }

    for v11, v12 in p11 or {} do
        t3[v11] = v12
    end

    return (part(p3, t3))
end

function t1.emitter(p12, p13) -- line: 56
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v13, v14 in p13 do
        ParticleEmitter[v13] = v14
    end

    ParticleEmitter.Parent = p12

    return ParticleEmitter
end

function t1.bubble(p14, p15, p16, p17, p18) -- line: 66
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(p17, p17)
    BillboardGui.StudsOffsetWorldSpace = p18 or Vector3.new(0, 2.6, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p14

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Text = p15
    TextLabel.TextScaled = true
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
    TextLabel.TextColor3 = p16

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = p14

    return BillboardGui
end

function t1.sub(p19) -- line: 91
    -- upvalues: t1 (copy), part (copy)
    local v15 = workspace:FindFirstChild("EventHole") and workspace.EventHole:FindFirstChild("Cave")
    local Submarine = v15 and v15:FindFirstChild("Submarine")

    if not Submarine then
        return nil
    end

    local clone = Submarine:Clone()

    clone.Name = "TripSub"

    local Pivot = clone:GetPivot()
    local t4 = {
        model = clone,
        pieces = {},
        home = Pivot
    }

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false

            if descendant.Name:find("Glass") then
                descendant.Transparency = 0.85
                descendant.CastShadow = false
            end

            if descendant.Name == "Submarine_Interior" or descendant.Name == "Submarine_Interior_Glow" then
                descendant.CastShadow = false
            end

            table.insert(t4.pieces, {
                part = descendant,
                rel = Pivot:ToObjectSpace(descendant.CFrame),
                name = descendant.Name
            })
        end
    end

    local function find(p20) -- line: 114
        -- upvalues: clone (copy)
        return (clone:FindFirstChild(p20, true))
    end

    t4.hull = clone:FindFirstChild("Submarine_Hull", true)
    t4.chair = clone:FindFirstChild("Submarine_Chair", true)
    t4.hatch = clone:FindFirstChild("Submarine_Hatch", true)
    t4.prop = clone:FindFirstChild("Submarine_Propeller", true)

    local function lamp(p21) -- line: 123
        -- upvalues: clone (copy), t4 (copy), part (copy)
        local v16 = part(clone, {
            Name = "Lamp",
            Size = Vector3.new(1, 1, 1),
            CastShadow = false,
            Color = Color3.fromRGB(255, 250, 220),
            Material = Enum.Material.Neon
        })

        table.insert(t4.pieces, {
            name = "Lamp",
            part = v16,
            rel = CFrame.new(p21, -5.5, 15.5) * CFrame.Angles(0, 3.141592653589793, 0)
        })

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v16

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(0, -3, -55)
        Attachment2.Parent = v16

        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.Width0 = 1.5
        Beam.Width1 = 20
        Beam.FaceCamera = true
        Beam.LightEmission = 0.8
        Beam.LightInfluence = 0
        Beam.Color = ColorSequence.new(Color3.fromRGB(200, 235, 255))
        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(0.6, 0.88),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Segments = 4
        Beam.Parent = v16

        local SpotLight = Instance.new("SpotLight")

        SpotLight.Face = Enum.NormalId.Front
        SpotLight.Range = 60
        SpotLight.Angle = 50
        SpotLight.Brightness = 3
        SpotLight.Color = Color3.fromRGB(210, 235, 255)
        SpotLight.Parent = v16

        return Beam
    end

    t4.beams = {
        lamp(-5),
        (lamp(5))
    }

    if t4.hatch then
        local v17 = math.min(t4.hatch.Size.X, t4.hatch.Size.Z) * 0.8
        local v18 = part(clone, {
            Name = "HatchHole",
            CastShadow = false,
            Transparency = 1,
            Shape = Enum.PartType.Cylinder,
            Size = Vector3.new(0.3, v17, v17),
            Color = Color3.fromRGB(6, 8, 12),
            Material = Enum.Material.SmoothPlastic
        })
        local v19 = Pivot:ToObjectSpace(t4.hatch.CFrame)

        table.insert(t4.pieces, {
            name = "HatchHole",
            part = v18,
            rel = CFrame.new(v19.Position + Vector3.new(0, -0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        })
    end

    local v20 = part(clone, {
        Name = "DashGlow",
        Size = Vector3.new(0.5, 0.5, 0.5),
        Transparency = 1,
        CastShadow = false
    })

    table.insert(t4.pieces, {
        name = "DashGlow",
        part = v20,
        rel = CFrame.new(0, 1.5, 12.5)
    })

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(255, 238, 215)
    PointLight.Range = 10
    PointLight.Brightness = 1
    PointLight.Parent = v20
    t4.bubbles = t4.prop and t1.emitter(t4.prop, {
        LightEmission = 0.4,
        Acceleration = Vector3.new(0, 6, 0),
        Rate = 0,
        Color = ColorSequence.new(Color3.fromRGB(220, 240, 255)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.8, 1.6),
        Speed = NumberRange.new(4, 9),
        SpreadAngle = Vector2.new(25, 25),
        EmissionDirection = Enum.NormalId.Back
    })
    clone.Parent = p19

    return t4
end

function t1.placeSub(p22, p23, p24, p25) -- line: 186
    local t9 = {}
    local t10 = {}
    local v21 = p23 * CFrame.Angles(0, 3.141592653589793, 0)

    for _, v22 in p22.pieces do
        local rel = v22.rel

        if v22.name == "Submarine_Propeller" then
            rel = CFrame.new(rel.Position) * CFrame.Angles(0, 0, p24) * rel.Rotation
        elseif v22.name == "HatchHole" then
            v22.part.Transparency = p25 and p25 > 0.05 and 0 or 1
        elseif v22.name == "Submarine_Hatch" and p25 and p25 > 0 then
            local Size = v22.part.Size
            local v24 = rel.Position + Vector3.new(0, 0, -Size.Z / 2)

            rel = CFrame.new(v24) * CFrame.Angles(-p25 * 2.007128639793479, 0, 0) * CFrame.new(-v24) * rel
        end

        table.insert(t9, v22.part)
        table.insert(t10, v21 * rel)
    end

    workspace:BulkMoveTo(t9, t10, Enum.BulkMoveMode.FireCFrameChanged)
end

function t1.seat(p26, p27) -- line: 209
    local v26 = p27 * CFrame.Angles(0, 3.141592653589793, 0)

    for _, v27 in p26.pieces do
        if v27.name == "Submarine_Chair" then
            local Size = v27.part.Size

            return v26 * CFrame.new(v27.rel.Position + Vector3.new(0, -Size.Y * 0.5 + Size.Y * 0.42, 0.25)) * CFrame.Angles(0, 3.141592653589793, 0)
        end
    end

    return p27
end

function t1.hatchHole(p28, p29) -- line: 222
    local v29 = p29 * CFrame.Angles(0, 3.141592653589793, 0)

    for _, v30 in p28.pieces do
        if v30.name == "Submarine_Hatch" then
            return (v29 * v30.rel).Position
        end
    end

    return p29.Position + Vector3.new(0, 9, 0)
end

function t1.monster(p30) -- line: 234
    -- upvalues: HullRig (copy), t1 (copy)
    local v31 = HullRig.clone(t1.MONSTER_SCALE)

    if not v31 then
        return nil
    end

    v31.Name = "TripHullbreaker"

    for _, descendant in v31:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name:find("Glow") then
            local PointLight = Instance.new("PointLight")

            PointLight.Color = Color3.fromRGB(255, 200, 120)
            PointLight.Range = 40
            PointLight.Brightness = 2
            PointLight.Parent = descendant
        end
    end

    v31.Parent = p30

    return {
        model = v31,
        rig = HullRig.new(v31),
        head = v31:FindFirstChild("Hullbreaker_Head", true)
    }
end

function t1.build(p31) -- line: 256
    -- upvalues: t1 (copy), v1 (copy), v2 (copy), v3 (copy), t2 (copy), v4 (copy), part (copy), box (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "Deep"

    local FLOOR_Y = t1.FLOOR_Y

    box(Folder, 8500, FLOOR_Y - 10, -6500, t1.CLIFF_X + 2, FLOOR_Y, -5200, v1)
    box(Folder, 8000, -780, -7000, 10200, -778, -4600, Color3.fromRGB(60, 120, 190), {
        Transparency = 0.55,
        CastShadow = false,
        Material = Enum.Material.Neon
    })

    for _ = 1, 6 do
        local v33 = Vector3.new(v4:NextNumber(8700, 9400), -900, v4:NextNumber(-6200, -5500))

        part(Folder, {
            Transparency = 0.95,
            CastShadow = false,
            Size = Vector3.new(v4:NextNumber(14, 30), 260, 2),
            CFrame = CFrame.new(v33) * CFrame.Angles(0, v4:NextNumber(0, 6.28), 0.24434609527920614),
            Color = Color3.fromRGB(150, 200, 255),
            Material = Enum.Material.Neon
        })
    end

    for _ = 1, 70 do
        local v36 = Vector3.new(v4:NextNumber(8550, 9440), FLOOR_Y, v4:NextNumber(-6450, -5250))

        if not (math.abs(v36.Z - t1.CRACK_Z) < 30 and v36.X > 8990) then
            local v38 = v4:NextNumber(6, 22)

            part(Folder, {
                Size = Vector3.new(v38, v38 * v4:NextNumber(0.5, 1.2), v38 * v4:NextNumber(0.8, 1.3)),
                CFrame = CFrame.new(v36) * CFrame.Angles(v4:NextNumber(-0.3, 0.3), v4:NextNumber(0, 6.28), v4:NextNumber(-0.3, 0.3)),
                Color = v2:Lerp(v3, v4:NextNumber())
            })
        end
    end

    for _ = 1, 14 do
        local v43 = Vector3.new(v4:NextNumber(8500, 9400), FLOOR_Y, if v4:NextNumber() < 0.5 then v4:NextNumber(-6500, -6050) else v4:NextNumber(-5600, -5250))
        local v44 = v4:NextNumber(80, 200)

        part(Folder, {
            Size = Vector3.new(v4:NextNumber(20, 40), v44, v4:NextNumber(20, 40)),
            CFrame = CFrame.new(v43 + Vector3.new(0, v44 / 2, 0)) * CFrame.Angles(v4:NextNumber(-0.1, 0.1), v4:NextNumber(0, 6), v4:NextNumber(-0.1, 0.1)),
            Color = v3
        })
    end

    for _ = 1, 90 do
        local v49 = Vector3.new(v4:NextNumber(8800, 9450), FLOOR_Y, t1.CRACK_Z + v4:NextNumber(-140, 140))
        local v50 = v4:NextNumber(1.5, 5)

        part(Folder, {
            Size = Vector3.new(0.6, v50, 0.6),
            CFrame = CFrame.new(v49 + Vector3.new(0, v50 / 2, 0)),
            Color = v3
        })
        part(Folder, {
            CastShadow = false,
            Shape = Enum.PartType.Ball,
            Size = Vector3.new(1, 1, 1) * v4:NextNumber(0.8, 1.6),
            CFrame = CFrame.new(v49 + Vector3.new(0, v50, 0)),
            Color = t2[v4:NextInteger(1, #t2)],
            Material = Enum.Material.Neon
        })
    end

    for _ = 1, 40 do
        local v54 = Vector3.new(v4:NextNumber(8900, 9440), FLOOR_Y, t1.CRACK_Z + (if v4:NextNumber() < 0.5 then -1 else 1) * v4:NextNumber(30, 90))
        local v55 = v4:NextNumber(20, 45)

        part(Folder, {
            Size = Vector3.new(1.2, v55, 0.4),
            CFrame = CFrame.new(v54 + Vector3.new(0, v55 / 2, 0)) * CFrame.Angles(v4:NextNumber(-0.15, 0.15), v4:NextNumber(0, 6), 0),
            Color = Color3.fromRGB(20, 70, 50)
        })
    end

    local CLIFF_X = t1.CLIFF_X
    local v57 = t1.CLIFF_X + 40
    local CRACK_Z, CRACK_HALF, CRACK_TOP = t1.CRACK_Z, t1.CRACK_HALF, t1.CRACK_TOP

    box(Folder, CLIFF_X, FLOOR_Y - 10, -6500, v57, -760, CRACK_Z - CRACK_HALF, v2)
    box(Folder, CLIFF_X, FLOOR_Y - 10, CRACK_Z + CRACK_HALF, v57, -760, -5200, v2)
    box(Folder, CLIFF_X, CRACK_TOP, CRACK_Z - CRACK_HALF, v57, -760, CRACK_Z + CRACK_HALF, v2)

    for _ = 1, 40 do
        local v58 = v4:NextNumber(-6450, -5250)

        if not (math.abs(v58 - CRACK_Z) < CRACK_HALF + 14) then
            local v60 = v4:NextNumber(60, 220)
            local v61 = v4:NextNumber(20, 50)

            part(Folder, {
                Size = Vector3.new(v4:NextNumber(8, 16), v60, v61),
                CFrame = CFrame.new(CLIFF_X - 2, FLOOR_Y + v60 / 2 - 10, v58) * CFrame.Angles(0, 0, v4:NextNumber(-0.08, 0.08)),
                Color = v2:Lerp(v3, v4:NextNumber(0, 0.7))
            })
        end
    end

    for i = -1, 1, 2 do
        for j = 0, 9 do
            local v63 = FLOOR_Y + j * 8 + 4
            local v64 = v4:NextNumber(2, 5)

            part(Folder, {
                Size = Vector3.new(10, 9, v64),
                CFrame = CFrame.new(CLIFF_X - 1, v63, CRACK_Z + i * (CRACK_HALF + v64 / 2 - v4:NextNumber(0.5, 2))),
                Color = v3
            })
        end

        part(Folder, {
            CastShadow = false,
            Size = Vector3.new(0.6, CRACK_TOP - FLOOR_Y, 0.6),
            CFrame = CFrame.new(CLIFF_X - 0.5, (FLOOR_Y + CRACK_TOP) / 2, CRACK_Z + i * (CRACK_HALF - 0.4)),
            Color = t2[1],
            Material = Enum.Material.Neon
        })
    end

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "Passage"
    Folder2.Parent = Folder
    box(Folder2, v57, FLOOR_Y - 10, CRACK_Z - CRACK_HALF - 30, t1.PASSAGE_END + 40, FLOOR_Y, CRACK_Z + CRACK_HALF + 30, v3)
    box(Folder2, v57, FLOOR_Y, CRACK_Z - CRACK_HALF - 30, t1.PASSAGE_END + 40, -760, CRACK_Z - CRACK_HALF, v2)
    box(Folder2, v57, FLOOR_Y, CRACK_Z + CRACK_HALF, t1.PASSAGE_END + 40, -760, CRACK_Z + CRACK_HALF + 30, v2)
    box(Folder2, v57, CRACK_TOP, CRACK_Z - CRACK_HALF, t1.PASSAGE_END + 40, -760, CRACK_Z + CRACK_HALF, v3)

    for i = v57 + 20, t1.PASSAGE_END - 20, 34 do
        for j = -1, 1, 2 do
            local v67 = part(Folder2, {
                CastShadow = false,
                Size = Vector3.new(1.2, v4:NextNumber(3, 6), 1.2),
                CFrame = CFrame.new(i, FLOOR_Y + v4:NextNumber(10, 60), CRACK_Z + j * (CRACK_HALF - 0.8)) * CFrame.Angles(0, 0, j * 0.5),
                Color = t2[1],
                Material = Enum.Material.Neon
            })

            if i < v57 + 330 then
                local PointLight = Instance.new("PointLight")

                PointLight.Color = t2[1]
                PointLight.Range = 22
                PointLight.Brightness = 1.2
                PointLight.Parent = v67
            end
        end
    end

    for i = 0, 3 do
        local v68 = v57 + 120 + i * 130
        local v69 = box(Folder2, v68, FLOOR_Y, CRACK_Z - CRACK_HALF, v68 + 130, CRACK_TOP, CRACK_Z + CRACK_HALF, v3, {
            Transparency = 1
        })

        t1.emitter(v69, {
            LightEmission = 0.15,
            LightInfluence = 0.4,
            Color = ColorSequence.new(Color3.fromRGB(70, 100, 140)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 22),
                NumberSequenceKeypoint.new(1, 34)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 0.82 - i * 0.08),
                NumberSequenceKeypoint.new(0.7, 0.82 - i * 0.08),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(6, 9),
            Speed = NumberRange.new(0.5, 1.5),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-6, 6),
            Shape = Enum.ParticleEmitterShape.Box,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
            Rate = i * 4 + 8
        })
    end

    box(Folder2, t1.PASSAGE_END, FLOOR_Y, CRACK_Z - CRACK_HALF, t1.PASSAGE_END + 4, CRACK_TOP, CRACK_Z + CRACK_HALF, v3)
    Folder.Parent = p31

    return {
        folder = Folder
    }
end

function t1.snow(p32) -- line: 365
    -- upvalues: t1 (copy), part (copy)
    local v70 = part(p32, {
        Name = "Snow",
        Size = Vector3.new(90, 60, 90),
        Transparency = 1
    })

    t1.emitter(v70, {
        LightEmission = 0.6,
        LightInfluence = 0,
        Acceleration = Vector3.new(0, -0.4, 0),
        Rate = 160,
        Color = ColorSequence.new(Color3.fromRGB(220, 235, 255)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(1, 0.2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(4, 6),
        Speed = NumberRange.new(0.3, 1),
        SpreadAngle = Vector2.new(180, 180),
        Shape = Enum.ParticleEmitterShape.Box,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    })

    return v70
end

function t1.grade() -- line: 385
    -- upvalues: Lighting (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "TripGrade"
    ColorCorrectionEffect.TintColor = Color3.fromRGB(170, 200, 255)
    ColorCorrectionEffect.Brightness = -0.04
    ColorCorrectionEffect.Contrast = 0.16
    ColorCorrectionEffect.Saturation = -0.05
    ColorCorrectionEffect.Parent = Lighting

    return function() -- line: 393
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end
end

function t1.debris(p33, p34, p35, p36) -- line: 399
    -- upvalues: t1 (copy), v2 (copy), v4 (copy), part (copy)
    local t19 = {}

    for _ = 1, p36 do
        local v71 = v4:NextNumber(2, 7)

        table.insert(t19, {
            p = part(p33, {
                Size = Vector3.new(v71, v71 * 0.8, v71),
                CFrame = CFrame.new(p34 + Vector3.new(0, v4:NextNumber(-20, 30), v4:NextNumber(-30, 30))),
                Color = v2
            }),
            v = p35 * v4:NextNumber(20, 50) + Vector3.new(0, v4:NextNumber(5, 30), v4:NextNumber(-30, 30)),
            spin = Vector3.new(v4:NextNumber(-4, 4), v4:NextNumber(-4, 4), v4:NextNumber(-4, 4))
        })
    end

    local v79 = part(p33, {
        Size = Vector3.new(30, 40, 60),
        Transparency = 1,
        CFrame = CFrame.new(p34)
    })

    t1.emitter(v79, {
        LightEmission = 0,
        Drag = 2,
        Rate = 0,
        Color = ColorSequence.new(Color3.fromRGB(70, 80, 100)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 10),
            NumberSequenceKeypoint.new(1, 30)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(2.5, 4),
        Speed = NumberRange.new(10, 30),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-30, 30),
        Shape = Enum.ParticleEmitterShape.Box,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    }):Emit(40)

    return function(p37) -- line: 424
        -- upvalues: t19 (copy)
        for _, v80 in t19 do
            if v80.p.Parent then
                v80.v = v80.v * (1 - p37 * 1.5) + Vector3.new(0, p37 * -25, 0)
                v80.p.CFrame = (v80.p.CFrame + v80.v * p37) * CFrame.Angles(v80.spin.X * p37, v80.spin.Y * p37, v80.spin.Z * p37)
            end
        end
    end
end

return t1
