-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoundFigures = require(ReplicatedStorage.UserGenerated.Math.RoundFigures)
local StableExp10 = require(ReplicatedStorage.UserGenerated.Math.StableExp10)
local TrimmedNumberString = require(ReplicatedStorage.UserGenerated.Strings.TrimmedNumberString)
local t1 = {
    "",
    "k",
    "m",
    "b",
    "t",
    "q",
    "Qt",
    "Sx",
    "Sp",
    "o",
    "n",
    "d",
    "u",
    "Du",
    "Tr"
}

local function FormatAbbreviated(p1) -- line: 66
    -- upvalues: RoundFigures (copy), StableExp10 (copy), TrimmedNumberString (copy), t1 (copy)
    assert(type(p1) == "number")

    if p1 ~= p1 then
        return "NaN"
    end

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 == (-1e999) then
        return "-Infinity"
    end

    local t2 = {}
    local v2 = p1

    if p1 < 0 then
        table.insert(t2, "-")
        v2 = -p1
    end

    local v3 = math.floor(v2)

    if not (v3 >= 1000) then
        table.insert(t2, TrimmedNumberString(v3))

        return table.concat(t2)
    end

    local v7 = math.clamp(math.floor(math.log10(v3) / 3) + 1, 1, #t1)

    table.insert(t2, TrimmedNumberString((RoundFigures(StableExp10(v3, (v7 - 1) * -3), 3, nil, math.floor))))
    table.insert(t2, t1[v7])

    return table.concat(t2)
end

return FormatAbbreviated
