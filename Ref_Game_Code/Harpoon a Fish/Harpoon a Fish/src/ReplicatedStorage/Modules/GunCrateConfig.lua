-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GunSkins = require(script.Parent:WaitForChild("GunSkins"))
local t1 = {
    ORDER = { "Tier1", "Tier2", "Tier3" },
    CRATES = {
        Tier1 = {
            name = "Rare Crate",
            rarity = "Rare",
            price = 100,
            dup = 20,
            key = {
                tier = "Tier2",
                chance = 10
            }
        },
        Tier2 = {
            name = "Legendary Crate",
            rarity = "Legendary",
            dup = 60,
            key = {
                tier = "Tier3",
                chance = 5
            }
        },
        Tier3 = {
            name = "Mythical Crate",
            rarity = "Mythic",
            dup = 100
        }
    },
    KEYS = {
        Tier1 = {
            name = "Rare Key",
            image = "rbxassetid://113433235287302",
            rect = { 0, 0, 512, 512 },
            tint = Color3.fromRGB(255, 255, 255)
        },
        Tier2 = {
            name = "Legendary Key",
            image = "rbxassetid://95811590499182",
            rect = { 0, 0, 512, 512 },
            tint = Color3.fromRGB(255, 255, 255)
        },
        Tier3 = {
            name = "Mythical Key",
            image = "rbxassetid://102366219320588",
            rect = { 0, 0, 512, 512 },
            tint = Color3.fromRGB(255, 255, 255)
        }
    },
    BURST_AT = 2.5
}

local function drops(p1) -- line: 39
    -- upvalues: GunSkins (copy), t1 (copy)
    local v1 = t1.CRATES[p1]
    local t2 = {}
    local v2 = 100

    if v1.key then
        t2[1] = {
            key = v1.key.tier,
            chance = v1.key.chance,
            rarity = t1.CRATES[v1.key.tier].rarity
        }
        v2 = 100 - v1.key.chance
    end

    local v3 = GunSkins.OfRarity(v1.rarity)
    local n1 = 0

    for _, v4 in ipairs(v3) do
        local v6 = math.round(v2 / #v3 * 100) / 100

        n1 += v6
        t2[#t2 + 1] = {
            skin = v4.id,
            chance = v6,
            rarity = v1.rarity
        }
    end

    t2[#t2].chance = math.round((t2[#t2].chance + v2 - n1) * 100) / 100

    return t2
end

t1.DROPS = {}

for _, v9 in ipairs(t1.ORDER) do
    t1.DROPS[v9] = drops(v9)
end

function t1.Get(p2) -- line: 61
    -- upvalues: t1 (copy)
    return p2 and t1.CRATES[p2] or nil
end

function t1.KeyAttr(p3) -- line: 62
    return "GunKey" .. p3
end

function t1.ChanceText(p4) -- line: 65
    return string.format("%g%%", p4.chance)
end

function t1.Buyable(p5) -- line: 68
    -- upvalues: t1 (copy)
    return t1.CRATES[p5] ~= nil and t1.CRATES[p5].price ~= nil
end

function t1.Title(p6) -- line: 71
    -- upvalues: GunSkins (copy), t1 (copy)
    if p6.key then
        return t1.KEYS[p6.key].name
    end

    local v10 = GunSkins.Get(p6.skin)

    return v10 and v10.name or "?"
end

function t1.Roll(p7, p8) -- line: 78
    -- upvalues: t1 (copy)
    local v11 = t1.DROPS[p7]

    if not v11 then
        return nil
    end

    local v12 = (p8 and p8:NextNumber() or math.random()) * 100

    for v13, v14 in ipairs(v11) do
        v12 -= v14.chance

        if v12 < 0 then
            return v14, v13
        end
    end

    return v11[#v11], #v11
end

function t1.Keys(p9) -- line: 90
    -- upvalues: t1 (copy)
    local BlackMarket2 = type(p9.BlackMarket) == "table" and p9.BlackMarket or {}

    p9.BlackMarket = BlackMarket2

    local GunKeys2 = type(BlackMarket2.GunKeys) == "table" and BlackMarket2.GunKeys or {}

    for _, v15 in ipairs(t1.ORDER) do
        GunKeys2[v15] = math.max(0, (math.floor(tonumber(GunKeys2[v15]) or 0)))
    end

    BlackMarket2.GunKeys = GunKeys2

    return GunKeys2
end

return t1
