-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Config = require(script.Parent.Config)
local Animals = require(script.Parent.Animals)
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local t2 = {
    ["rbxassetid://16676544947"] = "OneShot",
    ["rbxassetid://16669188960"] = "OneShot",
    ["rbxassetid://16664675233"] = "OneShot",
    ["rbxassetid://9147387925"] = "Loop",
    ["rbxassetid://111860228388694"] = "Loop"
}

local function emitter(p1, p2) -- line: 27
    -- upvalues: t2 (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "LookVfx"
    ParticleEmitter.Texture = "rbxassetid://1851669703"
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Brightness = 1.2
    ParticleEmitter.LockedToPart = false

    for v2, v3 in p2 do
        ParticleEmitter[v2] = v3
    end

    local v4 = t2[ParticleEmitter.Texture]

    if v4 then
        ParticleEmitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        ParticleEmitter.FlipbookMode = Enum.ParticleFlipbookMode[v4]
    end

    ParticleEmitter.Parent = p1

    return ParticleEmitter
end

local function sizes(p3, p4, p5) -- line: 47
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p3),
        NumberSequenceKeypoint.new(0.5, p4),
        NumberSequenceKeypoint.new(1, p5 or 0)
    })
end

local function fadeInOut(p6) -- line: 55
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, p6 or 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function light(p7, p8, p9, p10) -- line: 63
    local PointLight = Instance.new("PointLight")

    PointLight.Name = "LookLight"
    PointLight.Color = p8
    PointLight.Range = p9 * 0.7
    PointLight.Brightness = p10 * 0.25
    PointLight.Shadows = false
    PointLight.Parent = p7
end

local function rainbowSequence() -- line: 73
    local t3 = {}

    for i = 0, 5 do
        table.insert(t3, ColorSequenceKeypoint.new(i / 5, Color3.fromHSV(i / 6, 0.75, 1)))
    end

    return ColorSequence.new(t3)
end

local function roleOf(p11, p12) -- line: 81
    -- upvalues: Animals (copy)
    local v7 = p11:GetAttribute("Species") or p11.Name
    local Name = p12.Name
    local v8 = "A_" .. Animals.look(v7) .. "_"

    if Name:sub(1, #v8) == v8 then
        Name = Name:sub(#v8 + 1)
    end

    return (Name:gsub("__.*$", ""))
end

local function shadeOf(p13, p14) -- line: 93
    if p13:find("^Body") then
        return 1
    end

    if p13:find("^Head") or p13:find("^Neck") then
        return 0.9
    end

    return p14 % 3 * 0.1 + 0.62
end

function t1.mutate(p15, p16) -- line: 103
    -- upvalues: Config (copy), roleOf (copy)
    local v9 = p16 and Config.MutationByName[p16]

    if not v9 then
        return
    end

    p15:SetAttribute("Mutation", v9.Name)

    local n1 = 0

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("BasePart") then
            n1 += 1

            local v10 = roleOf(p15, descendant)

            if descendant:IsA("MeshPart") then
                descendant.TextureID = ""
            end

            local v11 = descendant.Material == Enum.Material.Neon

            if v9.Rainbow then
                descendant.Color = Color3.fromHSV(n1 * 0.17 % 1, 0.75, 0.85)
            elseif v9.Eyes and (v10:find("Eye") or v10:find("Pupil")) then
                descendant.Color = v9.Eyes
            else
                descendant.Color = v9.Dark:Lerp(v9.Light, if v10:find("^Body") then 1 elseif v10:find("^Head") or v10:find("^Neck") then 0.9 else n1 % 3 * 0.1 + 0.62)
            end

            if not v11 then
                descendant.Material = v9.Material
                descendant.Reflectance = v9.Reflectance or 0
            end

            if v9.Transparency and descendant.Transparency < v9.Transparency then
                descendant.Transparency = v9.Transparency
            end
        end
    end
end

local function pulse(p17, p18, p19, p20) -- line: 137
    -- upvalues: emitter (copy)
    emitter(p17, {
        Texture = "rbxassetid://8271495905",
        LightEmission = 0.6,
        Brightness = 2.5,
        LockedToPart = true,
        Color = ColorSequence.new(p18),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p19 * 0.1),
            NumberSequenceKeypoint.new(1, p19 * 0.85)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.4),
        Rate = 1 / p20
    })
end

