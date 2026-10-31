-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GameConfig = require(script.Parent.GameConfig)
local t1 = {}

local function rgb(p1, p2, p3) -- line: 25
    return Color3.fromRGB(p1, p2, p3)
end

t1.BaseSlots = GameConfig.Plot.MaxPlacedAnimals
t1.SegmentLength = 11.75
t1.MaxGrowth = 2
t1.SignOffset = Vector3.new(-8.5, 0, -24.6)
t1.SignRange = 22
t1.Upgrades = {
    {
        Slots = 12,
        Price = 4E+07,
        Grow = 1,
        Style = "Wood"
    },
    {
        Slots = 14,
        Price = 2E+14,
        Grow = 2,
        Style = "Wood"
    },
    {
        Slots = 16,
        Price = 5E+19,
        Grow = 2,
        Style = "Iron"
    },
    {
        Slots = 18,
        Price = 1E+23,
        Grow = 2,
        Style = "Gold"
    },
    {
        Slots = 20,
        Price = 4.999999999999999E+24,
        Grow = 2,
        Style = "Diamond"
    }
}
t1.Styles = {
    Wood = {
        Name = "Wooden Fence"
    },
    Iron = {
        Name = "Iron Fence",
        Reflectance = 0.05,
        Post = Color3.fromRGB(70, 76, 88),
        Rail = Color3.fromRGB(150, 158, 172)
    },
    Gold = {
        Name = "Gold Fence",
        Reflectance = 0.18,
        Post = Color3.fromRGB(214, 148, 18),
        Rail = Color3.fromRGB(255, 210, 66),
        Sparkles = ColorSequence.new(Color3.fromRGB(255, 240, 150), rgb(255, 190, 40))
    },
    Diamond = {
        Name = "Diamond Fence",
        Reflectance = 0.22,
        Post = Color3.fromRGB(36, 150, 220),
        Rail = Color3.fromRGB(160, 238, 255),
        Sparkles = ColorSequence.new(Color3.fromRGB(220, 250, 255), rgb(90, 210, 255))
    }
}

function t1.Get(p4) -- line: 52
    -- upvalues: t1 (copy)
    return t1.Upgrades[p4]
end

function t1.MaxLevel() -- line: 56
    -- upvalues: t1 (copy)
    return #t1.Upgrades
end

function t1.SlotsFor(p5) -- line: 61
    -- upvalues: t1 (copy)
    local v1 = t1.Upgrades[p5 or 0]

    return v1 and v1.Slots or t1.BaseSlots
end

function t1.GrowFor(p6) -- line: 67
    -- upvalues: t1 (copy)
    local v2 = t1.Upgrades[p6 or 0]

    if not v2 then
        return 0
    end

    return math.min(v2.Grow, t1.MaxGrowth) or 0
end

function t1.StyleFor(p7) -- line: 72
    -- upvalues: t1 (copy)
    local v3 = t1.Upgrades[p7 or 0]

    return v3 and v3.Style or "Wood"
end

return t1
