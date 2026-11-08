-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local v1 = BalanceConfig.Bind("Game.HalloweenEgg", {
    StartsAt = 1792249200,
    EndsAt = 1793458800,
    ProductIds = {
        Single = 3718848856,
        Triple = 3718848909,
        Ten = 3718848926,
        Fifty = 3718848956
    },
    GiftProductIds = {
        Single = 3718849262,
        Triple = 3718849356,
        Ten = 3718849452,
        Fifty = 3718849572
    }
}, {
    StartsAt = true,
    EndsAt = true,
    ProductIds = true,
    GiftProductIds = true
}, false, function(p1) -- line: 9
    assert(p1.StartsAt % 1 == 0 and p1.EndsAt % 1 == 0 and p1.EndsAt > p1.StartsAt, "Invalid Halloween sale schedule")

    local t1 = {}

    for _, v3 in {
            p1.ProductIds,
            p1.GiftProductIds
        } do
        for _, v4 in v3 do
            assert(v4 % 1 == 0 and v4 >= 0, "Invalid Halloween product ID")

            if v4 > 0 then
                assert(not t1[v4], "Duplicate Halloween product ID")
                t1[v4] = true
            end
        end
    end
end)

function v1.IsPreview() -- line: 17
    -- upvalues: Environment (copy)
    return Environment.IsDevPlace() or Environment.IsTestPlace()
end

function v1.Time(p2) -- line: 20
    -- upvalues: v1 (copy)
    if v1.IsPreview() and p2 < v1.StartsAt then
        return v1.StartsAt
    end

    return p2
end

function v1.IsActive(p3) -- line: 23
    -- upvalues: v1 (copy)
    local v7 = v1.Time(p3)

    if v1.StartsAt <= v7 then
        return v7 < v1.EndsAt
    end

    return false
end

return v1
