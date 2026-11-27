-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuraKit = require(script.Parent.AuraKit)
local T, seq = AuraKit.T, AuraKit.seq
local fromRGB, new, new2 = Color3.fromRGB, NumberRange.new, Vector3.new
local cs = AuraKit.cs
local Random = Enum.ParticleFlipbookMode.Random
local t1 = {
    GOLD = fromRGB(255, 205, 80),
    PALE_GOLD = fromRGB(255, 235, 170),
    PEARL = fromRGB(255, 250, 240),
    VOID = fromRGB(150, 70, 230),
    STORM = fromRGB(120, 215, 255),
    MAGENTA = fromRGB(255, 50, 220),
    CYAN = fromRGB(0, 240, 255),
    ring = function(p1, p2, p3, p4) -- ring | line: 30
        -- upvalues: AuraKit (copy), seq (copy), new (copy), cs (copy)
        local size = p1.size

        AuraKit.pulse(p1, p2, 1, p3, {
            Drag = 0,
            Color = cs(p4),
            Size = seq(0, size * 0.45, 1, size * 1.4),
            Transparency = seq(0, 0.5, 1, 1),
            Speed = new(0),
            Lifetime = new(0.85),
            Rotation = new(0),
            RotSpeed = new(0)
        })
    end,
    runes = function(p5, p6, p7) -- runes | line: 36
        -- upvalues: AuraKit (copy), T (copy), seq (copy), cs (copy), Random (copy)
        local size = p5.size

        AuraKit.rise(p5, T.RUNES, {
            LightEmission = 0.6,
            Color = cs(p6),
            Size = seq(0, 0, 0.15, size * 0.12, 0.85, size * 0.1, 1, 0),
            FlipbookMode = Random,
            Rate = p7
        })
    end,
    voidSmoke = function(p8, p9, p10, p11) -- voidSmoke | line: 42
        -- upvalues: AuraKit (copy), T (copy), seq (copy), new2 (copy), cs (copy)
        local size = p8.size

        AuraKit.engulf(p8, T.GHOST_SMOKE, {
            LightEmission = 0,
            Color = cs(p9, p10),
            Transparency = seq(0, 1, 0.25, 0.35, 0.7, 0.55, 1, 1),
            Acceleration = new2(0, size * 0.12, 0),
            Rate = (p11 or 40) * p8.k
        })
    end
}

function t1.radiant(p12, p13) -- line: 48
    -- upvalues: AuraKit (copy), T (copy), fromRGB (copy), cs (copy), t1 (copy)
    local size = p12.size

    AuraKit.halo(p12, T.GLOW, {
        Color = cs(t1.PALE_GOLD)
    })
    AuraKit.orbit(p12, T.SPARKLES, {
        speed = 1.3,
        y = 0.1,
        headSize = 0.22,
        count = p13,
        tilt = CFrame.Angles(0.35, 0, 0.15),
        head = T.THIN_RING
    }, {
        Color = cs(t1.PEARL, t1.GOLD),
        Size = NumberSequence.new(size * 0.05)
    })
    AuraKit.twinkle(p12, T.SHINE, {
        Rate = 8,
        Color = cs(fromRGB(255, 245, 205))
    })
    t1.ring(p12, 3.5, T.THIN_RING, t1.PALE_GOLD)
    AuraKit.light(p12, t1.PALE_GOLD, 1.2, size * 2)
end

function t1.tempest(p14, p15) -- line: 58
    -- upvalues: AuraKit (copy), T (copy), seq (copy), fromRGB (copy), new2 (copy), cs (copy), t1 (copy)
    local size = p14.size

    AuraKit.engulf(p14, T.DARK_CLOUD, {
        LightEmission = 0,
        Color = cs(fromRGB(95, 105, 125), fromRGB(30, 34, 45)),
        Transparency = seq(0, 1, 0.25, 0.4, 0.7, 0.6, 1, 1),
        Acceleration = new2(0, size * 0.1, 0),
        Rate = 35 * p14.k
    })
    AuraKit.crackle(p14, {
        Rate = 5,
        Color = cs(p15 or t1.STORM)
    })
    AuraKit.twinkle(p14, T.SPECS, {
        Rate = 9,
        Color = cs(fromRGB(200, 245, 255))
    })
    AuraKit.light(p14, p15 or t1.STORM, 1.2, size * 2, 0.5, 6)
end

function t1.glitched(p16, p17) -- line: 67
    -- upvalues: AuraKit (copy), T (copy), seq (copy), new (copy), cs (copy), t1 (copy), Random (copy)
    local size = p16.size

    AuraKit.twinkle(p16, T.GLITCH, {
        LightEmission = 0.8,
        Rate = 10,
        Color = cs(t1.MAGENTA, t1.CYAN),
        Size = seq(0, size * 0.14, 1, size * 0.14),
        Lifetime = new(0.12, 0.3),
        RotSpeed = new(0),
        Rotation = new(0),
        FlipbookMode = Random
    })
    AuraKit.rise(p16, T.GLITCH, {
        LightEmission = 0.8,
        Color = cs(t1.CYAN, t1.MAGENTA),
        Size = seq(0, 0, 0.1, size * 0.1, 0.9, size * 0.1, 1, 0),
        Rotation = new(0),
        RotSpeed = new(0),
        Speed = new(size * 0.1, size * 0.25),
        FlipbookMode = Random,
        Rate = p17 or 5
    })
    AuraKit.crackle(p16, {
        Rate = 4,
        texture = T.GLITCH_LINES,
        Color = cs(t1.CYAN, t1.MAGENTA),
        Size = NumberSequence.new(size * 0.35),
        Lifetime = new(0.08, 0.16)
    })
    AuraKit.light(p16, t1.MAGENTA, 1.1, size * 1.8, 0.6, 9)
end

return t1
