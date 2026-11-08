-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    ActiveDeploymentAttribute = "ActiveTrapCount",
    Description = "Place traps that freeze thieves for 7 seconds (3 Max)",
    DisplayInShop = true,
    DisplayName = "Trap",
    Icon = "rbxassetid://113747761726323",
    MaxActiveDeployments = 3,
    MaxShopStockQuantity = 3,
    MinShopStockQuantity = 1,
    MoneyCost = 1000,
    Persistent = false,
    Rarity = "Common",
    ShopDropWeight = 100,
    OneTime = false,
    ToolController = "None",
    _id = "Trap"
}

return table.freeze(t1)
