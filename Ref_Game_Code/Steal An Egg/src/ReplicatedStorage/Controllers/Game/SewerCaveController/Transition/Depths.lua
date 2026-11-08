-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Kit = require(script.Parent.Kit)

require(ReplicatedStorage.Packages.Trove)

local v1 = table.freeze({
    Vector2.new(4, 1.6),
    Vector2.new(10.5, 2.4),
    Vector2.new(15.5, 1.2),
    Vector2.new(22, 2),
    Vector2.new(27.5, 1.4),
    Vector2.new(34, 2.6),
    Vector2.new(41, 1.6),
    Vector2.new(46.5, 2.2),
    Vector2.new(52, 1.4)
})
local v2 = table.freeze({ 74, 80, 86, 92 })
local v3 = table.freeze({ 70, 31, -8, -47 })
local v4 = Color3.fromRGB(3, 20, 22)
local v5 = Color3.fromRGB(3, 14, 12)
local v6 = Color3.fromRGB(255, 140, 50)
local v7 = Color3.fromRGB(14, 52, 66)
local v8 = Color3.fromRGB(46, 96, 52)
local v9 = Color3.fromRGB(60, 43, 30)
local v10 = Color3.fromRGB(53, 38, 27)
local v11 = Color3.fromRGB(28, 21, 15)
local v12 = Color3.fromRGB(38, 50, 40)
local v13 = Color3.fromRGB(5, 16, 11)
local v14 = Color3.fromRGB(24, 44, 50)
local v15 = Color3.fromRGB(10, 24, 28)
local v16 = Color3.fromRGB(18, 30, 40)
local v17 = Color3.fromRGB(6, 14, 18)
local v18 = Color3.fromRGB(20, 36, 38)
local v19 = Color3.fromRGB(58, 40, 28)
local v20 = Color3.fromRGB(26, 74, 52)
local v21 = Color3.fromRGB(16, 46, 36)
local v22 = Color3.fromRGB(46, 38, 32)
local v23 = Color3.fromRGB(30, 44, 42)
local v24 = Color3.fromRGB(20, 27, 21)
local v25 = Color3.fromRGB(56, 58, 38)
local v26 = Color3.fromRGB(30, 31, 20)
local v27 = Color3.fromRGB(104, 104, 76)
local v28 = Color3.fromRGB(52, 124, 86)
local v29 = Color3.fromRGB(150, 240, 200)
local v30 = Color3.fromRGB(70, 84, 86)
local v31 = Color3.fromRGB(255, 130, 40)
local v32 = Color3.fromRGB(232, 122, 48)
local v33 = Color3.fromRGB(8, 16, 18)
local v34 = CFrame.Angles(0.9, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
local v35 = Color3.fromRGB(150, 235, 230)
local v36 = Color3.fromRGB(120, 235, 215)
local v37 = Color3.fromRGB(16, 46, 78)
local v38 = Color3.fromRGB(10, 84, 82)
local v39 = Color3.fromRGB(8, 44, 40)
local v40 = table.freeze({
    {
        Radius = 21,
        Speed = 60,
        Murk = 0.1,
        Dim = 0.92,
        Props = { "Barrel", "Crate", "Barrel" }
    },
    {
        Radius = 29,
        Speed = 40,
        Murk = 0.3,
        Dim = 0.86,
        Props = { "Kiosk", "Grave", "Lantern", "Pumpkin" }
    },
    {
        Radius = 40,
        Speed = 28,
        Murk = 0.5,
        Dim = 0.82,
        Props = { "Canopy", "Grave", "Crate", "Pumpkin" }
    },
    {
        Radius = 51,
        Speed = 18,
        Murk = 0.68,
        Dim = 0.8,
        Props = { "Lantern", "Kiosk", "Frame", "Grave" }
    }
})
local v41 = table.freeze({
    Warm = Color3.fromRGB(150, 82, 34),
    Window = Color3.fromRGB(170, 66, 20),
    Pumpkin = Color3.fromRGB(190, 70, 18)
})
local t1 = {
    Floor = -80,
    PipeRadius = 8.5,
    PipeLength = 100
}

local function funnelSlope() -- line: 247
    return 0.5098332286596837
end

local function funnelY(p1) -- line: 251
    return math.clamp((p1 - 13 - 0.5) / 46.5, 0, 1) * 26 + -79
end

local function onFunnel(p2, p3, p4, p5) -- line: 256
    return p2 * CFrame.Angles(0, p3, 0) * CFrame.new(0, math.clamp((p4 - 13 - 0.5) / 46.5, 0, 1) * 26 + -79 + p5, -p4) * CFrame.Angles(0.5098332286596837, 0, 0)
end

local function wall(p6, p7, p8, p9) -- line: 263
    -- upvalues: Kit (copy), v4 (copy), v5 (copy), v37 (copy), v38 (copy), v39 (copy)
    local v45 = Kit.Part({
        Name = "Wall",
        Size = Vector3.new(40.160076, 182, 2),
        Color = v39,
        Material = Enum.Material.SmoothPlastic
    })

    v45.CFrame = p7 * CFrame.Angles(0, p8, 0) * CFrame.new(0, 9, -61)

    local SurfaceGui = Instance.new("SurfaceGui")

    SurfaceGui.Name = "Water"
    SurfaceGui.Face = Enum.NormalId.Back
    SurfaceGui.LightInfluence = 0
    SurfaceGui.Brightness = 1
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui.PixelsPerStud = 3
    SurfaceGui.ClipsDescendants = true
    SurfaceGui.Parent = v45

    local Frame = Instance.new("Frame")

    Frame.Name = "Fill"
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.Parent = SurfaceGui

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v37),
        ColorSequenceKeypoint.new(0.45, v38),
        ColorSequenceKeypoint.new(0.8, v39),
        ColorSequenceKeypoint.new(1, v5)
    })
    UIGradient.Parent = Frame

    local n1 = 89

    while n1 > -76.5 do
        local v46 = (100 - n1) / 182
        local Frame = Instance.new("Frame")

        Frame.Name = "Band"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v4
        Frame.BackgroundTransparency = 0.5 - v46 * 0.3
        Frame.Size = UDim2.fromScale(1, 0.013846153846153847)
        Frame.Position = UDim2.fromScale(0, v46)
        Frame.Parent = SurfaceGui

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = Frame
        n1 -= 11
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Caustic"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://18177147504"
    ImageLabel.ImageColor3 = Color3.fromRGB(140, 240, 222)
    ImageLabel.ImageTransparency = 0.5
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromScale(0.5, 0.08241758241758242)
    ImageLabel.Size = UDim2.fromScale(1, 2)
    ImageLabel.Position = UDim2.fromScale(0, -1)
    ImageLabel.Parent = SurfaceGui
    table.insert(p9, ImageLabel)
    v45.Parent = p6
end