local t4 = {
    Gold = function(p21, p22) -- Gold | line: 143
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
        emitter(p21, {
            Rate = 5,
            Color = ColorSequence.new(Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 190, 40)),
            Size = sizes(0, p22 * 0.07),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.6, 1),
            Speed = NumberRange.new(0, 0.3),
            Rotation = NumberRange.new(0, 360)
        })
    end,
    Diamond = function(p23, p24) -- Diamond | line: 146
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy)
        emitter(p23, {
            Rate = 9,
            Color = ColorSequence.new(v1, Color3.fromRGB(150, 230, 255)),
            Size = sizes(0, p24 * 0.09),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.4, 0.8),
            Speed = NumberRange.new(0, 0.2),
            Rotation = NumberRange.new(0, 360)
        })

        local v12 = Color3.fromRGB(170, 230, 255)
        local v13 = p24 * 1.2
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v12
        PointLight.Range = v13 * 0.7
        PointLight.Brightness = 0.2
        PointLight.Shadows = false
        PointLight.Parent = p23
    end,
    Emerald = function(p25, p26) -- Emerald | line: 150
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
        local v14 = Color3.fromRGB(70, 235, 135)

        emitter(p25, {
            Rate = 11,
            Color = ColorSequence.new(Color3.fromRGB(210, 255, 225), v14),
            Size = sizes(0, p26 * 0.09),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.5, 0.9),
            Speed = NumberRange.new(0, p26 * 0.03),
            Rotation = NumberRange.new(0, 360)
        })
        emitter(p25, {
            Texture = "rbxassetid://111860228388694",
            LightEmission = 0.5,
            Drag = 2,
            Rate = 3,
            Color = ColorSequence.new(v14),
            Size = sizes(p26 * 0.03, p26 * 0.05, 0),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(1.2, 1.8),
            Speed = NumberRange.new(p26 * 0.05, p26 * 0.12),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-90, 90)
        })

        local v15 = p26 * 1.3
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v14
        PointLight.Range = v15 * 0.7
        PointLight.Brightness = 0.25
        PointLight.Shadows = false
        PointLight.Parent = p25
    end,
    Ruby = function(p27, p28) -- Ruby | line: 156
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy)
        local v16 = Color3.fromRGB(255, 50, 80)

        emitter(p27, {
            Rate = 16,
            Color = ColorSequence.new(Color3.fromRGB(255, 200, 205), v16),
            Size = sizes(0, p28 * 0.1),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.5, 1),
            Speed = NumberRange.new(0, p28 * 0.05),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360)
        })
        emitter(p27, {
            Texture = "rbxassetid://111860228388694",
            LightEmission = 0.6,
            Brightness = 2,
            Drag = 2,
            Rate = 5,
            Color = ColorSequence.new(v16),
            Size = sizes(p28 * 0.04, p28 * 0.06, 0),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(1.2, 2),
            Speed = NumberRange.new(p28 * 0.06, p28 * 0.15),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-120, 120)
        })
        pulse(p27, v16, p28, 2.2)

        local v17 = p28 * 1.4
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v16
        PointLight.Range = v17 * 0.7
        PointLight.Brightness = 0.325
        PointLight.Shadows = false
        PointLight.Parent = p27
    end,
    Rainbow = function(p29, p30) -- Rainbow | line: 163
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy), rainbowSequence (copy), pulse (copy)
        emitter(p29, {
            Drag = 1,
            Rate = 22,
            Color = rainbowSequence(),
            Size = sizes(0, p30 * 0.1),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.8, 1.4),
            Speed = NumberRange.new(p30 * 0.08, p30 * 0.2),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-90, 90)
        })
        emitter(p29, {
            Texture = "rbxassetid://16956515291",
            LightEmission = 1,
            LockedToPart = true,
            Rate = 6,
            Color = rainbowSequence(),
            Size = sizes(0, p30 * 0.07),
            Transparency = NumberSequence.new(0, 1),
            Lifetime = NumberRange.new(0.4, 0.7),
            Speed = NumberRange.new(0),
            Rotation = NumberRange.new(0, 360)
        })
        pulse(p29, Color3.fromRGB(255, 255, 255), p30, 1.6)

        local v18 = Color3.fromRGB(255, 240, 255)
        local v19 = p30 * 1.5
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v18
        PointLight.Range = v19 * 0.7
        PointLight.Brightness = 0.35
        PointLight.Shadows = false
        PointLight.Parent = p29
    end,
    Galaxy = function(p31, p32) -- Galaxy | line: 169
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy)
        emitter(p31, {
            Rate = 16,
            Color = ColorSequence.new(v1, Color3.fromRGB(200, 160, 255)),
            Size = sizes(0, p32 * 0.06),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(1, 2),
            Speed = NumberRange.new(0, 0.2),
            Rotation = NumberRange.new(0, 360)
        })
        emitter(p31, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0.6,
            Rate = 4,
            Color = ColorSequence.new(Color3.fromRGB(120, 60, 255), Color3.fromRGB(40, 20, 120)),
            Size = sizes(p32 * 0.15, p32 * 0.35, p32 * 0.4),
            Transparency = fadeInOut(0.75),
            Lifetime = NumberRange.new(1.5, 2.5),
            Speed = NumberRange.new(0, p32 * 0.05),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-20, 20)
        })

        local v20 = Color3.fromRGB(140, 90, 255)
        local v21 = p32 * 1.5
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v20
        PointLight.Range = v21 * 0.7
        PointLight.Brightness = 0.3
        PointLight.Shadows = false
        PointLight.Parent = p31
    end
}
local t5 = {}

