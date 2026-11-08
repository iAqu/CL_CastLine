-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local Numeric = require(ReplicatedStorage.Shared.Utils.Numeric)
local t1 = {
    table.freeze({
        AssetId = "Candy Corn",
        Weight = 51
    }),
    table.freeze({
        AssetId = "Hollow Bat",
        Weight = 24
    }),
    table.freeze({
        AssetId = "Scarecrow",
        Weight = 18
    }),
    table.freeze({
        AssetId = "Pumpkin Golem",
        Weight = 6.5
    }),
    table.freeze({
        AssetId = "Soul Phantom",
        Weight = 0.5
    })
}
local t2 = {}
local n1 = 0
local t3 = {
    DisplayName = "Halloween Dimension Egg",
    ModelName = "Halloween Dimension Egg",
    Price = 2250,
    Entries = table.freeze(t1),
    Chance = function(p1) -- Chance | line: 49
        -- upvalues: n1 (ref)
        return p1.Weight / n1 * 100
    end,
    Roll = function(p2) -- Roll | line: 53
        -- upvalues: Numeric (copy), t2 (copy)
        return (Numeric.RollWeighted(t2, p2))
    end
}

for _, v1 in t1 do
    local v2 = Assets.Directory[v1.AssetId]

    assert(v2 ~= nil, (("%* is not in Data.Assets"):format(v1.AssetId)))
    assert(v2.Egg.ModelName == "Halloween Dimension Egg", (("%* must hatch from the Halloween Dimension Egg"):format(v1.AssetId)))
    assert(v1.Weight > 0, (("%* needs a positive weight"):format(v1.AssetId)))
    table.insert(t2, table.freeze({
        v1.AssetId,
        v1.Weight
    }))

    local Weight = v1.Weight

    n1 += Weight
end

table.freeze(t2)

return table.freeze(t3)
