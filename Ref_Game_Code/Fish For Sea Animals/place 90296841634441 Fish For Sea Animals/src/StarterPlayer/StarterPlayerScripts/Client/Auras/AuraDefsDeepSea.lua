-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Shared.Animals)
local AuraKit = require(script.Parent.AuraKit)
local AuraThemes = require(script.Parent.AuraThemes)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new = Color3.fromRGB, Vector3.new
local cs = AuraKit.cs

local function motes(p1, p2, p3, p4, p5) -- line: 23
    -- upvalues: AuraKit (copy), seq (copy), cs (copy)
    local size = p1.size

    AuraKit.rise(p1, p2, {
        Color = cs(p3),
        Size = seq(0, 0, 0.15, size * (p5 or 0.06), 0.85, size * (p5 or 0.06) * 0.8, 1, 0),
        Rate = p4
    })
end

local t1 = {
    Radiant = function(p6) -- line: 31
        -- upvalues: AuraThemes (copy)
        AuraThemes.radiant(p6, 1)
    end,
    Tempest = function(p7) -- line: 35
        -- upvalues: AuraThemes (copy)
        AuraThemes.tempest(p7)
    end,
    Glitched = function(p8) -- line: 39
        -- upvalues: AuraThemes (copy)
        AuraThemes.glitched(p8)
    end,
    Dusk = function(p9) -- line: 44
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p9.size

        AuraKit.halo(p9, T.GLOW, {
            Color = cs(fromRGB(255, 170, 130))
        })
        AuraKit.twinkle(p9, T.SPARKLE, {
            Rate = 8,
            Color = cs(fromRGB(255, 210, 160), fromRGB(220, 110, 170))
        })
        AuraKit.rise(p9, T.STAR4, {
            Rate = 4,
            Color = cs(fromRGB(255, 190, 140), fromRGB(150, 90, 200)),
            Size = seq(0, 0, 0.15, size * 0.07, 1, 0)
        })
        AuraKit.light(p9, fromRGB(255, 160, 120), 1.1, size * 2)
    end,
    Nightfall = function(p10) -- line: 53
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p10.size

        AuraThemes.voidSmoke(p10, fromRGB(80, 70, 190), fromRGB(10, 10, 40), 30)
        AuraKit.twinkle(p10, T.STAR, {
            Rate = 9,
            Color = cs(fromRGB(220, 225, 255)),
            Size = seq(0, 0, 0.35, size * 0.1, 1, 0)
        })
        AuraKit.orbit(p10, T.SPARKLES, {
            count = 1,
            speed = 0.9,
            y = 0.2,
            headSize = 0.2,
            head = T.CRESCENT
        }, {
            Color = cs(fromRGB(230, 230, 255), fromRGB(120, 110, 255)),
            Size = NumberSequence.new(size * 0.04)
        })
        AuraKit.light(p10, fromRGB(120, 110, 255), 1.1, size * 2)
    end,
    Lumen = function(p11) -- line: 62
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), cs (copy), motes (copy)
        local size = p11.size

        AuraKit.halo(p11, T.SOFT_GLOW, {
            Color = cs(fromRGB(90, 255, 230))
        })
        AuraKit.twinkle(p11, T.SPECK, {
            Rate = 16,
            Color = cs(fromRGB(160, 255, 240), fromRGB(60, 220, 255)),
            Size = seq(0, 0, 0.35, size * 0.08, 1, 0)
        })
        motes(p11, T.BUBBLE, fromRGB(140, 255, 235), 5, 0.07)
        AuraThemes.ring(p11, 4, T.SOFT_RING, fromRGB(110, 255, 230))
        AuraKit.light(p11, fromRGB(90, 255, 220), 1.3, size * 2.2, 0.4, 1.5)
    end,
    Phantom = function(p12) -- line: 72
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p12.size

        AuraKit.engulf(p12, T.GHOST_SMOKE, {
            LightEmission = 0.3,
            Color = cs(fromRGB(225, 235, 255), fromRGB(120, 140, 190)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new(0, size * 0.1, 0)
        })
        AuraKit.rise(p12, T.GHOST, {
            Rate = 3,
            Color = cs(fromRGB(220, 235, 255))
        })
        AuraKit.twinkle(p12, T.FLARE, {
            Rate = 6,
            Color = cs(fromRGB(210, 230, 255)),
            Size = seq(0, 0, 0.35, size * 0.1, 1, 0)
        })
        AuraKit.light(p12, fromRGB(190, 215, 255), 1, size * 2, 0.5, 0.8)
    end,
    Quicksilver = function(p13) -- line: 81
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p13.size

        AuraKit.twinkle(p13, T.SHINE, {
            Rate = 12,
            Color = cs(fromRGB(255, 255, 255), fromRGB(190, 200, 215))
        })
        AuraKit.fall(p13, T.DRIP, {
            Rate = 5,
            Color = cs(fromRGB(230, 235, 245), fromRGB(150, 160, 175)),
            Size = NumberSequence.new(size * 0.05)
        })
        AuraKit.swirl(p13, T.ARC, {
            Rate = 2.5,
            Color = cs(fromRGB(225, 232, 242))
        })
        AuraKit.light(p13, fromRGB(220, 230, 245), 1, size * 2)
    end,
    Thermal = function(p14) -- line: 90
        -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), cs (copy)
        local size = p14.size

        AuraKit.engulf(p14, T.FIRE2, {
            scale = 0.8,
            Color = cs(fromRGB(255, 220, 120), fromRGB(255, 110, 30), fromRGB(90, 20, 10))
        })
        AuraKit.rise(p14, T.FIRE_SPECS, {
            Rate = 6,
            Color = cs(fromRGB(255, 200, 90), fromRGB(255, 80, 20)),
            Size = seq(0, 0, 0.15, size * 0.08, 1, 0)
        })
        AuraKit.ground(p14, T.SMOKE, {
            LightEmission = 0,
            Color = cs(fromRGB(90, 70, 60), fromRGB(30, 25, 25))
        })
        AuraKit.light(p14, fromRGB(255, 120, 40), 1.3, size * 2, 0.4, 3)
    end,
    Bonecrest = function(p15) -- line: 99
        -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p15.size

        AuraKit.halo(p15, T.GLOW, {
            Color = cs(fromRGB(245, 235, 210))
        })
        AuraKit.orbit(p15, T.SPARKLES, {
            count = 3,
            speed = 1,
            y = 0.1,
            headSize = 0.14,
            tilt = CFrame.Angles(0.3, 0, 0.2),
            head = T.SHARD
        }, {
            Color = cs(fromRGB(255, 250, 235), fromRGB(200, 185, 150)),
            Size = NumberSequence.new(size * 0.04)
        })
        AuraKit.rise(p15, T.SKULL, {
            Rate = 2.5,
            Color = cs(fromRGB(250, 240, 215))
        })
        AuraKit.light(p15, fromRGB(245, 230, 200), 1.1, size * 2)
    end,
    Dreadnought = function(p16) -- line: 108
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), seq (copy), fromRGB (copy), new (copy), cs (copy)
        local size = p16.size

        AuraKit.engulf(p16, T.DARK_CLOUD, {
            LightEmission = 0,
            Color = cs(fromRGB(110, 120, 115), fromRGB(35, 40, 40)),
            Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
            Acceleration = new(0, size * 0.12, 0),
            Rate = 30 * p16.k
        })
        AuraKit.twinkle(p16, T.FIRE_SPECS, {
            Rate = 10,
            Color = cs(fromRGB(255, 190, 90), fromRGB(230, 90, 30))
        })
        AuraThemes.ring(p16, 4.5, T.SHOCKWAVE, fromRGB(200, 220, 210))
        AuraKit.light(p16, fromRGB(230, 120, 60), 1.1, size * 2, 0.5, 4)
    end,
    Hadal = function(p17) -- line: 117
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy), motes (copy)
        local size = p17.size

        AuraThemes.voidSmoke(p17, fromRGB(50, 100, 255), fromRGB(0, 5, 30), 32)
        motes(p17, T.BUBBLE, fromRGB(130, 190, 255), 6, 0.06)
        AuraKit.crackle(p17, {
            Rate = 4,
            Color = cs(fromRGB(90, 170, 255))
        })
        AuraKit.light(p17, fromRGB(60, 120, 255), 1.4, size * 2.2, 0.3, 2)
    end,
    Fathom = function(p18) -- line: 126
        -- upvalues: AuraKit (copy), AuraThemes (copy), T (copy), fromRGB (copy), cs (copy)
        local size = p18.size

        AuraKit.halo(p18, T.AURA, {
            Color = cs(fromRGB(255, 70, 90))
        })
        AuraKit.engulf(p18, T.MAGIC_FIRE, {
            scale = 0.8,
            Color = cs(fromRGB(255, 220, 120), fromRGB(255, 50, 80), fromRGB(60, 0, 70))
        })
        AuraKit.orbit(p18, T.SPARKLES, {
            count = 3,
            speed = 1.4,
            y = 0.1,
            headSize = 0.18,
            tilt = CFrame.Angles(0.4, 0, 0.2),
            head = T.GLOW
        }, {
            Color = cs(fromRGB(255, 230, 150), fromRGB(255, 60, 90)),
            Size = NumberSequence.new(size * 0.05)
        })
        AuraThemes.runes(p18, fromRGB(255, 200, 120), 3)
        AuraThemes.ring(p18, 3.5, T.ELECTRIC_RING, fromRGB(255, 90, 110))
        AuraKit.light(p18, fromRGB(255, 70, 90), 1.4, size * 2.2, 0.4, 2)
    end
}
local t4 = {}