local function floor(p10, p11, p12) -- line: 335
    -- upvalues: Kit (copy), v24 (copy)
    for v47, v48 in {
            {
                Size = Vector3.new(126, 2, 50),
                Offset = Vector3.new(0, 0, 38)
            },
            {
                Size = Vector3.new(126, 2, 50),
                Offset = Vector3.new(0, 0, -38)
            },
            {
                Size = Vector3.new(50, 2, 26),
                Offset = Vector3.new(38, 0, 0)
            },
            {
                Size = Vector3.new(50, 2, 26),
                Offset = Vector3.new(-38, 0, 0)
            }
        } do
        local v49 = Kit.Part({
            Name = ("Floor%*"):format(v47),
            Size = v48.Size,
            Color = v24,
            Material = Enum.Material.Mud
        })

        v49.CFrame = p11 * CFrame.new(v48.Offset + Vector3.new(0, -81, 0))

        local SurfaceGui = Instance.new("SurfaceGui")

        SurfaceGui.Name = "Bed"
        SurfaceGui.Face = Enum.NormalId.Top
        SurfaceGui.LightInfluence = 0
        SurfaceGui.Brightness = 1
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = 2
        SurfaceGui.ClipsDescendants = true
        SurfaceGui.Parent = v49

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Caustic"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://18177147504"
        ImageLabel.ImageColor3 = Color3.fromRGB(90, 200, 170)
        ImageLabel.ImageTransparency = 0.8
        ImageLabel.ScaleType = Enum.ScaleType.Tile
        ImageLabel.TileSize = UDim2.fromScale(0.25, 0.25)
        ImageLabel.Size = UDim2.fromScale(1, 2)
        ImageLabel.Position = UDim2.fromScale(0, -1)
        ImageLabel.Parent = SurfaceGui
        table.insert(p12, ImageLabel)
        v49.Parent = p10
    end
end

local function ring(p13, p14, p15, p16, p17, p18, p19) -- line: 377
    -- upvalues: Kit (copy), v12 (copy)
    local v50 = p17 - p16
    local v52 = math.sqrt(v50 * v50 + p18 * p18)
    local v53 = math.atan2(p18, v50)
    local v54 = p17 * 2 * 0.13165249758739583 * 1.08

    for i = 1, 24 do
        local v55 = (i - 1) / 24 * 3.141592653589793 * 2
        local v57 = Kit.Part({
            Name = p15,
            Size = Vector3.new(v54, 0.8, v52 + 0.5),
            Color = v12,
            Material = Enum.Material.Slate
        })

        v57.CFrame = p14 * CFrame.Angles(0, v55, 0) * CFrame.new(0, p19 - p18 / 2, -(p16 + p17) / 2) * CFrame.Angles(v53, 0, 0)
        v57.Parent = p13
    end
end

local function funnel(p20, p21) -- line: 406
    -- upvalues: Kit (copy), v1 (copy), v25 (copy), v26 (copy)
    for i = 1, 24 do
        local v58 = (i - 1) / 24 * 3.141592653589793 * 2
        local v59 = Kit.Part({
            Name = "Funnel",
            Size = Vector3.new(17.062164, 1, 53.77523),
            Color = v25,
            Material = Enum.Material.Mud
        })

        v59.CFrame = p21 * CFrame.Angles(0, v58, 0) * CFrame.new(0, -66.5, -36.75) * CFrame.Angles(0.5098332286596837, 0, 0)

        local SurfaceGui = Instance.new("SurfaceGui")

        SurfaceGui.Name = "Silt"
        SurfaceGui.Face = Enum.NormalId.Top
        SurfaceGui.LightInfluence = 1
        SurfaceGui.Brightness = 1
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = 2
        SurfaceGui.ClipsDescendants = true
        SurfaceGui.Parent = v59

        for _, v60 in v1 do
            local Frame = Instance.new("Frame")

            Frame.Name = "Ridge"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v26
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.fromScale(v60.Y / 53.77522876534647, 1)
            Frame.Position = UDim2.fromScale((v60.X - v60.Y / 2) / 53.77522876534647, 0)
            Frame.Parent = SurfaceGui

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.35, 0.35),
                NumberSequenceKeypoint.new(0.6, 0.45),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = Frame
        end

        v59.Parent = p20
    end
end

local function siltSlide(p22, p23, p24) -- line: 455
    -- upvalues: Kit (copy), v27 (copy)
    local v61 = Kit.Part({
        Name = "SiltSlide",
        Size = Vector3.new(106, 1, 106),
        Transparency = 1,
        Shape = Enum.PartType.Ball
    })

    v61.CFrame = p23 * CFrame.new(0, -56, 0)
    v61.Parent = p22
    Kit.Emitter({
        Name = "Silt",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Acceleration = Vector3.new(0, -5, 0),
        LightEmission = 0,
        LightInfluence = 1,
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
        Rate = p24 and 18 or 36,
        Lifetime = NumberRange.new(2.2, 3),
        Speed = NumberRange.new(12, 17),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.5),
            NumberSequenceKeypoint.new(1, 6)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0.6),
            NumberSequenceKeypoint.new(0.8, 0.7),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-60, 60),
        Color = ColorSequence.new(v27)
    }).Parent = v61
end

local function collar(p25, p26) -- line: 493
    -- upvalues: ring (copy)
    ring(p25, p26, "Collar", 8.5, 13.5, 3.5, -79.6)
end

local function ribs(p27, p28) -- line: 499
    -- upvalues: Kit (copy), v11 (copy), v28 (copy)
    for i = 1, 11 do
        local v62 = -80 - i * 9 + 3.6

        for j = 1, 16 do
            local v63 = (j - 1) / 16 * 3.141592653589793 * 2
            local v64 = i % 2 == 0
            local Part = Kit.Part
            local t4 = {
                Name = "Rib",
                Size = Vector3.new(3.386284, 1.1, 0.9)
            }

            if v64 then
                t4.Color = v28
                t4.Material = Enum.Material.Neon
            else
                t4.Color = v11
                t4.Material = Enum.Material.CorrodedMetal
            end

            local v65 = Part(t4)

            v65.CFrame = p28 * CFrame.new(0, v62, 0) * CFrame.Angles(0, v63, 0) * CFrame.new(0, 0, -8.05)
            v65.Parent = p27
        end
    end
end

