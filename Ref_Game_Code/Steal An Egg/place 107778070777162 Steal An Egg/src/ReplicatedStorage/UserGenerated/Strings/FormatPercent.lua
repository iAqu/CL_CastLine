-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatFigures = require(ReplicatedStorage.UserGenerated.Strings.FormatFigures)

local function FormatPercent(p1) -- line: 24
    -- upvalues: FormatFigures (copy)
    return FormatFigures(p1 * 100, 4, 5) .. "%"
end

return FormatPercent
