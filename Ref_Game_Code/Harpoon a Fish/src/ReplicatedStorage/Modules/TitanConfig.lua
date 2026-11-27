-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local WeatherConfig = require(script.Parent:WaitForChild("WeatherConfig"))
local TitanEventConfig = require(script.Parent:WaitForChild("TitanEventConfig"))
local WorldConfig = require(script.Parent:WaitForChild("WorldConfig"))
local v1 = WorldConfig.IsJurassic()
local t1 = {
    EVERY = 3600,
    ORIGIN_RISE_AT = 1800,
    JURASSIC_RISE_AT = 0
}

t1.RISE_AT = v1 and t1.JURASSIC_RISE_AT or t1.ORIGIN_RISE_AT
t1.ORIGIN_ICON = "rbxassetid://125903200861398"
t1.JURASSIC_ICON = "rbxassetid://95127811606621"
t1.ICON = v1 and t1.JURASSIC_ICON or t1.ORIGIN_ICON
t1.JURASSIC_LAUNCH = {
    START = 1795888800,
    SHOW = 300,
    RISES = {
        {
            at = 0,
            titan = "Spinosauron"
        },
        {
            at = 450,
            titan = "Plessiomother"
        },
        {
            at = 900,
            titan = "Spinosauron",
            shiny = true
        },
        {
            at = 3600,
            titan = "Dunkeltorian",
            shiny = false
        },
        {
            at = 18000,
            titan = "Dunkeltorian",
            shiny = true
        }
    }
}

local JURASSIC_LAUNCH = t1.JURASSIC_LAUNCH
local t2 = {}
local t3 = {}

for _, v2 in ipairs(JURASSIC_LAUNCH.RISES) do
    t2[JURASSIC_LAUNCH.START + v2.at] = v2
    table.insert(t3, JURASSIC_LAUNCH.START + v2.at)
end

local function launchPin(p1) -- line: 63
    -- upvalues: v1 (copy), t2 (copy)
    return if v1 then t2[p1] or nil else nil
end

local function launchTitan(p2) -- line: 66
    -- upvalues: v1 (copy), t2 (copy)
    local v5

    if v1 then
        v5 = t2[p2]
        v5 = v5 or nil
    end

    return v5 and v5.titan or nil
end

function t1.Shown(p3) -- line: 72
    -- upvalues: v1 (copy), JURASSIC_LAUNCH (copy)
    return not v1 or JURASSIC_LAUNCH.START - JURASSIC_LAUNCH.SHOW <= p3
end

function t1.Pinned(p4) -- line: 77
    -- upvalues: TitanEventConfig (copy), v1 (copy), t2 (copy)
    if v1 then
        return t2[p4] ~= nil
    end

    return TitanEventConfig.PickOf(p4) ~= nil
end

t1.GLOOM = 100
t1.LEAD = 85
t1.SONG = 61.07
t1.TEASE_GONE = 60
t1.AFTER = 15

function t1.Now() -- line: 97
    -- upvalues: WeatherConfig (copy)
    return WeatherConfig.Now()
end

function t1.NextRise(p5) -- line: 103
    -- upvalues: TitanEventConfig (copy), v1 (copy), t1 (copy), JURASSIC_LAUNCH (copy), t3 (copy)
    local v7 = math.floor((p5 - t1.RISE_AT) / t1.EVERY) * t1.EVERY + t1.RISE_AT

    if v7 <= p5 then
        v7 += t1.EVERY
    end

    if v1 and v7 < JURASSIC_LAUNCH.START then
        v7 = JURASSIC_LAUNCH.START
    end

    for _, v8 in ipairs(v1 and t3 or TitanEventConfig.Rises()) do
        if p5 < v8 and v8 < v7 then
            v7 = v8
        end
    end

    return v7
end

function t1.OriginNextRise(p6) -- line: 116
    -- upvalues: t1 (copy)
    local v10 = math.floor((p6 - t1.ORIGIN_RISE_AT) / t1.EVERY) * t1.EVERY + t1.ORIGIN_RISE_AT

    v10 = v10 <= p6 and v10 + t1.EVERY or v10

    return v10
