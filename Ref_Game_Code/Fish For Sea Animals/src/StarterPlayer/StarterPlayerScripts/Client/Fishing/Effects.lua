-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local t1 = {}
local v1 = Random.new()
local v2 = Color3.new(1, 1, 1)

local function anchoredPart(p1) -- line: 17
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Material = Enum.Material.SmoothPlastic

    for v3, v4 in p1 do
        Part[v3] = v4
    end

    return Part
end

t1.part = anchoredPart

local function biomeModel(p2) -- line: 34
    -- upvalues: Config (copy)
    for _, v5 in Config.inWorlds("Biomes") do
        for _, child in v5:GetChildren() do
            if child:GetAttribute("BiomeIndex") == p2 then
                return child
            end
        end
    end

    return nil
end

function t1.liquid(p3) -- line: 46
    -- upvalues: biomeModel (copy)
    local v6 = biomeModel(p3)

    return v6 and (v6:FindFirstChild("Water") or v6:FindFirstChild("Lava"))
end

function t1.liquidAt(p4) -- line: 53
    -- upvalues: Canyon (copy), biomeModel (copy)
    local v7 = biomeModel(Canyon.biomeAt(p4))

    if not v7 then
        return nil
    end

    for _, child in v7:GetChildren() do
        if (child.Name == "Water" or child.Name == "Lava") and (child:GetAttribute("S0") or (-1e999)) <= p4 and p4 <= (child:GetAttribute("S1") or 1e999) then
            return child
        end
    end

    return v7:FindFirstChild("Water") or v7:FindFirstChild("Lava")
end

function t1.waterCover() -- line: 68
    -- upvalues: Config (copy), anchoredPart (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "WaterCover"

    for _, v8 in Config.inWorlds("Biomes") do
        for _, descendant in v8:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant.Name == "Water" or descendant.Name == "Lava") then
                anchoredPart({
                    Name = "Cover",
                    Size = descendant.Size,
                    CFrame = descendant.CFrame * CFrame.new(0, -0.08, 0),
                    Color = descendant.Color:Lerp(Color3.new(0, 0, 0), 0.35),
                    Material = descendant.Material,
                    Parent = Folder
                })
            end
        end
    end

    Folder.Parent = workspace

    return Folder
end

function t1.splash(p5, p6, p7) -- line: 91
    -- upvalues: Debris (copy), t1 (copy), anchoredPart (copy)
    p7 = p7 or 1

    local v10 = anchoredPart({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p5,
        Parent = workspace
    })
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1), p6:Lerp(Color3.new(1, 1, 1), 0.4))
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7 * p7),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.1)
    ParticleEmitter.Speed = NumberRange.new(14 * p7, 26 * p7)
    ParticleEmitter.SpreadAngle = Vector2.new(32, 32)
    ParticleEmitter.Acceleration = Vector3.new(0, -70, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v10
    ParticleEmitter:Emit((math.floor(45 * p7)))
    t1.ripple(p5, 14 * p7)
    Debris:AddItem(v10, 2)
end

function t1.emitter(p8, p9) -- line: 112
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 0

    for v12, v13 in p9 do
        ParticleEmitter[v12] = v13
    end

    ParticleEmitter.Parent = p8

    return ParticleEmitter
end

function t1.ripple(p10, p11, p12) -- line: 125
    -- upvalues: Debris (copy), t1 (copy), v2 (copy), anchoredPart (copy)
    local v14 = anchoredPart({
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        Position = p10,
        Parent = workspace
    })
    local v15 = t1.emitter(v14, {
        LightEmission = 0.1,
        Drag = 2.2,
        Color = ColorSequence.new(p12 or v2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 0.12)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.765, 0.9),
        Speed = NumberRange.new(p11 * 0.95, p11 * 1.05),
        SpreadAngle = Vector2.new(6, 0),
        EmissionDirection = Enum.NormalId.Front
    })
    local v18 = math.clamp(math.floor(p11 * 2.5), 12, 48)

    for i = 1, v18 do
        v14.CFrame = CFrame.new(p10 + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, i / v18 * 3.141592653589793 * 2, 0)
        v15:Emit(1)
    end

    Debris:AddItem(v14, 1.1)
end

