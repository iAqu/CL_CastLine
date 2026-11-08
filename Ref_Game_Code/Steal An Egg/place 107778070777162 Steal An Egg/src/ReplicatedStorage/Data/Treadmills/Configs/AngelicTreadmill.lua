-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "AngelicTreadmill",
    Price = 1E+15,
    ProductId = 3611606732,
    Icon = "rbxassetid://104277706019985",
    SpeedMultiplier = 2000,
    DisplayInShop = true,
    DisplayName = "Angelic Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Divine
}

return table.freeze(t1)
