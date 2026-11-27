-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.new(0, 0, 0)
local v3 = Random.new()

local function smooth(p1) -- line: 31
    local v4 = math.clamp(p1, 0, 1)

    return v4 * v4 * (3 - v4 * 2)
end

local function edges(p2, p3) -- line: 37
    local t2 = {}

    for v5, v6 in {
            { 0, 0, 1, 0.22, 90 },
            { 0, 0.78, 1, 0.22, -90 },
            { 0, 0, 0.16, 1, 0 },
            { 0.84, 0, 0.16, 1, 180 }
        } do
        local Frame = Instance.new("Frame")

        Frame.Name = "LuckEdge" .. v5
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = p3
        Frame.BackgroundTransparency = 1
        Frame.Position = UDim2.fromScale(v6[1], v6[2])
        Frame.Size = UDim2.fromScale(v6[3], v6[4])
        Frame.ZIndex = 1

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = v6[5]
        UIGradient.Transparency = NumberSequence.new(0, 1)
        UIGradient.Parent = Frame
        Frame.Parent = p2
        table.insert(t2, Frame)
    end

    return t2
end

local function showTitle(p4, p5, p6, p7) -- line: 58
    -- upvalues: UIUtil (copy), v1 (copy)
    p4.Text = p5
    p4.TextColor3 = v1

    local UIGradient = p4:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = ColorSequence.new(v1, p6)
    end

    p4.Parent.Visible = true

    if p7 then
        UIUtil.pop(p4, p7)
    end
end

local function folder(p8) -- line: 72
    local Folder = Instance.new("Folder")

    Folder.Name = "LuckPrelude"
    Folder.Parent = p8.scene

    return Folder
end

local function creep(p9, p10) -- line: 79
    return CFrame.lookAt(p9.base.Position:Lerp(p9.look, p10 * 0.25 * p10), p9.look)
end

