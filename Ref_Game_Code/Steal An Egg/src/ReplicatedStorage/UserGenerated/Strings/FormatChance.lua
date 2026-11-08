-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatOdds = require(ReplicatedStorage.UserGenerated.Strings.FormatOdds)
local FormatPercent = require(ReplicatedStorage.UserGenerated.Strings.FormatPercent)

local function FormatChance(p1, p2) -- line: 31
    -- upvalues: FormatOdds (copy), FormatPercent (copy)
    assert(type(p1) == "number")
    assert(p2 == nil or type(p2) == "number")

    local v3 = math.clamp(p1, 0, 1)
    local v5 = math.clamp(p2 or v3, 0, 1)

    if v3 > 0 and v5 <= 2E-04 and v3 <= 0.001 then
        return FormatOdds(v3)
    end

    return FormatPercent(v3)
end

return FormatChance
