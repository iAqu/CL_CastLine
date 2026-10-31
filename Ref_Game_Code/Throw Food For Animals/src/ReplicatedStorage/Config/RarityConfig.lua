-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function seq(p1, p2, p3) -- line: 14
    if p3 then
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, p1),
            ColorSequenceKeypoint.new(0.5, p2),
            ColorSequenceKeypoint.new(1, p3)
        })
    end

    return ColorSequence.new(p1, p2)
end

t1.List = {
    {
        Name = "Common",
        Color = Color3.fromRGB(190, 190, 200),
        Gradient = seq(Color3.fromRGB(215, 215, 222), Color3.fromRGB(150, 150, 160))
    },
    {
        Name = "Uncommon",
        Color = Color3.fromRGB(110, 230, 90),
        Gradient = seq(Color3.fromRGB(150, 255, 120), Color3.fromRGB(50, 180, 50))
    },
    {
        Name = "Rare",
        Color = Color3.fromRGB(80, 160, 255),
        Gradient = seq(Color3.fromRGB(120, 190, 255), Color3.fromRGB(30, 90, 230))
    },
    {
        Name = "Epic",
        Color = Color3.fromRGB(190, 90, 255),
        Gradient = seq(Color3.fromRGB(215, 130, 255), Color3.fromRGB(120, 40, 220))
    },
    {
        Name = "Legendary",
        Color = Color3.fromRGB(255, 170, 40),
        Gradient = seq(Color3.fromRGB(255, 210, 90), Color3.fromRGB(255, 120, 0))
    },
    {
        Name = "Mythic",
        Color = Color3.fromRGB(255, 70, 110),
        Gradient = seq(Color3.fromRGB(255, 110, 150), Color3.fromRGB(200, 0, 60))
    },
    {
        Name = "Secret",
        Color = Color3.fromRGB(60, 60, 70),
        Gradient = seq(Color3.fromRGB(90, 90, 105), Color3.fromRGB(20, 20, 26))
    },
    {
        Name = "Divine",
        Color = Color3.fromRGB(255, 235, 120),
        Gradient = seq(Color3.fromRGB(255, 250, 200), Color3.fromRGB(255, 215, 0))
    },
    {
        Name = "Celestial",
        Color = Color3.fromRGB(140, 230, 255),
        Gradient = seq(Color3.fromRGB(120, 245, 255), Color3.fromRGB(190, 130, 255), Color3.fromRGB(255, 150, 220))
    },
    {
        Name = "Eternal",
        Color = Color3.fromRGB(175, 80, 255),
        Gradient = seq(Color3.fromRGB(255, 235, 255), Color3.fromRGB(190, 70, 255), Color3.fromRGB(60, 0, 150))
    },
    {
        Name = "Cosmic",
        Color = Color3.fromRGB(70, 110, 255),
        Gradient = seq(Color3.fromRGB(120, 255, 250), Color3.fromRGB(60, 90, 255), Color3.fromRGB(20, 0, 90))
    }
}
t1.ByName = {}

for v1, v2 in ipairs(t1.List) do
    v2.Index = v1
    t1.ByName[v2.Name] = v2
end

function t1.Get(p4) -- line: 46
    -- upvalues: t1 (copy)
    return t1.ByName[p4] or t1.List[1]
end

function t1.IndexOf(p5) -- line: 51
    -- upvalues: t1 (copy)
    local v3 = t1.ByName[p5]

    return v3 and v3.Index or 1
end

return t1