local function pipe(p29, p30, _) -- line: 522
    -- upvalues: Kit (copy), v2 (copy), v8 (copy), v9 (copy), v10 (copy), v13 (copy), v29 (copy), ring (copy), ribs (copy)
    for i = 1, 16 do
        local v66 = (i - 1) / 16 * 3.141592653589793 * 2
        local v67 = Kit.Part({
            Name = "Tube",
            Size = Vector3.new(3.9360778, 100, 1.2),
            Color = if i % 2 == 0 then v9 else v10,
            Material = Enum.Material.CorrodedMetal
        })

        v67.CFrame = p30 * CFrame.new(0, -130, 0) * CFrame.Angles(0, v66, 0) * CFrame.new(0, 0, -9.1)
        v67.Parent = p29
    end

    ribs(p29, p30)
    ring(p29, p30, "Collar", 8.5, 13.5, 3.5, -79.6)

    local t6 = {}
    local v68 = Kit.Part({
        Name = "Slime",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    })

    v68.CFrame = p30
    v68.Parent = p29

    for i = 1, 4 do
        local v69 = i * 3.141592653589793 / 2 + 0.4
        local Attachment = Instance.new("Attachment")

        Attachment.Position = Vector3.new(math.cos(v69) * 8.3, -81, math.sin(v69) * 8.3)
        Attachment.Parent = v68

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(math.cos(v69 + 0.3) * 8.3, -180, math.sin(v69 + 0.3) * 8.3)
        Attachment2.Parent = v68

        local v76 = Kit.Beam({
            Name = "Streak",
            Width0 = 1.1,
            Width1 = 0.7,
            LightEmission = 0.3,
            FaceCamera = true,
            Attachment0 = Attachment,
            Attachment1 = Attachment2,
            Color = ColorSequence.new(Color3.fromRGB(110, 190, 80), Color3.fromRGB(70, 150, 66)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.75),
                NumberSequenceKeypoint.new(0.5, 0.45),
                NumberSequenceKeypoint.new(1, 0.7)
            })
        })

        v76.Parent = v68
        table.insert(t6, v76)
    end

    local v77 = Kit.Part({
        Name = "Light",
        Size = Vector3.new(1, 18, 18),
        Transparency = 0.35,
        Shape = Enum.PartType.Cylinder,
        Color = v8,
        Material = Enum.Material.Neon
    })

    v77.CFrame = p30 * CFrame.new(0, -180, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    v77.Parent = p29

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Kit.CaveGreen
    PointLight.Range = 60
    PointLight.Brightness = 0.6
    PointLight.Shadows = false
    PointLight.Parent = v77

    local v78 = Kit.Part({
        Name = "Mouth",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1
    })

    v78.CFrame = p30 * CFrame.new(0, -86, 0)
    v78.Parent = p29

    local PointLight2 = Instance.new("PointLight")

    PointLight2.Color = Kit.CaveGreen
    PointLight2.Range = 26
    PointLight2.Brightness = 0.4
    PointLight2.Shadows = false
    PointLight2.Parent = v78

    local t7 = {}

    for _, v79 in v2 do
        local v80 = Kit.Part({
            Name = "Fog",
            Size = Vector3.new(0.2, 17.6, 17.6),
            Transparency = 1,
            Shape = Enum.PartType.Cylinder,
            Color = v13,
            Material = Enum.Material.SmoothPlastic
        })

        v80.CFrame = p30 * CFrame.new(0, -80 - v79, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
        v80.Parent = p29
        table.insert(t7, v80)
    end

    local v81 = Kit.Part({
        Name = "Exit",
        Size = Vector3.new(0.4, 17.4, 17.4),
        Transparency = 1,
        Shape = Enum.PartType.Cylinder,
        Color = v29,
        Material = Enum.Material.Neon
    })

    v81.CFrame = p30 * CFrame.new(0, -156, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    v81.Parent = p29

    local PointLight3 = Instance.new("PointLight")

    PointLight3.Color = v29
    PointLight3.Range = 40
    PointLight3.Brightness = 0
    PointLight3.Shadows = false
    PointLight3.Parent = v81

    return PointLight, v77, PointLight2, t7, t6, v81, PointLight3
end

local function wedge(p32) -- line: 648
    local WedgePart = Instance.new("WedgePart")

    WedgePart.Anchored = true
    WedgePart.CanCollide = false
    WedgePart.CanQuery = false
    WedgePart.CanTouch = false
    WedgePart.CastShadow = false

    for v82, v83 in p32 do
        WedgePart[v82] = v83
    end

    return WedgePart
end

local function onWall(p33, p34, p35, p36) -- line: 661
    return p33 * CFrame.Angles(0, p34, 0) * CFrame.new(0, p35, -(60 - p36))
end

local function facade(p37, p38, p39, p40, p41) -- line: 665
    -- upvalues: Kit (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v31 (copy), v32 (copy), v33 (copy)
    local v84 = Kit.Part({
        Name = "Facade",
        Size = p39,
        Color = v14:Lerp(v15, p40:NextNumber(0, 0.6)),
        Material = if p40:NextNumber() < 0.5 then Enum.Material.WoodPlanks else Enum.Material.Cobblestone
    })

    v84.CFrame = p38
    v84.Parent = p37

    local v85 = p40:NextNumber(3, 6)
    local t9 = {
        Name = "Roof",
        Size = Vector3.new(p39.X + 2, v85, p39.Z + 2.4),
        Color = v16,
        Material = Enum.Material.Slate
    }
    local WedgePart = Instance.new("WedgePart")

    WedgePart.Anchored = true
    WedgePart.CanCollide = false
    WedgePart.CanQuery = false
    WedgePart.CanTouch = false
    WedgePart.CastShadow = false

    for v88, v89 in t9 do
        WedgePart[v88] = v89
    end

    WedgePart.CFrame = p38 * CFrame.new(0, p39.Y / 2 + v85 / 2, 0.4) * CFrame.Angles(0, 3.141592653589793, p40:NextNumber(-0.12, 0.12))
    WedgePart.Parent = p37

    local v91 = Kit.Part({
        Name = "Trim",
        Size = Vector3.new(p39.X + 0.8, 0.8, 0.6),
        Color = v16,
        Material = Enum.Material.Wood
    })

    v91.CFrame = p38 * CFrame.new(0, -p39.Y / 2 + p39.Y * 0.45, p39.Z / 2 + 0.2)
    v91.Parent = p37

    local v94 = math.max(math.floor(p39.X / 4), 1)
    local v97 = math.max(math.floor(p39.Y / 7), 1)
    local n2 = 0

    for i = 1, v97 do
        for j = 1, v94 do
            if p41 <= n2 then
                return
            end

            if not (p40:NextNumber() < 0.25) then
                n2 += 1

                local v98 = p40:NextNumber() < 0.4
                local v99 = v98 and p40:NextNumber() < 0.3
                local Part = Kit.Part
                local t11 = {
                    Name = "Window",
                    Size = Vector3.new(1.4, 2, 0.3)
                }

                t11.Color = if v99 then v31 elseif v98 then v32 else v17

                if v98 then
                    t11.Material = Enum.Material.Neon
                    t11.Transparency = p40:NextNumber(0.35, 0.6)
                else
                    t11.Material = Enum.Material.SmoothPlastic
                    t11.Transparency = 0
                end

                local v100 = Part(t11)

                v100.CFrame = p38 * CFrame.new(-p39.X / 2 + (j - 0.5) * p39.X / v94, -p39.Y / 2 + (i - 0.5) * p39.Y / v97 + 1, p39.Z / 2 + 0.1)
                v100.Parent = p37

                if v98 then
                    local v101 = Kit.Part({
                        Name = "Mullion",
                        Size = Vector3.new(0.22, 2.1, 0.2),
                        Color = v33,
                        Material = Enum.Material.Wood
                    })

                    v101.CFrame = v100.CFrame * CFrame.new(0, 0, 0.2)
                    v101.Parent = p37

                    local clone = v101:Clone()

                    clone.Size = Vector3.new(1.5, 0.22, 0.2)
                    clone.Parent = p37
                end
            end
        end
    end
end

local function ledge(p42, p43, p44, p45, p46, p47) -- line: 740
    -- upvalues: Kit (copy), v15 (copy), v18 (copy)
    for i = 1, 14 do
        if not (p45:NextNumber() < 0.3) then
            local v102 = (i - 1) / 14 * 3.141592653589793 * 2 + p45:NextNumber(-0.05, 0.05)
            local v103 = p45:NextNumber(1.8, 2.8)
            local v104 = p44 + p45:NextNumber(-2.5, 2.5)
            local v105 = p45:NextNumber(1.2, 2.6)
            local v107 = Kit.Part({
                Name = "Ledge",
                Size = Vector3.new(26.702512074757728 * p45:NextNumber(0.55, 1), v105, v103),
                Color = v18:Lerp(v15, p45:NextNumber()),
                Material = Enum.Material.Slate
            })
            local v108 = v103 / 2

            v107.CFrame = p43 * CFrame.Angles(0, v102, 0) * CFrame.new(0, v104, -(60 - v108)) * CFrame.Angles(p45:NextNumber(-0.12, 0.12), 0, p45:NextNumber(-0.18, 0.18))
            v107.Parent = p42

            local v109 = v104 - 1
            local v110 = v103 - 0.3

            table.insert(p46, (p43 * CFrame.Angles(0, v102, 0) * CFrame.new(0, v109, -(60 - v110))).Position)

            if v103 > 2.2 then
                local v111 = v104 + v105 / 2
                local v112 = v103 * 0.8

                table.insert(p47, p43 * CFrame.Angles(0, v102, 0) * CFrame.new(0, v111, -(60 - v112)))
            end
        end
    end
end

local function vent(p48, p49, p50, p51, p52) -- line: 773
    -- upvalues: Kit (copy), v11 (copy), v13 (copy), v19 (copy)
    local v114 = p52:NextNumber(7, 13)
    local v115 = p52:NextNumber(1.4, 2.4)
    local v116 = v114 / 2 - 1
    local v117 = p49 * CFrame.Angles(0, p50, 0) * CFrame.new(0, p51, -(60 - v116)) * CFrame.Angles(0, 1.5707963267948966, 0)
    local v120 = Kit.Part({
        Name = "Vent",
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(v114, v115 * 2, v115 * 2),
        Color = v19,
        Material = Enum.Material.CorrodedMetal
    })

    v120.CFrame = v117
    v120.Parent = p48

    local v123 = Kit.Part({
        Name = "VentMouth",
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.3, v115 * 1.6, v115 * 1.6),
        Color = v13,
        Material = Enum.Material.SmoothPlastic
    })

    v123.CFrame = v117 * CFrame.new(-v114 / 2 - 0.1, 0, 0)
    v123.Parent = p48

    local v126 = Kit.Part({
        Name = "VentRim",
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.8, v115 * 2.5, v115 * 2.5),
        Color = v11,
        Material = Enum.Material.CorrodedMetal
    })

    v126.CFrame = v117 * CFrame.new(-v114 / 2 + 0.3, 0, 0)
    v126.Parent = p48

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(-v114 / 2 - 0.4, 0, 0)
    Attachment.Parent = v120
    Kit.Emitter({
        Name = "Seep",
        Texture = "rbxassetid://11800775280",
        Rate = 6,
        Acceleration = Vector3.new(0, 14, 0),
        LightEmission = 0.4,
        LightInfluence = 0,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        FlipbookFramerate = NumberRange.new(20, 30),
        Lifetime = NumberRange.new(1.4, 2.2),
        Speed = NumberRange.new(4, 9),
        SpreadAngle = Vector2.new(20, 20),
        EmissionDirection = Enum.NormalId.Left,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.8, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = ColorSequence.new(Color3.fromRGB(190, 245, 235))
    }).Parent = Attachment
end

local function weed(p53, p54, p55, p56) -- line: 835
    -- upvalues: Kit (copy), v20 (copy), v21 (copy)
    local v128 = p54:PointToObjectSpace(p55)
    local Unit = Vector3.new(-v128.X, 0, -v128.Z).Unit
    local Attachment = Instance.new("Attachment")

    Attachment.Position = v128
    Attachment.Parent = p53

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = v128 + Vector3.new(0, -p56:NextNumber(10, 24), 0) + Unit * p56:NextNumber(0.5, 2.5)
    Attachment2.Parent = p53

    local v132 = p56:NextNumber(2, 5) * (if p56:NextNumber() < 0.5 then -1 else 1)

    Kit.Beam({
        Name = "Weed",
        LightEmission = 0,
        Width1 = 0.15,
        Segments = 8,
        FaceCamera = true,
        Attachment0 = Attachment,
        Attachment1 = Attachment2,
        Color = ColorSequence.new(v20, v21),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.8, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Width0 = p56:NextNumber(0.9, 1.6),
        CurveSize0 = v132,
        CurveSize1 = -v132 * 0.6
    }).Parent = p53
end

local function shaftWalls(p57, p58, p59, p60) -- line: 868
    -- upvalues: Kit (copy), v3 (copy), facade (copy), ledge (copy), vent (copy), weed (copy)
    local v133 = if p60 then 8 else 16
    local v134 = if p60 then 5 else 10

    for i = 1, v133 do
        local v135 = (i - 1) / v133 * 3.141592653589793 * 2 + p59:NextNumber(-0.1, 0.1)
        local v138 = Vector3.new(p59:NextNumber(9, 15), p59:NextNumber(16, 34), p59:NextNumber(4, 7))
        local v139 = (i - 1) % 2 * 71 + -78 + p59:NextNumber(0, 71 - v138.Y * 0.5)
        local v140 = CFrame.Angles(p59:NextNumber(-0.06, 0.06), 0, p59:NextNumber(-0.1, 0.1))
        local v141 = v139 + v138.Y / 2
        local v142 = v138.Z / 2 + 0.5

        facade(p57, p58 * CFrame.Angles(0, v135, 0) * CFrame.new(0, v141, -(60 - v142)) * v140, v138, p59, v134)
    end

    local t16 = {}
    local t17 = {}

    for _, v143 in v3 do
        ledge(p57, p58, v143, p59, t16, t17)
    end

    for i = 1, 7 do
        vent(p57, p58, (i - 0.5) / 7 * 3.141592653589793 * 2 + p59:NextNumber(-0.2, 0.2), p59:NextNumber(-60, 80), p59)
    end

    local v145 = Kit.Part({
        Name = "Weeds",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    })

    v145.CFrame = p58
    v145.Parent = p57

    for i = 1, math.min(if p60 then 9 else 18, #t16) do
        local v148 = p59:NextInteger(i, #t16)
        local v149 = t16[v148]
        local v150 = t16[i]

        t16[i] = v149
        t16[v148] = v150
        weed(v145, p58, t16[i], p59)
    end

    return t17
end

local function struts(p61, p62, p63) -- line: 911
    -- upvalues: Kit (copy), v22 (copy)
    local n3 = 88

    while n3 >= -66 do
        local v151 = p63:NextNumber(15, 20)
        local v152 = 2 * (v151 + 0.9) * 0.2679491924311227 * 1.02
        local v153 = p62 * CFrame.new(0, n3, 0) * CFrame.Angles(p63:NextNumber(-0.2, 0.2), 0, p63:NextNumber(-0.2, 0.2))
        local v154 = p63:NextNumber(0, 6.283185307179586)
        local v155 = p63:NextInteger(2, 4)
        local v156 = p63:NextInteger(1, 12)

        for i = 1, 12 do
            if not ((i - v156) % 12 < v155) then
                local v157 = v154 + (i - 1) / 12 * 3.141592653589793 * 2
                local v158 = Kit.Part({
                    Name = "Girder",
                    Size = Vector3.new(v152, 1.3, 1.8),
                    Color = v22,
                    Material = Enum.Material.CorrodedMetal
                })

                v158.CFrame = v153 * CFrame.Angles(0, v157, 0) * CFrame.new(0, 0, -v151) * CFrame.Angles(0, 0, p63:NextNumber(-0.05, 0.05))
                v158.Parent = p61
            end
        end

        n3 -= 40 * p63:NextNumber(0.85, 1.15)
    end
end

local function floorDressing(p64, p65, p66) -- line: 943
    -- upvalues: Kit (copy), v11 (copy), v35 (copy), onFunnel (copy), facade (copy)
    local v159 = p66:NextNumber(0, 6.283185307179586)

    for i = 1, 3 do
        local v160 = v159 + (i - 1) / 3 * 3.141592653589793 * 2 + p66:NextNumber(-0.4, 0.4)
        local v163 = Vector3.new(p66:NextNumber(10, 14), p66:NextNumber(8, 11), p66:NextNumber(8, 10))

        facade(p64, onFunnel(p65, v160, p66:NextNumber(36, 44), v163.Y * 0.15) * CFrame.Angles(p66:NextNumber(-0.2, 0.05), 0, p66:NextNumber(-0.3, 0.3)), v163, p66, 2)
    end

    local v166 = onFunnel(p65, p66:NextNumber(0, 6.283185307179586), 32, 1) * CFrame.Angles(0, 0, 0.13962634015954636)

    for i = -3, 3 do
        local v167 = Kit.Part({
            Name = "Grate",
            Size = Vector3.new(0.5, 0.5, 9),
            Color = v11,
            Material = Enum.Material.CorrodedMetal
        })

        v167.CFrame = v166 * CFrame.new(i * 1.3, 0, 0)
        v167.Parent = p64
    end

    for i = -1, 1, 2 do
        local v168 = Kit.Part({
            Name = "Grate",
            Size = Vector3.new(9.4, 0.7, 0.7),
            Color = v11,
            Material = Enum.Material.CorrodedMetal
        })

        v168.CFrame = v166 * CFrame.new(0, 0, i * 4.3)
        v168.Parent = p64
    end

    local v169 = Kit.Part({
        Name = "Spot",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1
    })

    v169.CFrame = p65 * CFrame.new(0, -34, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
    v169.Parent = p64

    local SpotLight = Instance.new("SpotLight")

    SpotLight.Face = Enum.NormalId.Front
    SpotLight.Color = v35
    SpotLight.Angle = 40
    SpotLight.Range = 60
    SpotLight.Brightness = 0.9
    SpotLight.Shadows = false
    SpotLight.Parent = v169
end

local function twister(p67, p68, p69) -- line: 994
    -- upvalues: Kit (copy)
    local t18 = {
        {
            Texture = "rbxassetid://18925205019",
            Width = 7,
            Angle = 0,
            Rate = 2.4,
            Color = Kit.Teal
        },
        {
            Texture = "rbxassetid://12251459424",
            Width = 6,
            Angle = 2.0943951023931953,
            Rate = 2.4,
            Color = Color3.fromRGB(120, 230, 214)
        },
        {
            Texture = "rbxassetid://18925205019",
            Width = 5,
            Angle = 4.1887902047863905,
            Rate = 2.4,
            Color = Kit.DeepTeal
        }
    }
    local v170 = if p69 then 3 else 5

    for i = 1, v170 do
        table.insert(t18, {
            Width = 12,
            Rate = 1.7,
            TopRadius = 22,
            BottomRadius = 9.5,
            Curve = 46,
            Speed = 3.2,
            Fade = 0.62,
            Texture = i % 2 == 0 and "rbxassetid://12251459424" or "rbxassetid://18925205019",
            Angle = (i - 1) / v170 * 3.141592653589793 * 2 + 0.3,
            Color = if i % 2 == 0 then Color3.fromRGB(90, 200, 196) else Kit.DeepTeal
        })
    end

    for _, v171 in t18 do
        local v172 = v171.Fade or 0.45
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = p67

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = p67
        Kit.Beam({
            Name = "Twist",
            TextureLength = 18,
            LightEmission = 1,
            Segments = 24,
            FaceCamera = true,
            Attachment0 = Attachment,
            Attachment1 = Attachment2,
            Texture = v171.Texture,
            TextureMode = Enum.TextureMode.Wrap,
            TextureSpeed = v171.Speed or 1.5,
            Color = ColorSequence.new(v171.Color),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.25, v172),
                NumberSequenceKeypoint.new(0.8, v172 - 0.05),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Width0 = v171.Width,
            Width1 = v171.Width * 0.45,
            CurveSize0 = v171.Curve or 22,
            CurveSize1 = -(v171.Curve or 22)
        }).Parent = p67
        table.insert(p68, {
            Top = Attachment,
            Bottom = Attachment2,
            Angle = v171.Angle,
            Rate = v171.Rate,
            TopRadius = v171.TopRadius or 10,
            BottomRadius = v171.BottomRadius or 3
        })
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 100, 0)
    Attachment.Parent = p67

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, -80, 0)
    Attachment2.Parent = p67
    Kit.Beam({
        Name = "Core",
        Texture = "rbxassetid://15939596990",
        TextureLength = 30,
        TextureSpeed = 2,
        LightEmission = 1,
        Width0 = 9,
        Width1 = 4,
        FaceCamera = true,
        Attachment0 = Attachment,
        Attachment1 = Attachment2,
        Color = ColorSequence.new(Color3.fromRGB(150, 245, 225)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.7),
            NumberSequenceKeypoint.new(1, 0.85)
        })
    }).Parent = p67
