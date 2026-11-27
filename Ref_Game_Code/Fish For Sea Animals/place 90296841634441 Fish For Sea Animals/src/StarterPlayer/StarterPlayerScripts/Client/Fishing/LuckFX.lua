-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Effects = require(script.Parent.Effects)
local LuckBadge = require(script.Parent.LuckBadge)
local LuckSetPieces = require(script.Parent.LuckSetPieces)
local v1 = Color3.new(1, 1, 1)
local v2 = Random.new()
local t1 = {}

t1.stage = Config.luckStage

function t1.extraBuild(p1) -- line: 36
    return p1 * 0.5
end

function t1.extraHold(p2) -- line: 41
    return math.min(p2, 6) * 0.4 + math.max(p2 - 6, 0) * 0.25
end

local function sparkleBurst(p3, p4, p5, p6, p7, p8) -- line: 45
    -- upvalues: Debris (copy), Effects (copy)
    local v5 = Effects.part({
        Name = "Burst",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p3,
        Parent = p8
    })

    Effects.emitter(v5, {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        Drag = 2,
        Acceleration = Vector3.new(0, -8, 0),
        Color = p4,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p7),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new(0, 0.6),
        Lifetime = NumberRange.new(0.8, 1.6),
        Speed = NumberRange.new(p6 * 0.4, p6),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360)
    }):Emit(p5)
    Debris:AddItem(v5, 2)
end

local function bolt(p9, p10, p11) -- line: 64
    -- upvalues: Debris (copy), UIUtil (copy), Effects (copy), v1 (copy), v2 (copy)
    local v7 = p9 + Vector3.new(v2:NextNumber(-15, 15), 90, v2:NextNumber(-15, 15))
    local t2 = {
        v7
    }

    for i = 1, 7 do
        table.insert(t2, v7:Lerp(p9, i / 8) + Vector3.new(v2:NextNumber(-1, 1), 0, v2:NextNumber(-1, 1)) * 5)
    end

    table.insert(t2, p9)

    for i = 1, #t2 - 1 do
        local v11 = t2[i]
        local v12 = t2[i + 1]
        local v13 = Effects.part({
            Name = "Bolt",
            Material = Enum.Material.Neon,
            Color = p10:Lerp(v1, 0.6),
            Size = Vector3.new(0.6, 0.6, (v12 - v11).Magnitude),
            CFrame = CFrame.lookAt((v11 + v12) / 2, v12),
            Parent = p11
        })

        UIUtil.tween(v13, 0.3, {
            Transparency = 1,
            Size = Vector3.new(0.1, 0.1, (v12 - v11).Magnitude)
        })
        Debris:AddItem(v13, 0.35)
    end

    local v14 = Effects.part({
        Name = "BoltLight",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p9 + Vector3.new(0, 3, 0),
        Parent = p11
    })
    local PointLight = Instance.new("PointLight")

    PointLight.Color = p10:Lerp(v1, 0.5)
    PointLight.Range = 30
    PointLight.Brightness = 3
    PointLight.Parent = v14
    Debris:AddItem(v14, 0.15)
    UIUtil.sound("Lightning", 0.4, v2:NextNumber(0.9, 1.1))
end

