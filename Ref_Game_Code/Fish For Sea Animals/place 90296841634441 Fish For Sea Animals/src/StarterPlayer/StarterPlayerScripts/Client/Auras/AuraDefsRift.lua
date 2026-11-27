-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local AuraThemes = require(script.Parent.AuraThemes)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new = Color3.fromRGB, NumberRange.new
local cs = AuraKit.cs

return {
    RiftWatcher = function(p1) -- line: 21
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p1.size

        AuraKit.halo(p1, T.AURA, {
            Color = cs(fromRGB(200, 60, 230))
        })
        AuraKit.orbit(p1, T.SPARKLES, {
            count = 4,
            speed = 0.9,
            y = 0.05,
            headSize = 0.13,
            head = T.SHARD
        }, {
            Color = cs(AuraThemes.CYAN, AuraThemes.MAGENTA),
            Size = NumberSequence.new(size * 0.04)
        })
        AuraKit.crackle(p1, {
            Rate = 3,
            texture = T.GLITCH_LINES,
            Color = cs(AuraThemes.MAGENTA),
            Size = NumberSequence.new(size * 0.35),
            Lifetime = new(0.08, 0.16)
        })
        AuraKit.light(p1, AuraThemes.MAGENTA, 1.2, size * 2, 0.3, 2)
    end,
    MirrorKoi = function(p2) -- line: 30
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p2.size

        AuraKit.twinkle(p2, T.SHINE, {
            Rate = 10,
            Color = cs(fromRGB(235, 245, 255), AuraThemes.PALE_GOLD)
        })
        AuraKit.swirl(p2, T.ARC, {
            Rate = 3,
            Color = cs(fromRGB(220, 235, 255))
        })
        AuraKit.rise(p2, T.SPIN_COIN, {
            Rate = 4,
            Color = cs(fromRGB(255, 230, 140)),
            Size = seq(0, 0, 0.12, size * 0.1, 0.85, size * 0.1, 1, 0)
        })
        AuraKit.light(p2, fromRGB(230, 230, 255), 1.1, size * 2)
    end,
    RadiantJellyfish = function(p3) -- line: 41
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), cs (copy)
        local size = p3.size

        AuraThemes.radiant(p3, 2)
        AuraKit.fall(p3, T.SPARKLE, {
            Rate = 5,
            Color = cs(AuraThemes.PALE_GOLD),
            Size = NumberSequence.new(size * 0.05)
        })
    end,
    RadiantSeaDragon = function(p4) -- line: 48
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), cs (copy)
        local size = p4.size

        AuraThemes.radiant(p4, 1)
        AuraKit.rise(p4, T.LEAF, {
            Rate = 4,
            Color = cs(AuraThemes.GOLD),
            Size = seq(0, 0, 0.15, size * 0.1, 0.85, size * 0.09, 1, 0)
        })
    end,
    RadiantMosasaurus = function(p5) -- line: 55
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), cs (copy)
        local size = p5.size

        AuraThemes.radiant(p5, 1)
        AuraKit.rise(p5, T.STAR, {
            Rate = 5,
            Color = cs(AuraThemes.PEARL, AuraThemes.PALE_GOLD),
            Size = seq(0, 0, 0.15, size * 0.06, 1, 0)
        })
    end,
    TempestPlesiosaur = function(p6) -- line: 64
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy)
        AuraThemes.tempest(p6)
        AuraKit.crackle(p6, {
            Rate = 3,
            texture = T.BOLT,
            Color = cs(fromRGB(220, 245, 255))
        })
    end,
    TempestRay = function(p7) -- line: 70
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p7.size

        AuraThemes.tempest(p7)
        AuraKit.swirl(p7, T.WIND_ARC, {
            LightEmission = 0.3,
            Rate = 3,
            Color = cs(fromRGB(170, 190, 215)),
            Transparency = seq(0, 1, 0.3, 0.6, 1, 1)
        })
        AuraKit.rise(p7, T.SPECS, {
            Rate = 6,
            Color = cs(AuraThemes.STORM),
            Size = seq(0, size * 0.05, 1, 0)
        })
    end,
    TempestIsopod = function(p8) -- line: 78
        -- upvalues: AuraThemes (copy), T (copy), fromRGB (copy)
        AuraThemes.tempest(p8, fromRGB(140, 230, 255))
        AuraThemes.ring(p8, 3.5, T.ELECTRIC_RING, AuraThemes.STORM)
    end,
    GlitchedGreatWhite = function(p9) -- line: 86
        -- upvalues: AuraThemes (copy)
        AuraThemes.glitched(p9)
    end,
    GlitchedOctopus = function(p10) -- line: 91
        -- upvalues: AuraThemes (copy)
        AuraThemes.glitched(p10, 8)
    end,
    GlitchedSnapper = function(p11) -- line: 96
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), new (copy), cs (copy)
        local size = p11.size

        AuraThemes.glitched(p11, 4)
        AuraKit.twinkle(p11, T.GLITCH_LINES, {
            Rate = 6,
            Color = cs(AuraThemes.CYAN),
            Size = seq(0, size * 0.2, 1, size * 0.2),
            Lifetime = new(0.1, 0.2),
            RotSpeed = new(0),
            Rotation = new(0)
        })
    end,
    ErrorWhale = function(p12) -- line: 103
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), new (copy), cs (copy)
        local size = p12.size

        AuraThemes.glitched(p12, 8)
        AuraKit.pulse(p12, 3, 10, T.GLITCH, {
            LightEmission = 0.8,
            Color = cs(AuraThemes.MAGENTA, AuraThemes.CYAN),
            Size = seq(0, size * 0.09, 1, size * 0.09),
            Rotation = new(0),
            RotSpeed = new(0),
            Speed = new(size * 0.4, size * 0.8),
            Lifetime = new(0.8, 1.2),
            FlipbookMode = Enum.ParticleFlipbookMode.Random
        })
    end
}
