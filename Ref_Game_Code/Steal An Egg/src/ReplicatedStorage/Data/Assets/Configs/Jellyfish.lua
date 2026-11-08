-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 6
    local Animation = Instance.new("Animation")

    Animation.AnimationId = p1

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "Jellyfish",
    DisplayName = "Pure Jellyfish",
    Icon = "rbxassetid://125711705647799",
    EarningRate = 2.25E+08,
    IndexSpeedReward = 3E+07,
    DropWeight = 0,
    VisualOdds = 22.935779816513758,
    ModelWeight = 10000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    AlbinosColorFullWhite = true,
    WalkSound = table.freeze({
        SoundId = 119456513629592,
        Data = table.freeze({
            Looped = true,
            MaxDistance = 20,
            Speed = 1,
            Volume = 1.5
        })
    }),
    RandomIdleSound = table.freeze({
        SoundId = 120392356663478,
        Data = table.freeze({
            MaxDistance = 20,
            Volume = 1.5
        })
    }),
    Egg = table.freeze({
        DisplayName = "Pure Jellyfish Egg",
        Icon = "rbxassetid://128249019051623",
        ModelName = "Jellyfish",
        GrowthTime = 10800,
        WeightKg = 10
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://138191306409960"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://86698796056796"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(243, 243, 210)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(243, 243, 210),
        80
    }),
    table.freeze({
        Color3.fromRGB(232, 228, 197),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
