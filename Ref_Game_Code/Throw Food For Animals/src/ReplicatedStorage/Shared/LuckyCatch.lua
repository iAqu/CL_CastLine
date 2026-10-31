-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local MutationsConfig = require(ReplicatedStorage.Config.MutationsConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local LuckyCatch = GameConfig.LuckyCatch
local t1 = {}

t1.Config = LuckyCatch

local function mutationChance(p1) -- line: 39
    -- upvalues: MutationsConfig (copy)
    if p1 then
        local v1 = MutationsConfig.Get(p1)

        return v1 and v1.Chance or 1
    end

    local n1 = 0

    for _, v2 in ipairs(MutationsConfig.List) do
        n1 += v2.Chance
    end

    return (math.max(1 - n1, 0))
end

function t1.SizeSteps(p2) -- line: 50
    -- upvalues: MutationsConfig (copy)
    if not p2 or p2 <= 1.0001 then
        return 0
    end

    return (math.max(0, (math.floor(math.log(p2) / math.log(MutationsConfig.Size.Step) + 0.5))))
end

local function sizeChance(p3) -- line: 57
    -- upvalues: MutationsConfig (copy)
    local Size = MutationsConfig.Size
    local v7 = 1
    local v8 = Size.Chance

    for _ = 1, p3 do
        v7 *= v8
        v8 = math.min(v8 + Size.ChanceStep, Size.MaxChance)
    end

    return v7 * (1 - v8)
end

function t1.Chance(p4, p5) -- line: 67
    -- upvalues: MutationsConfig (copy), t1 (copy)
    local Chance

    if p4 then
        local v10 = MutationsConfig.Get(p4)

        if v10 then
            Chance = v10.Chance
        end

        if not v10 or not Chance then
            Chance = 1
        end
    else
        local n2 = 0

        for _, v11 in ipairs(MutationsConfig.List) do
            n2 += v11.Chance
        end

        Chance = math.max(1 - n2, 0)
    end

    local v13 = t1.SizeSteps(p5)
    local Size = MutationsConfig.Size
    local v14 = 1
    local v15 = Size.Chance

    for _ = 1, v13 do
        v14 *= v15
        v15 = math.min(v15 + Size.ChanceStep, Size.MaxChance)
    end

    return Chance * (v14 * (1 - v15))
end

function t1.OneIn(p6) -- line: 71
    -- upvalues: LuckyCatch (copy)
    if not p6 or p6 <= 0 then
        return 1
    end

    return math.max(1, (math.floor(1 / p6 + 0.5))) ^ (LuckyCatch.Exponent or 3)
end

function t1.TierFor(p7) -- line: 77
    -- upvalues: LuckyCatch (copy)
    local n3 = 0

    for v19, v20 in ipairs(LuckyCatch.Tiers) do
        if p7 <= v20.Chance * 1.000000001 then
            n3 = v19
        end
    end

    return n3
end

function t1.TierOdds(p8) -- line: 85
    -- upvalues: t1 (copy), LuckyCatch (copy)
    local v21 = LuckyCatch.Tiers[p8]

    return v21 and t1.OneIn(v21.Chance) or 1e999
end

function t1.Intensity(p9) -- line: 90
    -- upvalues: LuckyCatch (copy)
    if not p9 or p9 <= 0 then
        return 1
    end

    return (math.clamp(math.log10(LuckyCatch.MaxChance / p9) / math.log10(LuckyCatch.MaxChance / 1E-04), 0, 1))
end

function t1.Get(p10, p11) -- line: 97
    -- upvalues: t1 (copy), LuckyCatch (copy)
    local v26 = t1.Chance(p10, p11)

    return if not (v26 <= 0) and not (LuckyCatch.MaxChance * 1.000000001 < v26) then {
        Chance = v26,
        OneIn = t1.OneIn(v26),
        Tier = math.max(1, t1.TierFor(v26))
    } else nil
end

function t1.Comma(p12) -- line: 108
    local v29 = string.format("%.0f", (math.max(0, (math.floor(p12 or 0))))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    if v29:sub(1, 1) == "," then
        v29 = v29:sub(2)
    end

    return v29
end

function t1.Short(p13) -- line: 115
    -- upvalues: NumberFormat (copy)
    return NumberFormat.Abbreviate(math.max(1, p13 or 1), 2)
end

function t1.Text(p14, p15) -- line: 119
    -- upvalues: t1 (copy)
    return "1 in " .. (p15 and t1.Short(p14) or t1.Comma(p14))
end

function t1.Describe(p16, p17, p18) -- line: 124
    -- upvalues: MutationsConfig (copy), t1 (copy)
    local t3 = {}
    local v31 = t1.SizeSteps(p17)

    if v31 > 0 then
        local Titles = MutationsConfig.Size.Titles

        table.insert(t3, Titles[math.min(v31, #Titles)].Name)
    end

    if p16 then
        table.insert(t3, string.upper(p16))
    end

    table.insert(t3, string.upper(p18 or "ANIMAL"))

    return table.concat(t3, " ")
end

return t1
