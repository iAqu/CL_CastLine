-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "Sci-FiTreadmill",
    Price = 15000,
    ProductId = 3611606667,
    Icon = "rbxassetid://81563639782445",
    SpeedMultiplier = 5,
    DisplayInShop = true,
    DisplayName = "Sci-Fi Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Uncommon
}

return table.freeze(t1)
