-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    MAX_TIME = 1800,
    List = {
        {
            id = "luck",
            name = "Luck Potion",
            short = "LUCK",
            seconds = 300,
            weight = 14,
            stats = {
                luck = 2
            },
            Color = fromRGB(130, 245, 110),
            Color2 = fromRGB(30, 160, 60)
        },
        {
            id = "cash",
            name = "Cash Potion",
            short = "CASH",
            seconds = 300,
            weight = 14,
            stats = {
                cash = 2
            },
            Color = fromRGB(255, 220, 80),
            Color2 = fromRGB(220, 140, 20)
        },
        {
            id = "strength",
            name = "Strength Potion",
            short = "STRENGTH",
            seconds = 300,
            weight = 12,
            stats = {
                strength = 2
            },
            Color = fromRGB(255, 150, 70),
            Color2 = fromRGB(220, 80, 30)
        },
        {
            id = "cosmic",
            name = "Cosmic Potion",
            short = "ALL",
            seconds = 180,
            weight = 5,
            stats = {
                luck = 2,
                cash = 2,
                strength = 2
            },
            Color = fromRGB(200, 140, 255),
            Color2 = fromRGB(90, 40, 200)
        }
    },
    ById = {}
}

for _, v1 in ipairs(t1.List) do
    t1.ById[v1.id] = v1
end

local function now() -- line: 24
    return workspace:GetServerTimeNow()
end

function t1.Left(p1, p2) -- line: 28
    local Attribute = p1:GetAttribute("Buff_" .. p2)

    if type(Attribute) ~= "number" then
        return 0
    end

    return (math.max(0, Attribute - workspace:GetServerTimeNow()))
end

function t1.Mult(p3, p4) -- line: 36
    -- upvalues: t1 (copy)
    local n1 = 1

    for _, v3 in ipairs(t1.List) do
        local v4 = v3.stats[p4]

        if v4 and n1 < v4 and t1.Left(p3, v3.id) > 0 then
            n1 = v4
        end
    end

    return n1
end

function t1.Pick(p5) -- line: 48
    -- upvalues: t1 (copy)
    local n2 = 0

    for _, v5 in ipairs(t1.List) do
        n2 += v5.weight
    end

    local v6 = p5:NextNumber() * n2

    for _, v7 in ipairs(t1.List) do
        v6 -= v7.weight

        if v6 <= 0 then
            return v7
        end
    end

    return t1.List[1]
end

return t1