local function jackpot(p11, p12) -- line: 84
    -- upvalues: Config (copy), UIUtil (copy), Effects (copy), v1 (copy), edges (copy)
    local fx, surface, rarity = p12.fx, p12.surface, p12.rarity
    local Folder = Instance.new("Folder")

    Folder.Name = "LuckPrelude"
    Folder.Parent = p12.scene

    local v7 = edges(p12.gui, p12.def.Color)
    local v10 = Effects.part({
        Name = "LuckGlow",
        Transparency = 0.9,
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = rarity.Color:Lerp(v1, 0.3),
        Size = Vector3.new(0.1, fx * 0.4, fx * 0.4),
        CFrame = CFrame.new(surface + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = Folder
    })
    local PointLight = Instance.new("PointLight")

    PointLight.Color = rarity.Color
    PointLight.Range = fx * 3 + 10
    PointLight.Brightness = 0
    PointLight.Parent = v10

    local v11 = UIUtil.sound("LuckHeartbeat", 0.9, 0.85, p12.total + 2)
    local v12 = v11

    if v11 then
        v11.Looped = true
    end

    local t4 = {}

    for i = 1, p11 - 1 do
        table.insert(t4, i)
    end

    local n1 = 0
    local n2 = 0
    local n3 = -1

    local function show(p13) -- line: 104
        -- upvalues: p12 (copy), Config (copy), UIUtil (copy), v1 (copy)
        local v13 = Config.LuckStages[p13]
        local title = p12.title
        local Title, Color = v13.Title, v13.Color

        title.Text = Title
        title.TextColor3 = v1

        local UIGradient = title:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Color = ColorSequence.new(v1, Color)
        end

        title.Parent.Visible = true
        UIUtil.pop(title, 1.15)
    end

    return {
        step = function(p14, p15, p16) -- step | line: 109
            -- upvalues: p11 (copy), p12 (copy), fx (copy), surface (copy), rarity (copy), v7 (copy), v10 (copy), PointLight (copy), v12 (ref), t4 (copy), n1 (ref), n2 (ref), n3 (ref), Config (copy), UIUtil (copy), Effects (copy), v1 (copy)
            local v14 = p15 ^ 1.4 * 0.95 + 0.85

            if v12 and not p16 then
                v12.PlaybackSpeed = v14
            end

            local v15 = 0.625 / v14

            if not p16 then
                if v15 <= p14 - n3 then
                    n3 = p14
                    UIUtil.tween(PointLight, v15 * 0.8, {
                        Brightness = p15 * 5 + 1
                    })
                    v10.Transparency = 0.2
                    v10.Size = Vector3.new(0.1, fx * (p15 * 1.1 + 0.4), fx * (p15 * 1.1 + 0.4))
                    UIUtil.tween(v10, v15 * 0.9, {
                        Transparency = 0.8 - p15 * 0.35
                    })

                    for _, v18 in v7 do
                        v18.BackgroundTransparency = 0.35 - p15 * 0.25
                        UIUtil.tween(v18, v15 * 0.85, {
                            BackgroundTransparency = 1
                        })
                    end

                    Effects.ripple(surface, fx * (p15 + 0.6), rarity.Color:Lerp(v1, 0.5))
                end

                if p15 >= 0.3 and p15 < 0.82 and n2 <= p14 then
                    local v19 = (p15 - 0.3) / 0.52
                    local v22 = math.max(1, (math.floor((1 - v19) * 10)))

                    n1 = t4[(#t4 - 1 - v22) % #t4 + 1]

                    local v23 = n1
                    local v24 = Config.LuckStages[v23]
                    local title = p12.title
                    local Title, Color = v24.Title, v24.Color

                    title.Text = Title
                    title.TextColor3 = v1

                    local UIGradient = title:FindFirstChildOfClass("UIGradient")

                    if UIGradient then
                        UIGradient.Color = ColorSequence.new(v1, Color)
                    end

                    title.Parent.Visible = true
                    UIUtil.pop(title, 1.15)
                    UIUtil.sound("Tick", 0.5, v19 * 0.5 + 0.9)
                    n2 = p14 + (v19 ^ 2 * 0.24 + 0.06) * p12.pace
                elseif p15 >= 0.82 then
                    local v26 = n1
                    local title

                    if v26 ~= p11 - 1 then
                        n1 = p11 - 1

                        local v27 = n1
                        local v28 = Config.LuckStages[v27]

                        title = p12.title

                        local Title, Color = v28.Title, v28.Color

                        title.Text = Title
                        title.TextColor3 = v1

                        local UIGradient = title:FindFirstChildOfClass("UIGradient")

                        if UIGradient then
                            UIGradient.Color = ColorSequence.new(v1, Color)
                        end

                        title.Parent.Visible = true
                        UIUtil.pop(title, 1.15)
                        UIUtil.sound("LuckRung", 0.8, 0.9)
                    end
                end
            end

            local v30 = math.max(0, 1 - (p14 - n3) / 0.18) * (p15 * 2.5 + 1.5)

            return CFrame.lookAt(p12.base.Position:Lerp(p12.look, p15 * 0.25 * p15), p12.look), p15 * -10 - v30
        end,
        silence = function() -- silence | line: 145
            -- upvalues: p12 (copy), PointLight (copy), v12 (ref), UIUtil (copy)
            if v12 then
                v12:Destroy()
                v12 = nil
            end

            UIUtil.tween(PointLight, 0.25 * p12.pace, {
                Brightness = 0
            })
        end,
        cleanup = function() -- cleanup | line: 152
            -- upvalues: Folder (copy), v7 (copy), v12 (ref)
            if v12 then
                v12:Destroy()
            end

            for _, v31 in v7 do
                v31:Destroy()
            end

            Folder:Destroy()
        end
    }
end

local function mythical(_, p18) -- line: 165
    -- upvalues: UIUtil (copy), Effects (copy), v2 (copy), edges (copy)
    local fx, surface = p18.fx, p18.surface
    local Color = p18.def.Color
    local Folder = Instance.new("Folder")

    Folder.Name = "LuckPrelude"
    Folder.Parent = p18.scene
    UIUtil.tween(p18.grade, 1, {
        Saturation = -0.45,
        Brightness = -0.18,
        TintColor = Color3.fromRGB(255, 170, 165)
    })

    local v32 = edges(p18.gui, v2)
    local t6 = {}

    for i = 1, 26 do
        local v33 = Effects.part({
            Name = "Fire",
            Transparency = 1,
            Size = Vector3.new(0.15, 0.15, 1),
            Material = Enum.Material.Neon,
            Color = Color,
            Parent = Folder
        })
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/fire_main.dds"
        ParticleEmitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 80)),
            ColorSequenceKeypoint.new(0.5, Color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 10, 20))
        })
        ParticleEmitter.LightEmission = 0.8
        ParticleEmitter.LightInfluence = 0
        ParticleEmitter.Brightness = 2.5
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(0.4, 1.1),
            NumberSequenceKeypoint.new(1, 0.2)
        })
        ParticleEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.6)
        ParticleEmitter.Speed = NumberRange.new(2.5, 4.5)
        ParticleEmitter.SpreadAngle = Vector2.new(12, 12)
        ParticleEmitter.Rotation = NumberRange.new(-30, 30)
        ParticleEmitter.RotSpeed = NumberRange.new(-90, 90)
        ParticleEmitter.EmissionDirection = Enum.NormalId.Top
        ParticleEmitter.Rate = 0
        ParticleEmitter.Parent = v33
        t6[i] = {
            line = v33,
            fire = ParticleEmitter
        }
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color
    PointLight.Range = fx * 4 + 12
    PointLight.Brightness = 0.6
    PointLight.Parent = t6[1].line

    local v34 = fx * 4.5 + 6
    local v36 = math.max(fx * 0.45, 1.2)
    local n4 = -10
    local n5 = 0

    return {
        step = function(p19, p20, p21) -- step | line: 202
            -- upvalues: p18 (copy), fx (copy), surface (copy), Color (copy), v32 (copy), t6 (copy), v34 (copy), v36 (copy), n4 (ref), n5 (ref), UIUtil (copy), Effects (copy)
            local v38 = math.clamp(p20 / 0.9, 0, 1)
            local v39 = v38 * v38 * (3 - v38 * 2)
            local v40 = v34 + (v36 - v34) * v39
            local v41 = (1.05 - p20 * 0.65) * p18.pace
            local v42

            if p21 then
                v42 = 0
            else
                if v41 <= p19 - n4 then
                    n4 = p19
                    n5 += 1
                    UIUtil.sound("SubBoom", p20 * 0.35 + 0.35, p20 * 0.35 + 0.75)
                    Effects.ripple(surface, v40 * 0.8, Color)
                end

                v42 = math.max(0, 1 - (p19 - n4) / 0.25)
            end

            local v45 = math.min(p19 / 0.6, 1)

            for v46, v47 in t6 do
                local v48 = v46 / 26 * 6.283185307179586 + p19 * 0.35
                local v49 = 6.283185307179586 * v40 / 26 * 1.05

                v47.line.Size = Vector3.new(0.15, 0.15, v49)
                v47.line.CFrame = CFrame.new(surface + Vector3.new(math.cos(v48) * v40, 0.15, math.sin(v48) * v40)) * CFrame.Angles(0, -v48, 0)

                local line2 = v47.line

                if p21 then
                    line2.Transparency = 1
                else
                    line2.Transparency = 0.6 - v45 * 0.4
                end

                local v54 = (p20 * 0.8 + 0.7 + v42 * 0.8) * math.clamp(fx / 4, 0.6, 2.5)

                v47.fire.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, v54 * 0.6),
                    NumberSequenceKeypoint.new(0.4, v54 * 1.1),
                    NumberSequenceKeypoint.new(1, v54 * 0.2)
                })
                v47.fire.Speed = NumberRange.new(v54 * 2.5, v54 * 4.5)

                local fire = v47.fire

                if p21 then
                    fire.Rate = 0
                else
                    fire.Rate = (p20 * 20 + 14 + v42 * 40) * v45
                end
            end

            for _, v55 in v32 do
                if p21 then
                    v55.BackgroundTransparency = 0
                else
                    local v56 = math.clamp(p20, 0, 1)

                    v55.BackgroundTransparency = 1 - v56 * v56 * (3 - v56 * 2) * 0.9
                end
            end

            local v57 = p18.base.Position:Lerp(p18.look, p20 * 0.18)
            local X, Y = v57.X, v57.Y
            local v58 = (surface.Y + 1.2 - v57.Y) * 0.55
            local v59 = math.clamp(p20, 0, 1)
            local v61 = Vector3.new(X, Y + v58 * (v59 * v59 * (3 - v59 * 2)), v57.Z)
            local v62 = CFrame.lookAt(v61, p18.look)

            return Effects.shake(v62, v42 * (p20 * 0.3 + 0.25)), p20 * -6 - v42 * (p20 * 2 + 1)
        end,
        silence = function() -- silence | line: 235
            -- upvalues: PointLight (copy)
            PointLight.Brightness = 0
        end,
        cleanup = function() -- cleanup | line: 238
            -- upvalues: Folder (copy), v32 (copy)
            for _, v63 in v32 do
                v63:Destroy()
            end

            Folder:Destroy()
        end
    }
