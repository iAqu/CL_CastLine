-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

return table.freeze({
    DisplayName = "Sakura Crystals",
    Desc = "",
    Icon = "rbxassetid://71612969542341",
    _id = "SakuraCrystals",
    Rarity = Rarity.Rarities.Epic,
    Sounds = {
        Single = {
            Data = {
                Volume = 0.5,
                Speed = { 0.95, 1.05 }
            },
            Ids = { "rbxassetid://122083641072193" }
        }
    }
})