end

function t1.Seed(p7) -- line: 123
    -- upvalues: t1 (copy)
    if (p7 - t1.RISE_AT) % t1.EVERY == 0 then
        return (math.floor(p7 / t1.EVERY))
    end

    return math.floor(p7 / 60) + 1E+07
end

function t1.SecondsLeft(p8) -- line: 129
    -- upvalues: t1 (copy)
    return t1.NextRise(p8) - p8
end

function t1.AfterOf(p9) -- line: 135
    -- upvalues: t1 (copy)
    local v13 = t1.SPECIES[t1.RiseTitan(p9)]

    return t1.AFTER + (v13 and v13.late or 0)
end

local function maxLate() -- line: 140
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v14 in pairs(t1.SPECIES) do
        n1 = math.max(n1, v14.late or 0)
    end

    return n1
end

function t1.Current(p10, p11) -- line: 147
    -- upvalues: t1 (copy)
    local NextRise = t1.NextRise
    local v16 = p10 - t1.AFTER
    local n2 = 0

    for _, v17 in pairs(t1.SPECIES) do
        n2 = math.max(n2, v17.late or 0)
    end

    local v19 = NextRise(v16 - n2 - (p11 or 0))

    return if v19 - t1.GLOOM <= p10 and p10 < v19 + t1.AfterOf(v19) + (p11 or 0) then v19 else nil
end

t1.WAVE = {
    TO = 0,
    SPEED = 300,
    FROM = WorldConfig.PIT.PLANKS
}
t1.RELEASE = 2

function t1.WaveAt(p12, p13) -- line: 167
    -- upvalues: t1 (copy)
    return p12 - t1.SONG + (p13 - t1.WAVE.FROM) / t1.WAVE.SPEED
end

function t1.WaveY(p14, p15) -- line: 170
    -- upvalues: t1 (copy)
    return t1.WAVE.FROM + t1.WAVE.SPEED * (p15 - (p14 - t1.SONG))
end

function t1.BackAt(p16, p17) -- line: 174
    -- upvalues: t1 (copy)
    return p16 + t1.AfterOf(p16) + (p17 - 1) * t1.RELEASE
end

t1.SPARED_ZONE = 1

function t1.Spared(p18) -- line: 184
    -- upvalues: Players (copy), t1 (copy)
    if p18 ~= t1.SPARED_ZONE then
        return false
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player:GetAttribute("InTutorial") then
            return true
        end
    end

    return false
end

function t1.Hijacked(p19) -- line: 196
    -- upvalues: t1 (copy)
    local v20 = t1.Current(p19)

    if v20 ~= nil and v20 - t1.SONG <= p19 then
        return p19 < v20 + t1.AfterOf(v20)
    end

    return false
end

function t1.Test(p20) -- line: 202
    -- upvalues: WeatherConfig (copy), t1 (copy)
    if p20 == false then
        return WeatherConfig.Test(false)
    end

    local v21 = type(p20) == "number" and math.max(0, p20) or t1.GLOOM + 5

    workspace:SetAttribute("WeatherForce", nil)
    workspace:SetAttribute("WeatherReal", nil)
    workspace:SetAttribute("HalloweenTest", nil)

    local v22 = WeatherConfig.Now()
    local v23 = t1.NextRise(v22) - v21

    if v23 <= v22 then
        v23 += t1.EVERY
    end

    workspace:SetAttribute("WeatherOffset", v23 - workspace:GetServerTimeNow())

    return ("the Titan rises in %d s (the gloom starts in %d s, the music in %d s)"):format(v21, math.max(0, v21 - t1.GLOOM), (math.max(0, (math.floor(v21 - t1.SONG)))))
end

function t1.TeaseTest(p21, p22) -- line: 220
    -- upvalues: t1 (copy)
    if p21 == false then
        workspace:SetAttribute("TitanTeaseTest", nil)
        workspace:SetAttribute("TitanTeaseAt", nil)

        return "tease test off"
    end

    p21 = p21 or "Karkinos"

    local v29 = if type(p22) ~= "number" or not p22 then 3 else p22

    workspace:SetAttribute("TitanTeaseTest", p21)
    workspace:SetAttribute("TitanTeaseAt", t1.Now() + v29)

    return ("%s passes under the boards in %d s (be in zone 7)"):format(p21, v29)