end

local function cosmic(_, p23) -- line: 248
    -- upvalues: UIUtil (copy), Effects (copy), v1 (copy), v3 (copy)
    local fx, surface = p23.fx, p23.surface
    local Color = p23.def.Color
    local Folder = Instance.new("Folder")

    Folder.Name = "LuckPrelude"
    Folder.Parent = p23.scene
    UIUtil.tween(p23.grade, 1, {
        Saturation = -0.3,
        Brightness = -0.15,
        TintColor = Color3.fromRGB(175, 215, 255)
    })

    local t8 = {}

    for i = 1, 48 do
        local v64 = if i % 4 == 0 then Color3.fromRGB(190, 120, 255) elseif i % 3 == 0 then v1 else Color

        t8[i] = Effects.part({
            Name = "Star",
            Transparency = 1,
            Size = Vector3.new(0.4, 0.4, 0.4),
            Shape = Enum.PartType.Ball,
            Material = Enum.Material.Neon,
            Color = v64,
            Parent = Folder
        })
    end

    local t9 = {}
    local basePosition = p23.base.Position
    local v65 = Vector3.new(surface.X, basePosition.Y, surface.Z) - basePosition
    local v68 = math.atan2(basePosition.X - surface.X, basePosition.Z - surface.Z)
    local Magnitude = Vector2.new(v65.X, v65.Z).Magnitude
    local v69 = basePosition.Y - surface.Y
    local n6 = 0
    local n7 = -10
    local n8 = 0

    return {
        step = function(p24, p25, p26) -- step | line: 267
            -- upvalues: p23 (copy), fx (copy), surface (copy), Color (copy), Folder (copy), t8 (copy), t9 (copy), v68 (copy), Magnitude (copy), v69 (copy), n6 (ref), n7 (ref), n8 (ref), UIUtil (copy), Effects (copy), v1 (copy), v3 (copy)
            local v70 = p24 - n8

            n8 = p24

            local v71 = n6

            n6 = v71 + v70 * (p25 * 5 * p25 + 0.6)

            local v74 = math.min(fx * 3.5 + 5, Magnitude * 0.45)

            for v75, v76 in t8 do
                local v77 = (v75 / 48 + p24 * (p25 * 0.45 * p25 + 0.12)) % 1
                local v78 = v74 * (1 - v77) + 0.3
                local v80 = v75 * 2.4
                local v81 = n6
                local v79 = v80 + v81 * (1 + 2 * v77)
                local v82 = 0.4 + (1 - v77) * fx * 0.9 * p25

                v76.Position = surface + Vector3.new(math.cos(v79) * v78, v82, math.sin(v79) * v78)
                v76.Size = Vector3.new(1, 1, 1) * (0.12 + 0.18 * (1 - v77)) * (0.8 + fx / 20)

                if p26 then
                    v76.Transparency = 1
                else
                    v76.Transparency = math.clamp(1 - math.min(p24 / 0.8, 1) * (0.3 + 0.6 * v77), 0, 1)
                end
            end

            local v87, part, t11, v88

            if not p26 and #t9 < 70 and v3:NextNumber() < p25 + 0.25 then
                v87 = surface + Vector3.new(v3:NextNumber(-60, 60), v3:NextNumber(25, 70), v3:NextNumber(-60, 60))
                part = Effects.part
                t11 = {
                    Name = "SkyStar",
                    Transparency = 1,
                    Shape = Enum.PartType.Ball,
                    Material = Enum.Material.Neon
                }
                v88 = if v3:NextNumber() < 0.3 then Color else v1
                t11.Color = v88
                t11.Size = Vector3.new(1, 1, 1) * v3:NextNumber(0.3, 0.8)
                t11.Position = v87
                t11.Parent = Folder

                local v91 = part(t11)

                UIUtil.tween(v91, 0.5, {
                    Transparency = 0.2
                })
                table.insert(t9, v91)
            end

            if not p26 and p24 - n7 > (0.9 - p25 * 0.6) * p23.pace then
                n7 = p24
                UIUtil.sound("Whoosh", p25 * 0.25 + 0.18, p25 * 1 + 0.6)
            end

            local v92 = v68 + p25 ^ 1.6 * 2.6179938779914944
            local v93 = math.clamp(p25, 0, 1)
            local v94 = Magnitude * (1 - v93 * v93 * (3 - v93 * 2) * 0.2)
            local v98 = Vector3.new(surface.X + math.sin(v92) * v94, surface.Y + v69 + p25 * 2, surface.Z + math.cos(v92) * v94)
            local v99 = CFrame.lookAt(v98, p23.look)
            local v100 = math.clamp(p25, 0, 1)

            return v99, v100 * v100 * (3 - v100 * 2) * 14
        end,
        silence = function() -- silence | line: 301
            -- upvalues: t9 (copy), UIUtil (copy)
            for _, v101 in t9 do
                UIUtil.tween(v101, 0.2, {
                    Transparency = 1
                })
            end
        end,
        cleanup = function() -- cleanup | line: 306
            -- upvalues: Folder (copy)
            Folder:Destroy()
        end
    }
