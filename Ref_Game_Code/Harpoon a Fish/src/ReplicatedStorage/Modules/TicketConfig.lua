-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    MAX = 99,
    HOUR = 3600,
    HUB = 113384248926706,
    JURASSIC = 125360944450831,
    GROUPS = {
        Chest = {
            stub = "CHEST",
            card = Color3.fromRGB(110, 62, 14),
            text = Color3.fromRGB(255, 190, 40)
        },
        Weather = {
            stub = "WEATHER",
            card = Color3.fromRGB(14, 74, 82),
            text = Color3.fromRGB(40, 190, 210)
        },
        Titan = {
            stub = "TITAN",
            card = Color3.fromRGB(14, 28, 74),
            text = Color3.fromRGB(36, 86, 214)
        },
        Event = {
            stub = "EVENT",
            card = Color3.fromRGB(70, 20, 90),
            text = Color3.fromRGB(180, 90, 255)
        },
        Thanksgiving = {
            stub = "FEAST",
            card = Color3.fromRGB(120, 60, 20),
            text = Color3.fromRGB(230, 130, 45)
        }
    },
    CHEST_ART = "rbxassetid://116296229607149",
    LIST = {}
}

local function add(p1) -- line: 39
    -- upvalues: t1 (copy)
    table.insert(t1.LIST, p1)
end

local t2 = {
    20, 30, 45, 65, 90, 125, 175, 250,
    350, 500
}

for i = 1, 10 do
    local t3 = {
        group = "Chest",
        id = "Chest" .. i,
        name = "Zone " .. i,
        thing = i,
        price = t2[i],
        place = i <= 7 and "hub" or "jurassic"
    }

    table.insert(t1.LIST, t3)
end

local t4 = {
    id = "Thunderstorm",
    group = "Weather",
    name = "Thunderstorm",
    thing = "Thunderstorm",
    price = 25,
    place = "both",
    weight = 67.8,
    art = "rbxassetid://93814292603804"
}

table.insert(t1.LIST, t4)

local t5 = {
    id = "Voidstorm",
    group = "Weather",
    name = "Voidstorm",
    thing = "Voidstorm",
    price = 75,
    place = "hub",
    weight = 22,
    art = "rbxassetid://136858219747701"
}

table.insert(t1.LIST, t5)

local t6 = {
    id = "PinkMoon",
    group = "Weather",
    name = "Pink Moon",
    thing = "PinkMoon",
    price = 150,
    place = "hub",
    weight = 10.2,
    art = "rbxassetid://72675255008364"
}

table.insert(t1.LIST, t6)

local t7 = {
    id = "MeteorShower",
    group = "Weather",
    name = "Meteor Shower",
    thing = "MeteorShower",
    price = 75,
    place = "jurassic",
    weight = 22,
    art = "rbxassetid://92359308234661"
}

table.insert(t1.LIST, t7)

local t8 = {
    id = "FossilStorm",
    group = "Weather",
    name = "Fossil Storm",
    thing = "FossilStorm",
    price = 150,
    place = "jurassic",
    weight = 10.2,
    art = "rbxassetid://132249208476611"
}

table.insert(t1.LIST, t8)

local t9 = {
    id = "Karkinos",
    group = "Titan",
    name = "Karkinos",
    thing = "Karkinos",
    price = 100,
    place = "hub",
    weight = 30,
    art = "rbxassetid://101392380210067"
}

table.insert(t1.LIST, t9)

local t10 = {
    id = "Charybdis",
    group = "Titan",
    name = "Charybdis",
    thing = "Charybdis",
    price = 125,
    place = "hub",
    weight = 25,
    art = "rbxassetid://105670958794381"
}

table.insert(t1.LIST, t10)

local t11 = {
    id = "Aspidochelone",
    group = "Titan",
    name = "Aspidochelone",
    thing = "Aspidochelone",
    price = 150,
    place = "hub",
    weight = 20,
    art = "rbxassetid://105743952098144"
}

table.insert(t1.LIST, t11)

local t12 = {
    id = "Umibozu",
    group = "Titan",
    name = "Umibōzu",
    thing = "Umibozu",
    price = 200,
    place = "hub",
    weight = 15,
    art = "rbxassetid://92231797862306"
}

