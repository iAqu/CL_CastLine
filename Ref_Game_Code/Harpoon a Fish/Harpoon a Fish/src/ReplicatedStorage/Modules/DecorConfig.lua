-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {
    RockTwinsGrey = 136348438561967,
    RockPileGrey = 129575991831479,
    RockFlat = 75098835126528,
    RockSeaBlue = 120338269381091,
    RockCrescentBlue = 137664892187116,
    RockTwinsMossy = 135133425694505,
    RockPilePurple = 73468935132522,
    RockCrescentBrown = 115185527182765,
    IceWeedTall = 123402065648677,
    Seagrass = 128425540788770,
    FireGrass = 120894189378388,
    PinkGrass = 79523525566908,
    Anemone = 95800471174408,
    TubeSponge = 102550655628825,
    BarrelSponge = 122680850536537,
    BranchCoralWhite = 91821274653078,
    BranchCoralPink = 78543319236048,
    TubeCoralPink = 73587783278538,
    TubeCoralPurple = 131471085016712,
    FanCoral = 72157883583082,
    NeonCoral = 73419264403582,
    Starfish = 110601700838509,
    Pillar = 127988289429773,
    Statue = 138094612916381,
    ToxicBarrel = 99815876604526,
    DangerSign = 139117244408683,
    Skull = 110409069615936,
    Ribcage = 77526501188019,
    TreasureChest = 126864969621137,
    SunkenGalleon = 81759075570427,
    Lighthouse = 73895624364465,
    AtlantisTemple = 119959743424727,
    RingedPlanet = 138316069173584,
    GiantSkull = 101299831282469,
    FlyingSaucer = 133641437051664,
    NeonRingworld = 102115631970332
}

local function card(p1) -- line: 42
    -- upvalues: t2 (copy)
    return t2[p1] and "rbxassetid://" .. t2[p1] or ""
end

