-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    CYCLE = 900,
    EVENT = 300,
    OUTRO = 10,
    PHASE = 600,
    STARTS = 1792258200,
    VOID_ONLY = 172800,
    PITY = {
        after = 6,
        of = "Thunderstorm",
        gives = "Voidstorm"
    },
    WEATHERS = {
        Thunderstorm = {
            name = "THUNDERSTORM",
            icon = "rbxassetid://93814292603804",
            buff = "+15% BIGGER FISH",
            sizeMult = 1.15,
            weight = 67.8
        },
        Voidstorm = {
            name = "VOIDSTORM",
            icon = "rbxassetid://136858219747701",
            buff = "VOIDSTORM MUTATION!",
            sizeMult = 1,
            weight = 22,
            hitMutation = {
                name = "Voidstorm",
                chance = 0.16666666666666666,
                pity = 8
            },
            fish = {
                BubblegumCrab = 1,
                BucktuskMarlin = 2,
                GlitteringFantail = 3,
                VoidbackTigershark = 3,
                VoidjawAngler = 4,
                Fangflyer = 4,
                Voidbloom = 4,
                NebulaPiranha = 5,
                Voidfang = 5,
                Voidjelly = 5,
                Voidlurker = 5,
                StarlightBubblefish = 6,
                Cosmowhale = 6,
                VoidstormTigermosasaur = 6,
                VoidspikedBattleworm = 6
            }
        },
        PinkMoon = {
            name = "PINK MOON",
            icon = "rbxassetid://72675255008364",
            buff = "PINK MOON MUTATION!",
            sizeMult = 1,
            weight = 10.2,
            hitMutation = {
                name = "PinkMoon",
                chance = 0.125,
                pity = 12
            },
            fish = {
                MoonbeamEel = 1,
                PearlwingAngelfish = 1,
                BlushwhiskerCatfish = 2,
                Moonjelly = 2,
                PearlclawCrab = 3,
                Bluorca = 3,
                RosebillMarlin = 4,
                PearlHammerhead = 4,
                MoonlureAngler = 5,
                TwinmoonSerpent = 5,
                Lunapus = 6,
                Triclipse = 6,
                Moonwhal = 7,
                Rosemaw = 7
            }
        }
    },
    ORDER = { "Thunderstorm", "Voidstorm", "PinkMoon" },
    PINK = {
        STARTS = 1794679200,
        ONLY = 259200,
        BEFORE = {
            Thunderstorm = 3,
            Voidstorm = 1,
            PinkMoon = 0
        }
    }
}

function t1.PinkOnly(p1) -- line: 129
    -- upvalues: t1 (copy)
    local PINK = t1.PINK

    if PINK.STARTS <= p1 then
        return p1 < PINK.STARTS + PINK.ONLY
    end

    return false
end

t1.NEXT_ICON = "rbxassetid://115022898840421"

function t1.Now() -- line: 140
    local WeatherOffset = workspace:GetAttribute("WeatherOffset")
    local ServerTimeNow = workspace:GetServerTimeNow()

    if type(WeatherOffset) ~= "number" or not WeatherOffset then
        WeatherOffset = 0
    end

    return ServerTimeNow + WeatherOffset
end

function t1.Live() -- line: 145
    if workspace:GetAttribute("WeatherOffset") == nil then
        return true
    end

    return workspace:GetAttribute("WeatherReal") == true
end

function t1.SlotOf(p2) -- line: 150
    -- upvalues: t1 (copy)
    return (math.floor((p2 - t1.PHASE) / t1.CYCLE))
end

function t1.SlotEnd(p3) -- line: 153
    -- upvalues: t1 (copy)
    return (p3 + 1) * t1.CYCLE + t1.PHASE
end

local function firstFrom(p4) -- line: 157
    -- upvalues: t1 (copy)
    local v2 = t1.SlotOf(p4)

    if t1.SlotEnd(v2) - t1.EVENT < p4 then
        v2 += 1
    end

    return v2
end

