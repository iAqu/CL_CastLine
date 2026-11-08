-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.integer, t.numberMin(0), t.numberMax(9007199254740991))
local t1 = {
    State = t.strictInterface({
        Tickets = v1,
        AccessUnlocked = t.boolean,
        Souls = v1,
        MutationConsumables = v1,
        TotalCaught = v1
    }),
    Blank = function() -- Blank | line: 23
        return {
            Tickets = 0,
            AccessUnlocked = false,
            Souls = 0,
            MutationConsumables = 0,
            TotalCaught = 0
        }
    end
}

return table.freeze(t1)
