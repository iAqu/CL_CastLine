-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "AstralTreadmill",
    Price = 2.5E+15,
    ProductId = 3712487576,
    Icon = "rbxassetid://118444572497588",
    SpeedMultiplier = 3000,
    DisplayInShop = true,
    DisplayName = "Astral Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Titan
}

return table.freeze(t1)
