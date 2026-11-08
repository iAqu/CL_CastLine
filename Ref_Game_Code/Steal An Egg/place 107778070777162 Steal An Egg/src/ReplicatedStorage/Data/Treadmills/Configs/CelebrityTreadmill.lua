-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "CelebrityTreadmill",
    Price = 5E+06,
    ProductId = 3611606688,
    Icon = "rbxassetid://75188836342954",
    SpeedMultiplier = 30,
    DisplayInShop = true,
    DisplayName = "Celebrity Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Epic
}

return table.freeze(t1)
