-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.freeze({
    table.freeze({
        low = 1,
        high = 1.01,
        weight = 250
    }),
    table.freeze({
        low = 0.48,
        high = 0.5,
        weight = 45.17
    }),
    table.freeze({
        low = 0.24,
        high = 0.25,
        weight = 17.09
    }),
    table.freeze({
        low = 1.49,
        high = 1.5,
        weight = 4.27
    }),
    table.freeze({
        low = 1.99,
        high = 2,
        weight = 0.1857
    })
})

return require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.AssetScaleBands", v1, true, false, function(p1) -- line: 25
    local n1 = 0

    for _, v2 in p1 do
        assert(v2.low > 0 and v2.high >= v2.low)
        n1 += v2.weight
    end

    assert(n1 > 0)
end)
