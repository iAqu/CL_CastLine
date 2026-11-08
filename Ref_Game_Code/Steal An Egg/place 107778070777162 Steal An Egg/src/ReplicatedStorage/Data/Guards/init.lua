-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Types)

local Configs = script.Configs
local v1 = table.freeze({
    ["Abyss Ocean"] = require(Configs["Abyss Ocean"]),
    ["Cherry Blossom"] = require(Configs["Cherry Blossom"]),
    Cosmic = require(Configs.Cosmic),
    Desert = require(Configs.Desert),
    Forest = require(Configs.Forest),
    Jungle = require(Configs.Jungle),
    ["Titan Temple"] = require(Configs["Titan Temple"]),
    ["Light Dark"] = require(Configs["Light Dark"]),
    ["Enchanted Forest"] = require(Configs["Enchanted Forest"]),
    ["Light Dark Light"] = require(Configs["Light Dark Light"]),
    ["Light Dark Dark"] = require(Configs["Light Dark Dark"]),
    ["Light Dark Mixed"] = require(Configs["Light Dark Mixed"]),
    Lake = require(Configs.Lake),
    Prehistoric = require(Configs.Prehistoric),
    Snow = require(Configs.Snow),
    Volcano = require(Configs.Volcano)
})
local v2 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Guards", v1, {
    WalkSpeed = true,
    FlatRadius = true,
    HitDistance = true,
    EggPickupDistance = true,
    HomeImpulseBoostDistanceXZ = true
}, true, function(p1) -- line: 40
    for _, v3 in p1 do
        assert(v3.WalkSpeed > 0 and v3.FlatRadius > 0 and v3.HitDistance > 0)
    end
end)
local t1 = {
    Directory = v2
}

function t1.GuardNameExists(p2) -- line: 49
    -- upvalues: v2 (copy)
    if rawget(v2, p2) == nil then
        return false, (("Guard name \"%*\" does not exist in the Guards directory."):format(p2))
    end

    return true
end

function t1.GetLowestWalkSpeed() -- line: 57
    return require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardMovement.MIN_REFERENCE_WALK_SPEED
end

function t1.GetHighestWalkSpeed() -- line: 61
    return require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardMovement.MAX_REFERENCE_WALK_SPEED
end

return table.freeze(t1)
