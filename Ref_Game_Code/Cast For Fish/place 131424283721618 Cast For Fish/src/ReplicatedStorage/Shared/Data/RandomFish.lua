-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Fish = require(script.Parent.Fish)
local t1 = {
    Chances = {
        {
            rarity = "Common",
            chance = 22
        },
        {
            rarity = "Uncommon",
            chance = 17
        },
        {
            rarity = "Rare",
            chance = 13
        },
        {
            rarity = "Epic",
            chance = 10
        },
        {
            rarity = "Legendary",
            chance = 8
        },
        {
            rarity = "Mythic",
            chance = 7
        },
        {
            rarity = "Secret",
            chance = 6
        },
        {
            rarity = "Divine",
            chance = 5
        },
        {
            rarity = "Celestial",
            chance = 4
        },
        {
            rarity = "Eternal",
            chance = 3
        },
        {
            rarity = "Cosmic",
            chance = 2
        },
        {
            rarity = "Supreme",
            chance = 1.3
        },
        {
            rarity = "Sovereign",
            chance = 0.8
        },
        {
            rarity = "Ascended",
            chance = 0.4
        },
        {
            rarity = "Primordial",
            chance = 0.25
        },
        {
            rarity = "Omega",
            chance = 0.13
        },
        {
            rarity = "Transcendent",
            chance = 0.07
        },
        {
            rarity = "Apex",
            chance = 0.035
        },
        {
            rarity = "Absolute",
            chance = 0.015
        }
    }
}
local t2 = nil

function t1.Allowed(p1) -- line: 29
    if type(p1) == "table" then
        return not p1.exclusive and not p1.endgame
    end

    return false
end

function t1.Pool() -- line: 33
    -- upvalues: Fish (copy), t1 (copy), t2 (ref)
    if t2 then
        return t2
    end

    t2 = {}

    for _, v1 in t1.Chances do
        t2[v1.rarity] = {}
    end

    for _, v2 in Fish.List do
        local v3 = t2[v2.rarity]

        if v3 and t1.Allowed(v2) then
            table.insert(v3, v2.id)
        end
    end

    return t2
end

function t1.Entries() -- line: 50
    -- upvalues: t1 (copy)
    local t5 = {}
    local v4 = t1.Pool()

    for _, v5 in t1.Chances do
        if #v4[v5.rarity] > 0 then
            table.insert(t5, v5)
        end
    end

    return t5
end

function t1.Total() -- line: 61
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v6 in t1.Entries() do
        n1 += v6.chance
    end

    return n1
end

function t1.PickRarity(p2) -- line: 69
    -- upvalues: t1 (copy)
    local v7 = t1.Entries()
    local v8 = p2 * t1.Total()

    for _, v9 in v7 do
        v8 -= v9.chance

        if v8 < 0 then
            return v9
        end
    end

    return v7[#v7]
end

function t1.FishChance(p3) -- line: 81
    -- upvalues: Fish (copy), t1 (copy)
    local v10 = Fish.ById[p3]

    if t1.Allowed(v10) then
        local v11 = t1.Pool()[v10.rarity]

        for _, v12 in t1.Entries() do
            if v12.rarity == v10.rarity then
                return v12.chance / t1.Total() * 100 / #v11
            end
        end
    end

    return 0
end

function t1.All() -- line: 95
    -- upvalues: t1 (copy)
    local t6 = {}
    local v13 = t1.Pool()

    for _, v14 in t1.Chances do
        for _, v15 in v13[v14.rarity] do
            table.insert(t6, v15)
        end
    end

    return t6
end

return t1
