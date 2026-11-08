-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "Treadmill",
    Price = 0,
    ProductId = nil,
    Icon = "rbxassetid://84421204509494",
    SpeedMultiplier = 2,
    DisplayInShop = true,
    DisplayName = "Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Common
}

return table.freeze(t1)