table.insert(t1.LIST, t12)

local t13 = {
    id = "Jormungandr",
    group = "Titan",
    name = "Jörmungandr",
    thing = "TitanJormungandr",
    price = 300,
    place = "hub",
    weight = 10,
    art = "rbxassetid://104856313488981"
}

table.insert(t1.LIST, t13)

local t14 = {
    id = "Thanksgiving",
    group = "Thanksgiving",
    name = "Thanksgiving",
    kind = "TURKEY FEAST",
    price = 0,
    place = "both",
    art = "rbxassetid://104956517754676"
}

table.insert(t1.LIST, t14)
t1.CHEST_ODDS = {}

for i = 1, 2 do
    t1.CHEST_ODDS[i] = {
        { "Mythic", 75 },
        { "Exotic", 25 }
    }
end

for i = 3, 6 do
    t1.CHEST_ODDS[i] = {
        { "Mythic", 74 },
        { "Exotic", 25 },
        { "Secret", 1 }
    }
end

t1.CHEST_ODDS[7] = {
    { "Exotic", 87.5 },
    { "Secret", 10 },
    { "Celestial", 2.5 }
}

for i = 8, 9 do
    t1.CHEST_ODDS[i] = {
        { "Exotic", 80 },
        { "Secret", 15 },
        { "Celestial", 4.5 }
    }
end

t1.CHEST_ODDS[10] = {
    { "Exotic", 80 },
    { "Secret", 15 },
    { "Celestial", 4.5 },
    { "Apex", 0.5 }
}

function t1.Percents(p2) -- line: 73
    local n1 = 0

    for _, v1 in ipairs(p2) do
        n1 += v1[2]
    end

    local t15 = {}

    for _, v2 in ipairs(p2) do
        t15[#t15 + 1] = {
            v2[1],
            v2[2] / n1 * 100
        }
    end

    return t15
end

function t1.Pct(p3) -- line: 82
    if math.abs(p3 * 1000 - math.round(p3 * 1000)) < 1E-06 then
        return string.format("%g%%", math.round(p3 * 1000) / 1000)
    end

    local v9 = math.max(0, 4 - math.floor((math.log10(p3))))

    return string.format("%." .. v9 .. "f", p3):gsub("0+$", "") .. "%"
end

t1.JURASSIC_FAT = {
    [8] = 2.5E+08,
    [9] = 1.125E+09,
    [10] = 5.06E+09
}

function t1.Reached(p4, p5, p6) -- line: 92
    -- upvalues: t1 (copy)
    if p4 <= 7 then
        return p4 <= (p5 or 1)
    end

    return (p6 or 0) >= (t1.JURASSIC_FAT[p4] or 1e999)
end

local t16 = {}

for _, v10 in ipairs(t1.LIST) do
    t16[v10.id] = v10
end

function t1.Get(p7) -- line: 99
    -- upvalues: t16 (copy)
    return if p7 then t16[p7] or nil else nil
end

function t1.ChestOf(p8) -- line: 100
    -- upvalues: t16 (copy)
    return t16["Chest" .. tostring(p8)]
end

function t1.Title(p9) -- line: 102
    if p9.group == "Chest" then
        return p9.name .. " Chest Ticket"
    end

    return p9.name .. " Ticket"
end

t1.SLOTS = { "Event", "Titan", "Weather" }
t1.START = 491600

function t1.Hour(p10) -- line: 112
    -- upvalues: t1 (copy)
    return (math.floor((p10 or os.time()) / t1.HOUR))
end

function t1.SecondsLeft(p11) -- line: 113
    -- upvalues: t1 (copy)
    p11 = p11 or os.time()

    return (t1.Hour(p11) + 1) * t1.HOUR - p11
end

