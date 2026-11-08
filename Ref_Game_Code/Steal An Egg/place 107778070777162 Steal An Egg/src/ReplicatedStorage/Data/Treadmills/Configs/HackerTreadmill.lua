-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "HackerTreadmill",
    Price = 2E+12,
    ProductId = 3611606718,
    Icon = "rbxassetid://114661675379027",
    SpeedMultiplier = 500,
    DisplayInShop = true,
    DisplayName = "Hacker Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Secret
}

return table.freeze(t1)