function t1.breach(p13, p14, p15) -- line: 149
    -- upvalues: Debris (copy), t1 (copy), anchoredPart (copy)
    local v19 = anchoredPart({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p13,
        Parent = workspace
    })
    local v20 = ColorSequence.new(p14:Lerp(Color3.new(1, 1, 1), 0.65), p14:Lerp(Color3.new(1, 1, 1), 0.25))

    t1.emitter(v19, {
        Acceleration = Vector3.new(0, -75, 0),
        Drag = 0.6,
        Color = v20,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p15 * 0.5),
            NumberSequenceKeypoint.new(1, p15 * 0.15)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.8, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1, 1.6),
        Speed = NumberRange.new(p15 * 22, p15 * 40),
        SpreadAngle = Vector2.new(14, 14),
        EmissionDirection = Enum.NormalId.Top
    }):Emit((math.floor(p15 * 110)))
    t1.emitter(v19, {
        Acceleration = Vector3.new(0, -60, 0),
        Color = v20,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p15 * 0.35),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new(0.15, 1),
        Lifetime = NumberRange.new(0.6, 1),
        Speed = NumberRange.new(p15 * 10, p15 * 18),
        SpreadAngle = Vector2.new(80, 80),
        EmissionDirection = Enum.NormalId.Top
    }):Emit((math.floor(p15 * 60)))
    t1.emitter(v19, {
        Acceleration = Vector3.new(0, 2, 0),
        Color = ColorSequence.new(Color3.new(1, 1, 1)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p15 * 2.5),
            NumberSequenceKeypoint.new(1, p15 * 7)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.2, 2),
        Speed = NumberRange.new(3, 9),
        SpreadAngle = Vector2.new(70, 70),
        Rotation = NumberRange.new(0, 360),
        EmissionDirection = Enum.NormalId.Top
    }):Emit((math.floor(p15 * 18)))

    for i = 0, 2 do
        task.delay(i * 0.2, t1.ripple, p13, (i * 5 + 12) * p15, p14:Lerp(Color3.new(1, 1, 1), 0.6))
    end

    Debris:AddItem(v19, 3)
end

function t1.wave(p16, p17, p18, p19, p20) -- line: 192
    -- upvalues: RunService (copy), v2 (copy), anchoredPart (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "Wave"
    Folder.Parent = workspace

    local v27 = p17:Lerp(v2, 0.25)
    local v28 = p17:Lerp(v2, 0.85)
    local t4 = {}

    for i = 1, 28 do
        local v29 = anchoredPart({
            Name = "Swell",
            Transparency = 0.2,
            Color = v27,
            Parent = Folder
        })
        local v30 = anchoredPart({
            Name = "Foam",
            Transparency = 0.1,
            Color = v28,
            Parent = Folder
        })

        t4[i] = {
            angle = i / 28 * 3.141592653589793 * 2,
            body = v29,
            cap = v30
        }
    end

    local elapsed = os.clock()
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 206
        -- upvalues: p16 (copy), p18 (copy), p19 (copy), p20 (copy), Folder (copy), t4 (copy), elapsed (copy), connection (ref)
        local v31 = (os.clock() - elapsed) / p20

        if v31 >= 1 or not Folder.Parent then
            connection:Disconnect()
            Folder:Destroy()
        else
            local v32 = 1.5 + (p18 - 1.5) * (1 - (1 - v31) ^ 2)
            local v36 = math.max(0.1, p19 * math.sin(math.min(v31 * 3, 1) * 3.141592653589793 / 2) * (1 - v31) ^ 1.3)
            local v37 = 6.283185307179586 * v32 / 28 * 1.2
            local v38 = 0.2 + 0.8 * v31 ^ 2

            for _, v39 in t4 do
                local v42 = Vector3.new(math.cos(v39.angle), 0, (math.sin(v39.angle)))
                local v43 = p16 + v42 * v32
                local v44 = CFrame.lookAt(v43, v43 + v42) * CFrame.Angles(-0.3141592653589793, 0, 0)

                v39.body.Size = Vector3.new(v37, v36, v36 * 0.35 + 0.8)
                v39.body.CFrame = v44 * CFrame.new(0, v36 / 2 - 0.25, 0)
                v39.body.Transparency = v38
                v39.cap.Size = Vector3.new(v37, 0.35, v36 * 0.35 + 1)
                v39.cap.CFrame = v44 * CFrame.new(0, v36 - 0.1, -0.15)
                v39.cap.Transparency = math.min(1, v38 - 0.1)
            end
        end
    end)
end