end

local function paint(p70, p71, p72) -- line: 1093
    -- upvalues: v7 (copy), v41 (copy)
    local t21 = {}

    for _, descendant in p70:GetDescendants() do
        if descendant:IsA("SurfaceAppearance") or descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") and descendant.Transparency < 0.95 then
            local DrainGlow = descendant:GetAttribute("DrainGlow")

            if descendant:IsA("MeshPart") then
                descendant.TextureID = ""
            end

            if type(DrainGlow) ~= "string" or v41[DrainGlow] == nil then
                if descendant.Material == Enum.Material.Neon or descendant.Material == Enum.Material.Plastic or descendant.Material == Enum.Material.Glacier then
                    descendant.Material = Enum.Material.SmoothPlastic
                end

                local v174 = descendant.Color:Lerp(v7, p71)

                descendant.Color = Color3.new(v174.R * p72, v174.G * p72, v174.B * p72)
                descendant.Transparency = 0
            else
                descendant.Material = Enum.Material.Neon
                descendant.Color = v41[DrainGlow]
                descendant.Transparency = 0.45
                table.insert(t21, descendant)
            end
        end
    end

    return t21
end

local function grave(p73) -- line: 1125
    -- upvalues: Kit (copy), v15 (copy), v23 (copy), v30 (copy)
    local Model = Instance.new("Model")

    Model.Name = "Grave"

    local v175 = p73:NextNumber(2.8, 3.6)
    local v176 = p73:NextNumber(3.6, 4.8)
    local v177 = Kit.Part({
        Name = "Stone",
        Size = Vector3.new(v175, v176, 0.9),
        Color = v30,
        Material = Enum.Material.Slate
    })

    v177.CFrame = CFrame.new(0, v176 / 2, 0)
    v177.Parent = Model

    local v178 = Kit.Part({
        Name = "Crown",
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.9, v175, v175),
        Color = v30,
        Material = Enum.Material.Slate
    })

    v178.CFrame = CFrame.new(0, v176, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
    v178.Parent = Model

    local v180 = Kit.Part({
        Name = "Plinth",
        Size = Vector3.new(v175 + 1, 0.8, 1.8),
        Color = v23,
        Material = Enum.Material.Slate
    })

    v180.CFrame = CFrame.new(0, 0.2, 0)
    v180.Parent = Model

    local v181 = Kit.Part({
        Name = "Cross",
        Size = Vector3.new(0.4, 1.6, 0.2),
        Color = v15,
        Material = Enum.Material.SmoothPlastic
    })

    v181.CFrame = CFrame.new(0, v176 * 0.55, 0.5)
    v181.Parent = Model

    local clone = v181:Clone()

    clone.Size = Vector3.new(1.1, 0.4, 0.2)
    clone.CFrame = CFrame.new(0, v176 * 0.6, 0.5)
    clone.Parent = Model
    Model.WorldPivot = CFrame.new(0, v176 / 2, 0)

    return Model
end

local function ledgeProps(p74, p75, p76, p77, p78) -- line: 1171
    -- upvalues: Kit (copy), v6 (copy), onFunnel (copy), paint (copy)
    local Props = p76 and p76:FindFirstChild("Props")
    local Pumpkin = Props and Props:FindFirstChild("Pumpkin")

    if Pumpkin ~= nil and Pumpkin:IsA("Model") then
        local v182 = p77:NextNumber(0, 6.283185307179586)

        table.insert(p78, 1, (onFunnel(p75, v182 + 0, 48, 0.2)))
        table.insert(p78, 2, (onFunnel(p75, v182 + 2.0943951023931953, 48, 0.2)))
        table.insert(p78, 3, (onFunnel(p75, v182 + 4.1887902047863905, 48, 0.2)))

        for i = 1, math.min(8, #p78) do
            local v190 = i <= 3

            if not v190 then
                local v191 = p77:NextInteger(i, #p78)
                local v192 = p78[v191]
                local v193 = p78[i]

                p78[i] = v192
                p78[v191] = v193
            end

            local v194 = p78[i]
            local clone = Pumpkin:Clone()

            Kit.Quiet(clone)
            clone:ScaleTo(clone:GetScale() * (if v190 then p77:NextNumber(0.9, 1.1) else p77:NextNumber(0.7, 1)))

            local v195 = paint(clone, 0.05, 1)

            if v190 then
                if v195[1] ~= nil then
                    local PointLight = Instance.new("PointLight")

                    PointLight.Color = v6
                    PointLight.Range = 12
                    PointLight.Brightness = 1.4
                    PointLight.Shadows = false
                    PointLight.Parent = v195[1]
                end

                clone:PivotTo(v194 * CFrame.Angles(0, 1.5707963267948966 + p77:NextNumber(-0.5, 0.5), 0))
            else
                local Position = v194.Position
                local v196 = p75 * Vector3.new(0, p75:PointToObjectSpace(Position).Y, 0)

                clone:PivotTo(CFrame.lookAt(Position, v196) * CFrame.Angles(0, p77:NextNumber(-0.4, 0.4), 0) * CFrame.Angles(0.6, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0))
            end

            local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
            local v197 = v194.Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)

            clone:PivotTo(clone:GetPivot() + Vector3.new(0, v197, 0))
            clone.Parent = p74
        end
    end
end

local function drifters(p79, _, p81, p82, p83, p84) -- line: 1229
    -- upvalues: Kit (copy), v34 (copy), v40 (copy), paint (copy), grave (copy)
    local Props = p81 and p81:FindFirstChild("Props")

    if Props ~= nil then
        for v198, v199 in v40 do
            local Props2 = v199.Props
            local v200 = if p84 then math.max(#Props2 - 1, 2) else #Props2

            for i = 1, v200 do
                local v202 = if Props2[i] == "Grave" then grave(p82) else Props:FindFirstChild(Props2[i])

                if v202 ~= nil and v202:IsA("Model") then
                    local v203 = if Props2[i] == "Grave" then v202 else v202:Clone()

                    Kit.Quiet(v203)

                    if Props2[i] ~= "Kiosk" then
                        v203:ScaleTo(v203:GetScale() * p82:NextNumber(0.85, v198 == 1 and 1.1 or 1.3))
                    end

                    local v204 = Props2[i] == "Pumpkin"
                    local v206 = math.clamp(v199.Murk + p82:NextNumber(-0.08, 0.08), 0, 0.9)

                    if v204 then
                        v206 = math.min(v206, 0.12)
                    end

                    local v207 = paint(v203, v206, v199.Dim)

                    v203.Parent = p79

                    local t23 = {}

                    for _, descendant in v203:GetDescendants() do
                        if descendant:IsA("BasePart") and descendant.Transparency < 0.95 then
                            table.insert(t23, descendant)
                        end
                    end

                    local v208 = 66 / v200
                    local BoundingBox, BoundingBox2 = v203:GetBoundingBox()

                    table.insert(p83, {
                        Faded = 0,
                        Model = v203,
                        Pivot = v203:GetPivot(),
                        Radius = v199.Radius,
                        Angle = (i - 1) / v200 * 3.141592653589793 * 2 + v198 * 0.9 + p82:NextNumber(-0.3, 0.3),
                        Height = (i - 1) * v208 + -54 + p82:NextNumber(0, v208 * 0.6),
                        Speed = v199.Speed,
                        Spin = p82:NextNumber(-0.25, 0.25),
                        Tilt = p82:NextNumber(-0.35, 0.35),
                        Glows = v207,
                        Parts = t23,
                        Face = if v204 then v34 else CFrame.identity,
                        Center = v203:GetPivot():ToObjectSpace(BoundingBox),
                        Reach = BoundingBox2.Magnitude / 2
                    })
                end
            end
        end
    end
end

local function lines(p85, p86, p87) -- line: 1293
    -- upvalues: Kit (copy), v36 (copy)
    local t25 = {}

    for _ = 1, if p87 then 16 else 30 do
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = p85

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = p85

        local v209 = Kit.Beam({
            Name = "Line",
            Texture = "rbxassetid://15939596990",
            TextureLength = 1,
            TextureSpeed = 0,
            LightEmission = 0.6,
            Segments = 1,
            FaceCamera = true,
            Attachment0 = Attachment,
            Attachment1 = Attachment2,
            TextureMode = Enum.TextureMode.Stretch,
            Color = ColorSequence.new(v36),
            Transparency = NumberSequence.new(1),
            Width0 = p86:NextNumber(0.5, 0.8),
            Width1 = p86:NextNumber(0.5, 0.8)
        })

        v209.Parent = p85
        table.insert(t25, {
            Beam = v209,
            Top = Attachment,
            Bottom = Attachment2,
            Angle = p86:NextNumber(0, 6.283185307179586),
            Radius = p86:NextNumber(13, 48),
            Offset = p86:NextNumber(0, 150),
            Length = p86:NextNumber(2.5, 5),
            Speed = p86:NextNumber(40, 90)
        })
    end

    return t25
end

local function lineFade(p88) -- line: 1332
    local v210 = math.clamp(p88, 0, 1)

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 1 - v210 * 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function stepLines(p89, p90) -- line: 1341
    -- upvalues: lineFade (copy)
    local LineAlpha = p89.LineAlpha

    if math.abs(LineAlpha - p89.LineShown) > 0.04 or LineAlpha == 0 and p89.LineShown ~= 0 then
        p89.LineShown = LineAlpha

        local v212 = lineFade(LineAlpha)

        for _, v213 in p89.Lines do
            v213.Beam.Transparency = v212
        end
    end

    if LineAlpha <= 0 then
        return
    end

    local v214 = p89.LineY - 110
    local v215 = LineAlpha * 0.9 + 0.6

    for _, v216 in p89.Lines do
        local v217 = v214 + (v216.Offset + p90 * v216.Speed - v214) % 150
        local v218 = math.cos(v216.Angle) * v216.Radius
        local v219 = math.sin(v216.Angle) * v216.Radius

        v216.Bottom.Position = Vector3.new(v218, v217, v219)
        v216.Top.Position = Vector3.new(v218, v217 + v216.Length * v215, v219)
    end
end

local function breathEmitter() -- line: 1364
    -- upvalues: Kit (copy)
    return Kit.Emitter({
        Name = "Breath",
        Texture = "rbxassetid://11800775280",
        LightEmission = 0.6,
        LightInfluence = 0,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        FlipbookFramerate = NumberRange.new(20, 30),
        Shape = Enum.ParticleEmitterShape.Box,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
        EmissionDirection = Enum.NormalId.Top,
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(30, 55),
        SpreadAngle = Vector2.new(25, 25),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(1, 0.45)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.8, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = ColorSequence.new(Color3.fromRGB(215, 255, 248))
    })
end

local function placeDrifter(p91, p92, p93) -- line: 1392
    local Origin = p91.Origin
    local v221 = p92.Angle + p93 * 0.12
    local v224 = Vector3.new(math.cos(v221) * p92.Radius, p92.Height, math.sin(v221) * p92.Radius)
    local v225 = CFrame.lookAt(v224, (Vector3.new(0, p92.Height, 0)))
    local v226 = CFrame.Angles(p92.Tilt, p93 * p92.Spin, p92.Tilt * 0.6)

    p92.Model:PivotTo(Origin * v225 * p92.Face * v226)
end

local function fadeNearLens(p94, p95) -- line: 1405
    local v227 = if ((p94.Model:GetPivot() * p94.Center).Position - p95).Magnitude - p94.Reach < 8 then 1 else 0

    if v227 ~= p94.Faded then
        p94.Faded = v227

        for _, v228 in p94.Parts do
            v228.LocalTransparencyModifier = v227
        end
    end
end

function t1.Build(p96, p97, p98, p99) -- line: 1422
    -- upvalues: Kit (copy), v37 (copy), t1 (copy), wall (copy), floor (copy), funnel (copy), siltSlide (copy), pipe (copy), shaftWalls (copy), struts (copy), floorDressing (copy), twister (copy), ledgeProps (copy), drifters (copy), lines (copy), breathEmitter (copy)
    local v229 = p96:Add(Instance.new("Model"))

    v229.Name = "SewerDrainDepths"

    local Assets = script.Parent:FindFirstChild("Assets")
    local t27 = {}

    for i = 1, 10 do
        wall(v229, p98, (i - 1) / 10 * 3.141592653589793 * 2, t27)
    end

    floor(v229, p98, t27)
    funnel(v229, p98)
    siltSlide(v229, p98, p99)

    local v230 = Kit.Part({
        Name = "Sky",
        Size = Vector3.new(128, 2, 128),
        Color = v37,
        Material = Enum.Material.Neon
    })

    v230.CFrame = p98 * CFrame.new(0, 101, 0)
    v230.Parent = v229

    local v231 = Random.new()
    local v232, v233, v234, v235, v236, v237, v238 = pipe(v229, p98, v231)
    local v239 = shaftWalls(v229, p98, v231, p99)

    struts(v229, p98, v231)
    floorDressing(v229, p98, v231)

    local v240 = Kit.Part({
        Name = "Hub",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    })

    v240.CFrame = p98
    v240.Parent = v229

    local t28 = {}

    twister(v240, t28, p99)

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Bubbles"
    Attachment.Position = Vector3.new(0, -78, 0)
    Attachment.Orientation = Vector3.new(0, 0, 0)
    Attachment.Parent = v240

    local v241 = Kit.Emitter({
        Name = "Bubbles",
        Texture = "rbxassetid://11800775280",
        LightEmission = 0.6,
        LightInfluence = 0,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        FlipbookFramerate = NumberRange.new(20, 30),
        Rate = p99 and 10 or 22,
        Lifetime = NumberRange.new(2.4, 3.2),
        Speed = NumberRange.new(26, 38),
        SpreadAngle = Vector2.new(28, 28),
        EmissionDirection = Enum.NormalId.Top,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 0.9)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.8, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = ColorSequence.new(Color3.fromRGB(200, 255, 245))
    })

    v241.Parent = Attachment

    local v242 = Kit.Part({
        Name = "Breath",
        Size = Vector3.new(2, 2, 2),
        Transparency = 1
    })

    v242.CFrame = p98
    v242.Parent = v229

    local v243 = breathEmitter()

    v243.Parent = v242

    local v244 = Kit.Part({
        Name = "Motes",
        Size = Vector3.new(36, 26, 36),
        Transparency = 1
    })

    v244.CFrame = p98
    v244.Parent = v229

    local v245 = Kit.Emitter({
        Name = "Motes",
        Texture = "rbxassetid://15939596990",
        LightEmission = 1,
        LightInfluence = 0,
        Shape = Enum.ParticleEmitterShape.Box,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
        EmissionDirection = Enum.NormalId.Top,
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Lifetime = NumberRange.new(0.3, 0.55),
        Speed = NumberRange.new(80, 120),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(1, 0.15)
        }),
        Squash = NumberSequence.new(-2.5),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = ColorSequence.new(Color3.fromRGB(180, 245, 235))
    })

    v245.Parent = v244

    local v246 = lines(v240, v231, p99)
    local t30 = {}

    drifters(v229, p98, Assets, v231, t30, p99)
    ledgeProps(v229, p98, Assets, v231, v239)
    v229.Parent = p97

    local t31 = {
        LineAlpha = 0,
        LineShown = -1,
        LineY = 0,
        Low = -54,
        High = 12,
        Squeeze = 1,
        Spin = 0,
        Travel = 0,
        Floor = -80,
        PipeBottom = -180,
        PipeRadius = 8.5,
        Model = v229,
        Origin = p98,
        Hub = v240,
        Strands = t28,
        Drifters = t30,
        Caustics = t27,
        Bubbles = v241,
        Glow = v232,
        EndCap = v233,
        Exit = v237,
        ExitLight = v238,
        Fog = v235,
        Slime = v236,
        Lines = v246,
        Mouth = v234,
        Breath = v243,
        BreathPart = v242,
        Motes = v245,
        MotesPart = v244,
        Quality = p99,
        Random = v231
    }

    t1.Step(t31, 0, 0, 0)

    return t31
