-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local LuckScenes = require(script.Parent.LuckScenes)
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.new(0, 0, 0)
local v3 = Random.new()

local function ease(p1) -- line: 28
    return 1 - (1 - math.clamp(p1, 0, 1)) ^ 3
end

local function back(p2) -- line: 34
    local v4 = math.clamp(p2, 0, 1)

    return (v4 - 1) ^ 3 * 2.70158 + 1 + (v4 - 1) ^ 2 * 1.70158
end

local function ring(p3, p4, p5, p6, p7, p8, p9) -- line: 42
    -- upvalues: Effects (copy)
    local Model = Instance.new("Model")

    Model.Name = "Ring"

    local v5 = 6.283185307179586 * p3 / p4 * (if p8 then 0.6 else 1.08)

    for i = 1, p4 do
        local v6 = if p8 then i % 2 == 0 else nil

        if not p8 or v6 then
            local v7 = i / p4 * 6.283185307179586

            Effects.part({
                Name = "Segment",
                Material = Enum.Material.Neon,
                Color = p6,
                Transparency = p7,
                Size = Vector3.new(p5, v5, p5),
                CFrame = CFrame.Angles(0, 0, v7) * CFrame.new(p3, 0, 0),
                Parent = Model
            })
        end
    end

    Model.WorldPivot = CFrame.new()
    Model.Parent = p9

    return Model
end

local function emitterPart(p10, p11, p12, p13, p14) -- line: 57
    -- upvalues: Effects (copy)
    local v8 = Effects.part({
        Transparency = 1,
        Name = p10,
        Size = p12,
        CFrame = p11,
        Parent = p13
    })

    p14.Texture = p14.Texture or "rbxasset://textures/particles/sparkles_main.dds"

    return Effects.emitter(v8, p14)
end

local function grade(p15, p16) -- line: 64
    -- upvalues: Lighting (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = p15
    ColorCorrectionEffect.Parent = Lighting
    p16.Destroying:Connect(function() -- line: 68
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end)

    return ColorCorrectionEffect
end

local function godly(p17) -- line: 78
    -- upvalues: Config (copy), UIUtil (copy), v1 (copy), ring (copy), emitterPart (copy)
    local Color = Config.LuckStages[7].Color
    local Unit = (p17.apex - p17.cameraPos).Unit
    local v9 = p17.apex + Unit * p17.fx * 0.9
    local v10 = CFrame.lookAt(v9, p17.cameraPos)
    local v11 = ring(p17.fx * 1.15 + 1, 30, p17.fx * 0.03 + 0.12, Color:Lerp(v1, 0.3), 0, false, p17.scene)
    local v12 = ring(p17.fx * 1.45 + 1.5, 24, p17.fx * 0.02 + 0.1, Color, 0.25, true, p17.scene)

    emitterPart("GoldRain", CFrame.new(p17.apex + Vector3.new(0, p17.fx * 2.5 + 6, 0)), Vector3.new(p17.fx * 5 + 10, 1, p17.fx * 5 + 10), p17.scene, {
        LightEmission = 1,
        LightInfluence = 0,
        Rate = 70,
        Color = ColorSequence.new(Color:Lerp(v1, 0.5), Color),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0.3)
        }),
        Transparency = NumberSequence.new(0, 0.5),
        Lifetime = NumberRange.new(1.6, 2.4),
        Speed = NumberRange.new(4, 9),
        EmissionDirection = Enum.NormalId.Bottom,
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-180, 180)
    })
    task.delay(0.3, UIUtil.sound, "Cash", 0.4, 1.1)
    task.delay(0.52, UIUtil.sound, "Cash", 0.4, 1.2200000000000002)
    task.delay(0.74, UIUtil.sound, "Cash", 0.4, 1.34)
    task.delay(0.96, UIUtil.sound, "Cash", 0.4, 1.46)

    return function(p18) -- line: 101
        -- upvalues: v10 (copy), v11 (copy), v12 (copy)
        local v18 = math.clamp(p18 / 0.7, 0, 1)
        local v19 = (v18 - 1) ^ 3 * 2.70158 + 1 + (v18 - 1) ^ 2 * 1.70158

        v11:ScaleTo((math.max(v19, 0.01)))
        v12:ScaleTo((math.max(v19 * 1.02, 0.01)))
        v11:PivotTo(v10 * CFrame.Angles(0, 0, p18 * 0.8))
        v12:PivotTo(v10 * CFrame.Angles(0, 0, -p18 * 1.3))

        return 0, 0
    end