end

t1.SELL = 600
t1.ORIGIN_RISES = {
    {
        species = "Charybdis",
        odds = 25
    },
    {
        species = "TitanJormungandr",
        odds = 10
    },
    {
        species = "Karkinos",
        odds = 30
    },
    {
        species = "Aspidochelone",
        odds = 20
    },
    {
        species = "Umibozu",
        odds = 15
    }
}
t1.JURASSIC_RISES = {
    {
        species = "Ammonarch",
        odds = 25
    },
    {
        species = "Spinosauron",
        odds = 25
    },
    {
        species = "Dunkeltorian",
        odds = 20
    },
    {
        species = "Plessiomother",
        odds = 15
    },
    {
        species = "Bagosaurus",
        odds = 15
    }
}
t1.RISES = v1 and t1.JURASSIC_RISES or t1.ORIGIN_RISES

local function risesHere(p23) -- line: 267
    -- upvalues: t1 (copy)
    for _, v30 in ipairs(t1.RISES) do
        if v30.species == p23 then
            return true
        end
    end

    return false
end

function t1.IsJurassicTitan(p24) -- line: 275
    -- upvalues: t1 (copy)
    for _, v31 in ipairs(t1.JURASSIC_RISES) do
        local v32 = t1.SPECIES[v31.species]

        if p24 == v31.species or v32 and v32.shiny == p24 then
            return true
        end
    end

    return false
end

local t4 = {
    { 40, 10, 14 },
    { 25, 15, 19 },
    { 18, 20, 29 },
    { 10, 30, 44 },
    { 5, 45, 69 },
    { 1.8, 70, 99 },
    { 0.2, 100, 100 }
}
local t5 = {
    { 40, 15, 29 },
    { 35, 30, 49 },
    { 15, 50, 74 },
    { 7, 75, 99 },
    { 2.5, 100, 149 },
    { 0.45, 150, 199 },
    { 0.05, 200, 200 }
}
local t6 = {
    { 45, 10, 19 },
    { 33, 20, 34 },
    { 14, 35, 59 },
    { 5.5, 60, 99 },
    { 2, 100, 149 },
    { 0.45, 150, 199 },
    { 0.05, 200, 200 }
}
local t7 = {
    { 55, 10, 12 },
    { 28, 13, 16 },
    { 11, 17, 22 },
    { 4.5, 23, 29 },
    { 1.2, 30, 35 },
    { 0.25, 36, 39 },
    { 0.05, 40, 40 }
}
local t8 = {
    { 45, 11, 13 },
    { 30, 14, 16 },
    { 15, 17, 20 },
    { 7, 21, 24 },
    { 2.5, 25, 28 },
    { 0.45, 29, 29 },
    { 0.05, 30, 30 }
}
local t9 = {
    { 45, 5, 9 },
    { 30, 10, 17 },
    { 15, 18, 27 },
    { 7, 28, 39 },
    { 2.5, 40, 52 },
    { 0.45, 53, 64 },
    { 0.05, 65, 65 }
}
local t10 = {
    { 65, 1, 1 },
    { 28, 2, 2 },
    { 5, 3, 3 },
    { 1.6, 4, 4 },
    { 0.4, 5, 5 }
}
local t11 = {
    { 55, 1, 1 },
    { 42, 2, 2 },
    { 2.5, 3, 3 },
    { 0.45, 4, 4 },
    { 0.05, 5, 5 }
}

