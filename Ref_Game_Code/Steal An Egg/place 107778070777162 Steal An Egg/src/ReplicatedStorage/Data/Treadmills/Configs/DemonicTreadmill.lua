-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "DemonicTreadmill",
    Price = 5E+13,
    ProductId = 3611606728,
    Icon = "rbxassetid://99849961715962",
    SpeedMultiplier = 1000,
    DisplayInShop = true,
    DisplayName = "Demonic Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Eternal
}

return table.freeze(t1)