end

local function mythical(p19) -- line: 112
    -- upvalues: Lighting (copy), Config (copy), UIUtil (copy), Effects (copy), v1 (copy), v2 (copy), ring (copy), emitterPart (copy)
    local Color = Config.LuckStages[8].Color
    local scene = p19.scene
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "Eclipse"
    ColorCorrectionEffect.Parent = Lighting
    scene.Destroying:Connect(function() -- line: 68
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end)
    UIUtil.tween(ColorCorrectionEffect, 0.9, {
        Brightness = -0.28,
        Contrast = 0.25,
        TintColor = Color3.fromRGB(255, 170, 165)
    })

    local Unit = (p19.apex - p19.cameraPos).Unit
    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
    local v21 = p19.fx * 2.6 + 10
    local v24 = p19.apex + Unit * (p19.fx * 4 + 32) + Vector3.new(0, p19.fx * 1.2 + 4, 0)
    local v25 = Effects.part({
        Name = "Sun",
        Shape = Enum.PartType.Ball,
        Material = Enum.Material.Neon,
        Color = Color:Lerp(v1, 0.55),
        Size = Vector3.new(1, 1, 1) * v21,
        Position = v24,
        Parent = p19.scene
    })
    local v26 = Effects.part({
        Name = "Moon",
        Shape = Enum.PartType.Ball,
        Material = Enum.Material.SmoothPlastic,
        Color = v2,
        Size = Vector3.new(1, 1, 1) * v21 * 0.97,
        Position = v24 + Unit2 * v21 * 1.4 - Unit * 1.5,
        Parent = p19.scene
    })
    local v27 = ring(v21 * 0.56, 36, v21 * 0.02 + 0.5, Color, 0.1, false, p19.scene)
    local v28 = ring(v21 * 0.7, 18, v21 * 0.015 + 0.3, Color:Lerp(v1, 0.4), 0.4, true, p19.scene)
    local v29 = CFrame.lookAt(v24 - Unit * 2, p19.cameraPos)

    v27:ScaleTo(0.01)
    v28:ScaleTo(0.01)
    emitterPart("Stars", CFrame.new(p19.apex + Vector3.new(0, 70, 0) + Unit * 40), Vector3.new(260, 1, 120), p19.scene, {
        LightEmission = 1,
        LightInfluence = 0,
        Rate = 70,
        Color = ColorSequence.new(v1),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Lifetime = NumberRange.new(1.5, 3),
        Speed = NumberRange.new(0, 0)
    })

    local v31 = false

    return function(p20) -- line: 138
        -- upvalues: p19 (copy), Color (copy), Unit (copy), Unit2 (copy), v21 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), v31 (ref), UIUtil (copy), Effects (copy), v1 (copy)
        local v33 = 1 - (1 - math.clamp(p20 / 1.6, 0, 1)) ^ 3

        v26.Position = v24 + Unit2 * v21 * 1.4 * (1 - v33) - Unit * 1.5

        if v33 > 0.985 and not v31 then
            v31 = true
            Effects.flash(p19.gui, Color:Lerp(v1, 0.6), 0.6, 0.1)
            UIUtil.sound("SubBoom", 0.7, 0.8)
            v25.Color = Color
        end

        local v34 = 0

        if v31 then
            local v36 = math.clamp((p20 - 1.6) / 0.5, 0, 1)

            v34 = (v36 - 1) ^ 3 * 2.70158 + 1 + (v36 - 1) ^ 2 * 1.70158
        end

        v27:ScaleTo((math.max(v34, 0.01)))
        v28:ScaleTo((math.max(v34 * (math.sin(p20 * 6) * 0.05 + 1), 0.01)))
        v27:PivotTo(v29 * CFrame.Angles(0, 0, p20 * 0.3))
        v28:PivotTo(v29 * CFrame.Angles(0, 0, -p20 * 0.9))

        return if not (v31 and p20 - 1.6 < 0.3) then 0 else 0.4, 0
    end
end

