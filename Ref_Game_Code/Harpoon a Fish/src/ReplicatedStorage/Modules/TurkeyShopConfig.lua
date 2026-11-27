-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ThanksgivingConfig = require(script.Parent:WaitForChild("ThanksgivingConfig"))
local t1 = {
    MUT_VALUE = {
        Thanksgiving = 2
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
    SHOP = {
        {
            key = "Turkey",
            kind = "fish",
            fish = "TurkeyFish",
            price = 3000,
            once = true,
            plus = true,
            desc = "+100% money for your whole aquarium!",
            robux = {
                price = 1000,
                product = 3734004456
            }
        },
        {
            key = "TurkeyLuck",
            kind = "boost",
            mutation = "Thanksgiving",
            mult = 2,
            secs = 900,
            price = 150,
            attr = "TurkeyLuckEnd",
            desc = "2x THANKSGIVING chance for 15 min"
        },
        {
            key = "TurkeyAFish",
            kind = "mutate",
            mutation = "Thanksgiving",
            chance = 0.25,
            price = 75,
            desc = "1 in 4 chance your fish turns THANKSGIVING"
        },
        {
            key = "HatFish",
            kind = "hat",
            chance = 0.2,
            price = 40,
            desc = "1 in 5 chance your fish gets a turkey hat (can't be traded)"
        }
    },
    BY_KEY = {}
}

for _, v1 in ipairs(t1.SHOP) do
    t1.BY_KEY[v1.key] = v1
end

function t1.BoostMul(p1, p2, p3) -- line: 42
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

function t1.ByProduct(p4) -- line: 53
    -- upvalues: t1 (copy)
    if not p4 or p4 == 0 then
        return nil
    end

    for _, v4 in ipairs(t1.SHOP) do
        if v4.robux and v4.robux.product == p4 then
            return v4
        end
    end

    return nil
end

function t1.Open(p5) -- line: 62
    -- upvalues: ThanksgivingConfig (copy)
    return ThanksgivingConfig.TicketsLive(p5)
end

function t1.Value(p6, p7, p8, p9, p10) -- line: 66
    -- upvalues: ThanksgivingConfig (copy), t1 (copy)
    local VALUES, v5

    if not p6 or p7 ~= ThanksgivingConfig.HAT or p8 then
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
