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
    Lake = require(Configs.Lake),
    Prehistoric = require(Configs.Prehistoric),
    Snow = require(Configs.Snow),
    Volcano = require(Configs.Volcano)
})
local v2 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Areas", v1, {
    DropTable = true
}, true, function(p1) -- line: 29
    for _, v3 in p1 do
        local n1 = 0

        for _, v4 in v3.DropTable do
            n1 += v4[2]
        end

        assert(n1 > 0)
    end
end)
local t1 = {
    Directory = v2
}

function t1.AreaNameExists(p2) -- line: 44
    -- upvalues: v2 (copy)
    if rawget(v2, p2) == nil then
        return false, (("Area name \"%*\" does not exist in the Areas directory."):format(p2))
    end

    return true
end

function t1.GetProgressionOrder(p3) -- line: 52
    return p3.ProgressionOrder or p3.Rarity.Rank
end

return table.freeze(t1)
