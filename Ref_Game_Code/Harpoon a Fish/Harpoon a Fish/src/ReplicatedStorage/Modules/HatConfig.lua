-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TIERS = { "Mythic", "Legendary", "Rare" },
    PRICE = {
        Rare = 50,
        Legendary = 200,
        Mythic = 500
    },
    ODDS = {
        Rare = 75,
        Legendary = 15,
        Mythic = 10
    },
    COLOR = {
        Rare = Color3.fromRGB(255, 70, 70),
        Legendary = Color3.fromRGB(255, 214, 40),
        Mythic = Color3.fromRGB(255, 70, 190)
    },
    SLOTS = 3,
    COOLDOWN = 2,
    DAY = 86400,
    START = 20400,
    LIST = {
        {
            key = "FjordHelm",
            name = "Fjord Helm",
            tier = "Mythic"
        },
        {
            key = "FishbowlHelmet",
            name = "Fishbowl Helmet",
            tier = "Mythic"
        },
        {
            key = "CowboyHat",
            name = "Cowboy Hat",
            tier = "Mythic"
        },
        {
            key = "PropFella",
            name = "Prop-Fella",
            tier = "Legendary"
        },
        {
            key = "ArmyHelmet",
            name = "Army Helmet",
            tier = "Legendary"
        },
        {
            key = "GoneFishin",
            name = "Gone Fishin'",
            tier = "Legendary"
        },
        {
            key = "HighRoller",
            name = "High Roller",
            tier = "Legendary"
        },
        {
            key = "CapnTricorn",
            name = "Cap'n Tricorn",
            tier = "Legendary"
        },
        {
            key = "HolyMackerel",
            name = "Holy Mackerel",
            tier = "Rare"
        },
        {
            key = "ConeHead",
            name = "Cone Head",
            tier = "Rare"
        },
        {
            key = "AnglerLamp",
            name = "Angler Lamp",
            tier = "Rare"
        },
        {
            key = "FinDisguise",
            name = "Fin Disguise",
            tier = "Rare"
        },
        {
            key = "SchoolsOut",
            name = "School's Out",
            tier = "Rare"
        },
        {
            key = "CrabbyCap",
            name = "Crabby Cap",
            tier = "Rare"
        },
        {
            key = "BaseballCap",
            name = "Baseball Cap",
            tier = "Rare"
        }
    }
}
local t2 = {}

for _, v1 in ipairs(t1.LIST) do
    t2[v1.key] = v1
end

function t1.Get(p1) -- line: 45
    -- upvalues: t2 (copy)
    return if p1 then t2[p1] or nil else nil
end

function t1.Price(p2) -- line: 46
    -- upvalues: t1 (copy), t2 (copy)
    local v3 = t2[p2]

    return v3 and t1.PRICE[v3.tier] or nil
end

function t1.Day(p3) -- line: 48
    -- upvalues: t1 (copy)
    return (math.floor((p3 or os.time()) / t1.DAY))
end

function t1.SecondsLeft(p4) -- line: 49
    -- upvalues: t1 (copy)
    p4 = p4 or os.time()

    return (t1.Day(p4) + 1) * t1.DAY - p4
end

local function draw(p5, p6) -- line: 55
    -- upvalues: t1 (copy)
    local v6 = Random.new(p5 * 7919 + 17)
    local t3 = {}
    local t4 = {}

    for _ = 1, t1.SLOTS do
        local v7 = v6:NextNumber() * 100
        local v8 = if v7 < t1.ODDS.Mythic then "Mythic" elseif v7 < t1.ODDS.Mythic + t1.ODDS.Legendary then "Legendary" else "Rare"
        local v9 = table.find(t1.TIERS, v8)
        local t5 = {}

        for i = v9, #t1.TIERS do
            table.insert(t5, t1.TIERS[i])
        end

        for j = v9 - 1, 1, -1 do
            table.insert(t5, t1.TIERS[j])
        end

        local v12

        for _, v13 in ipairs(t5) do
            local t6 = {}

            for _, v14 in ipairs(t1.LIST) do
                if v14.tier == v13 and not p6[v14.key] and not t4[v14.key] then
                    table.insert(t6, v14.key)
                end
            end

            if #t6 > 0 then
                v12 = t6[v6:NextInteger(1, #t6)]
                break
            end

            v12 = nil
        end

        if v12 then
            t4[v12] = true
            table.insert(t3, v12)
        end
    end

    return t3
end

local t7 = {}
local v15 = t1.START - 1

function t1.Shop(p7) -- line: 85
    -- upvalues: t1 (copy), draw (copy), t7 (copy), v15 (ref)
    p7 = p7 or t1.Day()

    if p7 < t1.START then
        return (draw(p7, {}))
    end

    for i = v15 + 1, p7 do
        local t8 = {}

        for j = 1, t1.COOLDOWN do
            for _, v17 in ipairs(t7[i - j] or {}) do
                t8[v17] = true
            end
        end

        t7[i] = draw(i, t8)
        t7[i - t1.COOLDOWN - 2] = nil
        v15 = i
    end

    return t7[p7] or draw(p7, {})
end

return t1
