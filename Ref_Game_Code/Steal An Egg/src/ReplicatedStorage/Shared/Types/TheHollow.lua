-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    State = t.strictInterface({
        Wins = t.intersection(t.integer, t.numberMin(0)),
        Claimed = t.map(t.string, t.boolean)
    }),
    Blank = function() -- Blank | line: 21
        return {
            Wins = 0,
            Claimed = {}
        }
    end
}

return table.freeze(t1)
