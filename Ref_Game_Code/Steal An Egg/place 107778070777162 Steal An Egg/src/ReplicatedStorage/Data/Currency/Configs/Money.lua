-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local InstanceCache = require(ReplicatedStorage.Packages.InstanceCache)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Money = ReplicatedStorage.Assets.Models.Orbs.Money

local function orbSource() -- line: 11
    -- upvalues: Constants (copy), InstanceCache (copy), Money (copy)
    if Constants.IS_SERVER then
        return Money
    end

    return InstanceCache.new(Money, 1):SetExpandAmount(1)
end

return table.freeze({
    DisplayName = "Money",
    Desc = "",
    Icon = "rbxassetid://119640363267627",
    _id = "Money",
    Rarity = Rarity.Rarities.Uncommon,
    Sounds = {
        Single = {
            Data = {
                Volume = 0.5,
                Speed = { 0.95, 1.05 }
            },
            Ids = { "rbxassetid://122083641072193" }
        }
    },
    Instance = if Constants.IS_SERVER then Money else InstanceCache.new(Money, 1):SetExpandAmount(1)
})
