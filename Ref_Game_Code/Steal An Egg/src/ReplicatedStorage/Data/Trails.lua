-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local t1 = {
    BlueTrail = table.freeze({
        _id = "BlueTrail",
        Price = 75000,
        ProductId = 3611606747,
        Icon = "rbxassetid://137035834049811",
        SpeedMultiplier = 2.5,
        DisplayInShop = true,
        DisplayName = "Blue Trail",
        Rarity = Rarity.Rarities.Rare
    }),
    MoonbloomTrail = table.freeze({
        _id = "MoonbloomTrail",
        Price = 5E+15,
        ProductId = 3712487399,
        Icon = "rbxassetid://123538285077698",
        SpeedMultiplier = 20,
        DisplayInShop = true,
        DisplayName = "Moonbloom Trail",
        Rarity = Rarity.Rarities.Divine,
        SpeedNumberColor = Color3.fromRGB(29, 255, 210)
    }),
    DivineTrail = table.freeze({
        _id = "DivineTrail",
        Price = 3E+14,
        ProductId = 3611606791,
        Icon = "rbxassetid://140597836052094",
        SpeedMultiplier = 14,
        DisplayInShop = true,
        DisplayName = "Divine Trail",
        Rarity = Rarity.Rarities.Divine
    }),
    EternalTrail = table.freeze({
        _id = "EternalTrail",
        Price = 1.25E+13,
        ProductId = 3611606787,
        Icon = "rbxassetid://127740746006344",
        SpeedMultiplier = 10,
        DisplayInShop = true,
        DisplayName = "Eternal Trail",
        Rarity = Rarity.Rarities.Eternal
    }),
    GalaxyTrail = table.freeze({
        _id = "GalaxyTrail",
        Price = 2E+10,
        ProductId = 3611606773,
        Icon = "rbxassetid://86672420342894",
        SpeedMultiplier = 5,
        DisplayInShop = true,
        DisplayName = "Galaxy Trail",
        Rarity = Rarity.Rarities.Cosmic
    }),
    GoldenTrail = table.freeze({
        _id = "GoldenTrail",
        Price = 3E+07,
        ProductId = 3611606764,
        Icon = "rbxassetid://78957355975053",
        SpeedMultiplier = 3.5,
        DisplayInShop = true,
        DisplayName = "Golden Trail",
        Rarity = Rarity.Rarities.Legendary
    }),
    GreenTrail = table.freeze({
        _id = "GreenTrail",
        Price = 5000,
        ProductId = 3611606739,
        Icon = "rbxassetid://123930672117029",
        SpeedMultiplier = 2,
        DisplayInShop = true,
        DisplayName = "Green Trail",
        Rarity = Rarity.Rarities.Uncommon
    }),
    GreyTrail = table.freeze({
        _id = "GreyTrail",
        Price = 100,
        ProductId = nil,
        Icon = "rbxassetid://103930213073663",
        SpeedMultiplier = 1.5,
        DisplayInShop = true,
        DisplayName = "Grey Trail",
        Rarity = Rarity.Rarities.Common
    }),
    PurpleTrail = table.freeze({
        _id = "PurpleTrail",
        Price = 1500000,
        ProductId = 3611606754,
        Icon = "rbxassetid://109475464579632",
        SpeedMultiplier = 3,
        DisplayInShop = true,
        DisplayName = "Purple Trail",
        Rarity = Rarity.Rarities.Epic
    }),
    RedTrail = table.freeze({
        _id = "RedTrail",
        Price = 7.5E+08,
        ProductId = 3611606768,
        Icon = "rbxassetid://72219596211828",
        SpeedMultiplier = 4,
        DisplayInShop = true,
        DisplayName = "Red Trail",
        Rarity = Rarity.Rarities.Mythic
    }),
    SecretTrail = table.freeze({
        _id = "SecretTrail",
        Price = 5E+11,
        ProductId = 3611606784,
        Icon = "rbxassetid://124057247070872",
        SpeedMultiplier = 7,
        DisplayInShop = true,
        DisplayName = "Secret Trail",
        Rarity = Rarity.Rarities.Secret
    })
}
local v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Trails", t1, {
    Price = true,
    SpeedMultiplier = true
}, true, function(p1) -- line: 138
    for _, v2 in p1 do
        assert(v2.SpeedMultiplier > 0)
    end
end)

table.freeze(v1)

local t2 = {
    Directory = v1
}

function t2.TrailNameExists(p2) -- line: 151
    -- upvalues: v1 (copy)
    if v1[p2] == nil then
        return false, (("Trails name \"%*\" does not exist in the Trails directory."):format(p2))
    end

    return true
end

return table.freeze(t2)