t5[6] = function(p33, p34, p35) -- line: 178
    -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
    emitter(p33, {
        Rate = 16,
        Color = ColorSequence.new(Color3.fromRGB(170, 255, 140), p35),
        Size = sizes(0, p34 * 0.11),
        Transparency = fadeInOut(0),
        Lifetime = NumberRange.new(1.5, 2.5),
        Speed = NumberRange.new(p34 * 0.05, p34 * 0.12),
        Acceleration = Vector3.new(0, p34 * 0.08, 0),
        SpreadAngle = Vector2.new(180, 180)
    })
    emitter(p33, {
        Texture = "rbxassetid://242214111",
        LightEmission = 0.3,
        Rate = 10,
        Color = ColorSequence.new(Color3.fromRGB(220, 255, 240)),
        Size = sizes(p34 * 0.03, p34 * 0.05, p34 * 0.06),
        Transparency = NumberSequence.new(0.4, 1),
        Lifetime = NumberRange.new(1, 1.6),
        Speed = NumberRange.new(p34 * 0.1, p34 * 0.2),
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(25, 25)
    })
end

t5[7] = function(p36, p37, p38) -- line: 182
    -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
    emitter(p36, {
        Drag = 1.5,
        Rate = 26,
        Color = ColorSequence.new(Color3.fromRGB(180, 245, 255), p38),
        Size = sizes(0, p37 * 0.12),
        Transparency = fadeInOut(0),
        Lifetime = NumberRange.new(0.8, 1.4),
        Speed = NumberRange.new(p37 * 0.1, p37 * 0.25),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-180, 180)
    })
end

t5[8] = function(p39, p40, p41) -- line: 185
    -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy)
    emitter(p39, {
        Rate = 22,
        Color = ColorSequence.new(v1, Color3.fromRGB(180, 230, 255)),
        Size = sizes(p40 * 0.05, p40 * 0.08, 0),
        Transparency = fadeInOut(0),
        Lifetime = NumberRange.new(1.5, 2.5),
        Speed = NumberRange.new(0, p40 * 0.05),
        Acceleration = Vector3.new(0, -p40 * 0.08, 0),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-60, 60)
    })
    emitter(p39, {
        Texture = "rbxassetid://16669188960",
        LightEmission = 0.4,
        Rate = 5,
        Color = ColorSequence.new(Color3.fromRGB(210, 240, 255), p41),
        Size = sizes(p40 * 0.2, p40 * 0.35, p40 * 0.45),
        Transparency = fadeInOut(0.7),
        Lifetime = NumberRange.new(2, 3),
        Speed = NumberRange.new(0, p40 * 0.03),
        Rotation = NumberRange.new(0, 360)
    })
end

t5[9] = function(p42, p43, p44) -- line: 189
    -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
    emitter(p42, {
        Texture = "rbxassetid://16669188960",
        LightEmission = 0,
        Rate = 10,
        Color = ColorSequence.new(Color3.fromRGB(70, 20, 120), Color3.fromRGB(10, 0, 25)),
        Size = sizes(p43 * 0.15, p43 * 0.3, p43 * 0.4),
        Transparency = fadeInOut(0.45),
        Lifetime = NumberRange.new(1.5, 2.5),
        Speed = NumberRange.new(0, p43 * 0.06),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-30, 30)
    })
    emitter(p42, {
        Rate = 16,
        Color = ColorSequence.new(Color3.fromRGB(220, 140, 255), p44),
        Size = sizes(0, p43 * 0.1),
        Transparency = fadeInOut(0),
        Lifetime = NumberRange.new(0.5, 1),
        Speed = NumberRange.new(p43 * 0.05, p43 * 0.15),
        SpreadAngle = Vector2.new(180, 180)
    })
end

t5[10] = function(p45, p46, p47) -- line: 193
    -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy)
    emitter(p45, {
        Rate = 29,
        Color = ColorSequence.new(Color3.fromRGB(255, 220, 120), Color3.fromRGB(255, 80, 20)),
        Size = sizes(p46 * 0.05, p46 * 0.07, 0),
        Transparency = fadeInOut(0),
        Lifetime = NumberRange.new(1, 2),
        Speed = NumberRange.new(p46 * 0.05, p46 * 0.15),
        Acceleration = Vector3.new(0, p46 * 0.15, 0),
        SpreadAngle = Vector2.new(180, 180)
    })
    emitter(p45, {
        Texture = "rbxassetid://16676544947",
        Rate = 16,
        Color = ColorSequence.new(Color3.fromRGB(255, 190, 70), p47),
        Size = sizes(p46 * 0.12, p46 * 0.16, 0),
        Transparency = NumberSequence.new(0.5, 1),
        Lifetime = NumberRange.new(0.4, 0.7),
        Speed = NumberRange.new(p46 * 0.05, p46 * 0.1),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360)
    })
end

local function partOf(p48, p49) -- line: 200
    -- upvalues: roleOf (copy)
    for _, descendant in p48:GetDescendants() do
        if descendant:IsA("BasePart") and roleOf(p48, descendant) == p49 then
            return descendant
        end
    end

    return nil
end

