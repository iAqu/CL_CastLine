-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DEPTH = 300,
    NAMES = { "Shipwreck", "Ruins", "Toxic", "Bone", "Lava", "Void", "Cosmic" },
    COLORS = {
        {
            Color3.fromRGB(70, 190, 255),
            Color3.fromRGB(0, 45, 90)
        },
        {
            Color3.fromRGB(95, 150, 255),
            Color3.fromRGB(10, 30, 95)
        },
        {
            Color3.fromRGB(120, 240, 70),
            Color3.fromRGB(15, 70, 10)
        },
        {
            Color3.fromRGB(175, 195, 225),
            Color3.fromRGB(25, 35, 55)
        },
        {
            Color3.fromRGB(255, 120, 60),
            Color3.fromRGB(90, 20, 0)
        },
        {
            Color3.fromRGB(185, 110, 255),
            Color3.fromRGB(45, 10, 90)
        },
        {
            Color3.fromRGB(255, 110, 205),
            Color3.fromRGB(95, 10, 70)
        }
    }
}

t1.FIRST = t1.FIRST or 1
t1.GLOBAL_NAMES = {
    "Shipwreck",
    "Ruins",
    "Toxic",
    "Bone",
    "Lava",
    "Void",
    "Cosmic",
    "Primal",
    "Meteorite",
    "Extinction"
}
t1.GLOBAL_COLORS = {
    {
        Color3.fromRGB(70, 190, 255),
        Color3.fromRGB(0, 45, 90)
    },
    {
        Color3.fromRGB(95, 150, 255),
        Color3.fromRGB(10, 30, 95)
    },
    {
        Color3.fromRGB(120, 240, 70),
        Color3.fromRGB(15, 70, 10)
    },
    {
        Color3.fromRGB(175, 195, 225),
        Color3.fromRGB(25, 35, 55)
    },
    {
        Color3.fromRGB(255, 120, 60),
        Color3.fromRGB(90, 20, 0)
    },
    {
        Color3.fromRGB(185, 110, 255),
        Color3.fromRGB(45, 10, 90)
    },
    {
        Color3.fromRGB(255, 110, 205),
        Color3.fromRGB(95, 10, 70)
    },
    {
        Color3.fromRGB(120, 215, 70),
        Color3.fromRGB(20, 65, 10)
    },
    {
        Color3.fromRGB(255, 85, 50),
        Color3.fromRGB(95, 15, 5)
    },
    {
        Color3.fromRGB(205, 195, 180),
        Color3.fromRGB(20, 16, 16)
    }
}

function t1.Global(p1) -- line: 41
    -- upvalues: t1 (copy)
    return p1 + t1.FIRST - 1
end

function t1.At(p2) -- line: 46
    -- upvalues: t1 (copy)
    return (math.clamp(math.floor(-p2 / t1.DEPTH) + 1, 1, #t1.NAMES))
end

return t1