local function cosmic(p21) -- line: 158
    -- upvalues: Config (copy), UIUtil (copy), Effects (copy), v1 (copy), v2 (copy), v3 (copy), ring (copy)
    local Color = Config.LuckStages[9].Color
    local v39 = Color3.fromRGB(150, 70, 255)
    local Unit = (p21.apex - p21.cameraPos).Unit
    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
    local v41 = p21.apex + Vector3.new(0, p21.fx * 2.5 + 26, 0) + Unit * 6
    local v42 = p21.fx * 4 + 60
    local t3 = {}

    for i = 0, 10 do
        local v43 = v41 + Unit2 * (i / 10 - 0.5) * v42
        local v44 = v3:NextNumber(-5, 5)

        t3[i + 1] = v43 + Vector3.new(0, v44, 0)
    end

    local t4 = {}

    for i = 1, #t3 - 1 do
        local v45 = t3[i]
        local v46 = t3[i + 1]

        t4[i] = Effects.part({
            Name = "Tear",
            Transparency = 1,
            Material = Enum.Material.Neon,
            Color = Color:Lerp(v1, 0.5),
            Size = Vector3.new(1, 1, (v46 - v45).Magnitude + 0.5),
            CFrame = CFrame.lookAt((v45 + v46) / 2, v46),
            Parent = p21.scene
        })
    end

    local v48 = p21.fx * 1.5 + 9
    local t6 = {
        {
            spin = 1.4,
            model = ring(v48, 32, 0.6, Color, 0, false, p21.scene),
            tilt = CFrame.Angles(1.5707963267948966, 0, 0)
        },
        {
            spin = -2,
            model = ring(v48 * 0.8, 24, 0.5, v39, 0.1, true, p21.scene),
            tilt = CFrame.Angles(2.0707963267948966, 0, 0)
        },
        {
            spin = 0.9,
            model = ring(v48 * 1.15, 20, 0.4, Color:Lerp(v1, 0.5), 0.3, true, p21.scene),
            tilt = CFrame.Angles(1.1707963267948966, 0.3, 0)
        }
    }
    local v49 = Effects.part({
        Name = "PortalCore",
        Transparency = 0.2,
        Size = Vector3.new(0.3, 0.1, 0.1),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = v39:Lerp(v2, 0.4),
        CFrame = CFrame.new(v41) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = p21.scene
    })
    local v50 = v41.Y - p21.apex.Y
    local v54 = Effects.part({
        Name = "PortalBeam",
        Transparency = 1,
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = Color:Lerp(v1, 0.6),
        Size = Vector3.new(v50, p21.fx * 0.7 + 1, p21.fx * 0.7 + 1),
        CFrame = CFrame.new(p21.apex + Vector3.new(0, v50 / 2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = p21.scene
    })

    for _, v55 in t6 do
        v55.model:ScaleTo(0.01)
    end

    local t8 = {}

    for i = 1, 16 do
        local v56 = v3:NextNumber(0.6, 1.6) * (p21.fx * 0.04 + 1)
        local v57 = v3:NextNumber(0, 6.283185307179586)
        local v58 = p21.fx * v3:NextNumber(0.8, 2.6) + 2
        local v61 = p21.surface + Vector3.new(math.cos(v57) * v58, 0, math.sin(v57) * v58)

        t8[i] = {
            part = Effects.part({
                Name = "Rock",
                Material = Enum.Material.Slate,
                Color = Color3.fromRGB(60, 60, 80),
                Size = Vector3.new(v56, v56 * 0.8, v56),
                Position = v61,
                Parent = p21.scene
            }),
            from = v61,
            delay = i * 0.12 + 0.5,
            speed = v3:NextNumber(0.25, 0.45),
            spin = Vector3.new(v3:NextNumber(-2, 2), v3:NextNumber(-2, 2), v3:NextNumber(-2, 2))
        }
    end

    task.delay(0.05, UIUtil.sound, "Lightning", 0.8, 0.7)

    return function(p22) -- line: 203
        -- upvalues: v41 (copy), t4 (copy), v48 (copy), t6 (copy), v49 (copy), v54 (copy), t8 (copy)
        local v67 = math.floor(math.clamp(p22 / 0.35, 0, 1) * #t4)

        for v68, v69 in t4 do
            if v68 <= v67 and v69.Transparency == 1 then
                v69.Transparency = 0
                v69.Size = Vector3.new(1.4, 1.4, v69.Size.Z)
            elseif p22 > 0.6 then
                v69.Transparency = math.min(1, (p22 - 0.6) / 0.8)
            end
        end

        local v72 = math.clamp((p22 - 0.4) / 0.8, 0, 1)
        local v73 = (v72 - 1) ^ 3 * 2.70158 + 1 + (v72 - 1) ^ 2 * 1.70158

        for _, v74 in t6 do
            v74.model:ScaleTo((math.max(v73, 0.01)))
            v74.model:PivotTo(CFrame.new(v41) * CFrame.Angles(0, p22 * v74.spin, 0) * v74.tilt)
        end

        v49.Size = Vector3.new(0.3, v48 * 1.7 * v73 + 0.1, v48 * 1.7 * v73 + 0.1)
        v54.Transparency = 1 - math.clamp((p22 - 0.9) / 0.4, 0, 1) * 0.6

        for _, v78 in t8 do
            local v80 = math.clamp((p22 - v78.delay) * v78.speed, 0, 1)
            local v84 = v78.from:Lerp(v41, v80 * v80) + Vector3.new(0, math.sin(p22 * 3 + v78.delay) * 0.3, 0)

            v78.part.CFrame = CFrame.new(v84) * CFrame.Angles(v78.spin.X * p22, v78.spin.Y * p22, v78.spin.Z * p22)
            v78.part.Transparency = v80 >= 1 and 1 or 0
        end

        local v89 = (1 - (1 - math.clamp(p22 / 1.4, 0, 1)) ^ 3) * 20 * (if p22 > 4 then math.max(0, 1 - (p22 - 4) / 2) else 1)

        return if not (v73 > 0 and v73 < 1) then 0.03 else 0.12, v89
    end
end

local function divine(p23) -- line: 235
    -- upvalues: Config (copy), UIUtil (copy), Effects (copy), v1 (copy), ring (copy), emitterPart (copy)
    local Color = Config.LuckStages[10].Color
    local Unit = (p23.apex - p23.cameraPos).Unit
    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit

    Effects.flash(p23.gui, v1, 0.9, 0)

    local t11 = {}

    for _, v90 in { -1, 1 } do
        local v91 = p23.apex + Unit * (p23.fx * 0.35 + 0.5) + Unit2 * v90 * p23.fx * 0.15
        local v92 = CFrame.lookAt(v91, v91 + Unit)

        for i = 1, 7 do
            local v93 = p23.fx * (1.9 - i * 0.13) + 3

            table.insert(t11, {
                part = Effects.part({
                    Name = "Feather",
                    Material = Enum.Material.Neon,
                    Color = Color:Lerp(v1, i / 7 * 0.6),
                    Transparency = i * 0.04 + 0.15,
                    Size = Vector3.new(p23.fx * 0.05 + 0.35, v93, 0.2),
                    Parent = p23.scene
                }),
                facing = v92,
                side = v90,
                i = i,
                length = v93
            })
        end
    end

    local v95 = ring(p23.fx * 0.4 + 0.6, 24, p23.fx * 0.02 + 0.12, Color3.fromRGB(255, 220, 110), 0, false, p23.scene)
    local v97 = p23.apex + Vector3.new(0, p23.fx * 0.75 + 1.4, 0)
    local t14 = {}

    for i = 1, 8 do
        local v98 = i / 8 * 6.283185307179586
        local v101 = p23.surface + Vector3.new(math.cos(v98), 0, (math.sin(v98))) * (p23.fx * 2.4 + 5)

        t14[i] = {
            rang = false,
            part = Effects.part({
                Name = "Pillar",
                Transparency = 0.1,
                Shape = Enum.PartType.Cylinder,
                Material = Enum.Material.Neon,
                Color = Color,
                Size = Vector3.new(0.1, p23.fx * 0.35 + 1.5, p23.fx * 0.35 + 1.5),
                CFrame = CFrame.new(v101) * CFrame.Angles(0, 0, 1.5707963267948966),
                Parent = p23.scene
            }),
            at = v101,
            delay = i * 0.09 + 0.2
        }
    end

    emitterPart("Feathers", CFrame.new(p23.apex + Vector3.new(0, p23.fx * 2 + 8, 0)), Vector3.new(p23.fx * 4 + 12, 1, p23.fx * 4 + 12), p23.scene, {
        LightEmission = 0.8,
        LightInfluence = 0,
        Acceleration = Vector3.new(0, -1, 0),
        Rate = 25,
        Color = ColorSequence.new(v1, Color),
        Size = NumberSequence.new(0.5, 0.2),
        Transparency = NumberSequence.new(0.1, 1),
        Lifetime = NumberRange.new(2.5, 4),
        Speed = NumberRange.new(1, 3),
        EmissionDirection = Enum.NormalId.Bottom,
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-60, 60)
    })

    return function(p24) -- line: 274
        -- upvalues: t11 (copy), v95 (copy), v97 (copy), t14 (copy), UIUtil (copy)
        local v109 = math.clamp((p24 - 0.15) / 0.9, 0, 1)
        local v110 = (v109 - 1) ^ 3 * 2.70158 + 1 + (v109 - 1) ^ 2 * 1.70158

        for _, v111 in t11 do
            local v115 = math.rad(6 + (18 + v111.i * 13) * v110 + math.sin(p24 * 2.2) * 4 * v110)

            v111.part.CFrame = v111.facing * CFrame.Angles(0, 0, -v111.side * v115) * CFrame.new(0, v111.length / 2, 0)
        end

        v95:PivotTo(CFrame.new(v97 + Vector3.new(0, math.sin(p24 * 2) * 0.2, 0)) * CFrame.Angles(1.5707963267948966, 0, p24))

        local n1 = 0

        for _, v118 in t14 do
            local v120 = 1 - (1 - math.clamp((p24 - v118.delay) / 0.25, 0, 1)) ^ 3

            if v120 > 0 and not v118.rang then
                v118.rang = true
                UIUtil.sound("Splash", 0.35, 1.3 + v118.delay * 0.3)
            end

            local v121 = v120 * 140 + 0.1

            v118.part.Size = Vector3.new(v121, v118.part.Size.Y, v118.part.Size.Z)
            v118.part.CFrame = CFrame.new(v118.at + Vector3.new(0, v121 / 2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
            v118.part.Transparency = p24 - v118.delay > 0.6 and 0.55 or 0.1

            if v120 > 0 and v120 < 1 then
                n1 = 0.15
            end
        end

        return n1, 0
    end
end

local t17 = {
    [7] = godly,
    [8] = mythical,
    [9] = cosmic,
    [10] = divine,
    [11] = function(p25) -- beyond | line: 301
        -- upvalues: Lighting (copy), Config (copy), UIUtil (copy), LuckScenes (copy), v3 (copy), godly (copy), cosmic (copy)
        LuckScenes.shatter(p25.gui, p25.cracks, Config.LuckStages[11].Color)
        UIUtil.sound("LuckShatter", 0.9, 0.9)

        local scene = p25.scene
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

        ColorCorrectionEffect.Name = "Beyond"
        ColorCorrectionEffect.Parent = Lighting
        scene.Destroying:Connect(function() -- line: 68
            -- upvalues: ColorCorrectionEffect (copy)
            ColorCorrectionEffect:Destroy()
        end)

        local t18 = {
            godly(p25),
            (cosmic(p25))
        }
        local Text = p25.title.Text
        local n2 = -1
        local n3 = 0
        local t19 = {
            "#",
            "%",
            "&",
            "$",
            "@",
            "!",
            "?",
            "0",
            "1",
            "X",
            "/"
        }

        return function(p26) -- line: 309
            -- upvalues: p25 (copy), ColorCorrectionEffect (copy), t18 (copy), Text (copy), n2 (ref), n3 (ref), t19 (copy), v3 (copy)
            if p26 < 1.3 then
                if p26 - n2 > 0.08 then
                    n2 = p26
                    ColorCorrectionEffect.Saturation = v3:NextNumber(-1, 1)
                    ColorCorrectionEffect.Contrast = v3:NextNumber(0.1, 0.6)
                    ColorCorrectionEffect.TintColor = Color3.fromHSV(v3:NextNumber(), 0.6, 1)
                end
            else
                ColorCorrectionEffect.Saturation = 0.35
                ColorCorrectionEffect.Contrast = 0.15
                ColorCorrectionEffect.TintColor = Color3.fromHSV(p26 * 0.2 % 1, 0.3, 1)
            end

            if p26 - n3 > 0.9 then
                n3 = p26

                local v123 = string.split(Text, "")

                for _ = 1, 3 do
                    v123[v3:NextInteger(1, #v123)] = t19[v3:NextInteger(1, #t19)]
                end

                p25.title.Text = table.concat(v123)
                p25.title.Position = UDim2.fromOffset(v3:NextNumber(-12, 12), 0)
                task.delay(0.09, function() -- line: 333
                    -- upvalues: p25 (copy), Text (copy)
                    p25.title.Text = Text
                    p25.title.Position = UDim2.new()
                end)
            end

            local n4 = 0
            local n5 = 0

            for _, v124 in t18 do
                local v125, v126 = v124(p26)

                n4 = math.max(n4, v125)
                n5 = math.max(n5, v126)
            end

            if p26 < 1.3 then
                n4 = math.max(n4, 0.3)
            end

            return n4, n5
        end
    end
}

function t1.play(p27, p28) -- line: 353
    -- upvalues: t17 (copy)
    local v127 = t17[p27]

    return if v127 then v127(p28) else nil
end

return t1