local function shockwave(p12, p13, p14, p15, p16) -- line: 88
    -- upvalues: Debris (copy), UIUtil (copy), Effects (copy), v1 (copy)
    local v15 = Effects.part({
        Name = "Shockwave",
        Transparency = 0.15,
        Size = Vector3.new(0.3, 2, 2),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = p13:Lerp(v1, 0.4),
        CFrame = CFrame.new(p12 + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = p16
    })

    UIUtil.tween(v15, p15, {
        Transparency = 1,
        Size = Vector3.new(0.1, p14 * 2, p14 * 2)
    }, Enum.EasingStyle.Quart)
    Debris:AddItem(v15, p15 + 0.1)
end

local function firework(p17, p18, p19, p20, p21) -- line: 95
    -- upvalues: v1 (copy), v2 (copy), sparkleBurst (copy)
    local v19 = math.min(p18 * 2.5, p21)
    local v26 = p17 + Vector3.new(v2:NextNumber(-1, 1) * v19, math.min(p18 * v2:NextNumber(1, 2.4), p21), v2:NextNumber(-1, 1) * math.min(p18 * 1.5, p21))
    local v27 = p19.Gradient or { p19.Color }
    local v28 = v27[v2:NextInteger(1, #v27)]

    sparkleBurst(v26, ColorSequence.new(v1, v28), 40, math.clamp(p18 * 3, 6, 22), math.clamp(p18 * 0.2, 0.3, 1.2), p20)
end

local function title(p22) -- line: 106
    -- upvalues: Config (copy)
    local LuckTitle = p22:FindFirstChild("LuckTitle")

    if LuckTitle then
        return LuckTitle.Text
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "LuckTitle"
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.fromScale(0.5, 0.8)
    Frame.Size = UDim2.fromOffset(0, 0)
    Frame.Visible = false
    Frame.ZIndex = 5

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Text"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Size = UDim2.fromOffset(760, 110)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.ZIndex = 5

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 5
    UIStroke.Color = Color3.fromRGB(20, 15, 35)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Frame
    Frame.Parent = p22

    return TextLabel
end

t1.title = title

function t1.reset(p23) -- line: 141
    -- upvalues: LuckBadge (copy)
    local LuckTitle = p23:FindFirstChild("LuckTitle")

    if LuckTitle then
        LuckTitle.Visible = false
    end

    LuckBadge.reset(p23)
end

local function kicker() -- line: 150
    local n1 = 0
    local n2 = 0
    local n3 = 1

    local function left() -- line: 152
        -- upvalues: n1 (ref), n2 (ref), n3 (ref)
        return n1 * math.max(0, 1 - (os.clock() - n2) / n3)
    end

    return function(p24, p25) -- kick | line: 155
        -- upvalues: n1 (ref), n2 (ref), n3 (ref)
        local v35 = n1

        if not (v35 * math.max(0, 1 - (os.clock() - n2) / n3) <= p24) then
            return
        end

        local elapsed = os.clock()

        p25 = p25 or 0.35
        n1 = p24
        n2 = elapsed
        n3 = p25
    end, left
end

local function rattle(p26, p27, p28) -- line: 165
    -- upvalues: UIUtil (copy), v2 (copy)
    local v38 = (p26:GetAttribute("Rattle") or 0) + 1

    p26:SetAttribute("Rattle", v38)

    local v39 = p26:GetAttribute("RattleBase") or p26.Position

    p26:SetAttribute("RattleBase", v39)

    local v40 = p26.Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 172
        -- upvalues: p26 (copy), p27 (copy), p28 (copy), v38 (copy), v39 (copy), v40 (ref), elapsed (copy), UIUtil (copy), v2 (copy)
        while p26.Parent and p26:GetAttribute("Rattle") == v38 and p26.Position == v40 do
            local v41 = 1 - (os.clock() - elapsed) / p28

            if v41 <= 0 then
                p26.Position = v39
                p26.Rotation = 0
                break
            end

            local v42 = p27 * v41 * UIUtil.scale

            v40 = v39 + UDim2.fromOffset(v2:NextNumber(-1, 1) * v42, v2:NextNumber(-1, 1) * v42)
            p26.Position = v40
            p26.Rotation = v2:NextNumber(-1, 1) * 6 * v41
            task.wait()
        end

        if p26:GetAttribute("Rattle") ~= v38 then
            return
        end

        p26:SetAttribute("Rattle", nil)
        p26:SetAttribute("RattleBase", nil)
        p26.Rotation = 0
    end)
end

function t1.buildUp(p29) -- line: 199
    -- upvalues: UIUtil (copy), LuckBadge (copy), rattle (copy)
    local n4 = 0
    local n5 = 0
    local n6 = 1

    local function left() -- line: 152
        -- upvalues: n4 (ref), n5 (ref), n6 (ref)
        local v43 = n4

        return v43 * math.max(0, 1 - (os.clock() - n5) / n6)
    end

    local function kick(p30, p31) -- line: 155
        -- upvalues: n4 (ref), n5 (ref), n6 (ref)
        local v45 = n4

        if not (v45 * math.max(0, 1 - (os.clock() - n5) / n6) <= p30) then
            return
        end

        local elapsed = os.clock()

        p31 = p31 or 0.35
        n4 = p30
        n5 = elapsed
        n6 = p31
    end

    local n7 = 0
    local n8 = 0

    return function(p32) -- line: 202
        -- upvalues: p29 (copy), left (copy), kick (copy), n7 (ref), n8 (ref), UIUtil (copy), LuckBadge (copy), rattle (copy)
        while n7 < p32 do
            n7 += 1
            LuckBadge.climb(p29, n7)
            kick(n7 * 0.07 + 0.35, 0.3)
        end

        local v48 = LuckBadge.shown(p29)

        if n8 < v48 then
            n8 = v48

            local Odds = p29:FindFirstChild("Odds")

            if Odds then
                UIUtil.pop(Odds, n8 * 0.03 + 1.12)
                rattle(Odds, n8 * 3 + 14, 0.45)
            end
        end

        return left()
    end
end

function t1.burst(p33, p34, p35, p36, p37, p38, p39, p40, p41) -- line: 226
    -- upvalues: Lighting (copy), Config (copy), UIUtil (copy), RarityText (copy), Effects (copy), LuckSetPieces (copy), v1 (copy), v2 (copy), sparkleBurst (copy), bolt (copy), shockwave (copy), firework (copy), title (copy)
    if p33 <= 0 then
        return function() -- line: 228
            return 0, 0
        end
    end

    local v49 = Config.LuckStages[p33]
    local Color = p38.Color
    local n9 = 0
    local n10 = 0
    local n11 = 1

    local function left() -- line: 152
        -- upvalues: n9 (ref), n10 (ref), n11 (ref)
        local v50 = n9

        return v50 * math.max(0, 1 - (os.clock() - n10) / n11)
    end

    local function kick(p42, p43) -- line: 155
        -- upvalues: n9 (ref), n10 (ref), n11 (ref)
        local v52 = n9

        if not (v52 * math.max(0, 1 - (os.clock() - n10) / n11) <= p42) then
            return
        end

        local elapsed = os.clock()

        p43 = p43 or 0.35
        n9 = p42
        n10 = elapsed
        n11 = p43
    end

    local v55 = math.min(p33, 6)
    local v57 = math.clamp(p37 / 5, 0.35, 1)
    local v58 = (p40 - p36).Magnitude * 0.45
    local v59 = title(p34)

    v59.Text = v49.Title
    RarityText.apply(v59, {
        Gradient = {
            v1,
            v49.Color,
            v49.Color:Lerp(Color3.new(0, 0, 0), 0.25)
        },
        Shine = p33 >= 5
    })
    v59.Parent.Visible = true
    UIUtil.pop(v59, p33 * 0.4 + 1.6)
    UIUtil.sound("Luck" .. p33, 0.9, 1, 12)
    kick(p33 * 0.2 + 0.3, p33 * 0.15 + 0.9)

    local v62 = Effects.part({
        Name = "LuckSparks",
        Transparency = 1,
        Size = Vector3.new(p37 * 1.5, 0.2, p37 * 1.5),
        Position = p35,
        Parent = p39
    })

    Effects.emitter(v62, {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        Color = Config.rarityGradient(p38),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, (v55 * 0.08 + 0.6) * v57),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new(0, 0.8),
        Lifetime = NumberRange.new(1, 2),
        Speed = NumberRange.new(4, p33 * 2 + 8),
        SpreadAngle = Vector2.new(20, 20),
        EmissionDirection = Enum.NormalId.Top,
        Rate = 2 ^ (v55 - 1) * 10
    })
    sparkleBurst(p36, Config.rarityGradient(p38), math.min(2 ^ v55 * 40, 800), (v55 * 6 + 20) * v57, (v55 * 0.15 + 0.8) * v57, p39)

    if p33 >= 2 then
        for i = 1, p33 - 1 do
            task.delay((i - 1) * 0.25, shockwave, p35, Color, p37 * (p33 * 1.2 + 3), 1.4, p39)
        end

        local v65 = p37 * (p33 * 0.35 + 0.6)
        local v66 = Effects.part({
            Name = "LuckBeam",
            Transparency = 0.6,
            Shape = Enum.PartType.Cylinder,
            Material = Enum.Material.Neon,
            Color = Color:Lerp(v1, 0.5),
            Size = Vector3.new(400, v65, v65),
            CFrame = CFrame.new(p35 + Vector3.new(0, 200, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
            Parent = p39
        })

        UIUtil.tween(v66, 1.6, {
            Transparency = 0.85,
            Size = Vector3.new(400, p37 * 0.25, p37 * 0.25)
        })
    end

    if p33 >= 3 then
        for _ = 1, math.min(p33 - 2, 2) do
            task.delay(v2:NextNumber(0, 0.4), function() -- line: 281
                -- upvalues: p35 (copy), p37 (copy), p39 (copy), Color (copy), kick (copy), v2 (copy), bolt (copy)
                bolt(p35 + Vector3.new(v2:NextNumber(-1, 1), 0, v2:NextNumber(-1, 1)) * p37 * 2, Color, p39)
                kick(0.4, 0.25)
            end)
        end
    end

    local t8 = {}

    if p33 >= 4 then
        for i = 1, 8 do
            t8[i] = Effects.part({
                Name = "Orb",
                Transparency = 0.3,
                Shape = Enum.PartType.Ball,
                Material = Enum.Material.Neon,
                Color = Color:Lerp(v1, i % 3 * 0.3),
                Size = Vector3.new(1, 1, 1) * math.clamp(p37 * 0.04, 0.12, 0.35),
                Position = p36,
                Parent = p39
            })
        end
    end

    if p33 >= 5 then
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

        ColorCorrectionEffect.Name = "LuckTint"
        ColorCorrectionEffect.Parent = Lighting
        p39.Destroying:Connect(function() -- line: 299
            -- upvalues: ColorCorrectionEffect (copy)
            ColorCorrectionEffect:Destroy()
        end)
        UIUtil.tween(ColorCorrectionEffect, 0.6, {
            Saturation = 0.3,
            TintColor = Color:Lerp(v1, 0.35)
        })

        local v72 = p38.Gradient or { Color }

        for i = 0, 5 do
            task.delay(i * 0.18 + 0.15, Effects.flash, p34, v72[i % #v72 + 1]:Lerp(v1, 0.3), 0.18, 0.75)
        end
    end

    local v73 = LuckSetPieces.play(p33, {
        gui = p34,
        surface = p35,
        apex = p36,
        fx = p37,
        rarity = p38,
        scene = p39,
        cameraPos = p40,
        title = v59,
        cracks = p41
    })
    local n12 = 0
    local n13 = 0
    local v74 = if p33 >= 6 then 0.3 else 0.4
    local v76 = math.max(1.6 - p33 * 0.1, 1.2)

    return function(p44) -- line: 315
        -- upvalues: p33 (copy), p34 (copy), p35 (copy), p36 (copy), p37 (copy), p38 (copy), p39 (copy), Color (copy), left (copy), kick (copy), v58 (copy), v59 (copy), t8 (copy), v73 (copy), n12 (ref), n13 (ref), v76 (copy), v74 (copy), Effects (copy), v1 (copy), v2 (copy), bolt (copy), firework (copy)
        v59.Rotation = math.sin(p44 * (p33 + 4)) * (p33 * 0.6 + 1)

        if p33 >= 4 and p44 - n12 > v74 then
            n12 = p44
            firework(p36, p37, p38, p39, v58)
            kick(p33 * 0.01 + 0.08, 0.2)
        end

        if p33 >= 3 and p44 > 0.5 and p44 - n13 > v76 then
            n13 = p44
            bolt(p35 + Vector3.new(v2:NextNumber(-1, 1), 0, v2:NextNumber(-1, 1)) * p37 * 2.5, Color, p39)
            Effects.flash(p34, Color:Lerp(v1, 0.7), 0.15, 0.8)
            kick(p33 * 0.04 + 0.25, 0.25)
        end

        local v80 = 1 - math.exp(-p44 * 4)

        for v81, v82 in t8 do
            local v83 = v81 / #t8 * 3.141592653589793 * 2 + p44 * ((1 - v80) * 3 + 1.2)
            local v86 = math.min(p37 * (v80 * 1.1 + 0.3), v58 * 0.6)

            v82.Position = p36 + Vector3.new(math.cos(v83) * v86, math.sin(p44 * 3 + v81) * p37 * 0.25, math.sin(v83) * v86)
        end

        if not v73 then
            return left(), 0
        end

        local v91, v92 = v73(p44)

        return math.max(left(), v91), v92
    end
end

return t1
