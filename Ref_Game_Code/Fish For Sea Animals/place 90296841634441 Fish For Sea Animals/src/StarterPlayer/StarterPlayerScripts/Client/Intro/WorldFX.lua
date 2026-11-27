-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Actors = require(script.Parent.Actors)
local Director = require(script.Parent.Director)
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(18, 18, 26)
local t2 = {}
local v3

local function emitter(p1, p2) -- line: 23
    -- upvalues: RunService (copy), Director (copy), t2 (copy), v3 (ref)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v4, v5 in p2 do
        ParticleEmitter[v4] = v5
    end

    ParticleEmitter.Parent = p1
    t2[ParticleEmitter] = true
    v3 = v3 or RunService.Heartbeat:Connect(function() -- line: 31
        -- upvalues: Director (copy), t2 (copy)
        local v7 = math.max(Director.rate(), 0.001)

        for v8 in t2 do
            if v8.Parent then
                v8.TimeScale = v7
            else
                t2[v8] = nil
            end
        end
    end)

    return ParticleEmitter
end

local function anchor(p3, p4) -- line: 45
    -- upvalues: Debris (copy), Actors (copy)
    local v9 = Actors.part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p3
    })

    Debris:AddItem(v9, p4)

    return v9
end

function t1.shockwave(p5, p6, p7, p8) -- line: 52
    -- upvalues: Debris (copy), UIUtil (copy), Actors (copy)
    local v10 = Actors.part({
        Size = Vector3.new(0.3, 1, 1),
        Transparency = 0.05,
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = p6,
        CFrame = CFrame.new(p5) * CFrame.Angles(0, 0, 1.5707963267948966)
    })

    UIUtil.tween(v10, p8 or 0.5, {
        Transparency = 1,
        Size = Vector3.new(0.05, p7, p7)
    }, Enum.EasingStyle.Quart)
    Debris:AddItem(v10, (p8 or 0.5) + 0.1)
end

function t1.pillar(p9, p10, p11, p12) -- line: 59
    -- upvalues: Debris (copy), UIUtil (copy), Actors (copy)
    local v12 = Actors.part({
        Transparency = 0.1,
        Material = Enum.Material.Neon,
        Color = p10,
        Size = Vector3.new(3, p11, 3),
        Position = p9 + Vector3.new(0, p11 / 2, 0)
    })

    UIUtil.tween(v12, p12, {
        Transparency = 1,
        Size = Vector3.new(18, p11, 18)
    }, Enum.EasingStyle.Sine)
    Debris:AddItem(v12, p12 + 0.1)
end

function t1.dust(p13, p14) -- line: 66
    -- upvalues: Debris (copy), Actors (copy), emitter (copy)
    p14 = p14 or 1

    local v14 = Actors.part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p13
    })

    Debris:AddItem(v14, 3)
    emitter(v14, {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Drag = 5,
        Rate = 0,
        Color = ColorSequence.new(Color3.fromRGB(235, 225, 205)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.2 * p14),
            NumberSequenceKeypoint.new(1, 3 * p14)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(14 * p14, 22 * p14),
        SpreadAngle = Vector2.new(0, 180),
        EmissionDirection = Enum.NormalId.Right
    }):Emit((math.floor(26 * p14)))
end

function t1.splash(p15, p16) -- line: 83
    -- upvalues: Debris (copy), Actors (copy), v1 (copy), emitter (copy)
    local v17 = Actors.part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p15
    })

    Debris:AddItem(v17, 4)
    emitter(v17, {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Acceleration = Vector3.new(0, -70, 0),
        Drag = 0.5,
        Rate = 0,
        Color = ColorSequence.new(Color3.fromRGB(230, 245, 255), Color3.fromRGB(120, 190, 240)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p16 * 0.6),
            NumberSequenceKeypoint.new(1, p16 * 0.15)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.9, 1.5),
        Speed = NumberRange.new(p16 * 20, p16 * 38),
        SpreadAngle = Vector2.new(18, 18),
        EmissionDirection = Enum.NormalId.Top
    }):Emit((math.floor(p16 * 90)))
    emitter(v17, {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Rate = 0,
        Color = ColorSequence.new(v1),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p16 * 2),
            NumberSequenceKeypoint.new(1, p16 * 5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.6, 1),
        Speed = NumberRange.new(p16 * 6, p16 * 12),
        SpreadAngle = Vector2.new(70, 70),
        EmissionDirection = Enum.NormalId.Top
    }):Emit((math.floor(p16 * 16)))
