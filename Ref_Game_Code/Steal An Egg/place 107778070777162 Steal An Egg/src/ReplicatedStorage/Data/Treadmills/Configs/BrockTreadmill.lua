-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    _id = "BrockTreadmill",
    Price = 0,
    ProductId = nil,
    Icon = "",
    SpeedMultiplier = 1E+09,
    DisplayInShop = false,
    DisplayName = "Brock Treadmill",
    Rarity = require(ReplicatedStorage.Data.Rarity).Rarities.Titan
}

return table.freeze(t1)