end

function t1.Step(p100, p101, p102, p103) -- line: 1556
    -- upvalues: Workspace (copy), stepLines (copy), placeDrifter (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else p100.Origin.Position

    p100.Travel += p102 * p103
    p100.Spin += p102 * p103

    for _, v247 in p100.Strands do
        local v248 = v247.Angle + p101 * v247.Rate + p100.Spin * v247.Rate * 0.5
        local v249 = v247.TopRadius * p100.Squeeze
        local BottomRadius = v247.BottomRadius

        v247.Top.Position = Vector3.new(math.cos(v248) * v249, 100, math.sin(v248) * v249)
        v247.Bottom.Position = Vector3.new(math.cos(v248 + 3.141592653589793) * BottomRadius, -80, math.sin(v248 + 3.141592653589793) * BottomRadius)
    end

    stepLines(p100, p101)

    local v256 = p100.Travel / 140 % 1

    for _, v257 in p100.Caustics do
        v257.Position = UDim2.fromScale(0, v256 + -1)
    end

    for _, v258 in p100.Drifters do
        v258.Height += v258.Speed * p102 * p103

        if v258.Height > p100.High then
            v258.Height = p100.Low - p100.Random:NextNumber(0, 6)
            v258.Angle += p100.Random:NextNumber(1.2, 2.4)
        elseif v258.Height < p100.Low - 12 then
            v258.Height = p100.Low + p100.Random:NextNumber(0, p100.High - p100.Low)
        end

        placeDrifter(p100, v258, p101)

        local v259 = if ((v258.Model:GetPivot() * v258.Center).Position - Position).Magnitude - v258.Reach < 8 then 1 else 0

        if v259 ~= v258.Faded then
            v258.Faded = v259

            for _, v260 in v258.Parts do
                v260.LocalTransparencyModifier = v259
            end
        end

        for _, v261 in v258.Glows do
            v261.Transparency = math.noise(p101 * 7, v258.Angle * 3) * 0.5 + 0.5 < 0.18 and 0.75 or 0.05
        end
    end
end

function t1.Light(p104, p105) -- line: 1594
    p104.Glow.Brightness = p105
    p104.Mouth.Brightness = p105 * 0.3
end

function t1.Follow(p106, p107) -- line: 1599
    p106.Low = math.max(p107 - 100, -54)
    p106.High = p107 + 40
end

function t1.Rush(p108, p109, p110) -- line: 1604
    local v263 = math.clamp(p109, 0, 1)
    local v264 = if p108.Quality then 0.5 else 1

    p108.LineAlpha = v263
    p108.LineY = p108.Origin:PointToObjectSpace(p110).Y
    p108.Breath.Rate = v264 * 30 * v263
    p108.BreathPart.CFrame = CFrame.new(p110)
    p108.Motes.Rate = v264 * 70 * v263
    p108.MotesPart.CFrame = CFrame.new(p110 + Vector3.new(0, 4, 0))
end

function t1.Tighten(p111, p112) -- line: 1615
    p111.Squeeze = p112
end

function t1.Fog(p113, p114) -- line: 1619
    local v265 = math.clamp(p114, 0, 1)

    for _, v266 in p113.Fog do
        v266.Transparency = 1 - v265 * 0.5800000000000001
    end

    p113.EndCap.Transparency = math.lerp(0.35, 1, v265)

    for _, v267 in p113.Slime do
        v267.Enabled = v265 < 0.5
    end
end

function t1.Exit(p115, p116) -- line: 1630
    local v268 = math.clamp(p116, 0, 1)

    p115.Exit.Transparency = math.lerp(1, 0.08, v268)
    p115.ExitLight.Brightness = v268 * 3

    for _, v269 in p115.Fog do
        v269.Transparency = math.max(v269.Transparency, v268)
    end
end

return table.freeze(t1)
