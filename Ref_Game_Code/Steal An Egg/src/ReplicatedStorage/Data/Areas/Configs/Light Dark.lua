-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    { "Dove", 37.51 },
    { "Lamb", 26.27 },
    { "Moth", 16.83 },
    { "Peacock", 13.96 },
    { "Jellyfish", 4.36 },
    { "Centaur", 0.74 },
    { "Pegasus", 0.31 },
    { "ArchAngel", 0.02 }
}
local t2 = {
    { "Flame Sprite", 37.51 },
    { "Toro", 26.27 },
    { "Imp", 16.83 },
    { "Demon Hound", 13.96 },
    { "Dark Gargoyle", 4.36 },
    { "RazorFang", 0.74 },
    { "Skeleton Horse", 0.31 },
    { "World Burner", 0.02 }
}
local t3 = {
    { "Moth", 23.23 },
    { "Peacock", 19.27 },
    { "Jellyfish", 6.02 },
    { "Centaur", 1.02 },
    { "Pegasus", 0.43 },
    { "ArchAngel", 0.03 },
    { "Imp", 23.23 },
    { "Demon Hound", 19.27 },
    { "Dark Gargoyle", 6.02 },
    { "RazorFang", 1.02 },
    { "Skeleton Horse", 0.43 },
    { "World Burner", 0.03 }
}

local function poolOf(p1) -- line: 41
    local t4 = {}

    for _, v1 in p1 do
        table.insert(t4, v1[1])
    end

    return t4
end

local v3 = table.move(t2, 1, #t2, #t1 + 1, table.clone(t1))
local t5 = {
    DisplayName = "Angels & Demons",
    Emoji = "☯️",
    GuardId = "Light Dark",
    Icon = "rbxassetid://129135259472825",
    IndexBatGearId = "Light Dark Staff",
    Lighting = nil,
    _id = "Light Dark",
    Color = Color3.fromRGB(196, 148, 255),
    DropTable = v3,
    Rarity = require(game:GetService("ReplicatedStorage").Data.Rarity).Rarities.LightDark,
    Reveal = {
        Flag = "LightDarkReveal",
        RevealSubBiome = "Mixed"
    }
}
local t7 = {
    Id = "Light",
    DisplayName = "Angels",
    Emoji = "👼",
    Weight = 45,
    LuckRolls = 1,
    Props = "Light",
    Vfx = nil,
    Lighting = nil,
    Announcement = "☀️ The Light has risen over the Angels & Demons biome!"
}
local t8 = {}

for _, v4 in t1 do
    table.insert(t8, v4[1])
end

t7.Pool = t8
t7.DropTable = t1
t7.Color = Color3.fromRGB(255, 255, 255)
t7.Gradient = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 226, 255))
})
t7.GuardIds = { "Light Dark Light" }

local t9 = {
    Id = "Dark",
    DisplayName = "Demons",
    Emoji = "😈",
    Weight = 45,
    LuckRolls = 1,
    Props = "Dark",
    Vfx = nil,
    Lighting = nil,
    Announcement = "🌑 The Dark has fallen over the Angels & Demons biome!"
}
local t10 = {}

for _, v6 in t2 do
    table.insert(t10, v6[1])
end

t9.Pool = t10
t9.DropTable = t2
t9.Color = Color3.fromRGB(224, 46, 46)
t9.Gradient = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 92, 92)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 18, 18))
})
t9.GuardIds = { "Light Dark Dark" }

local t11 = {
    Id = "Mixed",
    DisplayName = "Angels & Demons",
    Emoji = "☯️",
    Weight = 10,
    LuckRolls = 1,
    Props = "MixedRealm",
    HidesZoneFloor = true,
    Vfx = nil,
    Lighting = nil,
    Announcement = "🌗 A rare Mixed night! The rarest Angels & Demons eggs share the biome tonight!"
}
local t12 = {}

for _, v8 in t3 do
    table.insert(t12, v8[1])
end

t11.Pool = t12
t11.DropTable = t3
t11.Color = Color3.fromRGB(255, 150, 150)
t11.Gradient = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 246, 246)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 92, 92)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 18, 18))
})
t11.GuardIds = { "Light Dark Mixed" }
t5.SubBiomes = {
    t7,
    t9,
    t11
}

return table.freeze(t5)