local SlotEnd, STARTS = t1.SlotEnd, t1.STARTS
local v3 = t1.SlotOf(STARTS)

if t1.SlotEnd(v3) - t1.EVENT < STARTS then
    v3 += 1
end

t1.FIRST = SlotEnd(v3) - t1.EVENT
t1.HALLOWEEN = {
    STARTS = 1792861200,
    ENDS = 1794124800,
    EVERY = 3600,
    LENGTH = 1200,
    icon = "rbxassetid://73723253345985",
    soonIcon = "rbxassetid://83907308031150",
    buff = "HALLOWEEN!",
    hitMutations = {
        {
            name = "Hallowed",
            chance = 0.02,
            pity = 120
        },
        {
            name = "Ghost",
            chance = 0.1,
            pity = 15
        }
    },
    HAT = {
        window = 0.1111111111111111,
        rest = 0.05
    },
    fish = {
        CaptainPinchy = 1,
        AncientTurtleSkeleton = 2,
        CrimsonShadowRay = 3,
        WitchlightAngler = 4,
        HarvestHorrorOctopus = 4,
        VampireShark = 5,
        AbyssalRotmaw = 5,
        PumpkinReaperRay = 6,
        AbyssalBoneLeviathan = 6,
        DreadmawScythewyrm = 7,
        MummifiedSerpent = 7
    },
    roll = {
        AbyssalFlameLeviathan = "Hallowed Leviathan",
        DreadmawScythewyrm = "Reaperdon",
        AbyssalBoneLeviathan = "Ghosted Moby",
        MummifiedSerpent = "Dreadmummy",
        AbyssalRotmaw = "Zombiejaw",
        VampireShark = "Dracusoaur",
        AncientTurtleSkeleton = "Skeleturtle",
        HarvestHorrorOctopus = "Scarecrowpus",
        PumpkinReaperRay = "Headless Huntosaur",
        CrimsonShadowRay = "Batray",
        WitchlightAngler = "Bewitched Angler"
    }
}

function t1.HalloweenHour(p5, p6) -- line: 220
    -- upvalues: t1 (copy)
    local HALLOWEEN = t1.HALLOWEEN
    local v5 = math.floor(p5 / HALLOWEEN.EVERY)
    local v6 = v5 * HALLOWEEN.EVERY

    return if not p6 and workspace:GetAttribute("HalloweenTest") == true or not (v6 < HALLOWEEN.STARTS) and not (HALLOWEEN.ENDS <= v6) then {
        startsAt = v6,
        endsAt = v6 + HALLOWEEN.LENGTH,
        hour = v5
    } else nil
end

function t1.Halloween(p7) -- line: 229
    -- upvalues: t1 (copy)
    local v7 = t1.HalloweenHour(p7)

    if v7 ~= nil and v7.startsAt <= p7 then
        return p7 < v7.endsAt
    end

    return false
end

function t1.HatChance(p8) -- line: 235
    -- upvalues: t1 (copy)
    local v8 = t1.HalloweenHour(p8)

    if not v8 then
        return 0
    end

    local HAT = t1.HALLOWEEN.HAT
    local v9, v10

    if v8.startsAt <= p8 and p8 < v8.endsAt then
        local window = HAT.window

        if window then
            v9 = window
            v10 = true
        else
            v10 = false
        end
    else
        v10 = false
    end

    if not v10 then
        v9 = HAT.rest
    end

    return v9
end

function t1.HalloweenNext(p9) -- line: 242
    -- upvalues: t1 (copy)
    local v11 = t1.HalloweenHour(p9)

    if v11 and p9 < v11.endsAt then
        return v11
    end

    local HALLOWEEN = t1.HALLOWEEN
    local v13 = (math.floor(p9 / HALLOWEEN.EVERY) + 1) * HALLOWEEN.EVERY

    if workspace:GetAttribute("HalloweenTest") ~= true and v13 < HALLOWEEN.STARTS then
        v13 = HALLOWEEN.STARTS
    end

    return t1.HalloweenHour(v13)
end

