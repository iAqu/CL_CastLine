-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ShopConfig = require(script.Parent:WaitForChild("ShopConfig"))
local t1 = {}

t1.CASH_FLOOR = 1000
t1.GRACE = 300
t1.GIFTS = {
    {
        at = 60,
        potion = "B1"
    },
    {
        at = 180,
        cash = 2,
        first = 50000
    },
    {
        at = 300,
        xp = 1000
    },
    {
        at = 420,
        potion = "T1"
    },
    {
        at = 600,
        cash = 4,
        first = 5E+05
    },
    {
        at = 780,
        xp = 3000
    },
    {
        at = 1020,
        cash = 6,
        first = 1E+07
    },
    {
        at = 1320,
        potion = "T1"
    },
    {
        at = 1800,
        egg = true,
        fat = 600
    }
}

function t1.EggKind(p1, p2, p3) -- line: 59
    p1 = p1 or 0

    if p1 == 0 and not p2 then
        return "HellEgg"
    end

    if p1 ~= 1 or p3 then
        return "fat"
    end

    return "MassiveEgg"
end

function t1.Cash(p4, p5, p6) -- line: 67
    -- upvalues: t1 (copy)
    return (math.max(p6 and p4.first or t1.CASH_FLOOR, (math.floor((p5 or 0) * 60 * p4.cash))))
end

function t1.Fat(p7, p8, p9) -- line: 72
    -- upvalues: ShopConfig (copy)
    return ShopConfig.FatFor({
        secs = p7.fat
    }, p8, p9)
end

function t1.Unpack(p10) -- line: 77
    local t2 = {}

    for match in string.gmatch(p10 or "", "%d+") do
        t2[tonumber(match)] = true
    end

    return t2
end

function t1.Pack(p11) -- line: 82
    -- upvalues: t1 (copy)
    local t3 = {}

    for v4 in ipairs(t1.GIFTS) do
        if p11[v4] then
            t3[#t3 + 1] = tostring(v4)
        end
    end

    return table.concat(t3, ",")
end

return t1
