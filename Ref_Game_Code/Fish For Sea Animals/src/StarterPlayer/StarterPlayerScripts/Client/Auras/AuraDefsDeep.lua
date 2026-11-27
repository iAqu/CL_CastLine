-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new, new2 = Color3.fromRGB, NumberRange.new, Vector3.new
local cs = AuraKit.cs

return {
    VoidAngler = function(p1) -- line: 21
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p1.size

        AuraKit.engulf(p1, T.GHOST_SMOKE, {
            LightEmission = 0.15,
            Color = cs(fromRGB(110, 50, 190), fromRGB(15, 5, 30)),
            Transparency = seq(0, 1, 0.25, 0.3, 0.7, 0.5, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.orbit(p1, T.SPARKLES, {
            count = 1,
            speed = 2,
            radius = 0.35,
            y = 0.45,
            headSize = 0.2,
            head = T.GLOW
        }, {
            Color = cs(fromRGB(230, 200, 255), fromRGB(140, 60, 255)),
            Size = NumberSequence.new(size * 0.06)
        })
        AuraKit.twinkle(p1, T.SPECK, {
            Rate = 10,
            Color = cs(fromRGB(200, 140, 255))
        })
        AuraKit.light(p1, fromRGB(150, 70, 255), 1.4, size * 2)
    end,
    ShadowShark = function(p2) -- line: 30
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p2.size

        AuraKit.engulf(p2, T.DARK_CLOUD, {
            LightEmission = 0,
            Color = cs(fromRGB(50, 40, 60), fromRGB(5, 5, 10)),
            Transparency = seq(0, 1, 0.25, 0.3, 0.7, 0.5, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.crackle(p2, {
            Rate = 5,
            Color = cs(fromRGB(190, 110, 255))
        })
        AuraKit.rise(p2, T.SKULL, {
            Rate = 3,
            Color = cs(fromRGB(200, 160, 255))
        })
        AuraKit.light(p2, fromRGB(160, 80, 255), 1.3, size * 2, 0.3, 2.5)
    end,
    AbyssalRay = function(p3) -- line: 39
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p3.size

        AuraKit.engulf(p3, T.GHOST_SMOKE, {
            LightEmission = 0.25,
            Color = cs(fromRGB(60, 80, 220), fromRGB(10, 10, 50)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.swirl(p3, T.ARC, {
            Rate = 3.5,
            Color = cs(fromRGB(170, 110, 255))
        })
        AuraKit.twinkle(p3, T.SPARKLE, {
            Color = cs(fromRGB(140, 170, 255))
        })
        AuraKit.light(p3, fromRGB(90, 100, 255), 1.4, size * 2.2)
    end,
    AbyssWatcher = function(p4) -- line: 48
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p4.size

        AuraKit.halo(p4, T.SOFT_GLOW, {
            Color = cs(fromRGB(120, 40, 200))
        })
        AuraKit.engulf(p4, T.FLAME_EYE, {
            LightEmission = 0.7,
            scale = 0.8,
            Color = cs(fromRGB(220, 150, 255), fromRGB(130, 40, 255)),
            Rate = 18 * p4.k
        })
        AuraKit.engulf(p4, T.GHOST_SMOKE, {
            LightEmission = 0,
            Color = cs(fromRGB(60, 20, 100), fromRGB(10, 0, 20)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Rate = 25 * p4.k
        })
        AuraKit.crackle(p4, {
            Rate = 4,
            Color = cs(fromRGB(200, 120, 255))
        })
        AuraKit.light(p4, fromRGB(170, 70, 255), 1.5, size * 2.2, 0.4, 2)
    end,
    CinderSquid = function(p5) -- line: 58
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p5.size

        AuraKit.engulf(p5, T.FIRE2, {
            scale = 0.85,
            Color = cs(fromRGB(255, 150, 70), fromRGB(200, 30, 20), fromRGB(40, 10, 10))
        })
        AuraKit.fall(p5, T.ASH, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 6,
            Color = cs(fromRGB(90, 80, 80)),
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.rise(p5, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 10,
            Color = cs(fromRGB(255, 150, 60)),
            Size = seq(0, size * 0.06, 1, 0)
        })
        AuraKit.light(p5, fromRGB(255, 80, 40), 1.4, size * 2.2, 0.4, 3)
    end,
    SmokeShark = function(p6) -- line: 67
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p6.size

        AuraKit.engulf(p6, T.GHOST_SMOKE, {
            LightEmission = 0,
            Color = cs(fromRGB(150, 145, 140), fromRGB(60, 55, 55)),
            Transparency = seq(0, 1, 0.25, 0.3, 0.7, 0.5, 1, 1),
            Acceleration = new2(0, size * 0.15, 0)
        })
        AuraKit.twinkle(p6, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 12,
            Color = cs(fromRGB(255, 160, 60))
        })
        AuraKit.rise(p6, T.SMOKE, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 5,
            Color = cs(fromRGB(120, 115, 110)),
            Size = seq(0, size * 0.1, 1, size * 0.3),
            Transparency = seq(0, 0.5, 1, 1)
        })
        AuraKit.light(p6, fromRGB(255, 140, 60), 1.1, size * 1.8, 0.4, 3)
    end,
    EmberManta = function(p7) -- line: 76
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p7.size

        AuraKit.engulf(p7, T.FIRE3, {
            scale = 0.85,
            Color = cs(fromRGB(255, 230, 130), fromRGB(255, 120, 30), fromRGB(180, 30, 10))
        })
        AuraKit.rise(p7, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 12,
            Color = cs(fromRGB(255, 190, 80)),
            Size = seq(0, size * 0.06, 1, 0)
        })
        AuraKit.swirl(p7, T.WIND_ARC, {
            LightEmission = 0.6,
            Rate = 4,
            Color = cs(fromRGB(255, 150, 60)),
            Transparency = seq(0, 1, 0.3, 0.45, 1, 1)
        })
        AuraKit.light(p7, fromRGB(255, 130, 40), 1.5, size * 2.2, 0.4, 3)
    end,
    MagmaSerpent = function(p8) -- line: 87
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p8.size

        AuraKit.engulf(p8, T.FIRE_BIG, {
            scale = 0.7,
            Color = cs(fromRGB(255, 235, 140), fromRGB(255, 110, 20), fromRGB(150, 20, 0)),
            Rate = 35 * p8.k
        })
        AuraKit.orbit(p8, T.FIRE_SPECS, {
            count = 3,
            speed = 1.6,
            y = 0.15,
            headSize = 0.12,
            head = T.FIREBALL
        }, {
            LightEmission = 1,
            Color = cs(fromRGB(255, 210, 90), fromRGB(255, 80, 20))
        })
        AuraKit.crackle(p8, {
            Rate = 5,
            Color = cs(fromRGB(255, 170, 60))
        })
        AuraKit.pulse(p8, 3, 1, T.SOFT_RING, {
            Drag = 0,
            Color = cs(fromRGB(255, 160, 70)),
            Size = seq(0, size * 0.4, 1, size * 1.6),
            Transparency = seq(0, 0.3, 1, 1),
            Speed = new(0),
            Lifetime = new(0.7),
            Rotation = new(0),
            RotSpeed = new(0)
        })
        AuraKit.light(p8, fromRGB(255, 120, 30), 1.8, size * 2.4, 0.4, 3)
    end,
    GoldenKoi = function(p9) -- line: 97
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p9.size

        AuraKit.halo(p9, T.GLOW, {
            Color = cs(fromRGB(255, 225, 120))
        })
        AuraKit.engulf(p9, T.SSJ, {
            Color = cs(fromRGB(255, 250, 200), fromRGB(255, 200, 60)),
            Rate = 26 * p9.k
        })
        AuraKit.rise(p9, T.SPIN_COIN, {
            LightEmission = 0.3,
            Rate = 6,
            Color = cs(fromRGB(255, 225, 100)),
            Size = seq(0, 0, 0.12, size * 0.14, 0.85, size * 0.13, 1, 0)
        })
        AuraKit.orbit(p9, T.SPARKLES, {
            count = 2,
            speed = 1.5,
            y = 0.1,
            tilt = CFrame.Angles(0.3, 0, 0.2)
        }, {
            Color = cs(fromRGB(255, 240, 160), fromRGB(255, 190, 50)),
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.twinkle(p9, T.SHINE, {
            Color = cs(fromRGB(255, 245, 190))
        })
        AuraKit.light(p9, fromRGB(255, 210, 90), 1.8, size * 2.4, 0.3, 2)
    end,
    EclipseWhale = function(p10) -- line: 108
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), new2 (copy), cs (copy)
        local size = p10.size

        AuraKit.halo(p10, T.AURA, {
            Color = cs(fromRGB(255, 210, 110))
        })
        AuraKit.engulf(p10, T.DARK_CLOUD, {
            LightEmission = 0,
            Color = cs(fromRGB(40, 35, 45), fromRGB(5, 5, 8)),
            Transparency = seq(0, 1, 0.25, 0.3, 0.7, 0.5, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.swirl(p10, T.ARC, {
            Rate = 4,
            Color = cs(fromRGB(255, 210, 110))
        })
        AuraKit.twinkle(p10, T.STAR, {
            Rate = 10,
            Color = cs(fromRGB(255, 240, 200))
        })
        AuraKit.pulse(p10, 3.5, 1, T.SOFT_RING, {
            Drag = 0,
            Color = cs(fromRGB(255, 220, 140)),
            Size = seq(0, size * 0.4, 1, size * 1.6),
            Transparency = seq(0, 0.3, 1, 1),
            Speed = new(0),
            Lifetime = new(0.8),
            Rotation = new(0),
            RotSpeed = new(0)
        })
        AuraKit.light(p10, fromRGB(255, 200, 100), 1.6, size * 2.4, 0.3, 1.5)
    end
}
