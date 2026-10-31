-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local trainingWeightsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "training-weights").trainingWeightsData
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local t1 = {}
local n1 = 1

for v1, v2 in trainingWeightsData do
    local t2 = {
        itemName = v1,
        moneyPrice = v2.price
    }
    local v3 = n1

    n1 += 1
    t2.showOrder = v3
    t1[v1] = t2
end

local t3 = {}
local n2 = 1

for v4, v5 in fishingRodsData do
    local t4 = {
        itemName = v4,
        moneyPrice = v5.price
    }
    local v6 = n2

    n2 += 1
    t4.showOrder = v6
    t3[v4] = t4
end

return {
    rodRebirthRequirements = {
        TridentRod = 1,
        BloodthornRod = 2,
        LavaCrystalRod = 3,
        AngelRod = 4,
        CosmicRod = 5,
        ExcaliburRod = 6,
        PrimalRod = 7,
        UwuRod = 8,
        SaberRod = 9
    },
    weightRebirthRequirements = {
        CardsBarbell = 1,
        KrakenBarbell = 2,
        PoseidonBarbell = 3,
        DiamondBarbell = 4,
        BlackholeBarbell = 5,
        JudgementBarbell = 6,
        PrimalBarbell = 7,
        UwuBarbell = 8,
        ScifiBarbell = 9
    },
    shops = {
        weightsShop = {
            shopId = "weightsShop",
            title = "Weights Shop",
            shopItems = t1
        },
        rodsShop = {
            shopId = "rodsShop",
            title = "Rods Shop",
            shopItems = t3
        }
    }
}