end

local function divine(_, p28) -- line: 313
    -- upvalues: UIUtil (copy), Effects (copy), v1 (copy), v3 (copy)
    local fx, surface = p28.fx, p28.surface
    local Color = p28.def.Color
    local Folder = Instance.new("Folder")

    Folder.Name = "LuckPrelude"
    Folder.Parent = p28.scene
    UIUtil.tween(p28.grade, 1.2, {
        Saturation = -0.55,
        Brightness = -0.22,
        TintColor = Color3.fromRGB(255, 240, 215)
    })

    local v102 = Effects.part({
        Name = "Shaft",
        Transparency = 0.6,
        Size = Vector3.new(1, 0.5, 0.5),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = Color,
        Parent = Folder
    })
    local v103 = Effects.part({
        Name = "ShaftHaze",
        Transparency = 0.88,
        Size = Vector3.new(1, 0.5, 0.5),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = Color,
        Parent = Folder
    })
    local v104 = Effects.part({
        Name = "Pool",
        Transparency = 1,
        Size = Vector3.new(0.1, 1, 1),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = Color,
        CFrame = CFrame.new(surface + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = Folder
    })
    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color
    PointLight.Range = fx * 3 + 10
    PointLight.Brightness = 0
    PointLight.Parent = v104

    local t12 = {}
    local t13 = {
        0.8, 0.9, 1, 1.07, 1.2, 1.35, 1.5, 1.6
    }
    local n9 = 0
    local n10 = -10
    local n11 = 0
    local v105 = false

    return {
        step = function(p29, p30, p31) -- step | line: 332
            -- upvalues: p28 (copy), fx (copy), surface (copy), Color (copy), Folder (copy), v102 (copy), v103 (copy), v104 (copy), PointLight (copy), t12 (copy), t13 (copy), n9 (ref), n10 (ref), n11 (ref), v105 (ref), UIUtil (copy), Effects (copy), v1 (copy), v3 (copy)
            local v106 = p29 - n11

            n11 = p29

            local v108 = math.clamp(p30 / 0.6, 0, 1)
            local v109 = v108 * v108 * (3 - v108 * 2)
            local v110 = surface.Y + (1 - v109) * 140
            local v112 = math.clamp((p30 - 0.4) / 0.5, 0, 1)
            local v113 = fx * (v112 * v112 * (3 - v112 * 2) * 0.9 + 0.25) + 0.6
            local v114 = surface.Y + 140 + 40 - v110

            v102.Size = Vector3.new(v114, v113, v113)
            v102.CFrame = CFrame.new(surface.X, v110 + v114 / 2, surface.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
            v102.Transparency = if p31 then 1 else math.sin(p29 * 7) * 0.06 + 0.72
            v103.Size = Vector3.new(v114, v113 * 2.2, v113 * 2.2)
            v103.CFrame = v102.CFrame
            v103.Transparency = p31 and 1 or 0.88

            if v109 >= 1 and not v105 then
                v105 = true
                UIUtil.sound("Splash", 0.4, 1.4)
                Effects.ripple(surface, fx * 1.5, Color)
            end

            if v105 and not p31 then
                v104.Size = Vector3.new(0.1, v113 * 1.6, v113 * 1.6)
                v104.Transparency = 0.6
                PointLight.Brightness = 1.5
            end

            if not p31 and p30 > 0.15 and v3:NextNumber() < 0.35 then
                table.insert(t12, {
                    part = Effects.part({
                        Name = "Feather",
                        Transparency = 0.15,
                        Material = Enum.Material.Neon,
                        Color = v1:Lerp(Color, 0.3),
                        Size = Vector3.new(0.12 + fx * 0.01, 0.05, 0.5 + fx * 0.03),
                        Parent = Folder
                    }),
                    at = surface + Vector3.new(v3:NextNumber(-1, 1) * (v113 + 4), v3:NextNumber(14, 26), v3:NextNumber(-1, 1) * (v113 + 4)),
                    phase = v3:NextNumber(0, 6.283185307179586)
                })
            end

            for i = #t12, 1, -1 do
                local v126 = t12[i]

                v126.at = v126.at - Vector3.new(0, v106 * 3.2, 0)

                if v126.at.Y < surface.Y or p31 then
                    v126.part:Destroy()
                    table.remove(t12, i)
                else
                    local v129 = math.sin(p29 * 2.2 + v126.phase)

                    v126.part.CFrame = CFrame.new(v126.at + Vector3.new(v129 * 1.2, 0, math.cos(p29 * 1.7 + v126.phase) * 0.6)) * CFrame.Angles(v129 * 0.6, v126.phase + p29 * 0.4, 0)
                end
            end

            local v133 = not p31

            if v133 then
                local v134 = n9

                v133 = v134 < #t13 and p29 - n10 > (0.55 - p30 * 0.2) * p28.pace
            end

            if v133 then
                n10 = p29
                n9 += 1
                UIUtil.sound("LuckRung", 0.55, t13[n9])
            end

            local v136 = Vector3.new(surface.X, surface.Y + 45, surface.Z)
            local v139 = Vector3.new(surface.X, math.max(v110, surface.Y + 0.5), surface.Z)
            local v141 = math.clamp((p30 - 0.1) / 0.55, 0, 1)
            local v142 = v136:Lerp(v139, v141 * v141 * (3 - v141 * 2))
            local look = p28.look
            local v144 = math.clamp((p30 - 0.6) / 0.3, 0, 1)
            local v145 = v142:Lerp(look, v144 * v144 * (3 - v144 * 2))
            local v146 = p28.base.Position:Lerp(p28.look, p30 * 0.15)

            return CFrame.lookAt(v146, v145), p30 * -8
        end,
        silence = function() -- silence | line: 385
            -- upvalues: v104 (copy), PointLight (copy)
            PointLight.Brightness = 0
            v104.Transparency = 1
        end,
        cleanup = function() -- cleanup | line: 389
            -- upvalues: Folder (copy)
            Folder:Destroy()
        end
    }
end

local t17 = {
    "#",
    "@",
    "%",
    "?",
    "!",
    "&",
    "$",
    "0",
    "1",
    "X",
    "/",
    "\\",
    "*"
}
local t18 = {
    Color3.fromRGB(255, 80, 255),
    Color3.fromRGB(80, 255, 255),
    Color3.fromRGB(255, 255, 90),
    v1
}
local t19 = {
    [7] = jackpot,
    [8] = mythical,
    [9] = cosmic,
    [10] = divine,
    [11] = function(_, p33) -- beyond | line: 398
        -- upvalues: Config (copy), UIUtil (copy), v1 (copy), v3 (copy), t17 (copy), t18 (copy)
        local def, gui = p33.def, p33.gui

        UIUtil.tween(p33.grade, 0.5, {
            Saturation = -0.5,
            Brightness = -0.15
        })

        local t20 = {}

        for i = 1, 9 do
            local Frame = Instance.new("Frame")

            Frame.Name = "LuckEdgeGlitch" .. i
            Frame.BorderSizePixel = 0
            Frame.Visible = false
            Frame.ZIndex = 8
            Frame.Parent = gui
            t20[i] = Frame
        end

        local v147 = p33.base
        local n12 = 0
        local n13 = 0
        local n14 = 0
        local n15 = 0
        local v148 = false

        local function scramble(p34) -- line: 415
            -- upvalues: Config (copy), v3 (copy), t17 (copy)
            local Title = Config.LuckStages[v3:NextInteger(1, #Config.LuckStages)].Title
            local t21 = {}

            for i = 1, #Title do
                local v149 = Title:sub(i, i)

                if v3:NextNumber() < p34 * 0.6 + 0.25 then
                    v149 = t17[v3:NextInteger(1, #t17)]
                end

                table.insert(t21, v149)
            end

            return table.concat(t21)
        end

        return {
            step = function(p35, p36, p37) -- step | line: 426
                -- upvalues: p33 (copy), def (copy), t20 (copy), v147 (ref), n12 (ref), n13 (ref), n14 (ref), n15 (ref), v148 (ref), scramble (copy), UIUtil (copy), v1 (copy), v3 (copy), t18 (copy)
                if p37 then
                    for _, v150 in t20 do
                        v150.Visible = false
                    end

                    return CFrame.lookAt(p33.base.Position:Lerp(p33.look, p36 * 0.25 * p36), p33.look), p36 * -10
                end

                if n13 <= p35 then
                    n13 = p35 + v3:NextNumber(0.04, 0.16 - p36 * 0.1)

                    for v151, v152 in t20 do
                        v152.Visible = v3:NextNumber() < 0.15 + p36 * 0.6 * (v151 / #t20)
                        v152.BackgroundColor3 = t18[v3:NextInteger(1, #t18)]
                        v152.BackgroundTransparency = v3:NextNumber(0.35, 0.75)
                        v152.Position = UDim2.fromScale(v3:NextNumber(-0.3, 0.6), v3:NextNumber(0, 1))
                        v152.Size = UDim2.fromScale(v3:NextNumber(0.3, 1), v3:NextNumber(0.005, p36 * 0.05 + 0.04))
                    end

                    if v3:NextNumber() < p36 * 0.5 + 0.3 then
                        p33.grade.TintColor = t18[v3:NextInteger(1, #t18)]:Lerp(v1, 0.45)
                        p33.grade.Saturation = v3:NextNumber(-1, 0.6)
                        p33.grade.Contrast = v3:NextNumber(0, 0.6)
                    end
                end

                if n14 <= p35 and p36 > 0.2 then
                    n14 = p35 + v3:NextNumber(0.05, 0.18)

                    local title = p33.title
                    local v153 = scramble(p36)
                    local Color = def.Color

                    title.Text = v153
                    title.TextColor3 = v1

                    local UIGradient = title:FindFirstChildOfClass("UIGradient")

                    if UIGradient then
                        UIGradient.Color = ColorSequence.new(v1, Color)
                    end

                    title.Parent.Visible = true
                    p33.title.Rotation = v3:NextNumber(-6, 6) * p36
                end

                if n15 <= p35 then
                    n15 = p35 + v3:NextNumber(0.08, 0.5 - p36 * 0.35)
                    UIUtil.sound("Tick", p36 * 0.3 + 0.25, v3:NextNumber(0.4, 2.4))
                end

                if p36 >= 0.6 and not v148 then
                    v148 = true
                    p33.crack()
                end

                if n12 <= p35 then
                    n12 = p35 + v3:NextNumber(0.03, 0.2 - p36 * 0.12)

                    local v156 = Vector3.new(v3:NextNumber(-1, 1), v3:NextNumber(-1, 1), v3:NextNumber(-1, 1)) * (p36 * 0.6 + 0.15)

                    v147 = CFrame.lookAt(p33.base.Position:Lerp(p33.look, p36 * 0.25 * p36), p33.look) * CFrame.new(v156) * CFrame.Angles(0, 0, (math.rad(v3:NextNumber(-4, 4) * p36)))
                end

                local v159 = if v3:NextNumber() < p36 * 0.08 then v3:NextNumber(-12, 8) else p36 * -10

                return v147, v159
            end,
            silence = function() -- silence | line: 472
                -- upvalues: p33 (copy)
                p33.title.Rotation = 0
            end,
            cleanup = function() -- cleanup | line: 475
                -- upvalues: t20 (copy)
                for _, v160 in t20 do
                    v160:Destroy()
                end
            end
        }
    end
}

function t1.make(p38, p39) -- line: 485
    -- upvalues: jackpot (copy), t19 (copy)
    return (t19[math.min(p38, 11)] or jackpot)(p38, p39)
end

return t1
