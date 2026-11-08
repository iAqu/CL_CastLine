-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local HalloweenEggSettings = require(ReplicatedStorage.Data.HalloweenEggSettings)

require(script.Types.Interface)

local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    1, 3, 10, 50
}
local t2 = {
    DisplayName = "Luminous Egg",
    RerollName = "Luminous Re-roll",
    BalanceKey = "Game.Balance.LimitedEgg",
    ProductName = "Limited Egg",
    MechaPrefix = "Depths ",
    EndsAt = Constants.UPDATE_LIVE_AT,
    BaseOdds = table.freeze({
        table.freeze({
            AssetId = "Spike",
            Weight = 39
        }),
        table.freeze({
            AssetId = "Manta Ray",
            Weight = 24
        }),
        table.freeze({
            AssetId = "Megalodon",
            Weight = 18
        }),
        table.freeze({
            AssetId = "Electric Eel",
            Weight = 11
        }),
        table.freeze({
            AssetId = "Terra Snapper",
            Weight = 6.5
        }),
        table.freeze({
            AssetId = "Cthulhu",
            Weight = 0.5
        })
    })
}
local t3 = {
    DisplayName = "Extinction Egg",
    RerollName = "Skeletal Re-roll",
    EndsAt = 1792249200,
    BalanceKey = "Game.Balance.ExtinctionEgg",
    ProductName = "Extinction Egg",
    MechaPrefix = "Skeletal ",
    BaseOdds = table.freeze({
        table.freeze({
            AssetId = "Glyptodon",
            Weight = 39
        }),
        table.freeze({
            AssetId = "Terrorbird",
            Weight = 24
        }),
        table.freeze({
            AssetId = "Megatherium",
            Weight = 18
        }),
        table.freeze({
            AssetId = "Dunkleosteus",
            Weight = 11
        }),
        table.freeze({
            AssetId = "Gigantopithecus",
            Weight = 6.5
        }),
        table.freeze({
            AssetId = "Sabertooth",
            Weight = 0.5
        })
    })
}
local t4 = {
    DisplayName = "Halloween Egg",
    RerollName = "Zombified Re-roll",
    BalanceKey = "Game.Balance.HalloweenEgg",
    ProductName = "Halloween Egg",
    MechaPrefix = "Zombified ",
    EndsAt = HalloweenEggSettings.EndsAt,
    BaseOdds = table.freeze({
        table.freeze({
            AssetId = "Halloween Glyptodon",
            Weight = 39
        }),
        table.freeze({
            AssetId = "Halloween Terrorbird",
            Weight = 24
        }),
        table.freeze({
            AssetId = "Halloween Megatherium",
            Weight = 18
        }),
        table.freeze({
            AssetId = "Halloween Dunkleosteus",
            Weight = 11
        }),
        table.freeze({
            AssetId = "Halloween Gigantopithecus",
            Weight = 6.5
        }),
        table.freeze({
            AssetId = "Halloween Sabertooth",
            Weight = 0.5
        })
    })
}

local function weightedRow(p1) -- line: 85
    if type(p1) == "table" and type(p1[1]) == "string" and type(p1[2]) == "number" and not (p1[2] <= 0) then
        return true
    end

    return false, "expected { assetName, positiveWeight }"
end

local v3 = t.array(weightedRow)
local v4 = t.intersection(t.numberPositive, t.numberMax(1))
local v5 = t.interface({
    EndsAt = t.intersection(t.integer, t.numberPositive),
    DropTable = v3,
    MechaReroll = t.interface({
        Chance = t.numberMax(1),
        DisplayChance = t.numberMax(1),
        DropTable = v3
    }),
    Offers = t.array(t.interface({
        Amount = t.intersection(t.integer, t.numberMin(1))
    }))
})