local function piece(p50, p51) -- line: 210
    local v25 = "_" .. p51

    for _, descendant in p50:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name:sub(-#v25) == v25 then
            return descendant
        end
    end

    return nil
end

local function spot(p52, p53, p54) -- line: 222
    local Attachment = Instance.new("Attachment")

    Attachment.Name = p54
    Attachment.Position = p52.Size / 2 * p53
    Attachment.Parent = p52

    return Attachment
end

local function trail(p55, p56, p57, p58, p59) -- line: 232
    -- upvalues: v1 (copy)
    if not p55 then
        return
    end

    local v26 = p55.Size / 2 * p56
    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Name = "LookTrail0"
    Attachment2.Name = "LookTrail1"

    local v28 = v26 + Vector3.new(0, p58 / 2, 0)
    local v30 = v26 - Vector3.new(0, p58 / 2, 0)

    Attachment.Position = v28
    Attachment2.Position = v30
    Attachment.Parent = p55
    Attachment2.Parent = p55

    local Trail = Instance.new("Trail")

    Trail.Name = "LookTrail"
    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Color = ColorSequence.new(p57:Lerp(v1, 0.25), p57)
    Trail.Brightness = 2.5
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.WidthScale = NumberSequence.new(1, 0.15)
    Trail.Lifetime = p59
    Trail.MinLength = 0.05
    Trail.FaceCamera = true
    Trail.LightEmission = 0.4
    Trail.LightInfluence = 0
    Trail.Enabled = false
    Trail.Parent = p55
    task.delay(0.5, function() -- line: 260
        -- upvalues: Trail (copy)
        if Trail.Parent then
            Trail:Clear()
            Trail.Enabled = true
        end
    end)
end

local t9 = {
    TreasureTurtle = function(p60, p61, p62) -- TreasureTurtle | line: 273
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy), partOf (copy)
        local v31 = Color3.fromRGB(255, 205, 60)

        emitter(p60, {
            Rate = 14,
            Color = ColorSequence.new(Color3.fromRGB(255, 250, 200), v31),
            Size = sizes(0, p61 * 0.1),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.5, 0.9),
            Speed = NumberRange.new(0, p61 * 0.03),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-120, 120)
        })
        emitter(p60, {
            Texture = "rbxassetid://242214111",
            LightEmission = 0.6,
            Rate = 10,
            Color = ColorSequence.new(v31, Color3.fromRGB(255, 160, 30)),
            Size = sizes(p61 * 0.04, p61 * 0.06, 0),
            Transparency = fadeInOut(0.1),
            Lifetime = NumberRange.new(1.2, 2),
            Speed = NumberRange.new(p61 * 0.08, p61 * 0.16),
            Acceleration = Vector3.new(0, p61 * 0.06, 0),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(40, 40)
        })

        local Treasure = partOf(p62, "Treasure")

        if Treasure then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "Coins"
            Attachment.Position = Treasure.Size / 2 * Vector3.new(-0.3, 0.8, -0.5)
            Attachment.Parent = Treasure
            emitter(Attachment, {
                Texture = "rbxassetid://9147387925",
                LightEmission = 0.3,
                Brightness = 2,
                Rate = 3,
                Color = ColorSequence.new(Color3.fromRGB(255, 215, 70)),
                Size = NumberSequence.new(p61 * 0.07),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.8, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Lifetime = NumberRange.new(1.1, 1.5),
                Speed = NumberRange.new(p61 * 0.45, p61 * 0.6),
                Acceleration = Vector3.new(0, -p61 * 0.9, 0),
                EmissionDirection = Enum.NormalId.Top,
                SpreadAngle = Vector2.new(30, 30)
            })
            emitter(Attachment, {
                Brightness = 2.5,
                Rate = 10,
                Color = ColorSequence.new(Color3.fromRGB(255, 250, 200), v31),
                Size = sizes(0, p61 * 0.08),
                Transparency = fadeInOut(0),
                Lifetime = NumberRange.new(0.6, 1),
                Speed = NumberRange.new(p61 * 0.05, p61 * 0.15),
                EmissionDirection = Enum.NormalId.Top,
                SpreadAngle = Vector2.new(50, 50),
                Rotation = NumberRange.new(0, 360)
            })
        end

        pulse(p60, v31, p61, 1.6)

        local v34 = p61 * 1.5
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v31
        PointLight.Range = v34 * 0.7
        PointLight.Brightness = 0.35
        PointLight.Shadows = false
        PointLight.Parent = p60
    end,
    CrystalLeviathan = function(p63, p64, p65) -- CrystalLeviathan | line: 287
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy), partOf (copy), trail (copy)
        local v35 = Color3.fromRGB(110, 230, 255)

        emitter(p63, {
            Drag = 1.2,
            Rate = 26,
            Color = ColorSequence.new(v1, v35),
            Size = sizes(p64 * 0.04, p64 * 0.09, 0),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(1, 1.6),
            Speed = NumberRange.new(p64 * 0.08, p64 * 0.2),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-200, 200)
        })
        emitter(p63, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0.5,
            Rate = 5,
            Color = ColorSequence.new(Color3.fromRGB(200, 245, 255), v35),
            Size = sizes(p64 * 0.18, p64 * 0.32, p64 * 0.4),
            Transparency = fadeInOut(0.75),
            Lifetime = NumberRange.new(1.5, 2.5),
            Speed = NumberRange.new(0, p64 * 0.04),
            Rotation = NumberRange.new(0, 360)
        })

        local v36 = partOf(p65, "Crystals") or p63

        emitter(v36, {
            Texture = "rbxassetid://111860228388694",
            LightEmission = 0.6,
            Brightness = 2.5,
            Drag = 2,
            Rate = 6,
            Color = ColorSequence.new(v35),
            Size = sizes(p64 * 0.05, p64 * 0.07, 0),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(1.4, 2),
            Speed = NumberRange.new(p64 * 0.12, p64 * 0.22),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-90, 90)
        })
        emitter(v36, {
            Texture = "rbxassetid://16956515291",
            LightEmission = 1,
            LockedToPart = true,
            Rate = 4,
            Color = ColorSequence.new(v1, v35),
            Size = sizes(0, p64 * 0.06),
            Transparency = NumberSequence.new(0, 1),
            Lifetime = NumberRange.new(0.4, 0.7),
            Speed = NumberRange.new(0),
            Rotation = NumberRange.new(0, 360)
        })

        local Head = partOf(p65, "Head")

        if Head then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "Breath"
            Attachment.Position = Head.Size / 2 * Vector3.new(0.07, 0.1, 1)
            Attachment.Parent = Head
            emitter(Attachment, {
                Texture = "rbxassetid://16669188960",
                LightEmission = 0.6,
                Rate = 8,
                Color = ColorSequence.new(v1, v35),
                Size = sizes(p64 * 0.03, p64 * 0.08, p64 * 0.12),
                Transparency = fadeInOut(0.5),
                Lifetime = NumberRange.new(0.6, 1),
                Speed = NumberRange.new(p64 * 0.08, p64 * 0.14),
                EmissionDirection = Enum.NormalId.Front,
                SpreadAngle = Vector2.new(20, 20),
                Rotation = NumberRange.new(0, 360)
            })
        end

        trail(p63, Vector3.new(0.36, -0.76, -1), v35, p64 * 0.08, 0.6)
        pulse(p63, v35, p64, 2)

        local v37 = p64 * 1.6
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v35
        PointLight.Range = v37 * 0.7
        PointLight.Brightness = 0.4
        PointLight.Shadows = false
        PointLight.Parent = p63
    end,
    AbyssDragon = function(p66, p67, p68) -- AbyssDragon | line: 302
        -- upvalues: emitter (copy), sizes (copy), fadeInOut (copy), partOf (copy), trail (copy)
        local v38 = Color3.fromRGB(255, 60, 200)
        local v39 = Color3.fromRGB(150, 70, 255)

        emitter(p66, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0,
            Rate = 12,
            Color = ColorSequence.new(Color3.fromRGB(90, 20, 140), Color3.fromRGB(15, 0, 30)),
            Size = sizes(p67 * 0.18, p67 * 0.34, p67 * 0.45),
            Transparency = fadeInOut(0.4),
            Lifetime = NumberRange.new(1.5, 2.5),
            Speed = NumberRange.new(0, p67 * 0.06),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-30, 30)
        })
        emitter(p66, {
            Rate = 24,
            Color = ColorSequence.new(Color3.fromRGB(255, 180, 240), v38),
            Size = sizes(p67 * 0.03, p67 * 0.07, 0),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.8, 1.4),
            Speed = NumberRange.new(p67 * 0.05, p67 * 0.15),
            Acceleration = Vector3.new(0, p67 * 0.1, 0),
            SpreadAngle = Vector2.new(180, 180)
        })
        emitter(p66, {
            Texture = "rbxassetid://16664675233",
            LightEmission = 1,
            Brightness = 2.5,
            LockedToPart = true,
            Rate = 1.5,
            Color = ColorSequence.new(Color3.fromRGB(230, 190, 255), v39),
            Size = NumberSequence.new(p67 * 0.3),
            Transparency = NumberSequence.new(0.1, 0.6),
            Lifetime = NumberRange.new(0.2, 0.3),
            Speed = NumberRange.new(0),
            Rotation = NumberRange.new(0, 360)
        })

        local Head = partOf(p68, "Head")

        if Head then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "Breath"
            Attachment.Position = Head.Size / 2 * Vector3.new(-0.25, 0.1, 1)
            Attachment.Parent = Head
            emitter(Attachment, {
                Texture = "rbxassetid://16676544947",
                Brightness = 2,
                Rate = 14,
                Color = ColorSequence.new(Color3.fromRGB(255, 140, 240), v39),
                Size = sizes(p67 * 0.05, p67 * 0.09, 0),
                Transparency = NumberSequence.new(0.3, 1),
                Lifetime = NumberRange.new(0.35, 0.6),
                Speed = NumberRange.new(p67 * 0.08, p67 * 0.14),
                EmissionDirection = Enum.NormalId.Front,
                SpreadAngle = Vector2.new(15, 15),
                Rotation = NumberRange.new(0, 360)
            })
        end

        local Wings = partOf(p68, "Wings")

        trail(Wings, Vector3.new(1, 0.19, -0.97), v38, p67 * 0.07, 0.55)
        trail(Wings, Vector3.new(-1, -0.25, -1), v38, p67 * 0.07, 0.55)
        trail(Wings, Vector3.new(0.88, 1, -0.66), v38, p67 * 0.05, 0.45)
        trail(p66, Vector3.new(-0.65, -0.36, -1), v39, p67 * 0.07, 0.6)

        local v41 = Color3.fromRGB(190, 80, 255)
        local v42 = p67 * 1.6
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v41
        PointLight.Range = v42 * 0.7
        PointLight.Brightness = 0.45
        PointLight.Shadows = false
        PointLight.Parent = p66
    end,
    Kraken = function(p69, p70, p71) -- Kraken | line: 320
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy), partOf (copy), trail (copy)
        local v43 = Color3.fromRGB(60, 255, 215)

        emitter(p69, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0,
            Rate = 10,
            Color = ColorSequence.new(Color3.fromRGB(20, 40, 60), Color3.fromRGB(0, 5, 15)),
            Size = sizes(p70 * 0.14, p70 * 0.3, p70 * 0.4),
            Transparency = fadeInOut(0.45),
            Lifetime = NumberRange.new(1.6, 2.6),
            Speed = NumberRange.new(0, p70 * 0.05),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-30, 30)
        })
        emitter(p69, {
            Texture = "rbxassetid://242214111",
            LightEmission = 0.7,
            Rate = 16,
            Color = ColorSequence.new(v1, v43),
            Size = sizes(p70 * 0.02, p70 * 0.04, 0),
            Transparency = fadeInOut(0.05),
            Lifetime = NumberRange.new(1.2, 2.2),
            Speed = NumberRange.new(p70 * 0.06, p70 * 0.14),
            Acceleration = Vector3.new(0, p70 * 0.08, 0),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(60, 60)
        })

        for v45, v46 in {
                TentaclesL = { Vector3.new(0.12, 1, -0.51), Vector3.new(1, -0.35, 0.61), Vector3.new(-1, -0.44, 0.5), Vector3.new(-0.06, -0.84, 1), (Vector3.new(0.75, -0.69, -1)) },
                TentaclesR = { Vector3.new(-0.26, 1, -0.84), Vector3.new(1, -0.24, 0.85), Vector3.new(-1, -0.53, 0.46), Vector3.new(0.75, -0.46, 1), (Vector3.new(0.08, 0.86, -1)) }
            } do
            local v47 = partOf(p71, v45)

            if v47 then
                emitter(v47, {
                    Brightness = 2.5,
                    Rate = 10,
                    Color = ColorSequence.new(v43),
                    Size = sizes(0, p70 * 0.035),
                    Transparency = fadeInOut(0),
                    Lifetime = NumberRange.new(0.8, 1.4),
                    Speed = NumberRange.new(0, p70 * 0.03),
                    Rotation = NumberRange.new(0, 360)
                })

                for _, v48 in v46 do
                    trail(v47, v48, v43, p70 * 0.035, 0.55)
                end
            end
        end

        pulse(p69, v43, p70 * 1.2, 1.8)

        local v49 = p70 * 1.4
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v43
        PointLight.Range = v49 * 0.7
        PointLight.Brightness = 0.4
        PointLight.Shadows = false
        PointLight.Parent = p69
    end,
    Mermaid = function(p72, p73, p74) -- Mermaid | line: 340
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy), piece (copy), trail (copy)
        local v50 = Color3.fromRGB(70, 235, 255)
        local v51 = Color3.fromRGB(255, 120, 210)
        local v52 = Color3.fromRGB(255, 240, 250)

        emitter(p72, {
            Texture = "rbxassetid://242214111",
            LightEmission = 0.7,
            Rate = 18,
            Color = ColorSequence.new(v52, v50),
            Size = sizes(p73 * 0.025, p73 * 0.05, 0),
            Transparency = fadeInOut(0.05),
            Lifetime = NumberRange.new(1.4, 2.4),
            Speed = NumberRange.new(p73 * 0.06, p73 * 0.14),
            Acceleration = Vector3.new(0, p73 * 0.07, 0),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(70, 70)
        })
        emitter(p72, {
            Brightness = 2,
            Drag = 1.2,
            Rate = 26,
            Color = ColorSequence.new(v52, v51),
            Size = sizes(0, p73 * 0.09),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.8, 1.4),
            Speed = NumberRange.new(p73 * 0.06, p73 * 0.16),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-120, 120)
        })
        emitter(p72, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0.5,
            Rate = 5,
            Color = ColorSequence.new(Color3.fromRGB(255, 160, 225), Color3.fromRGB(90, 220, 255)),
            Size = sizes(p73 * 0.15, p73 * 0.3, p73 * 0.38),
            Transparency = fadeInOut(0.75),
            Lifetime = NumberRange.new(1.5, 2.5),
            Speed = NumberRange.new(0, p73 * 0.04),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-25, 25)
        })

        local Head__Hair = piece(p74, "Head__Hair")

        if Head__Hair then
            emitter(Head__Hair, {
                Brightness = 2,
                Rate = 8,
                Color = ColorSequence.new(v51),
                Size = sizes(0, p73 * 0.03),
                Transparency = fadeInOut(0),
                Lifetime = NumberRange.new(1, 1.6),
                Speed = NumberRange.new(0, p73 * 0.02),
                Acceleration = Vector3.new(0, p73 * 0.03, 0),
                Rotation = NumberRange.new(0, 360)
            })
        end

        local Head__Crown = piece(p74, "Head__Crown")

        if Head__Crown then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "Crown"
            Attachment.Position = Head__Crown.Size / 2 * Vector3.new(0, 0.85, 0.3)
            Attachment.Parent = Head__Crown
            emitter(Attachment, {
                Texture = "rbxassetid://16956515291",
                LightEmission = 1,
                LockedToPart = true,
                Rate = 3,
                Color = ColorSequence.new(v1, Color3.fromRGB(255, 230, 120)),
                Size = sizes(0, p73 * 0.06),
                Transparency = NumberSequence.new(0, 1),
                Lifetime = NumberRange.new(0.4, 0.7),
                Speed = NumberRange.new(0),
                SpreadAngle = Vector2.new(180, 180),
                Rotation = NumberRange.new(0, 360)
            })
        end

        local ArmR__Trident = piece(p74, "ArmR__Trident")

        if ArmR__Trident then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "TridentTip"
            Attachment.Position = ArmR__Trident.Size / 2 * Vector3.new(0, 0.9, 0.4)
            Attachment.Parent = ArmR__Trident
            emitter(Attachment, {
                Brightness = 3,
                Rate = 22,
                Color = ColorSequence.new(v1, v50),
                Size = sizes(0, p73 * 0.08),
                Transparency = fadeInOut(0),
                Lifetime = NumberRange.new(0.4, 0.8),
                Speed = NumberRange.new(p73 * 0.05, p73 * 0.12),
                SpreadAngle = Vector2.new(180, 180),
                Rotation = NumberRange.new(0, 360)
            })
            emitter(Attachment, {
                Texture = "rbxassetid://16664675233",
                LightEmission = 1,
                Brightness = 3,
                LockedToPart = true,
                Rate = 2,
                Color = ColorSequence.new(Color3.fromRGB(200, 250, 255), v50),
                Size = NumberSequence.new(p73 * 0.2),
                Transparency = NumberSequence.new(0.05, 0.6),
                Lifetime = NumberRange.new(0.2, 0.3),
                Speed = NumberRange.new(0),
                Rotation = NumberRange.new(0, 360)
            })

            for _, v55 in { Vector3.new(-0.03, 1, 0.41), Vector3.new(0.75, 0.95, 0.36), (Vector3.new(-0.75, 0.95, 0.36)) } do
                trail(ArmR__Trident, v55, v50, p73 * 0.035, 0.5)
            end
        end

        local Tail2__Fluke = piece(p74, "Tail2__Fluke")

        trail(Tail2__Fluke, Vector3.new(0.91, 1, -0.53), v51, p73 * 0.05, 0.7)
        trail(Tail2__Fluke, Vector3.new(-1, 0.65, -0.54), v51, p73 * 0.05, 0.7)
        pulse(p72, v50, p73, 2)

        local v56 = Color3.fromRGB(150, 200, 255)
        local v57 = p73 * 1.4
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v56
        PointLight.Range = v57 * 0.7
        PointLight.Brightness = 0.375
        PointLight.Shadows = false
        PointLight.Parent = p72
    end,
    SeaMonster = function(p75, p76, p77) -- SeaMonster | line: 375
        -- upvalues: v1 (copy), emitter (copy), sizes (copy), fadeInOut (copy), pulse (copy), partOf (copy), piece (copy), trail (copy)
        local v58 = Color3.fromRGB(70, 255, 160)
        local v59 = Color3.fromRGB(255, 110, 40)

        emitter(p75, {
            Texture = "rbxassetid://16669188960",
            LightEmission = 0,
            Rate = 9,
            Color = ColorSequence.new(Color3.fromRGB(40, 90, 80), Color3.fromRGB(10, 20, 30)),
            Size = sizes(p76 * 0.16, p76 * 0.32, p76 * 0.42),
            Transparency = fadeInOut(0.5),
            Lifetime = NumberRange.new(1.6, 2.6),
            Speed = NumberRange.new(0, p76 * 0.05),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-30, 30)
        })
        emitter(p75, {
            Texture = "rbxassetid://242214111",
            LightEmission = 0.6,
            Rate = 14,
            Color = ColorSequence.new(v1, v58),
            Size = sizes(p76 * 0.02, p76 * 0.04, 0),
            Transparency = fadeInOut(0.05),
            Lifetime = NumberRange.new(1.2, 2.2),
            Speed = NumberRange.new(p76 * 0.06, p76 * 0.14),
            Acceleration = Vector3.new(0, p76 * 0.08, 0),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(60, 60)
        })
        emitter(p75, {
            Brightness = 2,
            Drag = 1.2,
            Rate = 18,
            Color = ColorSequence.new(Color3.fromRGB(200, 255, 225), v58),
            Size = sizes(0, p76 * 0.05),
            Transparency = fadeInOut(0),
            Lifetime = NumberRange.new(0.8, 1.4),
            Speed = NumberRange.new(p76 * 0.04, p76 * 0.12),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360)
        })

        for _, v61 in { "Head", "Neck" } do
            local v62 = partOf(p77, v61)

            if v62 then
                emitter(v62, {
                    LightEmission = 0.3,
                    Rate = 22,
                    Color = ColorSequence.new(Color3.fromRGB(200, 235, 255)),
                    Size = sizes(p76 * 0.012, p76 * 0.01, p76 * 0.004),
                    Transparency = NumberSequence.new(0.2, 0.8),
                    Lifetime = NumberRange.new(0.7, 1.1),
                    Speed = NumberRange.new(0, p76 * 0.01),
                    Acceleration = Vector3.new(0, -p76 * 1.2, 0),
                    Shape = Enum.ParticleEmitterShape.Box,
                    ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                })
            end
        end

        local v64 = piece(p77, "Head__Glow") or partOf(p77, "Head")

        if v64 then
            emitter(v64, {
                Texture = "rbxassetid://16676544947",
                Brightness = 2,
                Rate = 10,
                Color = ColorSequence.new(Color3.fromRGB(255, 220, 120), v59),
                Size = sizes(p76 * 0.03, p76 * 0.05, 0),
                Transparency = NumberSequence.new(0.3, 1),
                Lifetime = NumberRange.new(0.4, 0.7),
                Speed = NumberRange.new(p76 * 0.02, p76 * 0.05),
                Acceleration = Vector3.new(0, p76 * 0.1, 0),
                Rotation = NumberRange.new(0, 360)
            })
            emitter(v64, {
                Brightness = 2.5,
                Rate = 8,
                Color = ColorSequence.new(v59, Color3.fromRGB(255, 220, 120)),
                Size = sizes(p76 * 0.015, p76 * 0.02, 0),
                Transparency = fadeInOut(0),
                Lifetime = NumberRange.new(0.6, 1.1),
                Speed = NumberRange.new(p76 * 0.03, p76 * 0.08),
                SpreadAngle = Vector2.new(180, 180),
                Acceleration = Vector3.new(0, p76 * 0.12, 0)
            })
        end

        trail(partOf(p77, "Tail"), Vector3.new(0.6, 0, -1), v58, p76 * 0.06, 0.6)
        pulse(p75, v58, p76 * 1.1, 2)

        local v67 = p76 * 1.4
        local PointLight = Instance.new("PointLight")

        PointLight.Name = "LookLight"
        PointLight.Color = v58
        PointLight.Range = v67 * 0.7
        PointLight.Brightness = 0.375
        PointLight.Shadows = false
        PointLight.Parent = p75
    end
}
local Index = Config.RarityByName.Celestial.Index

