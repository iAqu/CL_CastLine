-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    "Common",
    "Uncommon",
    "Rare",
    "Legendary",
    "Mythic",
    "Prismatic",
    "Divine",
    "Transcendent"
}
local t2 = {
    Rarity = require(ReplicatedStorage.Packages.t).valueOf(t1)
}

return table.freeze(t2)