local function halloweenCalm(p10, p11) -- line: 251
    -- upvalues: t1 (copy)
    local v14 = t1.SlotEnd(p10) - t1.EVENT
    local v15 = t1.HalloweenHour(v14, p11)

    return v15 ~= nil and v14 <= v15.endsAt
end

local function force(p12) -- line: 269
    -- upvalues: t1 (copy)
    if type(p12) ~= "string" then
        return
    end

    assert(t1.WEATHERS[p12], "no weather called " .. p12)
    workspace:SetAttribute("WeatherForce", p12)
end

function t1.Test(p13, p14) -- line: 275
    -- upvalues: t1 (copy)
    if p13 == false then
        workspace:SetAttribute("WeatherOffset", nil)
        workspace:SetAttribute("WeatherForce", nil)
        workspace:SetAttribute("WeatherReal", nil)
        workspace:SetAttribute("HalloweenTest", nil)

        return "weather clock back to real time"
    end

    local v18, v19

    if type(p13) == "string" then
        v19 = 0
        v18 = p13
    else
        v19 = p13
        v18 = p14
    end

    if type(v18) == "string" then
        assert(t1.WEATHERS[v18], "no weather called " .. v18)
        workspace:SetAttribute("WeatherForce", v18)
    end

    workspace:SetAttribute("WeatherReal", nil)
    workspace:SetAttribute("HalloweenTest", nil)

    local v22 = type(v19) == "number" and math.max(0, v19) or 0
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v23 = t1.Now()
    local v24 = t1.SlotEnd(t1.SlotOf(v23)) - t1.EVENT - v22

    if v24 <= v23 then
        v24 += t1.CYCLE
    end

    workspace:SetAttribute("WeatherOffset", v24 - ServerTimeNow)

    return v22 > 0 and "weather starts in " .. v22 .. " s" or "weather starts now"
end

function t1.TestEnd(p15, p16) -- line: 297
    -- upvalues: t1 (copy)
    local v25, v26

    if type(p15) == "string" then
        v26 = 5
        v25 = p15
    else
        v26 = p15
        v25 = p16
    end

    if type(v25) == "string" then
        assert(t1.WEATHERS[v25], "no weather called " .. v25)
        workspace:SetAttribute("WeatherForce", v25)
    end

    workspace:SetAttribute("WeatherReal", nil)
    workspace:SetAttribute("HalloweenTest", nil)

    local v29 = type(v26) == "number" and math.clamp(v26, 0, t1.EVENT) or 5
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v30 = t1.Now()
    local v31 = t1.SlotEnd(t1.SlotOf(v30)) - v29

    if v31 <= v30 then
        v31 += t1.CYCLE
    end

    workspace:SetAttribute("WeatherOffset", v31 - ServerTimeNow)

    return "weather ends in " .. v29 .. " s"
end

local function weightOf(p17, p18) -- line: 313
    -- upvalues: t1 (copy)
    if t1.SlotEnd(p18) - t1.EVENT < t1.PINK.STARTS then
        return t1.PINK.BEFORE[p17] or 0
    end

    return t1.WEATHERS[p17].weight
end

