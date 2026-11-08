-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)
local FormatAbbreviated = require(ReplicatedStorage.UserGenerated.Strings.FormatAbbreviated)
local t1 = {
    GateArea = "Abyss Ocean"
}

function t1.RequiredSpeedPower() -- line: 23
    -- upvalues: HalloweenDimensionFlags (copy)
    return HalloweenDimensionFlags.SpeedPowerRequirement:Get()
end

function t1.RequirementText() -- line: 27
    -- upvalues: FormatAbbreviated (copy), t1 (copy)
    return string.upper(FormatAbbreviated(t1.RequiredSpeedPower()))
end

function t1.IsEligible(p1) -- line: 31
    -- upvalues: t1 (copy)
    return t1.RequiredSpeedPower() <= p1
end

return table.freeze(t1)