t4[14] = function(p19) -- line: 139
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.twinkle(p19, T.SPECS, {
        Rate = 4,
        Color = cs(fromRGB(170, 210, 255))
    })
end

t4[15] = function(p20) -- line: 143
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.fall(p20, T.SNOW_BITS, {
        Rate = 4,
        Color = cs(fromRGB(220, 235, 255)),
        Size = NumberSequence.new(p20.size * 0.03)
    })
end

t4[16] = function(p21) -- line: 147
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.twinkle(p21, T.SPECK, {
        Rate = 5,
        Color = cs(fromRGB(255, 200, 110))
    })
end

t4[17] = function(p22) -- line: 151
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.twinkle(p22, T.SPARKLE, {
        Rate = 4,
        Color = cs(fromRGB(200, 255, 245))
    })
end

t4[18] = function(p23) -- line: 155
    -- upvalues: T (copy), fromRGB (copy), motes (copy)
    motes(p23, T.BUBBLE, fromRGB(170, 230, 220), 3, 0.05)
end

t4[19] = function(p24) -- line: 159
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.ground(p24, T.PUFF, {
        LightEmission = 0,
        Color = cs(fromRGB(140, 120, 110))
    })
end

t4[20] = function(p25) -- line: 163
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.fall(p25, T.SNOW_BITS, {
        Rate = 4,
        Color = cs(fromRGB(240, 235, 220)),
        Size = NumberSequence.new(p25.size * 0.03)
    })
end

t4[21] = function(p26) -- line: 167
    -- upvalues: T (copy), fromRGB (copy), motes (copy)
    motes(p26, T.BUBBLE, fromRGB(190, 225, 240), 3, 0.05)
end

t4[22] = function(p27) -- line: 171
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.fall(p27, T.SNOW_BITS, {
        Rate = 3,
        Color = cs(fromRGB(190, 210, 255)),
        Size = NumberSequence.new(p27.size * 0.03)
    })
end

t4[23] = function(p28) -- line: 175
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy)
    AuraKit.twinkle(p28, T.FIRE_SPECS, {
        Rate = 4,
        Color = cs(fromRGB(255, 120, 90))
    })
end

local t5 = {}

for i = 14, 23 do
    for _, v3 in Animals.ByBiome[i] or {} do
        local v4 = t1[v3.Rarity]
        local v5 = t4[i]

        if v4 then
            t5[v3.Id] = function(p29) -- line: 186
                -- upvalues: v4 (copy), v5 (copy)
                v4(p29)

                if v5 then
                    v5(p29)
                end
            end
        end
    end
end

return t5