t1.ADVANCED_PRICE = 2.5E+10
t1.SIZE_MIN = 0.25
t1.SIZE_MAX = 2
t1.SIZE_STEP = 0.25
t1.Y_MIN = -0.15
t1.Y_MAX = 1
t1.MAX_EXTRA = 200
t1.TOKEN_ICON = "rbxassetid://73921713030923"
t1.PIECES = {
    {
        id = "GreyBoulder",
        name = "Grey Boulder",
        tab = "Rocks",
        card = "RockTwinsGrey",
        size = 22,
        price = 1E+09
    },
    {
        id = "RockPile",
        name = "Rock Pile",
        tab = "Rocks",
        card = "RockPileGrey",
        size = 22,
        price = 1E+09
    },
    {
        id = "FlatStone",
        name = "Flat Stone",
        tab = "Rocks",
        card = "RockFlat",
        size = 24,
        price = 2.5E+09
    },
    {
        id = "BlueRock",
        name = "Blue Rock",
        tab = "Rocks",
        card = "RockSeaBlue",
        size = 20,
        price = 5E+09
    },
    {
        id = "CrescentRock",
        name = "Crescent Rock",
        tab = "Rocks",
        card = "RockCrescentBlue",
        size = 22,
        price = 1E+10
    },
    {
        id = "MossyRock",
        name = "Mossy Rock",
        tab = "Rocks",
        card = "RockTwinsMossy",
        size = 22,
        price = 2.5E+10
    },
    {
        id = "DarkRock",
        name = "Dark Rock",
        tab = "Rocks",
        card = "RockCrescentBrown",
        size = 20,
        price = 5E+10
    },
    {
        id = "CosmicRock",
        name = "Cosmic Rock",
        tab = "Rocks",
        card = "RockPilePurple",
        size = 20,
        price = 2.5E+11
    },
    {
        id = "Seagrass",
        name = "Seagrass",
        tab = "Plants",
        card = "Seagrass",
        size = 20,
        price = 1E+09
    },
    {
        id = "IceWeed",
        name = "Ice Weed",
        tab = "Plants",
        card = "IceWeedTall",
        size = 18,
        price = 2.5E+09
    },
    {
        id = "Anemone",
        name = "Anemone",
        tab = "Plants",
        card = "Anemone",
        size = 14,
        price = 5E+09
    },
    {
        id = "TubeSponge",
        name = "Tube Sponge",
        tab = "Plants",
        card = "TubeSponge",
        size = 14,
        price = 1E+10
    },
    {
        id = "BarrelSponge",
        name = "Barrel Sponge",
        tab = "Plants",
        card = "BarrelSponge",
        size = 16,
        price = 2.5E+10
    },
    {
        id = "FireGrass",
        name = "Fire Grass",
        tab = "Plants",
        card = "FireGrass",
        size = 18,
        price = 5E+11
    },
    {
        id = "GlowGrass",
        name = "Glow Grass",
        tab = "Plants",
        card = "PinkGrass",
        size = 18,
        price = 1E+12
    },
    {
        id = "BranchCoral",
        name = "Branch Coral",
        tab = "Coral",
        card = "BranchCoralWhite",
        size = 18,
        price = 2.5E+09
    },
    {
        id = "PinkCoral",
        name = "Pink Coral",
        tab = "Coral",
        card = "BranchCoralPink",
        size = 18,
        price = 5E+09
    },
    {
        id = "Starfish",
        name = "Starfish",
        tab = "Coral",
        card = "Starfish",
        size = 12,
        price = 1E+10
    },
    {
        id = "TubeCoral",
        name = "Tube Coral",
        tab = "Coral",
        card = "TubeCoralPink",
        size = 16,
        price = 2.5E+10
    },
    {
        id = "PurpleCoral",
        name = "Purple Coral",
        tab = "Coral",
        card = "TubeCoralPurple",
        size = 16,
        price = 5E+10
    },
    {
        id = "FanCoral",
        name = "Fan Coral",
        tab = "Coral",
        card = "FanCoral",
        size = 18,
        price = 1E+11
    },
    {
        id = "NeonCoral",
        name = "Neon Coral",
        tab = "Coral",
        card = "NeonCoral",
        size = 16,
        price = 2.5E+12
    },
    {
        id = "OldPillar",
        name = "Old Pillar",
        tab = "Ruins",
        card = "Pillar",
        size = 30,
        price = 1E+11
    },
    {
        id = "Skull",
        name = "Skull",
        tab = "Ruins",
        card = "Skull",
        size = 16,
        price = 1E+12
    },
    {
        id = "Ribcage",
        name = "Ribcage",
        tab = "Ruins",
        card = "Ribcage",
        size = 26,
        price = 5E+12
    },
    {
        id = "DangerSign",
        name = "Danger Sign",
        tab = "Ruins",
        card = "DangerSign",
        size = 16,
        price = 2.5E+13
    },
    {
        id = "ToxicBarrel",
        name = "Toxic Barrel",
        tab = "Ruins",
        card = "ToxicBarrel",
        size = 14,
        price = 1E+14
    },
    {
        id = "TridentStatue",
        name = "Trident Statue",
        tab = "Ruins",
        card = "Statue",
        size = 28,
        price = 1E+15
    }
}
t1.TOKEN_PIECES = {
    {
        id = "TreasureChest",
        name = "Treasure Chest",
        tier = "Mythic",
        size = 26
    },
    {
        id = "SunkenGalleon",
        name = "Sunken Galleon",
        tier = "Mythic",
        size = 40
    },
    {
        id = "Lighthouse",
        name = "Lighthouse",
        tier = "Legendary",
        size = 28
    },
    {
        id = "AtlantisTemple",
        name = "Atlantis Temple",
        tier = "Legendary",
        size = 40
    },
    {
        id = "RingedPlanet",
        name = "Ringed Planet",
        tier = "Legendary",
        size = 30
    },
    {
        id = "GiantSkull",
        name = "Giant Skull",
        tier = "Rare",
        size = 26
    },
    {
        id = "FlyingSaucer",
        name = "Flying Saucer",
        tier = "Rare",
        size = 30
    },
    {
        id = "NeonRingworld",
        name = "Neon Ringworld",
        tier = "Rare",
        size = 30
    }
}
t1.TOKEN_PRICE = {
    Rare = 100,
    Legendary = 300,
    Mythic = 750
}
t1.TOKEN_ODDS = {
    Rare = 75,
    Legendary = 15,
    Mythic = 10
}
t1.TIERS = { "Mythic", "Legendary", "Rare" }
t1.SLOTS = 3
t1.COOLDOWN = 1
t1.DAY = 86400
t1.START = 20408
t1.MAX_H = 28

for _, v2 in ipairs(t1.TOKEN_PIECES) do
    v2.tab = "BlackMarket"
    v2.card = v2.id
    v2.tokens = t1.TOKEN_PRICE[v2.tier]
    table.insert(t1.PIECES, v2)
end

t1.TABS = {
    {
        key = "Rocks",
        name = "ROCKS",
        icon = "RockTwinsGrey"
    },
    {
        key = "Plants",
        name = "PLANTS",
        icon = "Seagrass"
    },
    {
        key = "Coral",
        name = "CORAL",
        icon = "TubeCoralPink"
    },
    {
        key = "Ruins",
        name = "RUINS",
        icon = "Pillar"
    },
    {
        key = "BlackMarket",
        name = "BLACK MARKET",
        icon = nil
    }
}