end

function t1.aura(p17, p18, p19) -- line: 112
    -- upvalues: v1 (copy), emitter (copy)
    p19 = p19 or 1

    local v23 = emitter(p17, {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        LightEmission = 1,
        Acceleration = Vector3.new(0, 30, 0),
        ZOffset = -1,
        Color = ColorSequence.new(p18:Lerp(v1, 0.5), p18),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.6 * p19),
            NumberSequenceKeypoint.new(1, 0.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.3, 0.55),
        Speed = NumberRange.new(6, 12),
        SpreadAngle = Vector2.new(12, 12),
        EmissionDirection = Enum.NormalId.Top,
        Rate = 70 * p19
    })
    local v24 = emitter(p17, {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        Acceleration = Vector3.new(0, 15, 0),
        Color = ColorSequence.new(v1, p18),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Lifetime = NumberRange.new(0.4, 0.8),
        Speed = NumberRange.new(10, 20),
        SpreadAngle = Vector2.new(30, 30),
        EmissionDirection = Enum.NormalId.Top,
        Rate = 40 * p19
    })

    return function(p20) -- line: 140
        -- upvalues: v23 (copy), v24 (copy)
        v23.Enabled = p20
        v24.Enabled = p20
    end
end

function t1.rainbowTrail(p21, p22) -- line: 146
    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")
    local v26 = Vector3.new(0, p22 / 2, 0)
    local v28 = Vector3.new(0, -p22 / 2, 0)

    Attachment.Position = v26
    Attachment2.Position = v28
    Attachment.Parent = p21
    Attachment2.Parent = p21

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Lifetime = 0.6
    Trail.LightEmission = 0.25
    Trail.FaceCamera = true
    Trail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 100)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 255, 140)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 90, 255))
    })
    Trail.Transparency = NumberSequence.new(0, 1)
    Trail.WidthScale = NumberSequence.new(1, 0)
    Trail.Parent = p21

    return Trail
end

