-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HarpoonSkins = require(script.Parent:WaitForChild("HarpoonSkins"))
local t1 = {
    BRIBE = 1E+09,
    HIGH_ROLLER = 1E+12,
    TOKENS = {
        Common = 1,
        Uncommon = 2,
        Rare = 4,
        Epic = 8,
        Legendary = 20,
        Mythic = 50,
        Secret = 150
    },
    LEVELS = {
        {
            cost = 0,
            speed = 300,
            batch = 1
        },
        {
            cost = 2.5E+09,
            speed = 240,
            batch = 2
        },
        {
            cost = 1E+10,
            speed = 180,
            batch = 3
        },
        {
            cost = 4E+10,
            speed = 150,
            batch = 4
        },
        {
            cost = 2E+11,
            speed = 120,
            batch = 5
        },
        {
            cost = 1E+12,
            speed = 90,
            batch = 6
        },
        {
            cost = 5E+12,
            speed = 75,
            batch = 8
        },
        {
            cost = 2.5E+13,
            speed = 60,
            batch = 10
        },
        {
            cost = 1.5E+14,
            speed = 45,
            batch = 12
        },
        {
            cost = 1E+15,
            speed = 30,
            batch = 15
        }
    }
}

t1.MAX_LEVEL = #t1.LEVELS

function t1.Level(p1) -- line: 44
    -- upvalues: t1 (copy)
    return t1.LEVELS[math.clamp(math.floor(tonumber(p1) or 1), 1, t1.MAX_LEVEL)]
end

function t1.UpgradeCost(p2) -- line: 49
    -- upvalues: t1 (copy)
    local v4 = math.floor(tonumber(p2) or 1)

    return if not (t1.MAX_LEVEL <= v4) then t1.LEVELS[v4 + 1].cost else nil
end

function t1.TokensFor(p3) -- line: 55
    -- upvalues: HarpoonSkins (copy), t1 (copy)
    local v5 = HarpoonSkins.Get(p3)

    return v5 and t1.TOKENS[v5.rarity] or 1
end

function t1.Upgraded(p4) -- line: 65
    if type(p4) ~= "table" then
        return false
    end

    if (tonumber(p4.amp) or 0) > 0 or p4.s1 ~= nil or p4.s2 ~= nil or p4.slot2 == true or (tonumber(p4.rolls) or 0) > 0 then
        return true
    end

    return p4.pending ~= nil
end

local function ownedOk(p5, p6) -- line: 69
    -- upvalues: HarpoonSkins (copy), t1 (copy)
    local v6 = HarpoonSkins.Get(p6)

    if v6 == nil or v6.crate == nil or v6.rarity == "Secret" or p5.Harpoons.Equipped == p6 then
        return false
    end

    return not t1.Upgraded(type(p5.HarpoonUps) == "table" and p5.HarpoonUps[p6] or nil)
end

function t1.CanCompactOwned(p7, p8) -- line: 75
    -- upvalues: ownedOk (copy)
    local v7 = p7 and p7.Harpoons

    if type(v7) ~= "table" or type(v7.Bag) ~= "table" or table.find(v7.Bag, p8) == nil then
        return false
    end

    return (ownedOk(p7, p8))
end

