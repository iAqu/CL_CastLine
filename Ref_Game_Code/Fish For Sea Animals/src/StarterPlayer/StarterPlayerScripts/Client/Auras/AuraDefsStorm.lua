-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local AuraThemes = require(script.Parent.AuraThemes)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new, new2 = Color3.fromRGB, NumberRange.new, Vector3.new
local cs = AuraKit.cs
local t1 = {}

local function rain(p1, p2) -- line: 20
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), new (copy), cs (copy)
    local size = p1.size

    AuraKit.fall(p1, T.DROPS, {
        LightEmission = 0.2,
        Color = cs(fromRGB(170, 210, 240)),
        Size = NumberSequence.new(size * 0.07),
        RotSpeed = new(0),
        Rotation = new(0),
        Rate = p2
    })
end

t1.SquallSquid = function(p3) -- line: 28
    -- upvalues: AuraKit (copy), AuraThemes (copy), fromRGB (copy), cs (copy)
    local size = p3.size

    AuraThemes.voidSmoke(p3, fromRGB(70, 35, 110), fromRGB(10, 5, 20))
    AuraKit.crackle(p3, {
        Rate = 5,
        Color = cs(fromRGB(200, 130, 255))
    })
    AuraKit.light(p3, AuraThemes.VOID, 1.2, size * 2, 0.5, 6)
end

t1.VoidBarracuda = function(p4) -- line: 36
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
    local size = p4.size

    AuraKit.engulf(p4, T.DARK_CLOUD, {
        LightEmission = 0,
        Color = cs(fromRGB(60, 45, 80), fromRGB(8, 5, 15)),
        Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
        Acceleration = new2(0, size * 0.08, 0)
    })
    AuraKit.twinkle(p4, T.SPECK, {
        Rate = 8,
        Color = cs(fromRGB(210, 150, 255))
    })
    AuraKit.light(p4, AuraThemes.VOID, 1.1, size * 1.8)
end

t1.StormKraken = function(p5) -- line: 46
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy), rain (copy)
    AuraThemes.tempest(p5, fromRGB(150, 230, 255))
    AuraKit.crackle(p5, {
        Rate = 3,
        texture = T.BOLT,
        Color = cs(fromRGB(220, 245, 255))
    })
    rain(p5, 8)
    AuraThemes.ring(p5, 4, T.ELECTRIC_RING, AuraThemes.STORM)
end

t1.WhirlpoolSerpent = function(p6) -- line: 54
    -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
    local size = p6.size

    AuraKit.swirl(p6, T.WIND_SWIRL, {
        Rate = 4,
        Color = cs(fromRGB(150, 220, 255))
    })
    AuraKit.swirl(p6, T.WIND_ARC, {
        LightEmission = 0.4,
        Rate = 3,
        Color = cs(fromRGB(220, 245, 255)),
        Transparency = seq(0, 1, 0.3, 0.55, 1, 1)
    })
    AuraKit.ground(p6, T.SPLASH, {
        LightEmission = 0.2,
        Rate = 6,
        Color = cs(fromRGB(230, 248, 255)),
        Size = seq(0, size * 0.1, 1, size * 0.05)
    })
    AuraKit.light(p6, fromRGB(120, 200, 255), 1.1, size * 2)
end

t1.LighthouseAngler = function(p7) -- line: 63
    -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
    local size = p7.size

    AuraKit.halo(p7, T.SOFT_GLOW, {
        Color = cs(fromRGB(255, 230, 150))
    })
    AuraKit.orbit(p7, T.SPARKLE, {
        count = 1,
        speed = 2.2,
        radius = 0.3,
        y = 0.4,
        headSize = 0.18,
        head = T.GLOW
    }, {
        Color = cs(fromRGB(255, 240, 180)),
        Size = NumberSequence.new(size * 0.05)
    })
    AuraKit.swirl(p7, T.RAYS, {
        Rate = 2,
        Color = cs(fromRGB(255, 235, 170)),
        Transparency = seq(0, 1, 0.3, 0.75, 1, 1),
        RotSpeed = new(60, 90)
    })
    AuraKit.light(p7, fromRGB(255, 220, 140), 1.3, size * 2.2)
end

t1.RadiantStingray = function(p8) -- line: 74
    -- upvalues: AuraThemes (copy)
    AuraThemes.radiant(p8, 1)
end

t1.RadiantSeal = function(p9) -- line: 79
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), cs (copy)
    local size = p9.size

    AuraThemes.radiant(p9, 1)
    AuraKit.rise(p9, T.SPARKLE, {
        Rate = 6,
        Color = cs(AuraThemes.PALE_GOLD, AuraThemes.GOLD),
        Size = seq(0, 0, 0.15, size * 0.07, 1, 0)
    })
end

t1.RadiantOrca = function(p10) -- line: 86
    -- upvalues: AuraThemes (copy)
    AuraThemes.radiant(p10, 2)
end

t1.ThunderShark = function(p11) -- line: 93
    -- upvalues: AuraThemes (copy), T (copy)
    AuraThemes.tempest(p11)
    AuraThemes.ring(p11, 3, T.ELECTRIC_RING, AuraThemes.STORM)
end

t1.StormMegalodon = function(p12) -- line: 99
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy), rain (copy)
    AuraThemes.tempest(p12)
    AuraKit.crackle(p12, {
        Rate = 2,
        texture = T.BIG_BOLT,
        Color = cs(fromRGB(200, 240, 255))
    })
    rain(p12, 8)
end

t1.LightningEel = function(p13) -- line: 106
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
    local size = p13.size

    AuraThemes.tempest(p13, fromRGB(150, 235, 255))
    AuraKit.crackle(p13, {
        Rate = 4,
        texture = T.BOLT,
        Color = cs(fromRGB(230, 250, 255))
    })
    AuraKit.rise(p13, T.SPECS, {
        Rate = 6,
        Color = cs(AuraThemes.STORM),
        Size = seq(0, size * 0.05, 1, 0)
    })
end

t1.CloudWhale = function(p14) -- line: 114
    -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), rain (copy)
    local size = p14.size

    AuraThemes.tempest(p14)
    rain(p14, 12)
    AuraKit.rise(p14, T.CLOUD, {
        LightEmission = 0,
        LightInfluence = 0.6,
        Rate = 3,
        Color = cs(fromRGB(150, 160, 180)),
        Size = seq(0, size * 0.12, 1, size * 0.3),
        Transparency = seq(0, 0.6, 1, 1)
    })
end

return t1