function t1.decorate(p78, p79, p80) -- line: 405
    -- upvalues: Config (copy), Animals (copy), t4 (copy), t5 (copy), t9 (copy), Index (copy)
    if not p79 then
        return
    end

    local Mutation = p78:GetAttribute("Mutation")
    local v68 = Mutation and t4[Mutation]

    if v68 then
        v68(p79, p80)
    end

    local v69 = Animals.get(p78:GetAttribute("Species") or "")
    local v70 = v69 and v69.Exclusive and t9[v69.Id]

    if v70 then
        v70(p79, p80, p78)
    else
        local Vfx = v69

        if v69 then
            Vfx = v69.Vfx

            if Vfx then
                Vfx = v69.RarityIndex < Index and t5[v69.Biome]
            end
        end

        if Vfx then
            local Color = Config.RarityByName[v69.Rarity].Color

            Vfx(p79, p80, Color)

            local v71 = p80 * 1.4
            local PointLight = Instance.new("PointLight")

            PointLight.Name = "LookLight"
            PointLight.Color = Color
            PointLight.Range = v71 * 0.7
            PointLight.Brightness = 0.3
            PointLight.Shadows = false
            PointLight.Parent = p79
        end
    end
end

function t1.rainbowParts(p81) -- line: 429
    if p81:GetAttribute("Mutation") ~= "Rainbow" then
        return nil
    end

    local t20 = {}

    for _, descendant in p81:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t20, {
                part = descendant,
                hue = descendant.Color:ToHSV()
            })
        end
    end

    return t20
end

function t1.cycleRainbow(p82, p83) -- line: 443
    for _, v72 in p82 do
        v72.part.Color = Color3.fromHSV((v72.hue + p83 * 0.2) % 1, 0.75, 0.85)
    end
end

return t1
