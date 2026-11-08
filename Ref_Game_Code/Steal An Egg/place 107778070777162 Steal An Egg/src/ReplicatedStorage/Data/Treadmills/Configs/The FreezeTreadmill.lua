-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "The FreezeTreadmill",
    Price = 3E+09,
    ProductId = 3611606701,
    Icon = "rbxassetid://97611802500180",
    SpeedMultiplier = 100,
    DisplayInShop = true,
    DisplayName = "The Freeze Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Mythic
}

return table.freeze(t1)