local function mark(p23, p24, p25, p26) -- line: 169
    -- upvalues: Debris (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(p24, p24)
    BillboardGui.StudsOffsetWorldSpace = p25
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p23
    BillboardGui.Parent = p23

    if p26 then
        Debris:AddItem(BillboardGui, p26)
    end

    return BillboardGui
end

function t1.noseBubble(p27) -- line: 186
    -- upvalues: Debris (copy), RunService (copy), Actors (copy), Director (copy), emitter (copy)
    local v29 = Actors.part({
        Name = "NoseBubble",
        Transparency = 0.45,
        Reflectance = 0.3,
        Size = Vector3.new(0.2, 0.2, 0.2),
        Shape = Enum.PartType.Ball,
        Material = Enum.Material.Glass,
        Color = Color3.fromRGB(200, 235, 255)
    })
    local connection = RunService.RenderStepped:Connect(function() -- line: 188
        -- upvalues: p27 (copy), v29 (copy), Director (copy)
        local v31 = ((math.sin(Director.now() * 2.4) + 1) / 2) ^ 2 * 0.85 + 0.2

        v29.Size = Vector3.new(1, 1, 1) * v31
        v29.CFrame = p27.CFrame * CFrame.new(0.12, -0.1, -p27.Size.Z / 2 - v31 / 2 + 0.05)
    end)

    return function() -- line: 194
        -- upvalues: v29 (copy), connection (copy), Debris (copy), Actors (copy), emitter (copy)
        connection:Disconnect()

        local Position = v29.Position

        v29:Destroy()

        local v32 = Actors.part({
            Size = Vector3.new(1, 1, 1),
            Transparency = 1,
            Position = Position
        })

        Debris:AddItem(v32, 2)
        emitter(v32, {
            Rate = 0,
            Color = ColorSequence.new(Color3.fromRGB(200, 235, 255)),
            Size = NumberSequence.new(0.15, 0),
            Lifetime = NumberRange.new(0.25, 0.4),
            Speed = NumberRange.new(6, 10),
            SpreadAngle = Vector2.new(180, 180)
        }):Emit(14)
    end
end

function t1.zzz(p28) -- line: 210
    -- upvalues: Debris (copy), Kit (copy), UIUtil (copy), Actors (copy), v1 (copy)
    local v33 = true

    task.spawn(function() -- line: 212
        -- upvalues: p28 (copy), v33 (ref), Debris (copy), Kit (copy), UIUtil (copy), Actors (copy), v1 (copy)
        local n1 = 0

        while v33 and p28.Parent do
            n1 += 1

            local BillboardGui = Instance.new("BillboardGui")

            BillboardGui.Size = UDim2.fromScale(1.4, 1.4)
            BillboardGui.StudsOffsetWorldSpace = Vector3.new(1, 1.4, 0)
            BillboardGui.AlwaysOnTop = false
            BillboardGui.LightInfluence = 0
            BillboardGui.Adornee = p28
            BillboardGui.Parent = p28
            Debris:AddItem(BillboardGui, 1.9)

            local v35 = Kit.text(BillboardGui, if n1 % 2 == 0 then "Z" else "z", {
                StrokeThickness = 3,
                Size = UDim2.fromScale(1, 1),
                TextColor3 = v1,
                FontFace = Actors.COMIC
            })

            UIUtil.tween(BillboardGui, 1.8, {
                StudsOffsetWorldSpace = Vector3.new(n1 % 2 * 0.5 + 2.4, 3.8, 0),
                Size = UDim2.fromScale(2.2, 2.2)
            }, Enum.EasingStyle.Sine)
            UIUtil.tween(v35, 1.8, {
                TextTransparency = 1,
                Rotation = n1 % 2 == 0 and 20 or -15
            })
            UIUtil.tween(v35.UIStroke, 1.8, {
                Transparency = 1
            })
            task.wait(0.7)
        end
    end)

    return function() -- line: 224
        -- upvalues: v33 (ref)
        v33 = false
    end
end

function t1.shock(p29, p30) -- line: 230
    -- upvalues: Debris (copy), Kit (copy), UIUtil (copy), v2 (copy)
    p30 = p30 or 0.8

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(5, 5)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0.3, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p29
    BillboardGui.Parent = p29
    Debris:AddItem(BillboardGui, p30)

    for i = 0, 9 do
        local v38 = i * 36 + math.random(-8, 8)
        local v39 = Kit.frame(BillboardGui, {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            Rotation = v38
        })
        local v40 = Kit.frame(v39, {
            BackgroundColor3 = v2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.3),
            Size = UDim2.fromScale(0.035, 0)
        })

        UIUtil.tween(v40, 0.12, {
            Size = UDim2.fromScale(0.035, 0.16),
            Position = UDim2.fromScale(0.5, 0.2)
        }, Enum.EasingStyle.Back)
    end
end

function t1.sweat(p31, p32) -- line: 241
    -- upvalues: Debris (copy), Kit (copy), UIUtil (copy), v2 (copy)
    local v41 = p32 or 1.4
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(1.1, 1.1)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0.9, 0.9, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p31
    BillboardGui.Parent = p31
    Debris:AddItem(BillboardGui, v41)

    local v42 = Kit.frame(BillboardGui, {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.4),
        Size = UDim2.fromScale(0.6, 0.6)
    })
    local v43 = Kit.frame(v42, {
        Rotation = 45,
        BackgroundColor3 = Color3.fromRGB(150, 210, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.42),
        Size = UDim2.fromScale(0.5, 0.5)
    })

    Kit.stroke(v43, 2.5, v2)

    local v44 = Kit.frame(v42, {
        BackgroundColor3 = Color3.fromRGB(150, 210, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.62),
        Size = UDim2.fromScale(0.7, 0.7)
    })

    Kit.corner(v44, 999)
    Kit.stroke(v44, 2.5, v2)
    UIUtil.tween(v42, p32 or 1.4, {
        Position = UDim2.fromScale(0.5, 0.75)
    }, Enum.EasingStyle.Sine)
end

