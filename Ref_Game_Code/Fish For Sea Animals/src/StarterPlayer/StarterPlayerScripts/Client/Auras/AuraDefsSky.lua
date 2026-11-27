-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new, new2 = Color3.fromRGB, NumberRange.new, Vector3.new
local cs = AuraKit.cs

return {
    StarlightManta = function(p1) -- line: 20
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p1.size

        AuraKit.halo(p1, T.AURA, {
            Color = cs(fromRGB(255, 235, 170))
        })
        AuraKit.twinkle(p1, T.STAR, {
            Rate = 10,
            Color = cs(fromRGB(255, 245, 200))
        })
        AuraKit.rise(p1, T.SPARKLE, {
            Rate = 7,
            Color = cs(fromRGB(255, 225, 140), fromRGB(150, 180, 255)),
            Size = seq(0, 0, 0.15, size * 0.08, 1, 0)
        })
        AuraKit.light(p1, fromRGB(255, 220, 140), 1.2, size * 2)
    end,
    ConstellationSeahorse = function(p2) -- line: 29
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p2.size

        AuraKit.halo(p2, T.SOFT_GLOW, {
            Color = cs(fromRGB(140, 170, 255))
        })
        AuraKit.orbit(p2, T.SPARKLES, {
            count = 3,
            speed = 1.2,
            y = 0.1,
            headSize = 0.14,
            tilt = CFrame.Angles(0.3, 0, 0.15),
            head = T.STAR
        }, {
            Color = cs(fromRGB(200, 220, 255)),
            Size = NumberSequence.new(size * 0.06)
        })
        AuraKit.twinkle(p2, T.STAR4, {
            Rate = 8,
            Color = cs(fromRGB(230, 240, 255))
        })
        AuraKit.light(p2, fromRGB(140, 170, 255), 1, size * 1.8)
    end,
    MoonlightOtter = function(p3) -- line: 38
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), new2 (copy), cs (copy)
        local size = p3.size

        AuraKit.halo(p3, T.SOFT_GLOW, {
            Color = cs(fromRGB(200, 215, 255))
        })
        AuraKit.fall(p3, T.CRESCENT, {
            Rate = 4,
            Color = cs(fromRGB(220, 230, 255)),
            Size = NumberSequence.new(size * 0.14),
            RotSpeed = new(-40, 40)
        })
        AuraKit.engulf(p3, T.GHOST_SMOKE, {
            LightEmission = 0.4,
            Color = cs(fromRGB(220, 230, 255), fromRGB(140, 160, 230)),
            Transparency = seq(0, 1, 0.25, 0.55, 0.7, 0.7, 1, 1),
            Acceleration = new2(0, size * 0.15, 0),
            Rate = 20 * p3.k
        })
        AuraKit.twinkle(p3, T.SPARKLE, {
            Color = cs(fromRGB(235, 240, 255))
        })
        AuraKit.light(p3, fromRGB(190, 205, 255), 1, size * 1.8)
    end,
    StarfallSwordfish = function(p4) -- line: 48
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p4.size

        AuraKit.engulf(p4, T.ENERGY, {
            LightEmission = 0.6,
            scale = 0.8,
            Color = cs(fromRGB(190, 225, 255), fromRGB(70, 130, 255)),
            Rate = 30 * p4.k
        })
        AuraKit.fall(p4, T.STAR, {
            Rate = 6,
            Color = cs(fromRGB(255, 245, 190)),
            Size = NumberSequence.new(size * 0.1),
            RotSpeed = new(-120, 120)
        })
        AuraKit.twinkle(p4, T.SHINE, {
            Color = cs(fromRGB(200, 230, 255))
        })
        AuraKit.light(p4, fromRGB(120, 170, 255), 1.2, size * 2)
    end,
    CometDolphin = function(p5) -- line: 57
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p5.size

        AuraKit.halo(p5, T.SOFT_GLOW, {
            Color = cs(fromRGB(170, 225, 255))
        })
        AuraKit.orbit(p5, T.SPARKLES, {
            count = 2,
            speed = 1.8,
            y = 0.15,
            tilt = CFrame.Angles(0.4, 0, 0.2)
        }, {
            Color = cs(fromRGB(220, 245, 255), fromRGB(100, 190, 255)),
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.twinkle(p5, T.SPARKLE, {
            Color = cs(fromRGB(200, 240, 255))
        })
        AuraKit.light(p5, fromRGB(150, 210, 255), 1, size * 1.8)
    end,
    AuroraSeal = function(p6) -- line: 66
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p6.size

        AuraKit.swirl(p6, T.WIND_ARC, {
            LightEmission = 0.7,
            Rate = 5,
            Color = cs(fromRGB(120, 255, 190), fromRGB(120, 200, 255), fromRGB(200, 120, 255)),
            Transparency = seq(0, 1, 0.3, 0.35, 1, 1)
        })
        AuraKit.halo(p6, T.AURA, {
            Color = cs(fromRGB(140, 255, 210))
        })
        AuraKit.fall(p6, T.SNOWFLAKE, {
            Rate = 4,
            Color = cs(fromRGB(240, 250, 255)),
            RotSpeed = new(-60, 60)
        })
        AuraKit.light(p6, fromRGB(120, 255, 200), 1.2, size * 2, 0.3, 1.5)
    end,
    StarlitPenguin = function(p7) -- line: 75
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p7.size

        AuraKit.halo(p7, T.SOFT_GLOW, {
            Color = cs(fromRGB(150, 190, 255))
        })
        AuraKit.twinkle(p7, T.STAR, {
            Rate = 9,
            Color = cs(fromRGB(255, 245, 210))
        })
        AuraKit.fall(p7, T.SNOW_BITS, {
            Rate = 8,
            Color = cs(fromRGB(235, 245, 255)),
            Size = NumberSequence.new(size * 0.07)
        })
        AuraKit.light(p7, fromRGB(150, 190, 255), 1, size * 1.8)
    end,
    NebulaOctopus = function(p8) -- line: 86
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p8.size

        AuraKit.engulf(p8, T.GHOST_SMOKE, {
            LightEmission = 0.5,
            Color = cs(fromRGB(255, 140, 230), fromRGB(140, 80, 255)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.twinkle(p8, T.STAR, {
            Rate = 10,
            Color = cs(fromRGB(255, 230, 250))
        })
        AuraKit.rise(p8, T.SPARKLE, {
            Rate = 6,
            Color = cs(fromRGB(255, 160, 240)),
            Size = seq(0, 0, 0.15, size * 0.07, 1, 0)
        })
        AuraKit.light(p8, fromRGB(230, 110, 255), 1.3, size * 2)
    end,
    GalaxyWhaleShark = function(p9) -- line: 95
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p9.size

        AuraKit.engulf(p9, T.GHOST_SMOKE, {
            LightEmission = 0.5,
            Color = cs(fromRGB(120, 140, 255), fromRGB(90, 40, 200)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.twinkle(p9, T.SPECS, {
            Rate = 12,
            Color = cs(fromRGB(230, 235, 255))
        })
        AuraKit.orbit(p9, T.STARS, {
            count = 3,
            speed = 0.9,
            y = 0.1,
            tilt = CFrame.Angles(0.25, 0, 0.1)
        }, {
            Color = cs(fromRGB(200, 190, 255)),
            Size = NumberSequence.new(size * 0.07)
        })
        AuraKit.light(p9, fromRGB(140, 110, 255), 1.3, size * 2.2)
    end,
    CosmicGreatWhite = function(p10) -- line: 104
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p10.size

        AuraKit.engulf(p10, T.ENERGY, {
            LightEmission = 0.6,
            scale = 0.85,
            Color = cs(fromRGB(220, 160, 255), fromRGB(130, 50, 255))
        })
        AuraKit.crackle(p10, {
            Rate = 5,
            Color = cs(fromRGB(210, 150, 255))
        })
        AuraKit.twinkle(p10, T.STAR, {
            Color = cs(fromRGB(240, 220, 255))
        })
        AuraKit.light(p10, fromRGB(180, 100, 255), 1.4, size * 2.2, 0.3, 2.5)
    end,
    CometBeluga = function(p11) -- line: 113
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p11.size

        AuraKit.engulf(p11, T.ENERGY, {
            LightEmission = 0.5,
            scale = 0.8,
            Color = cs(fromRGB(235, 250, 255), fromRGB(130, 200, 255)),
            Transparency = seq(0, 1, 0.2, 0.3, 0.7, 0.5, 1, 1),
            Rate = 30 * p11.k
        })
        AuraKit.orbit(p11, T.SPARKLES, {
            count = 2,
            speed = -1.5,
            y = 0.2,
            tilt = CFrame.Angles(-0.35, 0, 0.2)
        }, {
            Color = cs(fromRGB(220, 245, 255), fromRGB(140, 200, 255)),
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.fall(p11, T.SNOW_BITS, {
            Rate = 7,
            Color = cs(fromRGB(240, 250, 255)),
            Size = NumberSequence.new(size * 0.06)
        })
        AuraKit.light(p11, fromRGB(170, 220, 255), 1.2, size * 2)
    end,
    NebulaOrca = function(p12) -- line: 122
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p12.size

        AuraKit.engulf(p12, T.GHOST_SMOKE, {
            LightEmission = 0.5,
            Color = cs(fromRGB(110, 240, 230), fromRGB(240, 110, 220)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.rise(p12, T.STAR, {
            Rate = 5,
            Color = cs(fromRGB(220, 255, 250), fromRGB(255, 180, 240)),
            Size = seq(0, 0, 0.12, size * 0.1, 0.85, size * 0.09, 1, 0)
        })
        AuraKit.twinkle(p12, T.SPARKLE, {
            Color = cs(fromRGB(200, 255, 245))
        })
        AuraKit.light(p12, fromRGB(140, 230, 255), 1.3, size * 2)
    end,
    CosmicWalrus = function(p13) -- line: 131
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p13.size

        AuraKit.halo(p13, T.AURA, {
            Color = cs(fromRGB(180, 120, 255))
        })
        AuraKit.swirl(p13, T.SPIN_LINES, {
            Rate = 3,
            Color = cs(fromRGB(200, 140, 255))
        })
        AuraKit.twinkle(p13, T.PLUS_STARS, {
            Rate = 9,
            Color = cs(fromRGB(240, 210, 255))
        })
        AuraKit.light(p13, fromRGB(170, 110, 255), 1.3, size * 2)
    end,
    GalaxyAnglerfish = function(p14) -- line: 140
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p14.size

        AuraKit.engulf(p14, T.GHOST_SMOKE, {
            LightEmission = 0.3,
            Color = cs(fromRGB(110, 60, 200), fromRGB(30, 10, 70)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.orbit(p14, T.SPARKLES, {
            count = 1,
            speed = 2.2,
            radius = 0.35,
            y = 0.45,
            headSize = 0.2,
            head = T.GLOW
        }, {
            Color = cs(fromRGB(255, 250, 200), fromRGB(180, 140, 255)),
            Size = NumberSequence.new(size * 0.06)
        })
        AuraKit.twinkle(p14, T.SPECS, {
            Rate = 12,
            Color = cs(fromRGB(220, 200, 255))
        })
        AuraKit.light(p14, fromRGB(255, 240, 180), 1.4, size * 2, 0.4, 3)
    end,
    NebulaJellyfish = function(p15) -- line: 149
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p15.size

        AuraKit.engulf(p15, T.GHOST_SMOKE, {
            LightEmission = 0.6,
            Color = cs(fromRGB(255, 150, 230), fromRGB(110, 220, 255)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.rise(p15, T.BUBBLE, {
            Rate = 6,
            Color = cs(fromRGB(200, 230, 255)),
            Size = seq(0, 0, 0.15, size * 0.08, 0.9, size * 0.09, 1, size * 0.12),
            Transparency = seq(0, 0.1, 0.9, 0.2, 1, 1)
        })
        AuraKit.twinkle(p15, T.SPARKLE, {
            Color = cs(fromRGB(255, 210, 250))
        })
        AuraKit.light(p15, fromRGB(220, 140, 255), 1.3, size * 2, 0.4, 1.5)
    end
}
