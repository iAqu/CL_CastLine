-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.integer, t.numberMin(0))
local t1 = {
    State = t.strictInterface({
        Accepted = t.boolean,
        MenuOpened = t.boolean,
        Stage = t.intersection(t.integer, t.numberMin(1), t.numberMax(4)),
        Essence = v1,
        Progress = t.map(t.string, v1),
        Claimed = t.map(t.string, t.boolean),
        Returning = t.boolean,
        Unlocked = t.boolean
    }),
    Blank = function() -- Blank | line: 28
        return {
            Accepted = false,
            MenuOpened = false,
            Stage = 1,
            Essence = 0,
            Returning = false,
            Unlocked = false,
            Progress = {},
            Claimed = {}
        }
    end,
    Copy = function(p1) -- Copy | line: 32
        local v2 = table.clone(p1)

        v2.Progress = table.clone(p1.Progress)
        v2.Claimed = table.clone(p1.Claimed)

        return v2
    end
}

return table.freeze(t1)
