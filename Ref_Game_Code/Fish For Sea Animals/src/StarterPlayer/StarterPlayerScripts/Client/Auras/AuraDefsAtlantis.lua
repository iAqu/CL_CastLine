-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local AuraThemes = require(script.Parent.AuraThemes)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new = Color3.fromRGB, Vector3.new
local cs = AuraKit.cs
local GOLD, PALE_GOLD, PEARL, VOID = AuraThemes.GOLD, AuraThemes.PALE_GOLD, AuraThemes.PEARL, AuraThemes.VOID
local runes, voidSmoke, radiant = AuraThemes.runes, AuraThemes.voidSmoke, AuraThemes.radiant

return {
    TitanTempleTurtle = function(p1) -- line: 24
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), GOLD (copy), PALE_GOLD (copy), runes (copy)
        local size = p1.size

        AuraKit.ground(p1, T.ROCKS, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 7,
            Color = cs(fromRGB(230, 222, 205)),
            Size = seq(0, size * 0.06, 1, size * 0.02)
        })
        runes(p1, GOLD, 5)
        AuraKit.twinkle(p1, T.SHINE, {
            Rate = 6,
            Color = cs(PALE_GOLD)
        })
        AuraKit.light(p1, GOLD, 1.2, size * 2)
    end,
    PlazaManta = function(p2) -- line: 33
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), PALE_GOLD (copy)
        local size = p2.size

        AuraKit.swirl(p2, T.WIND_ARC, {
            LightEmission = 0.4,
            Rate = 3,
            Color = cs(fromRGB(240, 235, 215)),
            Transparency = seq(0, 1, 0.3, 0.6, 1, 1)
        })
        AuraKit.twinkle(p2, T.SHINE, {
            Rate = 8,
            Color = cs(PALE_GOLD)
        })
        AuraKit.ground(p2, T.ROCKS, {
            LightEmission = 0,
            LightInfluence = 0.6,
            Rate = 5,
            Color = cs(fromRGB(220, 210, 190)),
            Size = seq(0, size * 0.05, 1, size * 0.02)
        })
        AuraKit.light(p2, PALE_GOLD, 1.1, size * 2)
    end,
    RuneEel = function(p3) -- line: 44
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy), GOLD (copy), VOID (copy), runes (copy), voidSmoke (copy)
        local size = p3.size

        voidSmoke(p3, fromRGB(70, 30, 110), fromRGB(10, 5, 20))
        runes(p3, GOLD, 6)
        AuraKit.twinkle(p3, T.SPECK, {
            Rate = 6,
            Color = cs(VOID)
        })
        AuraKit.light(p3, VOID, 1.2, size * 2)
    end,
    ShadeSeahorse = function(p4) -- line: 53
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy), VOID (copy)
        local size = p4.size

        AuraKit.engulf(p4, T.DARK_CLOUD, {
            LightEmission = 0,
            Color = cs(fromRGB(55, 40, 75), fromRGB(8, 5, 15)),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new(0, size * 0.1, 0)
        })
        AuraKit.swirl(p4, T.ARC, {
            Rate = 3,
            Color = cs(VOID)
        })
        AuraKit.twinkle(p4, T.SPECK, {
            Rate = 8,
            Color = cs(fromRGB(200, 140, 255))
        })
        AuraKit.light(p4, VOID, 1.1, size * 1.8)
    end,
    VoidPufferfish = function(p5) -- line: 62
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy), VOID (copy), voidSmoke (copy)
        local size = p5.size

        voidSmoke(p5, fromRGB(90, 40, 140), fromRGB(15, 5, 30), 35)
        AuraThemes.ring(p5, 3, T.SOFT_RING, VOID)
        AuraKit.twinkle(p5, T.SPARKLE, {
            Rate = 6,
            Color = cs(fromRGB(210, 150, 255))
        })
        AuraKit.light(p5, VOID, 1.1, size * 1.8, 0.3, 2)
    end,
    TridentSwordfish = function(p6) -- line: 73
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy), GOLD (copy), PALE_GOLD (copy)
        local size = p6.size

        AuraKit.crackle(p6, {
            Rate = 4,
            Color = cs(fromRGB(255, 230, 140))
        })
        AuraKit.orbit(p6, T.SPARKLES, {
            count = 3,
            speed = 1.6,
            y = 0.1,
            headSize = 0.12,
            tilt = CFrame.Angles(0.25, 0, 0.1),
            head = T.GLOW
        }, {
            Color = cs(PALE_GOLD, GOLD),
            Size = NumberSequence.new(size * 0.06)
        })
        AuraKit.twinkle(p6, T.SHINE, {
            Rate = 8,
            Color = cs(PALE_GOLD)
        })
        AuraKit.light(p6, GOLD, 1.3, size * 2.2, 0.3, 2)
    end,
    CrownCrab = function(p7) -- line: 82
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), GOLD (copy), PALE_GOLD (copy)
        local size = p7.size

        AuraKit.halo(p7, T.SOFT_GLOW, {
            Color = cs(GOLD)
        })
        AuraKit.rise(p7, T.SPIN_GEM, {
            Rate = 5,
            Color = cs(fromRGB(255, 240, 200)),
            Size = seq(0, 0, 0.12, size * 0.12, 0.85, size * 0.11, 1, 0)
        })
        AuraKit.twinkle(p7, T.SHINE, {
            Rate = 8,
            Color = cs(PALE_GOLD)
        })
        AuraKit.light(p7, GOLD, 1.3, size * 2.2)
    end,
    MarbleHydra = function(p8) -- line: 91
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), GOLD (copy), PALE_GOLD (copy), runes (copy)
        local size = p8.size

        AuraKit.engulf(p8, T.ENERGY, {
            scale = 0.75,
            Color = cs(fromRGB(255, 240, 190), fromRGB(230, 170, 50)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Rate = 30 * p8.k
        })
        runes(p8, GOLD, 6)
        AuraThemes.ring(p8, 3.2, T.SOFT_RING, PALE_GOLD)
        AuraKit.light(p8, GOLD, 1.3, size * 2.2, 0.3, 1.5)
    end,
    RadiantDolphin = function(p9) -- line: 102
        -- upvalues: radiant (copy)
        radiant(p9, 1)
    end,
    RadiantKoi = function(p10) -- line: 107
        -- upvalues: AuraKit (copy), T (copy), seq (copy), cs (copy), GOLD (copy), PALE_GOLD (copy), radiant (copy)
        local size = p10.size

        radiant(p10, 1)
        AuraKit.rise(p10, T.SPARKLE, {
            Rate = 6,
            Color = cs(PALE_GOLD, GOLD),
            Size = seq(0, 0, 0.15, size * 0.07, 1, 0)
        })
    end,
    RadiantNarwhal = function(p11) -- line: 114
        -- upvalues: AuraKit (copy), T (copy), seq (copy), cs (copy), PALE_GOLD (copy), PEARL (copy), radiant (copy)
        local size = p11.size

        radiant(p11, 1)
        AuraKit.rise(p11, T.STAR, {
            Rate = 5,
            Color = cs(PEARL, PALE_GOLD),
            Size = seq(0, 0, 0.15, size * 0.06, 1, 0)
        })
    end,
    RadiantHumpback = function(p12) -- line: 121
        -- upvalues: radiant (copy)
        radiant(p12, 2)
    end
}