function t1.sparkles(p33, p34) -- line: 253
    -- upvalues: Debris (copy), Kit (copy), UIUtil (copy)
    p34 = p34 or 1.6

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(6, 6)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0.2, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p33
    BillboardGui.Parent = p33
    Debris:AddItem(BillboardGui, p34)

    for i = 1, 7 do
        local v47 = math.rad(i * 51.42857142857143 + math.random(-15, 15))
        local v48 = 0.3 + math.random() * 0.12
        local v49 = Kit.frame(BillboardGui, {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5 + math.cos(v47) * v48, 0.5 + math.sin(v47) * v48),
            Size = UDim2.fromScale(0, 0)
        })

        for _, v50 in { true, false } do
            local v51 = Kit.frame(v49, {
                BackgroundColor3 = Color3.fromRGB(255, 245, 180),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = if v50 then UDim2.fromScale(1, 0.12) else UDim2.fromScale(0.12, 1)
            })
            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = v50 and 0 or 90
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = v51
        end

        local v52 = 0.14 + math.random() * 0.1

        task.delay(i * 0.05, function() -- line: 267
            -- upvalues: v49 (copy), v52 (copy), UIUtil (copy)
            UIUtil.tween(v49, 0.25, {
                Rotation = 45,
                Size = UDim2.fromScale(v52, v52)
            }, Enum.EasingStyle.Back)
        end)
    end
end

function t1.exclaim(p35, p36, p37) -- line: 274
    -- upvalues: Debris (copy), Kit (copy), UIUtil (copy), Actors (copy), v2 (copy)
    p37 = p37 or 1

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(2.4, 2.4)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(1.1, 1.8, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p35
    BillboardGui.Parent = p35
    Debris:AddItem(BillboardGui, p37)

    local v54 = Kit.text(BillboardGui, p36 or "!?", {
        StrokeThickness = 4,
        Rotation = 10,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = Color3.fromRGB(255, 70, 60),
        FontFace = Actors.COMIC
    })

    v54.UIStroke.Color = v2

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.2
    UIScale.Parent = v54
    UIUtil.tween(UIScale, 0.22, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

function t1.say(p38, p39, p40, p41) -- line: 286
    -- upvalues: RunService (copy), Kit (copy), UIUtil (copy), Actors (copy), v2 (copy)
    local head = p38.head

    if not head then
        return
    end

    local Bubble = head:FindFirstChild("Bubble")

    if Bubble then
        Bubble:Destroy()
    end

    local v56 = math.clamp(#p39 * 26 + 70, 150, 520) * (if p41 then 1.2 else 1)
    local v58 = if p41 then 120 else 96
    local v57 = if p41 then 6 else 4
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "Bubble"
    BillboardGui.Size = UDim2.fromOffset(v56, v58 + 26)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = head

    local v59 = Kit.frame(BillboardGui, {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local v60 = Kit.frame(v59, {
        Rotation = 45,
        ZIndex = 1,
        BackgroundColor3 = Color3.new(1, 1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.4, 0, 0, v58 + 6),
        Size = UDim2.fromOffset(26, 26)
    })

    Kit.stroke(v60, v57, v2)

    local v61 = Kit.frame(v59, {
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, v58)
    })

    Kit.corner(v61, v58 // 2)
    Kit.stroke(v61, v57, v2)
    Kit.frame(v59, {
        ZIndex = 3,
        BackgroundColor3 = Color3.new(1, 1, 1),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.4, 0, 0, v58 - 8),
        Size = UDim2.fromOffset(16, v57 + 9)
    })
    Kit.text(v61, p39, {
        StrokeThickness = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -36, 1, -22),
        TextColor3 = if p41 then Color3.fromRGB(230, 50, 30) else v2,
        FontFace = Actors.COMIC
    }).UIStroke.Enabled = false
    BillboardGui.Parent = head

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.3
    UIScale.Parent = v59
    UIUtil.tween(UIScale, 0.25, {
        Scale = 1
    }, Enum.EasingStyle.Back)

    local connection = if p41 then RunService.RenderStepped:Connect(function() -- line: 331
        -- upvalues: v59 (copy)
        v59.Position = UDim2.fromOffset(math.random(-3, 3), math.random(-3, 3))
    end) else nil

    task.delay(p40 or 2, function() -- line: 335
        -- upvalues: BillboardGui (copy), UIScale (copy), connection (copy), UIUtil (copy)
        if connection then
            connection:Disconnect()
        end

        if BillboardGui.Parent then
            UIUtil.tween(UIScale, 0.12, {
                Scale = 0
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.12)
            BillboardGui:Destroy()
        end
    end)
end

function t1.cleanup() -- line: 347
    -- upvalues: t2 (copy), v3 (ref)
    if v3 then
        v3:Disconnect()
        v3 = nil
    end

    table.clear(t2)
end

return t1
