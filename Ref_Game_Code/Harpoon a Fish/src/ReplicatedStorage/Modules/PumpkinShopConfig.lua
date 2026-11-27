-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local WeatherConfig = require(script.Parent:WaitForChild("WeatherConfig"))
local t1 = {
    SPOT = Vector3.new(49, 0, -60),
    FACE = Vector3.new(0, 0, 1),
    SCALE = 0.75,
    SINK = 1.1,
    MUT_VALUE = {
        Ghost = 2,
        Hallowed = 3
    },
    VALUES = {
        Common = 1,
        Uncommon = 1,
        Rare = 1,
        Epic = 2,
        Legendary = 4,
        Mythic = 10,
        Exotic = 30,
        Secret = 100,
        Unknown = 100,
        Celestial = 100,
        Apex = 200
    },
    SUMMON = 10,
    SHOP = {
        {
            key = "HallowedLeviathan",
            kind = "fish",
            fish = "AbyssalFlameLeviathan",
            price = 1500,
            once = true,
            desc = "Copies your best fish's $/s!",
            robux = {
                price = 1000,
                product = 3721657337
            }
        },
        {
            key = "Summon",
            kind = "summon",
            price = 200,
            desc = "Pick a zone: its pumpkin opens in 10 s!",
            robux = {
                price = 149,
                product = 3721471923
            }
        },
        {
            key = "PumpkinGuppy",
            kind = "fish",
            fish = "PumpkinGuppy",
            price = 150,
            once = true,
            desc = "+20% money for your whole aquarium! (+2.5% every grow)"
        },
        {
            key = "HallowedUpgrade",
            kind = "upgrade",
            ghostOdds = 0.1,
            keepHats = 50,
            desc = "Your fish: 1 in 10 HALLOWED, otherwise GHOST",
            odds = {
                { "Hallowed", 0.1 },
                { "Ghost", 0.9 }
            },
            robux = {
                price = 149,
                product = 3721471887
            }
        },
        {
            key = "HallowedLuck",
            kind = "boost",
            mutation = "Hallowed",
            mult = 2,
            secs = 900,
            price = 100,
            attr = "HallowedLuckEnd",
            desc = "2x HALLOWED chance for 15 min"
        },
        {
            key = "HallowedLuck5",
            kind = "boost",
            mutation = "Hallowed",
            mult = 5,
            secs = 900,
            attr = "HallowedLuck5End",
            desc = "5x HALLOWED chance for 15 min",
            robux = {
                price = 299,
                product = 3721471897
            }
        },
        {
            key = "GhostFish",
            kind = "ghost",
            chance = 0.25,
            price = 50,
            desc = "1 in 4 chance your fish turns GHOST"
        },
        {
            key = "GhostLuck",
            kind = "boost",
            mutation = "Ghost",
            mult = 2,
            secs = 900,
            price = 40,
            attr = "GhostLuckEnd",
            desc = "2x GHOST chance for 15 min",
            robux = {
                price = 79,
                product = 3721471907
            }
        },
        {
            key = "HatFish",
            kind = "hat",
            price = 25,
            chance = 0.2,
            desc = "1 in 5 chance your fish gets a witch hat (can't be traded)"
        }
    },
    BY_KEY = {}
}

for _, v1 in ipairs(t1.SHOP) do
    t1.BY_KEY[v1.key] = v1
end

function t1.BoostMul(p1, p2, p3) -- line: 76
    -- upvalues: t1 (copy)
    local n1 = 1

    for _, v2 in ipairs(t1.SHOP) do
        if v2.kind == "boost" and v2.mutation == p2 then
            local v3 = p1 and p1:GetAttribute(v2.attr)

            if type(v3) == "number" and (p3 or workspace:GetServerTimeNow()) < v3 then
                n1 = math.max(n1, v2.mult)
            end
        end
    end

    return n1
end

function t1.ByProduct(p4) -- line: 87
    -- upvalues: t1 (copy)
    for _, v4 in ipairs(t1.SHOP) do
        if v4.robux and v4.robux.product == p4 then
            return v4
        end
    end

    return nil
end

function t1.Open(p5) -- line: 95
    -- upvalues: WeatherConfig (copy)
    return WeatherConfig.HatChance(p5 or WeatherConfig.Now()) > 0
end

function t1.Value(p6, p7, p8, p9, p10) -- line: 103
    -- upvalues: t1 (copy)
    local VALUES, v5

    if not p6 or not p7 or p8 then
        return nil
    else
        VALUES = t1.VALUES
        v5 = p6.acts or p6.rarity
    end

    local v7 = VALUES[v5]
    local v8 = not (p10 ~= nil and p10 == p9) and t1.MUT_VALUE[p9] or 1

    return v7 and v7 * v8
end

return t1
