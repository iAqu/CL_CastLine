-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.integer, t.numberMin(0))
local t1 = {
    Purchase = t.strictInterface({
        Period = t.integer,
        Count = v1
    })
}

t1.State = t.strictInterface({
    Tokens = v1,
    Wins = v1,
    Races = v1,
    Milestones = t.map(t.string, t.boolean),
    Repeats = v1,
    Racers = t.map(t.string, t.boolean),
    EquippedRacer = t.string,
    Purchases = t.map(t.string, t1.Purchase),
    MutationConsumables = v1,
    LastRacedWindow = t.optional(t.integer)
})

function t1.Blank() -- line: 43
    return {
        Tokens = 0,
        Wins = 0,
        Races = 0,
        Repeats = 0,
        EquippedRacer = "",
        MutationConsumables = 0,
        Milestones = {},
        Racers = {},
        Purchases = {}
    }
end

return table.freeze(t1)
