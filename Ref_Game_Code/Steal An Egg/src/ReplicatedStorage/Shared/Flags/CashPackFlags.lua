-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local BalanceConfig = require(script.Parent.BalanceConfig)
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t1 = {}

for v1, v2 in CashPacks.Offers do
    t1[v1] = BalanceConfig.Bind("Game.Balance.ProductRewards." .. v2.Name, {
        Amount = v2.Floor
    }, true, false, function(p1) -- line: 17
        assert(p1.Amount > 0)
    end)
end

local v4 = FastFlags.Replicated("Game.CashPacks.Minutes", function(p2) -- line: 23
    -- upvalues: Asserts (copy), CashPacks (copy)
    Asserts.Array(Asserts.FinitePositive)(p2)
    assert(#p2 == #CashPacks.Offers, "Cash packs require five durations")

    return p2
end, { 40, 120, 360, 1080, 2880 })
local t2 = {
    GrowthMultiplier = FastFlags.Replicated("Game.CashPacks.GrowthMultiplier", Asserts.Range(1, 10), 1.2),
    RefreshEverySession = FastFlags.Replicated("Game.CashPacks.RefreshEverySession", Asserts.Boolean, true)
}

function t2.GetOffers() -- line: 36
    -- upvalues: CashPacks (copy), t1 (copy), v4 (copy)
    local t3 = {}

    for v6, v7 in CashPacks.Offers do
        local v8 = table.clone(v7)

        v8.Minutes = v4:Get()[v6]
        v8.Floor = math.max(v7.Floor, t1[v6].Amount)
        t3[v6] = v8
    end

    return t3
end

return t2
