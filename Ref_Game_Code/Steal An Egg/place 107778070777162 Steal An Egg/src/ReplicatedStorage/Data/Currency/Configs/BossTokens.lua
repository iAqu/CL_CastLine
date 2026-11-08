-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

return table.freeze({
    DisplayName = "Boss Tokens",
    Desc = "",
    Icon = "rbxassetid://84787104764975",
    _id = "BossTokens",
    Rarity = Rarity.Rarities.Epic
})
