-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "GoldenTreadmill",
    Price = 1.2E+08,
    ProductId = 3611606694,
    Icon = "rbxassetid://99555941892079",
    SpeedMultiplier = 80,
    DisplayInShop = true,
    DisplayName = "Golden Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Legendary
}

return table.freeze(t1)