local function roll(p19) -- line: 317
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v32 in ipairs(t1.ORDER) do
        n1 += if t1.SlotEnd(p19) - t1.EVENT < t1.PINK.STARTS then t1.PINK.BEFORE[v32] or 0 else t1.WEATHERS[v32].weight
    end

    local v33 = Random.new(p19):NextNumber() * n1

    for _, v34 in ipairs(t1.ORDER) do
        v33 -= if t1.SlotEnd(p19) - t1.EVENT < t1.PINK.STARTS then t1.PINK.BEFORE[v34] or 0 else t1.WEATHERS[v34].weight

        if v33 < 0 then
            return v34
        end
    end

    return t1.ORDER[#t1.ORDER]
end

local v35 = t1.STARTS + t1.VOID_ONLY
local v36 = t1.SlotOf(v35)

if t1.SlotEnd(v36) - t1.EVENT < v35 then
    v36 += 1
end

local t2 = {}
local v37 = v36 - 1
local n2 = 0

local function rolled(p20) -- line: 332
    -- upvalues: t1 (copy), roll (copy), t2 (copy), v37 (ref), n2 (ref)
    if p20 - v37 > 20000 then
        return (roll(p20))
    end

    for i = v37 + 1, p20 do
        local v38 = t1.SlotEnd(i) - t1.EVENT
        local v39 = t1.HalloweenHour(v38, true)

        if v39 == nil or not (v38 <= v39.endsAt) then
            local gives

            if t1.PinkOnly(t1.SlotEnd(i) - t1.EVENT) then
                gives = "PinkMoon"
            else
                local v40 = n2

                gives = v40 >= t1.PITY.after and t1.PITY.gives or roll(i)
            end

            local v41 = gives == t1.PITY.of
            local v42 = if v41 then n2 + 1 else nil

            n2 = if not v41 or not v42 then 0 else v42
            t2[i] = gives
        end

        v37 = i
    end

    return t2[p20]
end

local TicketWeathers
local t3 = {}

local function ticketWeather(p21) -- line: 351
    -- upvalues: t1 (copy), TicketWeathers (ref), t3 (ref)
    local TicketWeathers2 = workspace:GetAttribute("TicketWeathers")

    if TicketWeathers2 ~= TicketWeathers then
        local t4 = {}

        TicketWeathers = TicketWeathers2
        t3 = t4

        if type(TicketWeathers2) == "string" then
            for match, v43 in string.gmatch(TicketWeathers2, "(%d+)=(%w+)") do
                local t5 = t3

                t5[tonumber(match)] = v43
            end
        end
    end

    local v44 = t3[p21]

    return if v44 and t1.WEATHERS[v44] then v44 else nil
end

function t1.Pick(p22) -- line: 364
    -- upvalues: t1 (copy), roll (copy), rolled (copy), ticketWeather (copy)
    local WeatherForce = workspace:GetAttribute("WeatherForce")

    if WeatherForce and t1.WEATHERS[WeatherForce] then
        return WeatherForce
    end

    local v45 = ticketWeather(p22)

    if v45 then
        return v45
    end

    local v46 = t1.SlotEnd(p22) - t1.EVENT

    if v46 < t1.STARTS then
        return if not t1.Live() then roll(p22) else nil
    end

    local v47 = t1.SlotEnd(p22) - t1.EVENT
    local v48 = t1.HalloweenHour(v47, nil)

    if v48 ~= nil and v47 <= v48.endsAt then
        return nil
    end

    if v46 < t1.STARTS + t1.VOID_ONLY then
        return t1.PITY.gives
    end

    if t1.PinkOnly(v46) then
        return "PinkMoon"
    end

    return (rolled(p22))
end

function t1.At(p23) -- line: 381
    -- upvalues: t1 (copy)
    local v49 = t1.SlotOf(p23)
    local v50 = t1.SlotEnd(v49)

    return {
        id = t1.Pick(v49),
        slot = v49,
        startsAt = v50 - t1.EVENT,
        endsAt = v50
    }
end

function t1.Active(p24) -- line: 388
    -- upvalues: t1 (copy)
    local v51 = t1.At(p24)

    return if v51.startsAt <= p24 then v51.id else nil
end

function t1.Shift(p25) -- line: 395
    local WeatherOffset = workspace:GetAttribute("WeatherOffset")

    if type(WeatherOffset) ~= "number" or not WeatherOffset then
        WeatherOffset = 0
    end

    return p25 + WeatherOffset
end

function t1.Started(p26) -- line: 401
    -- upvalues: t1 (copy)
    if (p26 or t1.Now()) >= t1.STARTS then
        return true
    end

    return not t1.Live()
end

function t1.SizeMult(p27) -- line: 406
    -- upvalues: t1 (copy)
    local v52 = t1.Active(p27)

    return v52 and t1.WEATHERS[v52].sizeMult or 1
end

function t1.NextStorm(p28) -- line: 412
    -- upvalues: t1 (copy)
    local v53 = t1.SlotOf(p28)

    for i = v53, v53 + 16 do
        local v54 = t1.SlotEnd(i) - t1.EVENT

        if p28 < v54 and t1.Pick(i) then
            return v54
        end
    end

    return nil
end

function t1.TicketNext(p29) -- line: 422
    -- upvalues: t1 (copy), ticketWeather (copy)
    local v55 = t1.NextStorm(p29)

    if not v55 then
        return nil
    end

    local v56 = t1.SlotOf(v55)
    local v57 = ticketWeather(v56)

    return if v57 and t1.Pick(v56) == v57 then v57 else nil
end

local function halloweenTest(p30) -- line: 437
    -- upvalues: t1 (copy)
    workspace:SetAttribute("WeatherForce", nil)
    workspace:SetAttribute("WeatherReal", nil)
    workspace:SetAttribute("HalloweenTest", true)

    local HALLOWEEN = t1.HALLOWEEN
    local v58 = t1.Now()
    local v60 = p30((math.floor(v58 / HALLOWEEN.EVERY) + 1) * HALLOWEEN.EVERY)

    if v60 <= v58 then
        v60 += HALLOWEEN.EVERY
    end

    workspace:SetAttribute("WeatherOffset", v60 - workspace:GetServerTimeNow())
end

function t1.TestHalloween(p31) -- line: 447
    -- upvalues: halloweenTest (copy)
    local v61 = type(p31) == "number" and math.max(0, p31) or 0

    halloweenTest(function(p32) -- line: 449
        -- upvalues: v61 (copy)
        return p32 - v61
    end)

    return v61 > 0 and "halloween starts in " .. v61 .. " s" or "halloween starts now"
end

function t1.TestHalloweenEnd(p33) -- line: 452
    -- upvalues: t1 (copy)
    local v62 = type(p33) == "number" and math.max(0, p33) or 5
    local v63 = t1.Now()
    local v64 = t1.HalloweenHour(v63)

    if v64 and v64.startsAt <= v63 and v63 < v64.endsAt then
        local WeatherOffset = workspace:GetAttribute("WeatherOffset")

        workspace:SetAttribute("WeatherOffset", (type(WeatherOffset) == "number" and WeatherOffset or 0) + math.max(0, v64.endsAt - v62 - v63))

        return "halloween ends in " .. math.min(v62, v64.endsAt - v63) .. " s"
    end

    return "no halloween is on -- start one first: TestHalloween()"
end

t1.INDEX_ELSEWHERE = {
    {
        id = "MeteorShower",
        name = "METEOR SHOWER",
        zoneShift = 7,
        fish = {
            MeteoriteAnkylosaurus = 1,
            MeteoriteHammereel = 1,
            MeteoriteHelicoprion = 1,
            MeteoriteDunkleosteus = 1,
            LavaEel = 1,
            MeteoriteCrab = 1,
            MeteoriteTriceratops = 2,
            MeteoriteMeg = 2,
            LavaMosasaur = 2,
            LavaLeedsichthys = 2,
            MeteoriteAngelfish = 2,
            MeteoriteTRex = 3,
            LavaLeviathan = 3,
            LavaPlesiosaur = 3,
            LavaCoelacanth = 3,
            LavaHaikouichthys = 3,
            MeteoriteGuppy = 3
        }
    },
    {
        id = "FossilStorm",
        name = "FOSSIL STORM",
        zoneShift = 7,
        fish = {
            FossilizedAnkylosaurus = 1,
            BoneEel = 1,
            FossilizedAngler = 1,
            FossilizedKingCrab = 1,
            FossilGuppy = 1,
            FossilizedTriceratops = 2,
            FossilizedPlesiosaur = 2,
            FossilizedMamoshark = 2,
            FossilizedDunkleosteus = 2,
            FossilGrouper = 2,
            FossilizedTRex = 3,
            FossilizedSpinosaurus = 3,
            Skelemeg = 3,
            BoneLeedsichthys = 3,
            BonedAngelfish = 3
        }
    }
}

return t1