t1.SPECIES = {
    Charybdis = {
        stat = "Fat",
        label = "FAT",
        name = "CHARYBDIS",
        model = "Charybdis",
        shape = "Charybdis",
        shiny = "ShinyCharybdis",
        late = 3,
        bands = t4
    },
    ShinyCharybdis = {
        stat = "Fat",
        label = "FAT",
        name = "CHARYBDIS",
        model = "ShinyCharybdis",
        shape = "Charybdis",
        late = 3,
        bands = t4
    },
    TitanJormungandr = {
        stat = "Money",
        label = "MONEY",
        name = "JORMUNGANDR",
        model = "TitanJormungandr",
        shape = "TitanJormungandr",
        shiny = "ShinyJormungandr",
        late = 3,
        bands = t5
    },
    ShinyJormungandr = {
        stat = "Money",
        label = "MONEY",
        name = "JORMUNGANDR",
        model = "ShinyJormungandr",
        shape = "TitanJormungandr",
        late = 3,
        bands = t5
    },
    Karkinos = {
        stat = "XP",
        label = "XP",
        name = "KARKINOS",
        model = "Karkinos",
        shape = "Karkinos",
        shiny = "ShinyKarkinos",
        late = 8,
        bands = t6
    },
    ShinyKarkinos = {
        stat = "XP",
        label = "XP",
        name = "KARKINOS",
        model = "ShinyKarkinos",
        shape = "Karkinos",
        late = 8,
        bands = t6
    },
    Aspidochelone = {
        stat = "Grow",
        label = "GROW",
        name = "ASPIDOCHELONE",
        model = "Aspidochelone",
        shape = "Aspidochelone",
        shiny = "ShinyAspidochelone",
        late = 8,
        bands = t7
    },
    ShinyAspidochelone = {
        stat = "Grow",
        label = "GROW",
        name = "ASPIDOCHELONE",
        model = "ShinyAspidochelone",
        shape = "Aspidochelone",
        late = 8,
        bands = t7
    },
    Umibozu = {
        stat = "Luck",
        label = "LUCK",
        name = "UMIBOZU",
        model = "Umibozu",
        shape = "Umibozu",
        shiny = "ShinyUmibozu",
        late = 8,
        bands = t4
    },
    ShinyUmibozu = {
        stat = "Luck",
        label = "LUCK",
        name = "UMIBOZU",
        model = "ShinyUmibozu",
        shape = "Umibozu",
        late = 8,
        bands = t4
    },
    Ammonarch = {
        stat = "Fossilized",
        label = "FOSSILIZED",
        name = "AMMONARCH",
        model = "Ammonarch",
        shape = "Ammonarch",
        shiny = "ShinyAmmonarch",
        late = 2.4,
        bands = t8
    },
    ShinyAmmonarch = {
        stat = "Fossilized",
        label = "FOSSILIZED",
        name = "AMMONARCH",
        model = "ShinyAmmonarch",
        shape = "Ammonarch",
        late = 2.4,
        bands = t8
    },
    Spinosauron = {
        stat = "Meteorite",
        label = "METEORITE",
        name = "SPINOSAURON",
        model = "Spinosauron",
        shape = "Spinosauron",
        shiny = "ShinySpinosauron",
        late = 2.4,
        bands = t8
    },
    ShinySpinosauron = {
        stat = "Meteorite",
        label = "METEORITE",
        name = "SPINOSAURON",
        model = "ShinySpinosauron",
        shape = "Spinosauron",
        late = 2.4,
        bands = t8
    },
    Dunkeltorian = {
        stat = "Life",
        label = "EXTRA LIFE",
        name = "DUNKELTORIAN",
        model = "Dunkeltorian",
        shape = "Dunkeltorian",
        shiny = "ShinyDunkeltorian",
        late = 2.4,
        bands = t9
    },
    ShinyDunkeltorian = {
        stat = "Life",
        label = "EXTRA LIFE",
        name = "DUNKELTORIAN",
        model = "ShinyDunkeltorian",
        shape = "Dunkeltorian",
        late = 2.4,
        bands = t9
    },
    Plessiomother = {
        stat = "Aquarium",
        label = "AQUARIUM",
        name = "PLESSIOMOTHER",
        model = "Plessiomother",
        shape = "Plessiomother",
        shiny = "ShinyPlessiomother",
        late = 2.4,
        bands = t10
    },
    ShinyPlessiomother = {
        stat = "Aquarium",
        label = "AQUARIUM",
        name = "PLESSIOMOTHER",
        model = "ShinyPlessiomother",
        shape = "Plessiomother",
        late = 2.4,
        bands = t10
    },
    Bagosaurus = {
        stat = "Bag",
        label = "BAG",
        name = "BAGOSAURUS",
        model = "Bagosaurus",
        shape = "Bagosaurus",
        shiny = "ShinyBagosaurus",
        late = 2.4,
        bands = t11
    },
    ShinyBagosaurus = {
        stat = "Bag",
        label = "BAG",
        name = "BAGOSAURUS",
        model = "ShinyBagosaurus",
        shape = "Bagosaurus",
        late = 2.4,
        bands = t11
    }
}
t1.SHINY_ODDS = 100

