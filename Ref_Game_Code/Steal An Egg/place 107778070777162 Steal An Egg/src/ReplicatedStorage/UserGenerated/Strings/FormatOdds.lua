-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatAbbreviated = require(ReplicatedStorage.UserGenerated.Strings.FormatAbbreviated)

local function FormatOdds(p1) -- line: 24
    -- upvalues: FormatAbbreviated (copy)
    assert(type(p1) == "number")

    if p1 == 0 then
        return "0"
    end

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 == (-1e999) then
        return "-Infinity"
    end

    if p1 == p1 then
        return "1/" .. FormatAbbreviated(1 / p1)
    end

    return "NaN"
end

return FormatOdds
