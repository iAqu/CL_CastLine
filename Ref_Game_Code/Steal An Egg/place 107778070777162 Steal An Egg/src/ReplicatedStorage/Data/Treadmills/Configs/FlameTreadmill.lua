-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "FlameTreadmill",
    Price = 250000,
    ProductId = 3611606677,
    Icon = "rbxassetid://103122274001487",
    SpeedMultiplier = 12,
    DisplayInShop = true,
    DisplayName = "Flame Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Rare
}

return table.freeze(t1)
