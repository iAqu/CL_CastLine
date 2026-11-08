-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "GuardianTreadmill",
    Price = 7.5E+15,
    ProductId = 3716090292,
    Icon = "rbxassetid://90899568339219",
    SpeedMultiplier = 8500,
    DisplayInShop = true,
    DisplayName = "Guardian Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Titan
}

return table.freeze(t1)