function t1.underwaterLook(p21) -- line: 233
    -- upvalues: Lighting (copy), v2 (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.TintColor = p21:Lerp(v2, 0.45)
    ColorCorrectionEffect.Saturation = 0.15
    ColorCorrectionEffect.Contrast = 0.1
    ColorCorrectionEffect.Parent = Lighting

    local BlurEffect = Instance.new("BlurEffect")

    BlurEffect.Size = 4
    BlurEffect.Parent = Lighting

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    local t5

    if Atmosphere then
        t5 = {
            Density = Atmosphere.Density,
            Offset = Atmosphere.Offset,
            Color = Atmosphere.Color,
            Decay = Atmosphere.Decay,
            Haze = Atmosphere.Haze
        }
        Atmosphere.Density = 0.65
        Atmosphere.Offset = 0
        Atmosphere.Haze = 2

        local v48 = p21:Lerp(Color3.new(0, 0, 0), 0.5)

        Atmosphere.Color = p21
        Atmosphere.Decay = v48
    end

    return function() -- line: 249
        -- upvalues: ColorCorrectionEffect (copy), BlurEffect (copy), Atmosphere (copy), t5 (ref)
        ColorCorrectionEffect:Destroy()
        BlurEffect:Destroy()

        if Atmosphere and t5 then
            for v49, v50 in t5 do
                Atmosphere[v49] = v50
            end
        end
    end
end

function t1.rays(p22, p23, p24, p25, p26) -- line: 262
    -- upvalues: UIUtil (copy), v2 (copy), anchoredPart (copy)
    local v51 = anchoredPart({
        Name = "Rays",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        Position = p22 + (p22 - p23).Unit * p24 * 0.8,
        Parent = p26
    })
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(p24 * 4, p24 * 4)
    BillboardGui.LightInfluence = 0
    BillboardGui.Brightness = 1
    BillboardGui.Adornee = v51
    BillboardGui.Parent = v51

    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = BillboardGui

    local v53 = math.min(3 + p25.Index, 8)

    for i = 1, v53 do
        local Frame2 = Instance.new("Frame")

        Frame2.BorderSizePixel = 0
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromScale(0.5, 0.5)
        Frame2.Size = UDim2.fromScale(0.05, 1)
        Frame2.Rotation = i / v53 * 180
        Frame2.BackgroundColor3 = p25.Color:Lerp(v2, 0.4)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.8),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(0.7, 0.8),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = Frame2
        Frame2.Parent = Frame
    end

    BillboardGui.Size = UDim2.fromScale(0, 0)
    UIUtil.tween(BillboardGui, 0.6, {
        Size = UDim2.fromScale(p24 * 4, p24 * 4)
    }, Enum.EasingStyle.Back)

    return function(p27) -- line: 303
        -- upvalues: Frame (copy)
        Frame.Rotation = p27 * 15
    end
end

function t1.heave(p28) -- line: 310
    if p28 then
        local CFrame = p28.CFrame

        return function(p30) -- line: 315
            -- upvalues: p28 (copy), CFrame (copy)
            p28.CFrame = CFrame + Vector3.new(0, p30, 0)
        end
    end

    return function(_) -- line: 312
    end
end

function t1.storm(p31) -- line: 321
    -- upvalues: Lighting (copy), v2 (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Parent = Lighting

    return function(p32, p33) -- set | line: 324
        -- upvalues: p31 (copy), ColorCorrectionEffect (copy), v2 (copy)
        ColorCorrectionEffect.Brightness = p32 * -0.2 + p33 * 0.45
        ColorCorrectionEffect.Contrast = p32 * 0.3
        ColorCorrectionEffect.Saturation = p32 * 0.25
        ColorCorrectionEffect.TintColor = v2:Lerp(p31:Lerp(v2, 0.55), p32)
    end, function() -- line: 330
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end
end

function t1.letterbox(p34, p35) -- line: 335
    -- upvalues: UIUtil (copy)
    local v54 = if p35 then UDim2.fromScale(1, 0.085) else UDim2.fromScale(1, 0)

    p34.ScreenInsets = Enum.ScreenInsets.None
    UIUtil.tween(p34.BarTop, 0.4, {
        Size = v54
    })
    UIUtil.tween(p34.BarBottom, 0.4, {
        Size = v54
    })
end

t1.flashScale = 1

function t1.flash(p36, p37, p38, p39) -- line: 347
    -- upvalues: UIUtil (copy), t1 (copy)
    local Flash = p36.Flash

    Flash.BackgroundColor3 = p37 or Color3.new(1, 1, 1)
    Flash.BackgroundTransparency = 1 - (1 - (p39 or 0)) * t1.flashScale
    UIUtil.tween(Flash, p38 or 0.45, {
        BackgroundTransparency = 1
    })
end

function t1.fade(p40, p41, p42) -- line: 355
    -- upvalues: UIUtil (copy)
    p40.Enabled = true
    UIUtil.tween(p40.Fade, p42 or 0.35, {
        BackgroundTransparency = p41 and 0 or 1
    }, Enum.EasingStyle.Sine).Completed:Wait()
end

function t1.shake(p43, p44) -- line: 366
    -- upvalues: Settings (copy), v1 (copy)
    if not Settings.get("Shake") then
        return p43
    end

    local v57 = math.min(p44 * 0.5, 0.5)

    return p43 * CFrame.new(v1:NextNumber(-1, 1) * v57, v1:NextNumber(-1, 1) * v57, 0) * CFrame.Angles(0, 0, v1:NextNumber(-1, 1) * v57 * 0.05)
end

function t1.exclaim(p45) -- line: 377
    -- upvalues: Config (copy), UIUtil (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(3, 3)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p45

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = Config.Font
    TextLabel.Text = "!"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 70, 70)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = p45
    UIUtil.pop(TextLabel, 0.2)

    return BillboardGui
end

return t1
