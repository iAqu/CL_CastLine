-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    "BossTokens",
    "HalloweenTokens",
    "Money",
    "SakuraCrystals"
}

return table.freeze({
    AllCurrencyTypes = table.freeze({
        BossTokens = "BossTokens",
        HalloweenTokens = "HalloweenTokens",
        Money = "Money",
        SakuraCrystals = "SakuraCrystals"
    }),
    AllCurrencyTypesArray = table.freeze(t1),
    SchemaValidation = table.freeze({
        AllCurrencyTypes = t.valueOf(t1)
    })
})