function t1.Shiny(p25) -- line: 396
    -- upvalues: TitanEventConfig (copy), v1 (copy), t1 (copy), t2 (copy)
    if workspace:GetAttribute("TitanShinyTest") then
        return true
    end

    local v33 = if v1 then nil else TitanEventConfig.ShinyOf(p25)
    local v34

    if v1 then
        v34 = t2[p25]
        v34 = v34 or nil
    end

    if v34 and v34.shiny ~= nil then
        v33 = v34.shiny == true
    end

    if v33 == nil then
        return Random.new(t1.Seed(p25) * 7919 + 13):NextInteger(1, t1.SHINY_ODDS) == 1
    end

    return v33
end

local t12 = {}

local function rollRise(p26, p27) -- line: 414
    -- upvalues: t1 (copy)
    local n3 = 0

    for _, v35 in ipairs(t1.RISES) do
        if not p27[v35.species] then
            n3 += v35.odds
        end
    end

    local v36 = p27

    if n3 <= 0 then
        v36 = {}
        n3 = 0

        for _, v37 in ipairs(t1.RISES) do
            n3 += v37.odds
        end
    end

    local species = nil
    local v38 = Random.new(t1.Seed(p26) * 6151 + 29):NextNumber() * n3
    local species2

    for _, v39 in ipairs(t1.RISES) do
        if not v36[v39.species] then
            species = v39.species
            v38 -= v39.odds

            if v38 <= 0 then
                species2 = species
                break
            end
        end

        species2 = species
    end

    return species2
end

local function rollHour(p28, p29) -- line: 432
    -- upvalues: TitanEventConfig (copy), v1 (copy), t1 (copy), rollRise (copy)
    local t13 = {}
    local v41 = math.floor(p28 / t1.EVERY)

    for _, v42 in ipairs(v1 and {} or TitanEventConfig.Rises()) do
        local v43 = TitanEventConfig.PickOf(v42)

        if v43 and math.floor(v42 / t1.EVERY) == v41 then
            t13[v43] = true
        end
    end

    if p29 then
        t13[p29] = true
    end

    return (rollRise(p28, t13))
end

local v46 = math.floor(TitanEventConfig.START / t1.EVERY)
local v47 = v46 - 1
local v48 = nil
local v49

local function hourRun(p30) -- line: 449
    -- upvalues: TitanEventConfig (copy), v1 (copy), t1 (copy), t2 (copy), t12 (copy), rollHour (copy), v46 (copy), v47 (ref), v48 (ref), v49 (ref)
    local v51 = math.floor(p30 / t1.EVERY)

    if v51 < v46 or v51 - v47 > 20000 then
        return (rollHour(p30))
    end

    for i = v47 + 1, v51 do
        local v52 = i * t1.EVERY + t1.RISE_AT
        local v53 = if v1 then t2[v52] else nil
        local v54 = if not v1 or not v53 then nil else v53
        local titan = if v54 then v54.titan else nil
        local v55 = if not v54 or not titan then nil else titan

        v55 = v55 or not v1 and TitanEventConfig.PickOf(v52)

        if not v55 or not t1.SPECIES[v55] then
            local v56 = v48 == v49
            local v57 = if v56 then v48 else nil

            v55 = rollHour(v52, if not v56 or not v57 then nil else v57)
        end

        t12[v52] = v55
        v49 = v48
        v48 = v55
        v47 = i
    end

    return t12[p30]
