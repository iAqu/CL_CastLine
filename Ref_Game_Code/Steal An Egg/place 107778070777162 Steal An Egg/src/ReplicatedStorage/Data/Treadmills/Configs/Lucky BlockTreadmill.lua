-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "Lucky BlockTreadmill",
    Price = 7.5E+10,
    ProductId = 3611606706,
    Icon = "rbxassetid://85546442623094",
    SpeedMultiplier = 200,
    DisplayInShop = true,
    DisplayName = "Lucky Block Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Cosmic
}

return table.freeze(t1)
