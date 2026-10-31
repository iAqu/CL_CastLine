-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function rgb(p1, p2, p3) -- line: 45
    return Color3.fromRGB(p1, p2, p3)
end

t1.List = {
    {
        Name = "Gold",
        Chance = 0.13,
        Multiplier = 1.5,
        Texture = "Gold",
        Color = Color3.fromRGB(255, 205, 40),
        Gradient = ColorSequence.new(Color3.fromRGB(255, 235, 120), rgb(230, 160, 20)),
        Vignette = {
            Outer = Color3.fromRGB(255, 120, 0),
            Inner = Color3.fromRGB(255, 235, 90)
        },
        Particles = {
            Rate = 3,
            Size = 0.35,
            LightEmission = 0.3,
            Color = Color3.fromRGB(255, 191, 0)
        }
    },
    {
        Name = "Diamond",
        Chance = 0.04,
        Multiplier = 3,
        Texture = "Diamond",
        Color = Color3.fromRGB(90, 225, 255),
        Gradient = ColorSequence.new(Color3.fromRGB(200, 245, 255), rgb(40, 170, 255)),
        Vignette = {
            Outer = Color3.fromRGB(20, 90, 255),
            Inner = Color3.fromRGB(160, 230, 255)
        },
        Particles = {
            Rate = 3.5,
            Size = 0.35,
            LightEmission = 0.3,
            Color = Color3.fromRGB(0, 213, 255)
        }
    },
    {
        Name = "Emerald",
        Chance = 0.02,
        Multiplier = 5,
        Texture = "Emerald",
        Color = Color3.fromRGB(80, 255, 120),
        Gradient = ColorSequence.new(Color3.fromRGB(170, 255, 190), rgb(20, 190, 80)),
        Vignette = {
            Outer = Color3.fromRGB(0, 110, 45),
            Inner = Color3.fromRGB(140, 255, 170)
        },
        Particles = {
            Rate = 4,
            Size = 0.35,
            LightEmission = 0.3,
            Color = Color3.fromRGB(77, 255, 0)
        }
    },
    {
        Name = "Ruby",
        Chance = 0.01,
        Multiplier = 10,
        Texture = "Ruby",
        Color = Color3.fromRGB(255, 70, 100),
        Gradient = ColorSequence.new(Color3.fromRGB(255, 170, 190), rgb(220, 20, 60)),
        Vignette = {
            Outer = Color3.fromRGB(140, 0, 30),
            Inner = Color3.fromRGB(255, 120, 150)
        },
        Particles = {
            Rate = 4.5,
            Size = 0.4,
            LightEmission = 0.3,
            Color = Color3.fromRGB(255, 0, 68)
        }
    },
    {
        Name = "Rainbow",
        Chance = 0.005,
        Multiplier = 20,
        Texture = "Rainbow",
        Scroll = Vector2.new(1.5, 0.75),
        Color = Color3.fromRGB(255, 255, 255),
        Gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 80, 80)),
            ColorSequenceKeypoint.new(0.2, rgb(255, 200, 60)),
            ColorSequenceKeypoint.new(0.4, rgb(120, 255, 120)),
            ColorSequenceKeypoint.new(0.6, rgb(90, 220, 255)),
            ColorSequenceKeypoint.new(0.8, rgb(150, 120, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 120, 230))
        }),
        Vignette = {
            Speed = 1.2,
            Rainbow = {
                Color3.fromRGB(255, 40, 40),
                Color3.fromRGB(255, 150, 0),
                Color3.fromRGB(255, 240, 0),
                Color3.fromRGB(40, 220, 60),
                Color3.fromRGB(40, 200, 255),
                Color3.fromRGB(60, 70, 255),
                rgb(180, 60, 255)
            }
        },
        Particles = {
            Rate = 6,
            Size = 0.45,
            LightEmission = 0.3,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, rgb(255, 0, 0)),
                ColorSequenceKeypoint.new(0.25, rgb(238, 0, 255)),
                ColorSequenceKeypoint.new(0.5, rgb(13, 255, 0)),
                ColorSequenceKeypoint.new(0.75, rgb(251, 255, 0)),
                ColorSequenceKeypoint.new(1, rgb(255, 115, 0))
            })
        }
    }
}
t1.Size = {
    Chance = 0.2,
    ChanceStep = 0.05,
    MaxChance = 0.4,
    Step = 1.5,
    IncomeExponent = 1.8,
    MaxSteps = 40
}
t1.Size.Titles = {
    {
        Name = "BIG",
        Color = Color3.fromRGB(255, 255, 255)
    },
    {
        Name = "LARGE",
        Color = Color3.fromRGB(255, 255, 255)
    },
    {
        Name = "HUGE",
        Color = Color3.fromRGB(255, 200, 80)
    },
    {
        Name = "COLOSSAL",
        Color = Color3.fromRGB(255, 140, 60)
    },
    {
        Name = "GIGANTIC",
        Color = Color3.fromRGB(255, 90, 70)
    },
    {
        Name = "TITANIC",
        Color = Color3.fromRGB(255, 70, 140)
    },
    {
        Name = "MONSTROUS",
        Color = Color3.fromRGB(200, 90, 255)
    },
    {
        Name = "COSMIC",
        Color = Color3.fromRGB(120, 170, 255)
    },
    {
        Name = "INFINITE",
        Color = Color3.fromRGB(170, 255, 255)
    }
}
t1.ByName = {}

for _, v1 in ipairs(t1.List) do
    t1.ByName[v1.Name] = v1
end

function t1.Get(p4) -- line: 121
    -- upvalues: t1 (copy)
    return p4 and t1.ByName[p4] or nil
end

return t1