local function roll(p12, p13, p14, p15) -- line: 119
    -- upvalues: t1 (copy)
    local t17 = {}
    local n2 = 0

    for _, v14 in ipairs(t1.LIST) do
        if v14.group == p12 and v14.weight and v14.id ~= p15 then
            table.insert(t17, v14)
            n2 += v14.weight
        end
    end

    if #t17 == 0 then
        return nil
    end

    local v15 = Random.new(p13 * 7919 + p14):NextNumber() * n2

    for _, v16 in ipairs(t17) do
        v15 -= v16.weight

        if v15 <= 0 then
            return v16.id
        end
    end

    return t17[#t17].id
end

local t18 = {}
local v17 = t1.START - 1

function t1.Shop(p16) -- line: 138
    -- upvalues: t1 (copy), roll (copy), t18 (copy), v17 (ref)
    p16 = p16 or t1.Hour()

    if p16 < t1.START then
        return {
            Weather = roll("Weather", p16, 11),
            Titan = roll("Titan", p16, 29)
        }
    end

    for i = v17 + 1, p16 do
        local v19 = t18[i - 1] or {}

        t18[i] = {
            Weather = roll("Weather", i, 11, v19.Weather),
            Titan = roll("Titan", i, 29, v19.Titan)
        }
        t18[i - 3] = nil
        v17 = i
    end

    return t18[p16] or {
        Weather = roll("Weather", p16, 11),
        Titan = roll("Titan", p16, 29)
    }
end

function t1.OnSale(p17, p18) -- line: 154
    -- upvalues: t1 (copy), t16 (copy)
    local v20 = t16[p17]

    if not v20 then
        return false
    end

    if v20.group == "Chest" then
        return true
    end

    return t1.Shop(p18)[v20.group] == p17
end

t1.GROUP_ORDER = {
    Thanksgiving = 0,
    Titan = 1,
    Weather = 2,
    Chest = 3,
    Event = 4
}
t1.WHERE = {
    hub = "Works in the main world",
    jurassic = "Works on Jurassic Island",
    both = "Works in both worlds"
}

function t1.Info(p19, p20, p21) -- line: 167
    -- upvalues: t1 (copy)
    if p19.group == "Thanksgiving" then
        local t19 = {
            p20.T("Hold it and use it to start the Turkey Feast!"),
            p20.T(t1.WHERE.both)
        }
        local _require = require
        local Parent = script.Parent
        local ok, result = pcall(_require, Parent:WaitForChild("ThanksgivingConfig"))

        if ok and result.Phase() == "grace" then
            table.insert(t19, p20.T("Use it by the end of today!"))
        end

        return t19
    end

    local t20

    if p19.group == "Weather" then
        t20 = {
            p20.F("ticket.infoWeather", "Use it to make the NEXT WEATHER on your server a {w}!", {
                w = string.upper(p20.T(p19.name))
            })
        }
    elseif p19.group == "Titan" then
        local v21 = string.upper(p20.T(p19.name))

        t20 = {
            p20.F("ticket.infoTitan", "Use it to make the NEXT TITAN on your server {t}!", {
                t = v21
            }),
            p20.F("ticket.infoShiny", "{t} {a} / SHINY {t} {b}", {
                t = v21,
                a = t1.Pct(100 - 100 / p21),
                b = t1.Pct(100 / p21)
            })
        }
    else
        t20 = {
            p20.F("ticket.infoChest", "Use it to open zone {z}'s TREASURE CHEST right away!", {
                z = p19.thing
            })
        }
    end

    table.insert(t20, p20.T(t1.WHERE[p19.place]))

    return t20
end

function t1.ParsePicks(p22) -- line: 192
    local t21 = {}

    if type(p22) == "string" then
        for match, v23 in string.gmatch(p22, "(%d+)=(%w+)") do
            t21[tonumber(match)] = v23
        end
    end

    return t21
end

function t1.WritePicks(p23) -- line: 199
    local t22 = {}

    for v24, v25 in pairs(p23) do
        t22[#t22 + 1] = string.format("%d=%s", v24, v25)
    end

    table.sort(t22)

    return #t22 > 0 and table.concat(t22, ";") or nil
end

function t1.Random(p24) -- line: 209
    if p24 == nil then
        return false
    end

    if p24.group == "Chest" then
        return true
    end

    return p24.group == "Titan"
end

function t1.WorksIn(p25, p26) -- line: 214
    -- upvalues: t1 (copy)
    if p25.place == "both" then
        return true
    end

    if p25.place == "hub" then
        return p26 == t1.HUB
    end

    return p26 == t1.JURASSIC
end

return t1
