-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Data.Rarity)

local Configs = script.Configs
local t1 = {
    AngelicTreadmill = require(Configs.AngelicTreadmill),
    AstralTreadmill = require(Configs.AstralTreadmill),
    CelebrityTreadmill = require(Configs.CelebrityTreadmill),
    DemonicTreadmill = require(Configs.DemonicTreadmill),
    FlameTreadmill = require(Configs.FlameTreadmill),
    GoldenTreadmill = require(Configs.GoldenTreadmill),
    GuardianTreadmill = require(Configs.GuardianTreadmill),
    HackerTreadmill = require(Configs.HackerTreadmill),
    ["Lucky BlockTreadmill"] = require(Configs["Lucky BlockTreadmill"]),
    ["Sci-FiTreadmill"] = require(Configs["Sci-FiTreadmill"]),
    ["The FreezeTreadmill"] = require(Configs["The FreezeTreadmill"]),
    Treadmill = require(Configs.Treadmill)
}

table.freeze(t1)

local t2 = {
    BrockTreadmill = require(Configs.BrockTreadmill)
}

table.freeze(t2)

local t3 = {}
local t4 = {}

for _, v1 in pairs(t1) do
    table.insert(t3, v1)
end

table.sort(t3, function(p1, p2) -- line: 50
    return p1.Price < p2.Price
end)

for v2, v3 in ipairs(t3) do
    t4[v3._id] = v2
end

local v4 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Treadmills", t1, {
    Price = true,
    SpeedMultiplier = true
}, true, function(p3) -- line: 63
    for _, v5 in p3 do
        assert(v5.SpeedMultiplier > 0)
    end
end)

for v7, v8 in t3 do
    t3[v7] = v4[v8._id]
end

table.freeze(t3)
table.freeze(t4)

local t5 = {
    OverrideAttribute = "TreadmillOverride",
    Directory = v4,
    SessionOnly = t2,
    TreadmillNameExists = function(p4) -- TreadmillNameExists | line: 83
        -- upvalues: v4 (copy)
        if v4[p4] == nil then
            return false, (("Treadmills name \"%*\" does not exist in the Treadmills directory."):format(p4))
        end

        return true
    end
}

function t5.GetOrdered() -- line: 91
    -- upvalues: t3 (copy)
    return table.clone(t3)
end

function t5.GetByUpgradeLevel(p5) -- line: 95
    -- upvalues: t3 (copy)
    return t3[p5]
end

function t5.GetUpgradeLevel(p6) -- line: 99
    -- upvalues: t4 (copy)
    return t4[p6]
end

function t5.GetById(p7) -- line: 103
    -- upvalues: t2 (copy), v4 (copy)
    return v4[p7] or t2[p7]
end

function t5.ResolveForPlayer(p8, p9) -- line: 107
    -- upvalues: t2 (copy), t3 (copy)
    local TreadmillOverride = p8:GetAttribute("TreadmillOverride")

    if typeof(TreadmillOverride) ~= "string" or t2[TreadmillOverride] == nil then
        return t3[p9]
    end

    return t2[TreadmillOverride]
end

return table.freeze(t5)