local t3 = {}

for v3, v4 in ipairs(t1.PIECES) do
    v4.order = v3
    t3[v4.id] = v4
end

function t1.Get(p2) -- line: 124
    -- upvalues: t3 (copy)
    return t3[p2]
end

function t1.Card(p3) -- line: 126
    -- upvalues: t2 (copy)
    local card = p3.card

    return t2[card] and "rbxassetid://" .. t2[card] or ""
end

function t1.TabIcon(p4) -- line: 127
    -- upvalues: t2 (copy)
    if not p4.icon then
        return "rbxassetid://73921713030923"
    end

    local icon = p4.icon

    return t2[icon] and "rbxassetid://" .. t2[icon] or ""
end

function t1.InTab(p5) -- line: 129
    -- upvalues: t1 (copy)
    local t4 = {}

    for _, v6 in ipairs(t1.PIECES) do
        if v6.tab == p5 then
            table.insert(t4, v6)
        end
    end

    return t4
end

function t1.FreeSlots(p6) -- line: 135
    return (math.clamp(math.floor(p6 or 1), 1, 11) - 1) * 2 + 10
end

local function two(p7) -- line: 139
    if p7 <= 0 then
        return 0
    end

    local v10 = 10 ^ (math.floor((math.log10(p7))) - 1)

    return math.floor(p7 / v10 + 0.5) * v10
end

function t1.SlotPrice(p8) -- line: 147
    -- upvalues: t1 (copy)
    if p8 < 1 or t1.MAX_EXTRA < p8 then
        return nil
    end

    local v12 = 1E+09 * 1.109752496412072 ^ (p8 - 1)

    if v12 <= 0 then
        return 0
    end

    local v14 = 10 ^ (math.floor((math.log10(v12))) - 1)

    return math.floor(v12 / v14 + 0.5) * v14
end

function t1.Day(p9) -- line: 153
    -- upvalues: t1 (copy)
    return (math.floor((p9 or os.time()) / t1.DAY))
end

function t1.SecondsLeft(p10) -- line: 154
    -- upvalues: t1 (copy)
    p10 = p10 or os.time()

    return (t1.Day(p10) + 1) * t1.DAY - p10
end

local function draw(p11, p12) -- line: 158
    -- upvalues: t1 (copy)
    local v18 = Random.new(p11 * 7919 + 31)
    local t5 = {}
    local t6 = {}

    for _ = 1, t1.SLOTS do
        local v19 = v18:NextNumber() * 100
        local TOKEN_ODDS = t1.TOKEN_ODDS
        local v20 = if v19 < TOKEN_ODDS.Mythic then "Mythic" elseif v19 < TOKEN_ODDS.Mythic + TOKEN_ODDS.Legendary then "Legendary" else "Rare"
        local v21 = table.find(t1.TIERS, v20)
        local t7 = {}

        for i = v21, #t1.TIERS do
            table.insert(t7, t1.TIERS[i])
        end

        for j = v21 - 1, 1, -1 do
            table.insert(t7, t1.TIERS[j])
        end

        local v24

        for _, v25 in ipairs(t7) do
            local t8 = {}

            for _, v26 in ipairs(t1.TOKEN_PIECES) do
                if v26.tier == v25 and not p12[v26.id] and not t6[v26.id] then
                    table.insert(t8, v26.id)
                end
            end

            if #t8 > 0 then
                v24 = t8[v18:NextInteger(1, #t8)]
                break
            end

            v24 = nil
        end

        if v24 then
            t6[v24] = true
            table.insert(t5, v24)
        end
    end

    return t5
end

local t9 = {}
local v27 = t1.START - 1

function t1.Shop(p13) -- line: 187
    -- upvalues: t1 (copy), draw (copy), t9 (copy), v27 (ref)
    p13 = p13 or t1.Day()

    if p13 < t1.START then
        return (draw(p13, {}))
    end

    for i = v27 + 1, p13 do
        local t10 = {}

        for j = 1, t1.COOLDOWN do
            for _, v29 in ipairs(t9[i - j] or {}) do
                t10[v29] = true
            end
        end

        t9[i] = draw(i, t10)
        t9[i - t1.COOLDOWN - 2] = nil
        v27 = i
    end

    return t9[p13] or draw(p13, {})
end

function t1.OnSale(p14) -- line: 201
    -- upvalues: t1 (copy)
    for _, v30 in ipairs(t1.Shop()) do
        if v30 == p14 then
            return true
        end
    end

    return false
end

return t1
