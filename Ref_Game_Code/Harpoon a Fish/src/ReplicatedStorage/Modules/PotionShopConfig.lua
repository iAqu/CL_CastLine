-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local PotionConfig = require(script.Parent:WaitForChild("PotionConfig"))
local t1 = {
    ALWAYS = { "Body", "Bag", "Fat" },
    POTIONS = {
        Body = {
            potion = "Body",
            name = "Body Potion",
            effect = "Switches your body!",
            price = 75,
            desc = "One sip and you swap between your normal body and your FAT body. Drink it again to switch back!",
            color = Color3.fromRGB(30, 215, 185)
        },
        Bag = {
            potion = "B1",
            name = "Bag Potion",
            effect = "+10 bag space",
            price = 30,
            desc = "Your bag holds 10 more fish while it lasts.",
            lasts = PotionConfig.TIERS.B1.minutes,
            color = PotionConfig.KINDS.Bag.color
        },
        Fat = {
            potion = "T1",
            name = "Fat Potion",
            effect = "x3 fat from every bite",
            price = 40,
            desc = "Every fish you eat makes you three times fatter while it lasts.",
            lasts = PotionConfig.TIERS.T1.minutes,
            color = PotionConfig.KINDS.Fat.color
        },
        Mutation = {
            potion = "Mutation",
            name = "2X Mutation",
            effect = "x2 mutation chance",
            lasts = 5,
            price = 120,
            stock = 2,
            weight = 10,
            desc = "Twice as many of your fish come out mutated.",
            color = Color3.fromRGB(175, 80, 255)
        },
        Catch = {
            potion = "Catch",
            name = "Double Catch",
            effect = "+25% double catch",
            lasts = 5,
            price = 100,
            stock = 2,
            weight = 10,
            desc = "A 25% chance to reel in TWO of every fish you catch.",
            color = Color3.fromRGB(60, 215, 80)
        },
        XP = {
            potion = "XP",
            name = "2X XP",
            effect = "x2 XP from everything",
            lasts = 5,
            price = 60,
            stock = 3,
            weight = 10,
            desc = "Every bit of XP you earn is doubled.",
            color = Color3.fromRGB(255, 200, 40)
        },
        Slow = {
            potion = "Slow",
            name = "Slow Potion",
            effect = "Catch needle 25% slower",
            lasts = 5,
            price = 80,
            stock = 2,
            weight = 8,
            desc = "The catch needle swings slower. Easier to hit!",
            color = Color3.fromRGB(110, 210, 255)
        },
        Size = {
            potion = "Size",
            name = "Size Hormones",
            effect = "+5% fish size",
            lasts = 5,
            price = 70,
            stock = 3,
            weight = 8,
            desc = "Every fish you catch comes out 5% bigger.",
            color = Color3.fromRGB(225, 30, 90)
        },
        MegaSize = {
            potion = "MegaSize",
            name = "Mega Hormones",
            effect = "+10% fish size",
            lasts = 5,
            price = 140,
            stock = 1,
            weight = 3,
            desc = "Every fish you catch comes out 10% bigger.",
            color = Color3.fromRGB(190, 20, 70)
        },
        Molten = {
            potion = "Molten",
            name = "Molten Rush",
            effect = "x5 Molten chance",
            lasts = 5,
            price = 80,
            stock = 2,
            weight = 6,
            desc = "Molten fish come five times as often.",
            color = Color3.fromRGB(255, 100, 0)
        },
        Radioactive = {
            potion = "Radioactive",
            name = "Radioactive Rush",
            effect = "x5 Radioactive chance",
            lasts = 5,
            price = 90,
            stock = 2,
            weight = 6,
            desc = "Radioactive fish come five times as often.",
            color = Color3.fromRGB(120, 255, 40)
        },
        Shadow = {
            potion = "Shadow",
            name = "Shadow Rush",
            effect = "x5 Shadow chance",
            lasts = 5,
            price = 110,
            stock = 2,
            weight = 5,
            desc = "Shadow fish come five times as often.",
            color = Color3.fromRGB(130, 60, 200)
        },
        Electric = {
            potion = "Electric",
            name = "Electric Rush",
            effect = "x5 Electric chance",
            lasts = 5,
            price = 140,
            stock = 1,
            weight = 4,
            desc = "Electric fish come five times as often.",
            color = Color3.fromRGB(30, 100, 255)
        },
        Rainbow = {
            potion = "Rainbow",
            name = "Rainbow Rush",
            effect = "x5 Rainbow chance",
            lasts = 5,
            price = 250,
            stock = 1,
            weight = 2,
            desc = "Rainbow fish come five times as often.",
            color = Color3.fromRGB(255, 90, 200)
        }
    }
}

for v1, v2 in pairs(t1.POTIONS) do
    v2.id = v1
end

t1.SERVE_HAND = 2.15
t1.FRESH_ORDER = {
    "Mutation",
    "Catch",
    "XP",
    "Slow",
    "Size",
    "MegaSize",
    "Molten",
    "Radioactive",
    "Shadow",
    "Electric",
    "Rainbow"
}

function t1.Get(p1) -- line: 68
    -- upvalues: t1 (copy)
    return p1 and t1.POTIONS[p1] or nil
end

function t1.IsFresh(p2) -- line: 69
    -- upvalues: t1 (copy)
    local v3 = t1.POTIONS[p2]

    return v3 ~= nil and v3.weight ~= nil
end

t1.HOUR = 3600
t1.SLOTS = 5

function t1.Hour(p3) -- line: 74
    -- upvalues: t1 (copy)
    return (math.floor((p3 or os.time()) / t1.HOUR))
end

function t1.SecondsLeft(p4) -- line: 75
    -- upvalues: t1 (copy)
    p4 = p4 or os.time()

    return (t1.Hour(p4) + 1) * t1.HOUR - p4
end

function t1.Fresh(p5) -- line: 80
    -- upvalues: t1 (copy)
    local v6 = Random.new(p5 * 7919 + 431)
    local v7 = table.clone(t1.FRESH_ORDER)
    local t2 = {}

    for _ = 1, math.min(t1.SLOTS, #v7) do
        local n1 = 0

        for _, v9 in ipairs(v7) do
            n1 += t1.POTIONS[v9].weight
        end

        local v10 = v6:NextNumber() * n1

        for v11, v12 in ipairs(v7) do
            v10 -= t1.POTIONS[v12].weight

            if v10 <= 0 then
                table.insert(t2, v12)
                table.remove(v7, v11)
                break
            end

            if v11 == #v7 then
                table.insert(t2, v12)
                table.remove(v7, v11)
                break
            end
        end
    end

    return t2
end

return t1