end

local TicketTitans
local t14 = {}

local function ticketTitan(p31) -- line: 466
    -- upvalues: t1 (copy), TicketTitans (ref), t14 (ref)
    local TicketTitans2 = workspace:GetAttribute("TicketTitans")

    if TicketTitans2 ~= TicketTitans then
        local t15 = {}

        TicketTitans = TicketTitans2
        t14 = t15

        if type(TicketTitans2) == "string" then
            for match, v59 in string.gmatch(TicketTitans2, "(%d+)=(%w+)") do
                local t16 = t14

                t16[tonumber(match)] = v59
            end
        end
    end

    local v60 = t14[p31]

    if not v60 or not t1.SPECIES[v60] then
        v60 = nil

        return v60
    end

    local v61 = false
    local v62

    for _, v63 in ipairs(t1.RISES) do
        if v63.species == v60 then
            v62 = true
            v61 = true
            break
        end
    end

    if not v61 then
        v62 = false
    end

    if not v62 then
        v60 = nil
    end

    return v60
end

function t1.RiseTitan(p32) -- line: 478
    -- upvalues: TitanEventConfig (copy), v1 (copy), t1 (copy), t2 (copy), t12 (copy), rollRise (copy), hourRun (copy), ticketTitan (copy)
    local TitanTest = workspace:GetAttribute("TitanTest")

    if type(TitanTest) == "string" and t1.SPECIES[TitanTest] then
        return TitanTest
    end

    local v64 = ticketTitan(p32)

    if v64 then
        return v64
    end

    if t12[p32] then
        return t12[p32]
    end

    local v65

    if v1 then
        v65 = t2[p32]
        v65 = v65 or nil
    end

    local titan = v65 and v65.titan or nil or not v1 and TitanEventConfig.PickOf(p32)

    if not (titan and t1.SPECIES[titan]) then
        local v66

        if (p32 - t1.RISE_AT) % t1.EVERY == 0 then
            v66 = hourRun(p32)
        else
            local v68 = math.floor(p32 / t1.EVERY)
            local t17 = {}

            t17[t1.RiseTitan(v68 * t1.EVERY + t1.RISE_AT)] = true

            for _, v69 in ipairs(TitanEventConfig.Rises()) do
                if v69 < p32 and math.floor(v69 / t1.EVERY) == v68 then
                    t17[t1.RiseTitan(v69)] = true
                end
            end

            v66 = rollRise(p32, t17)
        end

        t12[p32] = v66

        return v66
    end

    t12[p32] = titan

    return titan
end

function t1.RiseSpecies(p33) -- line: 505
    -- upvalues: t1 (copy)
    local v71 = t1.RiseTitan(p33)
    local v72 = t1.SPECIES[v71]
    local v73, v74

    if v72 and v72.shiny and t1.Shiny(p33) then
        local shiny = v72.shiny

        if shiny then
            v73 = shiny
            v74 = true
        else
            v74 = false
        end
    else
        v74 = false
    end

    if not v74 then
        v73 = v71
    end

    return v73
end

function t1.NameOf(p34) -- line: 511
    -- upvalues: t1 (copy)
    local v75 = t1.SPECIES[t1.RiseSpecies(p34)]

    return v75 and v75.name or "TITAN"
end

