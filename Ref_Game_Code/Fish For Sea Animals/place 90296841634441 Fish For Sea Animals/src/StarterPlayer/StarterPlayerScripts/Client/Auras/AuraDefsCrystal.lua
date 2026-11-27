-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new, new2 = Color3.fromRGB, NumberRange.new, Vector3.new
local cs = AuraKit.cs
local v1 = cs(fromRGB(255, 100, 120), fromRGB(255, 210, 90), fromRGB(110, 240, 140), fromRGB(100, 190, 255), fromRGB(210, 120, 255))

return {
    PrismHumpback = function(p1) -- line: 23
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), v1 (copy)
        local size = p1.size

        AuraKit.engulf(p1, T.ENERGY, {
            LightEmission = 0.6,
            scale = 0.85,
            Color = v1,
            Rate = 40 * p1.k
        })
        AuraKit.rise(p1, T.SHINE, {
            Rate = 6,
            Color = v1,
            Size = seq(0, 0, 0.12, size * 0.12, 0.85, size * 0.1, 1, 0)
        })
        AuraKit.twinkle(p1, T.SPARKLE, {
            Color = cs(fromRGB(255, 255, 255))
        })
        AuraKit.light(p1, fromRGB(200, 230, 255), 1.3, size * 2.2)
    end,
    CrystalNarwhal = function(p2) -- line: 32
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p2.size

        AuraKit.halo(p2, T.AURA, {
            Color = cs(fromRGB(150, 240, 255))
        })
        AuraKit.rise(p2, T.SHARD, {
            Rate = 6,
            Color = cs(fromRGB(200, 250, 255), fromRGB(120, 210, 255)),
            RotSpeed = new(-120, 120)
        })
        AuraKit.twinkle(p2, T.SHINE, {
            Rate = 10,
            Color = cs(fromRGB(220, 250, 255))
        })
        AuraKit.light(p2, fromRGB(140, 230, 255), 1.3, size * 2)
    end,
    PrismJellyfish = function(p3) -- line: 41
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), v1 (copy)
        local size = p3.size

        AuraKit.engulf(p3, T.GHOST_SMOKE, {
            LightEmission = 0.6,
            Color = v1,
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.rise(p3, T.BUBBLE, {
            Rate = 6,
            Color = v1,
            Size = seq(0, 0, 0.15, size * 0.08, 0.9, size * 0.09, 1, size * 0.12),
            Transparency = seq(0, 0.1, 0.9, 0.2, 1, 1)
        })
        AuraKit.twinkle(p3, T.SPARKLE, {
            Color = v1
        })
        AuraKit.light(p3, fromRGB(255, 180, 240), 1.2, size * 2, 0.3, 1.5)
    end,
    DiamondWalrus = function(p4) -- line: 50
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p4.size

        AuraKit.halo(p4, T.SOFT_GLOW, {
            Color = cs(fromRGB(220, 245, 255))
        })
        AuraKit.twinkle(p4, T.SPIN_GEM, {
            Rate = 8,
            Color = cs(fromRGB(230, 250, 255)),
            Size = seq(0, 0, 0.35, size * 0.12, 1, 0)
        })
        AuraKit.rise(p4, T.GEM, {
            Rate = 5,
            Color = cs(fromRGB(200, 240, 255)),
            RotSpeed = new(-90, 90)
        })
        AuraKit.twinkle(p4, T.SHINE, {
            Rate = 6,
            Color = cs(fromRGB(255, 255, 255))
        })
        AuraKit.light(p4, fromRGB(200, 240, 255), 1.3, size * 2)
    end,
    PrismVampireSquid = function(p5) -- line: 60
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p5.size

        AuraKit.engulf(p5, T.GHOST_SMOKE, {
            LightEmission = 0.4,
            Color = cs(fromRGB(255, 80, 200), fromRGB(80, 220, 255), fromRGB(60, 20, 90)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.rise(p5, T.BAT, {
            Rate = 4,
            Color = cs(fromRGB(255, 120, 220), fromRGB(120, 230, 255))
        })
        AuraKit.twinkle(p5, T.SPARKLE, {
            Color = cs(fromRGB(255, 80, 120))
        })
        AuraKit.light(p5, fromRGB(255, 90, 210), 1.3, size * 2)
    end,
    CrystalGulperEel = function(p6) -- line: 69
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p6.size

        AuraKit.engulf(p6, T.ENERGY, {
            LightEmission = 0.6,
            scale = 0.85,
            Color = cs(fromRGB(255, 160, 230), fromRGB(120, 230, 255))
        })
        AuraKit.twinkle(p6, T.SHARDS, {
            Rate = 8,
            Color = cs(fromRGB(220, 250, 255)),
            Size = seq(0, 0, 0.35, size * 0.12, 1, 0)
        })
        AuraKit.light(p6, fromRGB(200, 170, 255), 1.3, size * 2)
    end,
    PrismIsopod = function(p7) -- line: 77
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy), v1 (copy)
        local size = p7.size

        AuraKit.engulf(p7, T.GEM_FLAME, {
            LightEmission = 0.6,
            scale = 0.9,
            Color = v1
        })
        AuraKit.ground(p7, T.SHARDS, {
            LightEmission = 0.5,
            Rate = 7,
            Color = v1,
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.twinkle(p7, T.SPARKLE, {
            Color = cs(fromRGB(255, 255, 255))
        })
        AuraKit.light(p7, fromRGB(210, 200, 255), 1.2, size * 2)
    end,
    MagmaCrystalCrab = function(p8) -- line: 86
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p8.size

        AuraKit.engulf(p8, T.FIRE, {
            scale = 0.85,
            Color = cs(fromRGB(255, 220, 110), fromRGB(255, 110, 40), fromRGB(200, 40, 80))
        })
        AuraKit.twinkle(p8, T.SPIN_GEM, {
            Rate = 7,
            Color = cs(fromRGB(255, 150, 220)),
            Size = seq(0, 0, 0.35, size * 0.11, 1, 0)
        })
        AuraKit.rise(p8, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 10,
            Color = cs(fromRGB(255, 190, 80)),
            Size = seq(0, size * 0.06, 1, 0)
        })
        AuraKit.light(p8, fromRGB(255, 130, 90), 1.3, size * 2, 0.3, 3)
    end,
    PrismLavaEel = function(p9) -- line: 95
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), v1 (copy)
        local size = p9.size

        AuraKit.engulf(p9, T.FIRE3, {
            scale = 0.85,
            Color = cs(fromRGB(255, 220, 120), fromRGB(255, 90, 160), fromRGB(160, 60, 255))
        })
        AuraKit.rise(p9, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 10,
            Color = cs(fromRGB(255, 170, 200), fromRGB(255, 160, 60)),
            Size = seq(0, size * 0.06, 1, 0)
        })
        AuraKit.twinkle(p9, T.SPARKLE, {
            Color = v1
        })
        AuraKit.light(p9, fromRGB(255, 120, 150), 1.3, size * 2, 0.3, 2.5)
    end,
    TitanOrca = function(p10) -- line: 106
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p10.size

        AuraKit.engulf(p10, T.SSJ, {
            Color = cs(fromRGB(230, 245, 255), fromRGB(90, 170, 255)),
            Rate = 26 * p10.k
        })
        AuraKit.crackle(p10, {
            Rate = 5,
            Color = cs(fromRGB(160, 220, 255))
        })
        AuraKit.pulse(p10, 3, 1, T.SOFT_RING, {
            Drag = 0,
            Color = cs(fromRGB(170, 220, 255)),
            Size = seq(0, size * 0.4, 1, size * 1.6),
            Transparency = seq(0, 0.3, 1, 1),
            Speed = new(0),
            Lifetime = new(0.7),
            Rotation = new(0),
            RotSpeed = new(0)
        })
        AuraKit.light(p10, fromRGB(130, 190, 255), 1.6, size * 2.4, 0.3, 2)
    end,
    GlacierTurtle = function(p11) -- line: 115
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), new2 (copy), cs (copy)
        local size = p11.size

        AuraKit.engulf(p11, T.GHOST_SMOKE, {
            LightEmission = 0.4,
            Color = cs(fromRGB(220, 245, 255), fromRGB(120, 200, 255)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.fall(p11, T.SNOWFLAKE, {
            Rate = 8,
            Color = cs(fromRGB(240, 250, 255)),
            RotSpeed = new(-70, 70)
        })
        AuraKit.ground(p11, T.SNOW_BITS, {
            LightEmission = 0.2,
            Rate = 9,
            Color = cs(fromRGB(240, 250, 255)),
            Size = NumberSequence.new(size * 0.07)
        })
        AuraKit.twinkle(p11, T.SHINE, {
            Color = cs(fromRGB(220, 245, 255))
        })
        AuraKit.light(p11, fromRGB(160, 220, 255), 1.4, size * 2.2)
    end,
    ColossalBlueWhale = function(p12) -- line: 125
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p12.size

        AuraKit.engulf(p12, T.WATER, {
            LightEmission = 0.5,
            Brightness = 1.6,
            scale = 0.85,
            Color = cs(fromRGB(160, 225, 255), fromRGB(40, 120, 255)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.5, 1, 1)
        })
        AuraKit.rise(p12, T.BUBBLES, {
            Rate = 7,
            Color = cs(fromRGB(210, 240, 255)),
            Size = NumberSequence.new(size * 0.1)
        })
        AuraKit.pulse(p12, 3.2, 6, T.SPLASH, {
            LightEmission = 0.4,
            Color = cs(fromRGB(190, 235, 255)),
            Size = seq(0, 0, 0.15, size * 0.2, 1, size * 0.1)
        })
        AuraKit.light(p12, fromRGB(90, 170, 255), 1.4, size * 2.4)
    end,
    MammothWalrus = function(p13) -- line: 134
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), new2 (copy), cs (copy)
        local size = p13.size

        AuraKit.swirl(p13, T.WIND_SWIRL, {
            Rate = 4,
            Color = cs(fromRGB(225, 245, 255))
        })
        AuraKit.engulf(p13, T.GHOST_SMOKE, {
            LightEmission = 0.35,
            Color = cs(fromRGB(235, 250, 255), fromRGB(150, 210, 255)),
            Transparency = seq(0, 1, 0.25, 0.45, 0.7, 0.6, 1, 1),
            Acceleration = new2(0, size * 0.1, 0),
            Rate = 35 * p13.k
        })
        AuraKit.fall(p13, T.SNOWFLAKE, {
            Rate = 10,
            Color = cs(fromRGB(245, 252, 255)),
            RotSpeed = new(-80, 80)
        })
        AuraKit.light(p13, fromRGB(180, 225, 255), 1.3, size * 2.2)
    end,
    ColossalSquid = function(p14) -- line: 143
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p14.size

        AuraKit.engulf(p14, T.GHOST_SMOKE, {
            LightEmission = 0.3,
            Color = cs(fromRGB(220, 60, 70), fromRGB(70, 10, 30)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.1, 0)
        })
        AuraKit.crackle(p14, {
            Rate = 4,
            Color = cs(fromRGB(255, 90, 90))
        })
        AuraKit.rise(p14, T.BUBBLE, {
            Rate = 5,
            Color = cs(fromRGB(255, 190, 190)),
            Size = seq(0, 0, 0.15, size * 0.07, 0.9, size * 0.08, 1, size * 0.1),
            Transparency = seq(0, 0.2, 0.9, 0.3, 1, 1)
        })
        AuraKit.light(p14, fromRGB(255, 70, 80), 1.3, size * 2, 0.3, 2)
    end,
    TitanIsopod = function(p15) -- line: 152
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p15.size

        AuraKit.engulf(p15, T.ENERGY, {
            LightEmission = 0.6,
            scale = 0.85,
            Color = cs(fromRGB(255, 220, 130), fromRGB(255, 150, 30))
        })
        AuraKit.crackle(p15, {
            Rate = 4,
            Color = cs(fromRGB(255, 210, 110))
        })
        AuraKit.ground(p15, T.ROCKS, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 8,
            Color = cs(fromRGB(170, 120, 70)),
            Size = seq(0, size * 0.07, 1, size * 0.02)
        })
        AuraKit.light(p15, fromRGB(255, 180, 70), 1.4, size * 2.2)
    end,
    TitanOarfish = function(p16) -- line: 161
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p16.size

        AuraKit.engulf(p16, T.SSJ, {
            Color = cs(fromRGB(255, 250, 220), fromRGB(255, 200, 90)),
            Rate = 24 * p16.k
        })
        AuraKit.swirl(p16, T.WIND_ARC, {
            LightEmission = 0.5,
            Rate = 4,
            Color = cs(fromRGB(255, 240, 190)),
            Transparency = seq(0, 1, 0.3, 0.45, 1, 1)
        })
        AuraKit.twinkle(p16, T.SHINE, {
            Color = cs(fromRGB(255, 245, 200))
        })
        AuraKit.light(p16, fromRGB(255, 220, 130), 1.4, size * 2.2, 0.3, 2)
    end,
    VolcanoTurtle = function(p17) -- line: 170
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), new2 (copy), cs (copy)
        local size = p17.size

        AuraKit.engulf(p17, T.FIRE_BIG, {
            scale = 0.85,
            Color = cs(fromRGB(255, 230, 130), fromRGB(255, 110, 20), fromRGB(150, 20, 0))
        })
        AuraKit.pulse(p17, 2.6, 12, T.FIRE_SPECS, {
            Drag = 0.5,
            LightEmission = 1,
            Color = cs(fromRGB(255, 200, 90), fromRGB(255, 80, 20)),
            Size = seq(0, size * 0.06, 1, 0),
            Speed = new(size * 1.2, size * 2),
            Acceleration = new2(0, -size * 1.6, 0),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(40, 40)
        })
        AuraKit.ground(p17, T.ASH, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 6,
            Color = cs(fromRGB(90, 80, 80)),
            Size = NumberSequence.new(size * 0.1)
        })
        AuraKit.light(p17, fromRGB(255, 120, 30), 1.6, size * 2.4, 0.4, 3)
    end,
    MoltenWhale = function(p18) -- line: 179
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p18.size

        AuraKit.engulf(p18, T.FIRE, {
            scale = 0.85,
            Color = cs(fromRGB(255, 210, 100), fromRGB(255, 90, 20), fromRGB(120, 20, 10))
        })
        AuraKit.fall(p18, T.ASH, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 6,
            Color = cs(fromRGB(120, 100, 95)),
            Size = NumberSequence.new(size * 0.08)
        })
        AuraKit.rise(p18, T.FIRE_SPECS, {
            LightEmission = 1,
            Rate = 10,
            Color = cs(fromRGB(255, 180, 70)),
            Size = seq(0, size * 0.06, 1, 0)
        })
        AuraKit.light(p18, fromRGB(255, 100, 30), 1.6, size * 2.4, 0.4, 1.5)
    end,
    ObsidianBehemoth = function(p19) -- line: 188
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy)
        local size = p19.size

        AuraKit.engulf(p19, T.GHOST_SMOKE, {
            LightEmission = 0,
            Color = cs(fromRGB(60, 40, 70), fromRGB(15, 10, 20)),
            Transparency = seq(0, 1, 0.25, 0.3, 0.7, 0.5, 1, 1),
            Acceleration = new2(0, size * 0.12, 0)
        })
        AuraKit.crackle(p19, {
            Rate = 5,
            Color = cs(fromRGB(220, 120, 255), fromRGB(255, 140, 60))
        })
        AuraKit.ground(p19, T.ROCKS, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 8,
            Color = cs(fromRGB(60, 50, 70)),
            Size = seq(0, size * 0.07, 1, size * 0.02)
        })
        AuraKit.twinkle(p19, T.SPARKLE, {
            Color = cs(fromRGB(255, 150, 80))
        })
        AuraKit.light(p19, fromRGB(200, 90, 255), 1.4, size * 2.2, 0.3, 2.5)
    end
}
