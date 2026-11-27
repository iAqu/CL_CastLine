-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraTextures = require(script.Parent.AuraTextures)
local Vfx = require(script.Parent.Vfx)
local t1 = {
    T = AuraTextures.T
}
local T = t1.T
local GRID, ON_BLACK, ICON = AuraTextures.GRID, AuraTextures.ON_BLACK, AuraTextures.ICON

t1.seq = Vfx.seq

local seq = Vfx.seq
local new, new2 = NumberRange.new, Vector3.new

function t1.cs(...) -- line: 81
    local t2 = { ... }

    if #t2 == 1 then
        return ColorSequence.new(t2[1])
    end

    local t3 = {}

    for v1, v2 in t2 do
        table.insert(t3, ColorSequenceKeypoint.new((v1 - 1) / (#t2 - 1), v2))
    end

    return ColorSequence.new(t3)
end

local function merge(p1, p2) -- line: 94
    if not p2 then
        return p1
    end

    for v4, v5 in p2 do
        p1[v4] = v5
    end

    return p1
end

local function take(p3, p4, p5) -- line: 104
    local v6 = p3[p4]

    p3[p4] = nil

    if v6 == nil then
        return p5
    end

    return v6
end

local function colorOf(p6) -- line: 111
    if typeof(p6.Color) == "Color3" then
        p6.Color = ColorSequence.new(p6.Color)
    end
end

local function track(p7, p8) -- line: 117
    table.insert(p7.aura.parts, p8)
end

local function mapSeq(p9, p10) -- line: 123
    local t4 = {}

    for _, v7 in p9.Keypoints do
        table.insert(t4, NumberSequenceKeypoint.new(v7.Time, p10(v7.Value), v7.Envelope))
    end

    return NumberSequence.new(t4)
end

function t1.emit(p11, p12, p13) -- line: 131
    -- upvalues: Vfx (copy), GRID (copy), ON_BLACK (copy), ICON (copy), mapSeq (copy)
    if typeof(p13.Color) == "Color3" then
        p13.Color = ColorSequence.new(p13.Color)
    end

    if ICON[p12] then
        p13.Size = mapSeq(p13.Size or NumberSequence.new(1), function(p14) -- line: 134
            return p14 * 0.7
        end)
        p13.Transparency = mapSeq(p13.Transparency or NumberSequence.new(0), function(p15) -- line: 137
            return 1 - (1 - p15) * 0.65
        end)

        if p13.Rate then
            p13.Rate *= 0.55
        end
    end

    local v10 = GRID[p12]

    if v10 and p13.FlipbookLayout == nil then
        p13.FlipbookLayout = v10

        local FlipbookMode = p13.FlipbookMode

        if not FlipbookMode then
            FlipbookMode = if v10 == Enum.ParticleFlipbookLayout.Grid2x2 then Enum.ParticleFlipbookMode.Random else Enum.ParticleFlipbookMode.OneShot
        end

        p13.FlipbookMode = FlipbookMode
    end

    if ON_BLACK[p12] then
        p13.LightEmission = 1
    elseif p13.LightEmission == nil then
        p13.LightEmission = 0.35
    end

    p13.Brightness = (p13.Brightness or 1) * 0.45

    return Vfx.emitter(p11, p12, p13)
end

function t1.attach(p16, p17, p18) -- line: 158
    local Attachment = Instance.new("Attachment")

    Attachment.Name = p18 or "Attachment"
    Attachment.Position = p17
    Attachment.Parent = p16

    return Attachment
end

function t1.mover(p19, p20, p21) -- line: 168
    -- upvalues: Vfx (copy)
    local v11

    if p21 then
        v11 = p21
    else
        v11 = Vfx.holder(CFrame.identity, (Vector3.new(0.2, 0.2, 0.2)))
        table.insert(p19.aura.parts, v11)
    end

    table.insert(p19.aura.movers, {
        part = v11,
        update = p20
    })

    return v11
end

function t1.zone(p22, p23, p24) -- line: 179
    -- upvalues: Vfx (copy), t1 (copy)
    local v12 = Vfx.holder(CFrame.identity, p23)

    table.insert(p22.aura.parts, v12)

    local v13 = p24 or Vector3.new(0, 0, 0)

    t1.mover(p22, function(p25, p26) -- line: 183
        -- upvalues: v13 (copy)
        p25.CFrame = CFrame.new(p26.Position + v13)
    end, v12)

    return v12
end

function t1.point(p27, p28) -- line: 190
    -- upvalues: t1 (copy)
    return t1.attach(p27.body, p28)
end

function t1.every(p29, p30, p31, p32) -- line: 196
    table.insert(p29.aura.tickers, {
        nextAt = -1,
        period = p30,
        jitter = p32 or 0.25,
        fire = p31
    })
end

local function onBits(p33, p34, p35, p36, p37, p38) -- line: 202
    -- upvalues: t1 (copy)
    local v14 = p35.Rate or 10
    local t7 = {}

    for v15, v16 in p33.bits do
        local v17 = table.clone(p35)

        v17.Rate = v14 * p33.shares[v15]

        if p36 then
            local v25 = math.clamp((v16.Size.X + v16.Size.Y + v16.Size.Z) / 3, p33.size * p37, (math.max(p33.size * p37, (math.min(p33.size * p38, p33.height * 0.75)))))
            local t8 = {}

            for i = 1, #p36, 2 do
                table.insert(t8, NumberSequenceKeypoint.new(p36[i], v25 * p36[i + 1]))
            end

            v17.Size = NumberSequence.new(t8)
        end

        local v28 = t1.emit(v16, p34, v17)

        table.insert(t7, v28)

        if v16 ~= p33.body then
            table.insert(p33.aura.emitters, v28)
        end
    end

    return t7
end

local Box = Enum.ParticleEmitterShape.Box
local Volume = Enum.ParticleEmitterShapeStyle.Volume

function t1.engulf(p39, p40, p41) -- line: 232
    -- upvalues: ON_BLACK (copy), seq (copy), new (copy), new2 (copy), mapSeq (copy), onBits (copy), Box (copy), Volume (copy)
    local t9 = {
        LockedToPart = true,
        ZOffset = -0.5,
        LightEmission = 0.6,
        LightInfluence = 0,
        Brightness = 3,
        Rate = p39.k * 50,
        Transparency = seq(0, 1, 0.2, 0.05, 0.7, 0.25, 1, 1),
        Lifetime = new(0.8, 1.1),
        Speed = new(0.01),
        Rotation = new(-360, 360),
        Acceleration = new2(0, p39.size * 0.45, 0),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p41 then
        for v30, v31 in p41 do
            t9[v30] = v31
        end
    end

    local scale = t9.scale

    t9.scale = nil

    if scale == nil then
        scale = 1
    end

    local v32 = scale * 0.8
    local clone = table.clone
    local v33 = {
        0, 0.9, 0.5, 1.35, 1, 1
    }
    local sizes = t9.sizes

    t9.sizes = nil

    if sizes ~= nil then
        v33 = sizes
    end

    local v34 = clone(v33)

    for i = 2, #v34, 2 do
        v34[i] *= v32
    end

    t9.Rate *= 0.45
    t9.Transparency = mapSeq(t9.Transparency, function(p42) -- line: 254
        return 1 - (1 - p42) * 0.6
    end)

    if not ON_BLACK[p40] then
        t9.LightEmission *= 0.5
    end

    return (onBits(p39, p40, t9, v34, 0.2, 0.5))
end

function t1.twinkle(p43, p44, p45) -- line: 264
    -- upvalues: seq (copy), new (copy), onBits (copy), Box (copy), Volume (copy)
    local size = p43.size
    local t10 = {
        LockedToPart = true,
        ZOffset = 1.5,
        LightEmission = 0.7,
        LightInfluence = 0,
        Brightness = 3,
        Rate = p43.k * 11,
        Size = seq(0, 0, 0.35, size * 0.17, 1, 0),
        Lifetime = new(0.5, 0.9),
        Speed = new(0.01),
        Rotation = new(-180, 180),
        RotSpeed = new(-90, 90),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p45 then
        for v35, v36 in p45 do
            t10[v35] = v36
        end
    end

    return (onBits(p43, p44, t10, nil, 0, 0))
end

function t1.crackle(p46, p47) -- line: 285
    -- upvalues: T (copy), new (copy), onBits (copy), Box (copy), Volume (copy)
    local size = p46.size
    local t11 = {
        LockedToPart = true,
        ZOffset = 2,
        LightEmission = 1,
        LightInfluence = 0,
        Brightness = 5,
        Rate = p46.k * 7,
        Size = NumberSequence.new(size * 0.45),
        Lifetime = new(0.22, 0.35),
        Speed = new(0.01),
        Rotation = new(-180, 180),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p47 then
        for v37, v38 in p47 do
            t11[v37] = v38
        end
    end

    local LIGHTNING = T.LIGHTNING
    local texture = t11.texture

    t11.texture = nil

    if texture ~= nil then
        LIGHTNING = texture
    end

    return (onBits(p46, LIGHTNING, t11, nil, 0, 0))
end

function t1.rise(p48, p49, p50) -- line: 306
    -- upvalues: t1 (copy), seq (copy), new (copy), new2 (copy), Box (copy), Volume (copy)
    local size = p48.size
    local t12 = {
        Drag = 0.6,
        LightEmission = 0.15,
        LightInfluence = 0,
        ZOffset = 1,
        Rate = p48.k * 5.5,
        Size = seq(0, 0, 0.12, size * 0.2, 0.85, size * 0.18, 1, 0),
        Transparency = seq(0, 0, 0.75, 0.1, 1, 1),
        Lifetime = new(1.4, 2.2),
        Speed = new(size * 0.25, size * 0.5),
        Acceleration = new2(0, size * 0.2, 0),
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(25, 25),
        Rotation = new(-25, 25),
        RotSpeed = new(-40, 40),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p50 then
        for v40, v41 in p50 do
            t12[v40] = v41
        end
    end

    local wide = t12.wide

    t12.wide = nil

    if wide == nil then
        wide = 1.25
    end

    local v47 = t1.zone(p48, new2(p48.width * wide + size * 0.15, p48.height * 0.8, p48.length * wide + size * 0.15), (new2(0, -p48.height * 0.05, 0)))

    return t1.emit(v47, p49, t12)
end

function t1.fall(p51, p52, p53) -- line: 332
    -- upvalues: t1 (copy), seq (copy), new (copy), new2 (copy), Box (copy), Volume (copy)
    local size = p51.size
    local v48 = p51.height + size * 0.35
    local v49 = size * 0.42
    local t13 = {
        LightEmission = 0.15,
        LightInfluence = 0,
        Rate = p51.k * 6,
        Size = NumberSequence.new(size * 0.13),
        Transparency = seq(0, 1, 0.12, 0.05, 0.8, 0.1, 1, 1),
        Lifetime = new(v48 / v49 * 0.9, v48 / v49 * 1.05),
        Speed = new(v49 * 0.85, v49 * 1.15),
        EmissionDirection = Enum.NormalId.Bottom,
        SpreadAngle = Vector2.new(12, 12),
        Rotation = new(-180, 180),
        RotSpeed = new(-60, 60),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p53 then
        for v50, v51 in p53 do
            t13[v50] = v51
        end
    end

    local wide = t13.wide

    t13.wide = nil

    if wide == nil then
        wide = 1.6
    end

    local v56 = t1.zone(p51, new2(p51.width * wide + size * 0.3, 0.2, p51.length * wide + size * 0.3), (new2(0, p51.height / 2 + size * 0.35, 0)))

    return t1.emit(v56, p52, t13)
end

function t1.ground(p54, p55, p56) -- line: 357
    -- upvalues: t1 (copy), seq (copy), new (copy), new2 (copy), Box (copy), Volume (copy)
    local size = p54.size
    local t14 = {
        LightEmission = 0.3,
        LightInfluence = 0,
        Rate = p54.k * 10,
        Size = seq(0, size * 0.12, 1, size * 0.04),
        Transparency = seq(0, 0.1, 0.7, 0.2, 1, 1),
        Lifetime = new(0.6, 1),
        Speed = new(size * 0.4, size * 0.9),
        Acceleration = new2(0, -size * 0.8, 0),
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(35, 35),
        Rotation = new(-180, 180),
        RotSpeed = new(-120, 120),
        Shape = Box,
        ShapeStyle = Volume
    }

    if p56 then
        for v58, v59 in p56 do
            t14[v58] = v59
        end
    end

    local wide = t14.wide

    t14.wide = nil

    if wide == nil then
        wide = 1.3
    end

    local v64 = t1.zone(p54, new2(p54.width * wide + size * 0.2, 0.1, p54.length * wide + size * 0.2), (new2(0, -p54.height / 2 + 0.05, 0)))

    return t1.emit(v64, p55, t14)
end

function t1.halo(p57, p58, p59) -- line: 381
    -- upvalues: t1 (copy), seq (copy), new (copy)
    local size = p57.size
    local t15 = {
        Rate = 2.5,
        LockedToPart = true,
        ZOffset = -3,
        LightEmission = 0.7,
        LightInfluence = 0,
        Brightness = 1.5,
        Size = seq(0, size * 0.7, 0.5, size * 0.85, 1, size * 0.8),
        Transparency = seq(0, 1, 0.5, 0.88, 1, 1),
        Lifetime = new(1.6),
        Speed = new(0),
        Rotation = new(-180, 180),
        RotSpeed = new(-15, 15)
    }

    if p59 then
        for v65, v66 in p59 do
            t15[v65] = v66
        end
    end

    return t1.emit(p57.center, p58, t15)
end

function t1.swirl(p60, p61, p62) -- line: 401
    -- upvalues: t1 (copy), seq (copy), new (copy)
    local size = p60.size
    local t16 = {
        LockedToPart = true,
        ZOffset = -0.5,
        LightEmission = 0.8,
        LightInfluence = 0,
        Brightness = 1.5,
        Rate = p60.k * 3.5,
        Size = seq(0, size * 0.65, 1, size * 0.9),
        Transparency = seq(0, 1, 0.3, 0.55, 1, 1),
        Lifetime = new(0.6, 0.9),
        Speed = new(0),
        Rotation = new(-180, 180),
        RotSpeed = new(260, 360)
    }

    if p62 then
        for v67, v68 in p62 do
            t16[v67] = v68
        end
    end

    return t1.emit(p60.center, p61, t16)
end

function t1.orbit(p63, p64, p65, p66) -- line: 423
    -- upvalues: t1 (copy), T (copy), seq (copy), new (copy)
    local size = p63.size
    local v70 = (p65.radius or 0.62) * math.max(p63.width, p63.length) + size * 0.15
    local v71 = (p65.y or 0) * p63.height
    local v72 = p65.tilt or CFrame.identity
    local t17 = {}

    for i = 1, p65.count do
        local v73 = (i - 1) / p65.count * 2 * 3.141592653589793
        local v74 = t1.mover(p63, function(p67, p68, p69) -- line: 436
            -- upvalues: p65 (copy), v70 (copy), v71 (copy), v73 (copy), v72 (copy)
            p67.CFrame = CFrame.new(p68.Position) * v72 * CFrame.Angles(0, v73 + p69 * p65.speed, 0) * CFrame.new(v70, v71, 0)
        end)
        local t18 = {
            Rate = 28,
            LightEmission = 0.7,
            LightInfluence = 0,
            Brightness = 2,
            Size = seq(0, size * 0.09, 1, 0),
            Transparency = seq(0, 0.1, 1, 1),
            Lifetime = new(0.45, 0.65),
            Speed = new(0.01),
            Rotation = new(-180, 180)
        }
        local v75 = if p66 then table.clone(p66) else nil

        if v75 then
            for v76, v77 in v75 do
                t18[v76] = v77
            end
        end

        t1.emit(v74, p64, t18)

        if p65.head ~= "" then
            t1.emit(v74, p65.head or T.GLOW, {
                Rate = 12,
                LockedToPart = true,
                LightEmission = 1,
                LightInfluence = 0,
                Brightness = 2,
                Color = t18.Color,
                Size = NumberSequence.new(size * (p65.headSize or 0.16)),
                Transparency = seq(0, 0.4, 1, 1),
                Lifetime = new(0.25),
                Speed = new(0)
            })
        end

        table.insert(t17, v74)
    end

    return t17
end

function t1.pulse(p70, p71, p72, p73, p74) -- line: 471
    -- upvalues: t1 (copy), ICON (copy), seq (copy), new (copy)
    local size = p70.size
    local t19 = {
        Drag = 3,
        LightEmission = 0.4,
        LightInfluence = 0,
        ZOffset = 1,
        Size = seq(0, 0, 0.15, size * 0.15, 1, 0),
        Transparency = seq(0, 0, 0.7, 0.1, 1, 1),
        Lifetime = new(0.6, 1),
        Speed = new(size * 0.9, size * 1.5),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = new(-180, 180),
        RotSpeed = new(-90, 90)
    }

    if p74 then
        for v78, v79 in p74 do
            t19[v78] = v79
        end
    end

    local v80 = t1.emit(p70.center, p73, t19)

    t1.every(p70, p71, function() -- line: 487
        -- upvalues: p72 (copy), p73 (copy), v80 (copy), ICON (copy)
        v80:Emit(if ICON[p73] then math.max(1, (math.round(p72 * 0.55))) else p72)
    end)

    return v80
end

function t1.light(p75, p76, p77, p78, p79, p80) -- line: 494
    -- upvalues: t1 (copy)
    local v84 = p77
    local v85 = p77 * 0.35

    v84 = v85

    local v86 = p78 * 0.55
    local PointLight = Instance.new("PointLight")

    PointLight.Color = p76
    PointLight.Brightness = v85
    PointLight.Range = v86
    PointLight.Shadows = false
    PointLight.Parent = p75.body

    if p79 then
        t1.mover(p75, function(_, _, p83) -- line: 506
            -- upvalues: v84 (ref), p79 (copy), p80 (copy), PointLight (copy)
            PointLight.Brightness = v84 * (1 - p79 + p79 * (math.sin(p83 * (p80 or 2)) * 0.5 + 0.5))
        end)
    end

    return PointLight
end

return t1
