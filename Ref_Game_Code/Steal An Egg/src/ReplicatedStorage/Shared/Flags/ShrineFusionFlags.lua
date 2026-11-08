-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function bounded(p1, p2) -- line: 6
    -- upvalues: Asserts (copy)
    return function(p3) -- line: 7
        -- upvalues: p1 (copy), p2 (copy), Asserts (copy)
        Asserts.FiniteNonNegative(p3)
        assert(p1 <= p3 and p3 <= p2, "Shrine fusion flag out of range")

        return p3
    end
end

local freeze = table.freeze
local t1 = {
    Enabled = FastFlags.Replicated("Game.ShrineFusion.Enabled", Asserts.Boolean, true),
    Recipes = FastFlags.Replicated("Game.ShrineFusion.Recipes", Asserts.Map(Asserts.String, Asserts.Map(Asserts.String, Asserts.String)), {
        Divine = {
            Light = "ArchAngel",
            Dark = "World Burner",
            Fused = "Aetheron"
        },
        Eternal = {
            Light = "Pegasus",
            Dark = "Skeleton Horse",
            Fused = "Equinox"
        },
        Enchanted = {
            Whale = "Royal Skywhale",
            Lion = "Cosmic Lion",
            Fused = "World Spirit"
        },
        Void = {
            Fish = "Ghost Fish",
            Pumpkin = "Voidseer Pumpkin",
            Fused = "Cursed Fish"
        }
    })
}
local Replicated = FastFlags.Replicated
local n1 = 1
local n2 = 60

t1.RitualSeconds = Replicated("Game.ShrineFusion.RitualSeconds", function(p4) -- line: 7
    -- upvalues: Asserts (copy), n1 (copy), n2 (copy)
    Asserts.FiniteNonNegative(p4)
    assert(n1 <= p4 and p4 <= n2, "Shrine fusion flag out of range")

    return p4
end, 5)

local Replicated2 = FastFlags.Replicated
local Map, String = Asserts.Map, Asserts.String
local n3 = 1
local n4 = 60

t1.ShrineRitualSeconds = Replicated2("Game.ShrineFusion.ShrineRitualSeconds", Map(String, function(p5) -- line: 7
    -- upvalues: Asserts (copy), n3 (copy), n4 (copy)
    Asserts.FiniteNonNegative(p5)
    assert(n3 <= p5 and p5 <= n4, "Shrine fusion flag out of range")

    return p5
end), {
    Enchanted = 15,
    Void = 18
})

local Replicated3 = FastFlags.Replicated
local n5 = 1
local n6 = 120

t1.RetrySeconds = Replicated3("Game.ShrineFusion.RetrySeconds", function(p6) -- line: 7
    -- upvalues: Asserts (copy), n5 (copy), n6 (copy)
    Asserts.FiniteNonNegative(p6)
    assert(n5 <= p6 and p6 <= n6, "Shrine fusion flag out of range")

    return p6
end, 5)
t1.EggInventoryLimit = FastFlags.Replicated("Game.ShrineFusion.EggInventoryLimit", Asserts.IntegerPositive, 115)
t1.AllowStolenDNA = FastFlags.Replicated("Game.ShrineFusion.AllowStolenDNA", Asserts.Boolean, false)
t1.PreserveMutations = FastFlags.Replicated("Game.ShrineFusion.PreserveMutations", Asserts.Boolean, true)
t1.PreservePersonality = FastFlags.Replicated("Game.ShrineFusion.PreservePersonality", Asserts.Boolean, true)
t1.PreserveInputScale = FastFlags.Replicated("Game.ShrineFusion.PreserveInputScale", Asserts.Boolean, true)
t1.RewardNeverEarnsLess = FastFlags.Replicated("Game.ShrineFusion.RewardNeverEarnsLess", Asserts.Boolean, true)

local Replicated4 = FastFlags.Replicated
local Map2, String2 = Asserts.Map, Asserts.String
local n7 = 0.01
local n8 = 100

t1.FixedRewardScale = Replicated4("Game.ShrineFusion.FixedRewardScale", Map2(String2, function(p7) -- line: 7
    -- upvalues: Asserts (copy), n7 (copy), n8 (copy)
    Asserts.FiniteNonNegative(p7)
    assert(n7 <= p7 and p7 <= n8, "Shrine fusion flag out of range")

    return p7
end), {
    Divine = 1,
    Eternal = 1,
    Enchanted = 1,
    Void = 1
})

local Replicated5 = FastFlags.Replicated
local Map3, String3 = Asserts.Map, Asserts.String
local n9 = 0.01
local n10 = 100

t1.RewardScaleMultiplier = Replicated5("Game.ShrineFusion.RewardScaleMultiplier", Map3(String3, function(p8) -- line: 7
    -- upvalues: Asserts (copy), n9 (copy), n10 (copy)
    Asserts.FiniteNonNegative(p8)
    assert(n9 <= p8 and p8 <= n10, "Shrine fusion flag out of range")

    return p8
end), {
    Divine = 1,
    Eternal = 1,
    Enchanted = 1,
    Void = 1
})

return freeze(t1)
