-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Types)

local Configs = script.Configs
local v1 = table.freeze({
    ["Abyss Ocean Bat"] = require(Configs["Abyss Ocean Bat"]),
    Bat = require(Configs.Bat),
    BeeLauncher = require(Configs.BeeLauncher),
    BigTrap = require(Configs.BigTrap),
    ["Cosmic Bat"] = require(Configs["Cosmic Bat"]),
    ["Cricket's Banjo"] = require(Configs["Cricket's Banjo"]),
    ["Desert Bat"] = require(Configs["Desert Bat"]),
    EnchantedHammer = require(Configs.EnchantedHammer),
    Flyswatter = require(Configs.Flyswatter),
    ["Forest Bat"] = require(Configs["Forest Bat"]),
    GravityDisruptor = require(Configs.GravityDisruptor),
    ["Haunted Rod"] = require(Configs["Haunted Rod"]),
    ["Jungle Bat"] = require(Configs["Jungle Bat"]),
    Katana = require(Configs.Katana),
    ["Lake Bat"] = require(Configs["Lake Bat"]),
    ["Light Dark Staff"] = require(Configs["Light Dark Staff"]),
    ["Manor Key"] = require(Configs["Manor Key"]),
    ["Prehistoric Bat"] = require(Configs["Prehistoric Bat"]),
    ["Pumpkin Scythe"] = require(Configs["Pumpkin Scythe"]),
    ["Scramble Sword"] = require(Configs["Scramble Sword"]),
    ["Racing Bat"] = require(Configs["Racing Bat"]),
    ["Snow Bat"] = require(Configs["Snow Bat"]),
    ["The Scrambler"] = require(Configs["The Scrambler"]),
    ["Titan Axe"] = require(Configs["Titan Axe"]),
    Trap = require(Configs.Trap),
    ["Volcano Bat"] = require(Configs["Volcano Bat"])
})
local v2 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Gears", v1, {
    MoneyCost = true,
    ShopDropWeight = true,
    MinShopStockQuantity = true,
    MaxShopStockQuantity = true,
    SlapPower = true,
    MaxActiveDeployments = true,
    BatControllerData = true,
    ControllerData = true,
    COOLDOWN = true,
    MAX_RANGE = true,
    MOB_DAMAGE = true,
    RAGDOLL_DURATION = true,
    SLAP_DURATION = true,
    SLAP_FORCE = true,
    DETECTION_RANGE = true,
    LIFETIME = true,
    PULL_SPEED = true,
    PULL_DURATION = true,
    MAX_PULL_DISTANCE = true,
    DANCE_DURATION = true,
    STUN_DURATION = true,
    USE_LIMIT = true
}, true, function(p1) -- line: 84
    for _, v3 in p1 do
        assert(v3.MinShopStockQuantity % 1 == 0 and v3.MaxShopStockQuantity % 1 == 0)
        assert(v3.MaxShopStockQuantity >= v3.MinShopStockQuantity)

        if v3.MaxActiveDeployments then
            assert(v3.MaxActiveDeployments % 1 == 0)
        end
    end
end)
local t1 = {
    Directory = v2
}

function t1.GearNameExists(p2) -- line: 98
    -- upvalues: v2 (copy)
    if rawget(v2, p2) == nil then
        return false, (("Gears name \"%*\" does not exist in the Gears directory."):format(p2))
    end

    return true
end

return table.freeze(t1)
