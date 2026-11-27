-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local FishDisplay = require(Parent:WaitForChild("FishDisplay"))
local ShopConfig = require(Parent:WaitForChild("ShopConfig"))
local WeatherConfig = require(Parent:WaitForChild("WeatherConfig"))
local RarityDisplay = require(Parent:WaitForChild("RarityDisplay"))
local Zones = require(Parent:WaitForChild("Zones"))
local t1 = {
    MODES = { "NORMAL", "WEATHER", "SPECIAL" }
}

local function ofRarity(p1, p2) -- line: 38
    -- upvalues: FishDisplay (copy)
    local t2 = {}

    for v1, v2 in pairs(FishDisplay) do
        if type(v2) == "table" and v2.rarity == p1 and (not p2 or not p2[v1]) then
            t2[#t2 + 1] = v1
        end
    end

    table.sort(t2, function(p3, p4) -- line: 43
        -- upvalues: FishDisplay (copy)
        return FishDisplay[p3].display < FishDisplay[p4].display
    end)

    return t2
end

local t3 = {}

local function eggList(p5) -- line: 47
    -- upvalues: FishDisplay (copy), t3 (copy)
    local t4 = {}

    for _, v3 in ipairs(p5 or {}) do
        if FishDisplay[v3.fish] and not t3[v3.fish] then
            t4[#t4 + 1] = v3.fish
            t3[v3.fish] = true
        end
    end

    return t4
end

local v4 = eggList(ShopConfig.HELL_EGG_FISH)
local v5 = eggList(ShopConfig.VOID_EGG_FISH)
local v6 = eggList(ShopConfig.AURORA_EGG_FISH)
local t5 = {}

t1.TABS = {}
t1.BY_ID = t5

local function addTab(p6) -- line: 64
    -- upvalues: t1 (copy)
    p6.species = {}

    for _, v7 in ipairs(p6.sections) do
        for _, v8 in ipairs(v7.species) do
            p6.species[#p6.species + 1] = v8
        end
    end

    if p6.each == nil and p6.done == nil then
        p6.claims = p6.ladder == true
    else
        p6.claims = true
    end

    t1.TABS[#t1.TABS + 1] = p6
    t1.BY_ID[p6.id] = p6
end

local t6 = {
    bar = Color3.fromRGB(255, 92, 30),
    ink = Color3.fromRGB(255, 150, 40),
    stroke = Color3.fromRGB(95, 12, 0)
}
local t7 = {
    bar = Color3.fromRGB(150, 55, 255),
    ink = Color3.fromRGB(215, 150, 255),
    stroke = Color3.fromRGB(40, 5, 80)
}
local t8 = {
    bar = Color3.fromRGB(40, 200, 160),
    ink = Color3.fromRGB(150, 255, 215),
    stroke = Color3.fromRGB(16, 10, 44)
}

t1.JURASSIC_TITAN = {
    bar = Color3.fromRGB(22, 92, 40),
    ink = Color3.fromRGB(120, 225, 130),
    stroke = Color3.fromRGB(4, 30, 12)
}

local TitanConfig = require(Parent:WaitForChild("TitanConfig"))

local function titansOf(p7) -- line: 91
    -- upvalues: FishDisplay (copy), TitanConfig (copy)
    local t9 = {}
    local t10 = {}

    for _, v9 in ipairs(p7) do
        local v10 = TitanConfig.SPECIES[v9.species]

        if FishDisplay[v9.species] then
            t9[#t9 + 1] = v9.species
        end

        if v10 and v10.shiny and FishDisplay[v10.shiny] then
            t10[#t10 + 1] = v10.shiny
        end
    end

    for _, v11 in ipairs(t10) do
        t9[#t9 + 1] = v11
    end

    return t9
end

addTab({
    id = 106,
    mode = "SPECIAL",
    key = "Titan",
    title = "TITANS",
    sections = {
        {
            key = "Titan",
            title = "ORIGIN TITANS",
            species = titansOf(TitanConfig.ORIGIN_RISES)
        },
        {
            key = "JurassicTitan",
            title = "JURASSIC TITANS",
            species = titansOf(TitanConfig.JURASSIC_RISES),
            look = t1.JURASSIC_TITAN
        }
    }
})
addTab({
    id = 101,
    mode = "SPECIAL",
    key = "Unknown",
    title = "UNKNOWN",
    each = {
        key = "Secret"
    },
    sections = {
        {
            key = "Unknown",
            title = "UNKNOWN",
            species = ofRarity("Unknown", t3)
        }
    }
})
addTab({
    id = 102,
    mode = "SPECIAL",
    key = "Eggs",
    title = "EGGS",
    ladder = true,
    sections = {
        {
            key = "HellEgg",
            title = "HELL EGG",
            species = v4,
            look = t6
        },
        {
            key = "VoidEgg",
            title = "VOIDSPARK EGG",
            species = v5,
            look = t7
        },
        {
            key = "AuroraEgg",
            title = "AURORA EGG",
            species = v6,
            look = t8
        }
    }
})

local t11 = {
    { "TurkeyFish" },
    { "AbyssalFlameLeviathan", "PumpkinGuppy" },
    { "Jesterwraith", "MummifiedMosasaur" },
    { "Dreadsaber", "BonedMosasaur", "AbominatedMaw" },
    { "Hydrax", "Tricerosaurus", "Fossilshark" },
    { "WishboneWyrm", "PecanPike", "TurkeyGuppy" },
    { "Devilshark", "Oroborus", "Mimefish", "MrHotdog", "Jestershark", "StrangewaterTylosaurus" },
    { "Drillwyrm", "Timefish", "Kingwhale" },
    { "GhostMegalodon" },
    { "GreenlandHydra", "Mimic", "Fatty", "DeathGuppy" },
    { "Rainbowborous" },
    { "IdeaFish" },
    { "Jormungandr" }
}
local t12 = {}
local t13 = {}

for _, v12 in ipairs(t11) do
    for _, v13 in ipairs(v12) do
        if FishDisplay[v13] and not t3[v13] and not t13[v13] then
            t12[#t12 + 1] = v13
            t13[v13] = true
        end
    end
end

local t14 = {}

for _, v14 in pairs(require(Parent:WaitForChild("ThanksgivingConfig")).FISH) do
    for _, v15 in ipairs(v14) do
        t14[v15] = true
    end
end

for _, v16 in ipairs((ofRarity("Exclusive", t3))) do
    if not t13[v16] and not t14[v16] then
        t12[#t12 + 1] = v16
        t13[v16] = true
    end
end

addTab({
    id = 104,
    mode = "SPECIAL",
    key = "Exclusive",
    title = "EXCLUSIVE",
    sections = {
        {
            key = "Exclusive",
            title = "EXCLUSIVE",
            species = t12
        }
    }
})

local t15 = {
    Voidstorm = "VoidstormHarpoon",
    PinkMoon = "PinkMoonHarpoon",
    MeteorShower = "MeteorShowerHarpoon",
    FossilStorm = "FossilStormHarpoon"
}
local t16 = {
    Voidstorm = 201,
    PinkMoon = 202,
    MeteorShower = 203,
    FossilStorm = 204
}
local t17 = {}

for v17, v18 in ipairs(RarityDisplay.order) do
    t17[v18] = v17
end

local t18 = {}
local t19 = {}

for _, v19 in ipairs(WeatherConfig.ORDER) do
    t18[#t18 + 1] = {
        shift = 0,
        id = v19,
        w = WeatherConfig.WEATHERS[v19]
    }
    t19[v19] = true
end

for _, v20 in ipairs(WeatherConfig.JURASSIC_ORDER or {}) do
    if not t19[v20] then
        t18[#t18 + 1] = {
            id = v20,
            w = WeatherConfig.WEATHERS[v20],
            shift = #Zones.HUB_NAMES
        }
        t19[v20] = true
    end
end

for _, v21 in ipairs(WeatherConfig.INDEX_ELSEWHERE or {}) do
    if not t19[v21.id] then
        t18[#t18 + 1] = {
            id = v21.id,
            w = v21,
            shift = v21.zoneShift
        }
        t19[v21.id] = true
    end
end

table.sort(t18, function(p8, p9) -- line: 201
    -- upvalues: t16 (copy)
    return (t16[p8.id] or 999) < (t16[p9.id] or 999)
end)

for _, v22 in ipairs(t18) do
    local id, w = v22.id, v22.w

    if w.fish and t16[id] then
        local t20 = {}
        local t21 = {}

        for v23, v24 in pairs(w.fish) do
            if FishDisplay[v23] then
                if not t20[v24] then
                    t20[v24] = {}
                    t21[#t21 + 1] = v24
                end

                table.insert(t20[v24], v23)
            end
        end

        table.sort(t21)

        local t22 = {}

        for _, v26 in ipairs(t21) do
            local v27 = t20[v26]

            table.sort(v27, function(p10, p11) -- line: 219
                -- upvalues: FishDisplay (copy), t17 (copy)
                local v28 = t17[FishDisplay[p10].rarity] or 99
                local v29 = t17[FishDisplay[p11].rarity] or 99

                if v28 == v29 then
                    return FishDisplay[p10].display < FishDisplay[p11].display
                end

                return v28 < v29
            end)

            local v30 = v26 + v22.shift
            local v31 = Zones.GLOBAL_COLORS[v30]

            t22[#t22 + 1] = {
                key = id .. "Z" .. v26,
                title = string.upper(Zones.GLOBAL_NAMES[v30] or "ZONE " .. v26),
                species = v27,
                look = v31 and {
                    bar = v31[1],
                    ink = v31[1]:Lerp(Color3.new(1, 1, 1), 0.35),
                    stroke = v31[2]
                } or t7
            }
        end

        addTab({
            mode = "WEATHER",
            id = t16[id],
            key = id,
            title = w.name or string.upper(id),
            sections = t22,
            each = {
                byRarity = true
            },
            done = t15[id] and {
                harpoon = t15[id]
            } or nil
        })
    end
end

local t25 = {}
local t26 = {}

for v33, v34 in pairs(WeatherConfig.HALLOWEEN.fish) do
    if FishDisplay[v33] then
        if not t25[v34] then
            t25[v34] = {}
            t26[#t26 + 1] = v34
        end

        table.insert(t25[v34], v33)
    end
end

table.sort(t26)

local t27 = {}

for _, v36 in ipairs(t26) do
    local v37 = t25[v36]

    table.sort(v37, function(p12, p13) -- line: 250
        -- upvalues: FishDisplay (copy), t17 (copy)
        local v38 = t17[FishDisplay[p12].rarity] or 99
        local v39 = t17[FishDisplay[p13].rarity] or 99

        if v38 == v39 then
            return FishDisplay[p12].display < FishDisplay[p13].display
        end

        return v38 < v39
    end)

    local v40 = Zones.COLORS[v36]

    t27[#t27 + 1] = {
        key = "HalloweenZ" .. v36,
        title = string.upper(Zones.NAMES[v36] or "ZONE " .. v36),
        species = v37,
        look = v40 and {
            bar = v40[1],
            ink = v40[1]:Lerp(Color3.new(1, 1, 1), 0.35),
            stroke = v40[2]
        } or t6
    }
end

addTab({
    id = 105,
    mode = "SPECIAL",
    key = "Halloween",
    title = "HALLOWEEN 2026",
    sections = t27,
    done = {
        harpoon = "HallowedHarpoon"
    }
})

local ThanksgivingConfig = require(Parent:WaitForChild("ThanksgivingConfig"))
local t29 = {}

for _, v42 in ipairs(ThanksgivingConfig.TIERS) do
    local t30 = {}

    for _, v43 in ipairs(ThanksgivingConfig.FISH[v42] or {}) do
        if FishDisplay[v43] then
            t30[#t30 + 1] = v43
        end
    end

    if #t30 > 0 then
        t29[#t29 + 1] = {
            key = v42,
            title = string.upper(v42),
            species = t30
        }
    end
end

addTab({
    id = 107,
    mode = "SPECIAL",
    key = "Thanksgiving",
    title = "THANKSGIVING 2026",
    sections = t29,
    done = {
        harpoon = "GratefulHarpoon"
    }
})

local t31 = {}
local t32 = {}

t1.LIST = {}
t1.IS = t31
t1.TAB_OF = t32

for _, v44 in ipairs(t1.TABS) do
    for _, v45 in ipairs(v44.species) do
        if not t1.IS[v45] then
            t1.LIST[#t1.LIST + 1] = v45
            t1.IS[v45] = true
            t1.TAB_OF[v45] = v44.id
        end
    end
end

t1.HOW = {
    GhostMegalodon = "FIRST EVER LIMITED! ONLY 300 SOLD!",
    Devilshark = "In the Fish Shop since 10/17",
    Jesterwraith = "Serial fish of the 10/24 Fish Shop",
    MummifiedMosasaur = "Serial fish of the 10/24 Fish Shop",
    BonedMosasaur = "Serial fish of the 11/7 Fish Shop",
    Dreadsaber = "Serial fish of the 11/7 Fish Shop",
    AbominatedMaw = "Serial fish of the 11/7 Fish Shop",
    StrangewaterTylosaurus = "In the Fish Shop since 11/7",
    Hydrax = "Serial fish of the 11/14 Fish Shop",
    Tricerosaurus = "Serial fish of the 11/14 Fish Shop",
    Fossilshark = "Serial fish of the 11/14 Fish Shop",
    WishboneWyrm = "Serial fish of the 11/21 Fish Shop",
    PecanPike = "Serial fish of the 11/21 Fish Shop",
    TurkeyGuppy = "Serial fish of the 11/21 Fish Shop",
    Drillwyrm = "Obtained during the FIRST ADMIN ABUSE! (10/17)",
    Timefish = "Obtained during the FIRST ADMIN ABUSE! (10/17)",
    Kingwhale = "Obtained during the FIRST ADMIN ABUSE! (10/17)",
    Oroborus = "In the Fish Shop since 10/17",
    Mimefish = "In the Fish Shop since 10/18",
    MrHotdog = "In the Fish Shop since 10/18",
    Jestershark = "In the Fish Shop since 10/21",
    Rainbowborous = "Awarded only to TRUE HARPOONERS",
    IdeaFish = "For players with a vivid imagination",
    GreenlandHydra = "From the Hydra Pack",
    Fatty = "Earned by buying Fat Packs",
    DeathGuppy = "Bone Starter Pack",
    Mimic = "Daily reward (Day 2)",
    Jormungandr = "Not obtainable yet"
}
t1.HOW_HALLOWEEN = {}

local PumpkinShopConfig = require(Parent:WaitForChild("PumpkinShopConfig"))

for _, v46 in ipairs(PumpkinShopConfig.SHOP) do
    if v46.kind == "fish" and v46.price then
        local v47 = tostring(v46.price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        t1.HOW_HALLOWEEN[v46.fish] = "Bought at the Pumpkin Shop for " .. v47 .. " hats during Halloween 2026"
    end
end

local ThanksgivingConfig2 = require(Parent:WaitForChild("ThanksgivingConfig"))

for _, v48 in pairs(ThanksgivingConfig2.FISH) do
    for _, v49 in ipairs(v48) do
        t1.HOW_HALLOWEEN[v49] = "Found in the Giant Turkey during Thanksgiving 2026"
    end
end

for _, v50 in ipairs(require(Parent:WaitForChild("TurkeyShopConfig")).SHOP) do
    if v50.kind == "fish" and v50.price then
        local v51 = tostring(v50.price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        t1.HOW_HALLOWEEN[v50.fish] = "Bought at the Turkey Shop for " .. v51 .. " hats during Thanksgiving 2026"
    end
end

for v52, v53 in pairs(WeatherConfig.HALLOWEEN.fish) do
    local v54 = Zones.NAMES[v53] or "Zone " .. v53

    t1.HOW_HALLOWEEN[v52] = "Found in " .. v54 .. (v54:sub(-1) == "s" and "'" or "'s") .. " Pumpkin Chest"
end

t1.NO_COPIES = {
    Mimic = true,
    Fatty = true,
    Drillwyrm = true,
    Timefish = true,
    Kingwhale = true
}

return t1