function t1.OwnedCompactable(p9) -- line: 80
    -- upvalues: ownedOk (copy)
    local t2 = {}
    local v8 = p9 and p9.Harpoons

    if type(v8) == "table" and type(v8.Bag) == "table" then
        for _, v9 in ipairs(v8.Bag) do
            if ownedOk(p9, v9) then
                t2[#t2 + 1] = v9
            end
        end

        return t2
    end

    return t2
end

function t1.Count(p10) -- line: 90
    local n1 = 0

    for _, v10 in pairs(p10) do
        n1 += v10
    end

    return n1
end

function t1.Of(p11) -- line: 97
    -- upvalues: t1 (copy)
    local BlackMarket2 = type(p11.BlackMarket) == "table" and p11.BlackMarket or {}

    BlackMarket2.Spares = type(BlackMarket2.Spares) == "table" and BlackMarket2.Spares or {}
    BlackMarket2.Hopper = type(BlackMarket2.Hopper) == "table" and BlackMarket2.Hopper or {}
    BlackMarket2.Bin = tonumber(BlackMarket2.Bin) or 0
    BlackMarket2.Tokens = tonumber(BlackMarket2.Tokens) or 0
    BlackMarket2.Level = math.clamp(math.floor(tonumber(BlackMarket2.Level) or 1), 1, t1.MAX_LEVEL)
    BlackMarket2.Last = tonumber(BlackMarket2.Last) or 0
    p11.BlackMarket = BlackMarket2

    return BlackMarket2
end

function t1.NextPress(p12) -- line: 110
    -- upvalues: t1 (copy)
    local v13 = t1.Of(p12)

    return if p12.BouncerPaid and t1.Count(v13.Hopper) ~= 0 and not (v13.Last <= 0) then v13.Last + t1.Level(v13.Level).speed else nil
end

local function crush(p13, p14) -- line: 117
    -- upvalues: t1 (copy)
    local t3 = {}

    for v14, v15 in pairs(p13.Hopper) do
        if v15 > 0 then
            t3[#t3 + 1] = v14
        else
            p13.Hopper[v14] = nil
        end
    end

    table.sort(t3, function(p15, p16) -- line: 122
        -- upvalues: t1 (copy)
        local v16 = t1.TokensFor(p15)
        local v17 = t1.TokensFor(p16)

        if v16 == v17 then
            return p15 < p16
        end

        return v17 < v16
    end)

    local n2 = 0
    local n3 = 0

    for _, v18 in ipairs(t3) do
        if p14 <= n2 then
            break
        end

        local v21 = math.min(p13.Hopper[v18], p14 - n2)

        p13.Hopper[v18] -= v21

        if p13.Hopper[v18] <= 0 then
            p13.Hopper[v18] = nil
        end

        n2 += v21
        n3 += v21 * t1.TokensFor(v18)
    end

    p13.Bin += n3

    return n2, n3
end

function t1.Settle(p17, p18) -- line: 142
    -- upvalues: t1 (copy), crush (copy)
    local v22 = t1.Of(p17)
    local v23 = t1.Count(v22.Hopper)

    if p17.BouncerPaid and v23 ~= 0 and not (v22.Last <= 0) and not (p18 < v22.Last) then
        local speed = t1.Level(v22.Level).speed
        local v25 = math.floor((p18 - v22.Last) / speed)

        if v25 < 1 then
            return 0, 0
        end

        local v27, v28 = crush(v22, (math.min(v25 * t1.Level(v22.Level).batch, v23)))

        if v23 <= v27 then
            v22.Last = p18
        else
            v22.Last += v25 * speed
        end

        return v27, v28
    end

    v22.Last = p18

    return 0, 0
end

function t1.Add(p19, p20, p21, _) -- line: 158
    -- upvalues: t1 (copy)
    if type(p20) == "string" and not ((tonumber(p21) or 0) < 1) then
        local v29 = t1.Of(p19)

        v29.Spares[p20] = (v29.Spares[p20] or 0) + math.floor(p21)
    end
end

function t1.Insert(p23, p24, p25) -- line: 166
    -- upvalues: t1 (copy)
    if type(p24) ~= "table" then
        return 0
    end

    t1.Settle(p23, p25)

    local BlackMarket = p23.BlackMarket
    local n4 = 0

    for v30, v31 in pairs(p24) do
        local v32 = type(v30) == "string" and BlackMarket.Spares[v30] or 0
        local v35 = math.min(v32, (math.floor(tonumber(v31) or 0)))

        if v35 > 0 then
            BlackMarket.Spares[v30] = v32 - v35

            if BlackMarket.Spares[v30] <= 0 then
                BlackMarket.Spares[v30] = nil
            end

            BlackMarket.Hopper[v30] = (BlackMarket.Hopper[v30] or 0) + v35
            n4 += v35
        end
    end

    return n4
end

function t1.CrushAll(p26, p27) -- line: 185
    -- upvalues: t1 (copy), crush (copy)
    local v36 = t1.Of(p26)
    local v37, v38 = crush(v36, t1.Count(v36.Hopper))

    v36.Last = p27

    return v37, v38
end

return t1