local function toRows(p2) -- line: 112
    local v6 = table.create(#p2)

    for v7, v8 in p2 do
        v6[v7] = table.freeze({
            v8.AssetId,
            v8.Weight
        })
    end

    return table.freeze(v6)
end

local function toEntries(p3) -- line: 120
    local v9 = table.create(#p3)

    for v10, v11 in p3 do
        local v12, v13

        if type(v11) == "table" then
            if type(v11[1]) == "string" then
                if type(v11[2]) ~= "number" or v11[2] <= 0 then
                    v12 = "expected { assetName, positiveWeight }"
                    v13 = false
                else
                    v13 = true
                end
            else
                v12 = "expected { assetName, positiveWeight }"
                v13 = false
            end
        else
            v12 = "expected { assetName, positiveWeight }"
            v13 = false
        end

        if not v13 then
            error((("limited egg drop row %*: %*"):format(v10, v12)))
        end

        v9[v10] = table.freeze({
            AssetId = v11[1],
            Weight = v11[2]
        })
    end

    return table.freeze(v9)
end

local function prefixed(p4, p5) -- line: 132
    local v16 = table.create(#p4)

    for v17, v18 in p4 do
        v16[v17] = table.freeze({
            AssetId = p5 .. v18.AssetId,
            Weight = v18.Weight
        })
    end

    return table.freeze(v16)
end

local function offersFor(p6, p7) -- line: 140
    local v19 = table.create(#p6)

    for v20, v21 in p6 do
        v19[v20] = table.freeze({
            Amount = v21,
            ProductName = if v21 == 1 then p7 else ("%* x%*"):format(p7, v21),
            GiftProductName = if p7 ~= "Halloween Egg" then nil elseif v21 == 1 then "Halloween Egg Gift" else ("Halloween Egg Gift x%*"):format(v21)
        })
    end

    return table.freeze(v19)
end

local v22 = if RunService:IsStudio() then 0.5 else 0.01

assert(v4(v22))
assert(v4(0.01))

local function bind(p8) -- line: 157
    -- upvalues: BalanceConfig (copy), t1 (copy), t4 (copy), v5 (copy), toRows (copy), toEntries (copy), prefixed (copy), offersFor (copy), v22 (copy)
    local v23 = prefixed(p8.BaseOdds, p8.MechaPrefix)

    assert(#p8.BaseOdds == 6, (`the limited egg shop expects {6} drop rows`))

    local v26 = table.freeze({
        InfoText = "Pets can have different <font color=\"#55FF77\"><b>sizes</b></font>, <font color=\"#55FF77\"><b>colors</b></font> and <font color=\"#55FF77\"><b>mutations</b></font>. Huge pets and pets with rare mutations earn <font color=\"#1AFF00\"><b>way more money</b></font>!",
        DisplayName = p8.DisplayName,
        RerollName = p8.RerollName,
        EndsAt = p8.EndsAt,
        Offers = offersFor(t1, p8.ProductName),
        DropTable = toRows(p8.BaseOdds),
        Entries = p8.BaseOdds,
        MechaReroll = table.freeze({
            DisplayChance = 0.01,
            Chance = if p8 == t4 then 0.01 else v22,
            DropTable = toRows(v23),
            Entries = v23
        })
    })

    local function checkOverrides(p9) -- line: 177
        -- upvalues: p8 (copy), v5 (copy)
        local v27, v28 = v5(p9)

        if not v27 then
            error((("%* override rejected: %*"):format(p8.BalanceKey, v28)))
        end
    end

    local v29 = BalanceConfig.Bind(p8.BalanceKey, v26, {
        EndsAt = true,
        DropTable = true,
        Offers = true,
        MechaReroll = {
            Chance = true,
            DisplayChance = true,
            DropTable = true
        }
    }, false, checkOverrides)

    local function rebuildEntries() -- line: 191
        -- upvalues: v29 (copy), toEntries (copy)
        v29.Entries = toEntries(v29.DropTable)

        local MechaReroll = v29.MechaReroll

        if MechaReroll ~= nil then
            MechaReroll.Entries = toEntries(MechaReroll.DropTable)
        end
    end

    v29.Entries = toEntries(v29.DropTable)

    local MechaReroll = v29.MechaReroll

    if MechaReroll ~= nil then
        MechaReroll.Entries = toEntries(MechaReroll.DropTable)
    end

    BalanceConfig.Changed:Connect(rebuildEntries)

    return v29
end

local v30 = bind(t2)
local v31 = bind(t3)
local v32 = bind(t4)

local function activeSale(p10) -- line: 208
    -- upvalues: Workspace (copy), Constants (copy), HalloweenEggSettings (copy), v30 (copy), v31 (copy), v32 (copy)
    v32.EndsAt = HalloweenEggSettings.EndsAt
    v31.EndsAt = HalloweenEggSettings.StartsAt
    p10 = p10 or Workspace:GetServerTimeNow()

    if HalloweenEggSettings.IsActive(p10) then
        return v32
    end

    if HalloweenEggSettings.EndsAt <= p10 then
        return nil
    end

    if Constants.UPDATE_LIVE_AT <= p10 then
        return v31
    end

    return v30
end

local function onSale() -- line: 215
    -- upvalues: Workspace (copy), Constants (copy), HalloweenEggSettings (copy), v30 (copy), v31 (copy), v32 (copy)
    v32.EndsAt = HalloweenEggSettings.EndsAt
    v31.EndsAt = HalloweenEggSettings.StartsAt

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v34 = if HalloweenEggSettings.IsActive(ServerTimeNow) then v32
        elseif HalloweenEggSettings.EndsAt <= ServerTimeNow then nil
        elseif Constants.UPDATE_LIVE_AT <= ServerTimeNow then v31
        else v30

    return v34 or v32
end

local function forCategory(p11) -- line: 218
    -- upvalues: v30 (copy), v31 (copy), v32 (copy)
    for _, v35 in { v30, v31, v32 } do
        for _, v36 in v35.Entries do
            if v36.AssetId == p11 then
                return v35
            end
        end

        if v35.MechaReroll then
            for _, v37 in v35.MechaReroll.Entries do
                if v37.AssetId == p11 then
                    return v35
                end
            end
        end
    end

    return nil
end

return (setmetatable({
    SwitchesAt = Constants.UPDATE_LIVE_AT,
    Luminous = v30,
    Extinction = v31,
    Halloween = v32,
    Active = activeSale,
    ForCategory = forCategory,
    IsOnSale = function(p12, p13) -- IsOnSale | line: 246
        -- upvalues: Workspace (copy), Constants (copy), HalloweenEggSettings (copy), v30 (copy), v31 (copy), v32 (copy)
        v32.EndsAt = HalloweenEggSettings.EndsAt
        v31.EndsAt = HalloweenEggSettings.StartsAt
        p13 = p13 or Workspace:GetServerTimeNow()

        local v39 = if HalloweenEggSettings.IsActive(p13) then v32
            elseif HalloweenEggSettings.EndsAt <= p13 then nil
            elseif Constants.UPDATE_LIVE_AT <= p13 then v31
            else v30

        return v39 == p12
    end
}, {
    __index = function(_, p15) -- __index | line: 248
        -- upvalues: Workspace (copy), Constants (copy), HalloweenEggSettings (copy), v30 (copy), v31 (copy), v32 (copy)
        v32.EndsAt = HalloweenEggSettings.EndsAt
        v31.EndsAt = HalloweenEggSettings.StartsAt

        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v40 = if HalloweenEggSettings.IsActive(ServerTimeNow) then v32
            elseif HalloweenEggSettings.EndsAt <= ServerTimeNow then nil
            elseif Constants.UPDATE_LIVE_AT <= ServerTimeNow then v31
            else v30

        return (v40 or v32)[p15]
    end
}))
