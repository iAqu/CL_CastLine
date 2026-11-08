-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local t1 = {
    Changed = RaceRallyFlags.SpeedPowerRequirement.Changed,
    IsEligible = function(p1) -- IsEligible | line: 13
        -- upvalues: RaceRallyFlags (copy)
        return RaceRallyFlags.SpeedPowerRequirement:Get() <= p1
    end
}

return table.freeze(t1)