t1.STATS = {
    Fat = {
        icon = "rbxassetid://135825676122341",
        grad = { "Fat", "Value", "Fat" }
    },
    Money = {
        icon = "rbxassetid://117252679272986",
        grad = { "PenRate", "Row", "Amount", "Money" }
    },
    XP = {
        icon = "rbxassetid://137513422393347",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(255, 240, 120), Color3.fromRGB(255, 165, 20))
    },
    Grow = {
        icon = "rbxassetid://72293964296867",
        sign = "-",
        rotation = 90,
        rect = { 102, 79, 308, 342 },
        colors = ColorSequence.new(Color3.fromRGB(225, 170, 255), Color3.fromRGB(150, 70, 230))
    },
    Luck = {
        icon = "rbxassetid://80418759118984",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(170, 255, 150), Color3.fromRGB(40, 190, 80))
    },
    Fossilized = {
        icon = "rbxassetid://139463957424627",
        sign = "x",
        tenths = true,
        unit = "",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(240, 215, 160), Color3.fromRGB(190, 145, 75))
    },
    Meteorite = {
        icon = "rbxassetid://103017365789445",
        sign = "x",
        tenths = true,
        unit = "",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(255, 205, 90), Color3.fromRGB(255, 120, 20))
    },
    Life = {
        icon = "rbxassetid://132634942989993",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(255, 150, 160), Color3.fromRGB(225, 40, 70))
    },
    Aquarium = {
        icon = "rbxassetid://88976101808812",
        unit = "",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(160, 225, 255), Color3.fromRGB(40, 140, 240))
    },
    Bag = {
        icon = "rbxassetid://76221925928537",
        unit = "",
        rotation = 90,
        colors = ColorSequence.new(Color3.fromRGB(255, 230, 160), Color3.fromRGB(215, 150, 60))
    }
}

function t1.StatIcon(p35, p36) -- line: 548
    -- upvalues: t1 (copy)
    local v76 = t1.STATS[p36]

    p35.Image = v76 and v76.icon or ""

    local v77 = v76 and v76.rect

    p35.ImageRectOffset = v77 and Vector2.new(v77[1], v77[2]) or Vector2.zero
    p35.ImageRectSize = v77 and Vector2.new(v77[3], v77[4]) or Vector2.zero
end

local t18 = {}

function t1.StatGradient(p37, p38) -- line: 557
    -- upvalues: t1 (copy), t18 (copy)
    local v78 = t1.STATS[p38]

    if v78 and v78.colors then
        if not t18[p38] then
            local UIGradient = Instance.new("UIGradient")
            local colors = v78.colors
            local v79 = v78.rotation or 0

            UIGradient.Color = colors
            UIGradient.Rotation = v79
            t18[p38] = UIGradient
        end

        return t18[p38]
    end

    local v80 = p37

    for _, v81 in ipairs(v78 and v78.grad or {}) do
        v80 = v80 and v80:FindFirstChild(v81)
    end

    return if v80 and v80:IsA("UIGradient") then v80 else nil
end

function t1.IsTitan(p39) -- line: 573
    -- upvalues: t1 (copy)
    return t1.SPECIES[p39] ~= nil
end

function t1.Roll(p40, p41) -- line: 577
    -- upvalues: t1 (copy)
    local v82 = t1.SPECIES[p40]

    if not v82 then
        return nil
    end

    p41 = p41 or Random.new()

    local n5 = 0

    for _, v84 in ipairs(v82.bands) do
        n5 += v84[1]
    end

    local v85 = p41:NextNumber() * n5

    for _, v86 in ipairs(v82.bands) do
        v85 -= v86[1]

        if v85 <= 0 then
            return p41:NextInteger(v86[2], v86[3])
        end
    end

    return v82.bands[#v82.bands][3]
end

function t1.Signed(p42, p43) -- line: 592
    -- upvalues: t1 (copy)
    local v87 = t1.SPECIES[p42]
    local v88 = v87 and t1.STATS[v87.stat]

    p43 = p43 or 0

    local v90, v91

    if v88 and v88.tenths then
        local v92 = ("%.1f"):format(p43 / 10)

        if v92 then
            v90 = v92
            v91 = true
        else
            v91 = false
        end
    else
        v91 = false
    end

    if not v91 then
        v90 = tostring(p43)
    end

    local sign = if v88 then v88.sign or "+" else "+"
    local unit = if v88 then v88.unit or "%" else "%"

    return sign .. v90 .. unit
end

function t1.BonusText(p44, p45) -- line: 600
    -- upvalues: t1 (copy)
    local v93 = t1.SPECIES[p44]

    return t1.Signed(p44, p45) .. " " .. (v93 and v93.label or "")
end

return t1
