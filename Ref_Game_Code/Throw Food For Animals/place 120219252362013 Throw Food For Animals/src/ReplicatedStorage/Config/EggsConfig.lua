-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function rgb(p1, p2, p3) -- line: 35
    return Color3.fromRGB(p1, p2, p3)
end

t1.List = {
    Halloween = {
        Name = "Halloween Egg",
        Model = "HalloweenEgg",
        Tagline = "Up to 900% of your best animal!",
        ScrollSpeed = 0,
        Pool = {
            {
                Animal = "Skeleton",
                OfBest = 1,
                Chance = 40
            },
            {
                Animal = "SkeletonHorse",
                OfBest = 1.5,
                Chance = 28
            },
            {
                Animal = "Demon",
                OfBest = 2,
                Chance = 17
            },
            {
                Animal = "ReaperSteed",
                OfBest = 3,
                Chance = 10
            },
            {
                Animal = "Reaper",
                OfBest = 5,
                Chance = 4
            },
            {
                Animal = "LivingPumpkin",
                OfBest = 9,
                Chance = 1
            }
        },
        Color = Color3.fromRGB(255, 140, 40)
    },
    Magma = {
        Name = "Magma Egg",
        Model = "MagmaEgg",
        Tagline = "Hatches a fiery beast!",
        ScrollSpeed = 0,
        Pool = {
            {
                Animal = "Cockatrice",
                Chance = 60
            },
            {
                Animal = "GargoyleBat",
                Chance = 30
            },
            {
                Animal = "Wyvern",
                Chance = 9
            },
            {
                Animal = "ClassicDragon",
                Chance = 1
            }
        },
        Color = Color3.fromRGB(255, 110, 30)
    },
    Rainbow = {
        Name = "Rainbow Egg",
        Model = "RainbowEgg",
        Pool = "All",
        Mutation = "Rainbow",
        Size = 7.59375,
        Tagline = "Random Rainbow GIGANTIC animal!",
        Rainbow = true,
        ScrollSpeed = 0.9,
        Color = Color3.fromRGB(255, 255, 255)
    }
}
t1.Hatch = {
    Duration = 6.5,
    PlotHeight = 5.5,
    HandHeight = 1.7,
    ShowTime = 5,
    SkipDelay = 1
}
t1.Order = { "Halloween", "Magma", "Rainbow" }

function t1.Get(p4) -- line: 95
    -- upvalues: t1 (copy)
    return p4 and t1.List[p4] or nil
end

local t2

require(script.Parent.ReleaseConfig).OnChanged(function() -- line: 102
    -- upvalues: t2 (ref)
    t2 = nil
end)

function t1.AllAnimals() -- line: 105
    -- upvalues: t2 (ref)
    if t2 then
        return t2
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
    local AnimalsData = require(ReplicatedStorage:WaitForChild("AnimalsData"))

    t2 = {}

    for _, v1 in ipairs(AreasConfig.List) do
        for _, v2 in ipairs(AnimalsData[v1.Key] or {}) do
            local t3 = t2

            table.insert(t3, v2.ModelName)
        end
    end

    return t2
end

function t1.Odds(p5) -- line: 120
    -- upvalues: t1 (copy)
    local v3 = t1.Get(p5)
    local v4 = if v3 then type(v3.Pool) == "table" else nil

    if not v3 or not v4 then
        return nil
    end

    local n1 = 0

    for _, v5 in ipairs(v3.Pool) do
        n1 += v5.Chance
    end

    local t4 = {}

    for _, v6 in ipairs(v3.Pool) do
        table.insert(t4, {
            Animal = v6.Animal,
            Chance = v6.Chance / n1,
            OfBest = v6.OfBest
        })
    end

    return t4
end

function t1.FormatChance(p6) -- line: 133
    local v7 = p6 * 100

    if not (v7 >= 1) then
        return string.format("%.2f", v7):gsub("0+$", ""):gsub("%.$", "") .. "%"
    end

    return string.format("%d%%", (math.floor(v7 + 0.5)))
end

return t1
