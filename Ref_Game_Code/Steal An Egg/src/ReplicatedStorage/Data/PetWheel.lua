-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NO_MUTATION = require(ReplicatedStorage.Shared.Modules.Mutations).NO_MUTATION
local t1 = {
    {
        Id = "Common",
        Weight = 20
    },
    {
        Id = "Divine",
        Weight = 3
    },
    {
        Id = "Uncommon",
        Weight = 16
    },
    {
        Id = "Secret",
        Weight = 5
    },
    {
        Id = "Rare",
        Weight = 14
    },
    {
        Id = "Eternal",
        Weight = 4
    },
    {
        Id = "Epic",
        Weight = 12
    },
    {
        Id = "Cosmic",
        Weight = 7
    },
    {
        Id = "Legendary",
        Weight = 10
    },
    {
        Id = "Mythic",
        Weight = 9
    }
}
local t2 = {
    {
        Weight = 10,
        Id = NO_MUTATION
    },
    {
        Id = "Silver",
        Weight = 9
    },
    {
        Id = "Golden",
        Weight = 7
    },
    {
        Weight = 10,
        Id = NO_MUTATION
    },
    {
        Id = "Rainbow",
        Weight = 5
    },
    {
        Id = "Silver",
        Weight = 9
    },
    {
        Weight = 10,
        Id = NO_MUTATION
    },
    {
        Id = "Golden",
        Weight = 7
    },
    {
        Id = "Silver",
        Weight = 9
    },
    {
        Weight = 10,
        Id = NO_MUTATION
    },
    {
        Id = "Rainbow",
        Weight = 5
    },
    {
        Id = "Silver",
        Weight = 9
    }
}

return table.freeze({
    UseRadius = 35,
    ReturnSeconds = 45,
    Rarity = table.freeze(t1),
    Mutation = table.freeze(t2),
    ExcludedPets = table.freeze({
        ["Mecha Scrambler"] = true
    })
})
