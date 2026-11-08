-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local t1 = {
    Preload = {},
    Main = {
        ["boss-tokens"] = require(ReplicatedStorage.Data.Currency.Configs.BossTokens).Icon
    }
}

t1.All = TableUtil.Reconcile(t1.Preload, t1.Main)

return t1
