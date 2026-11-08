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
    _id = "Demon Hound",
    DisplayName = "Demon Hound",
    Icon = "rbxassetid://97830965844787",
    EarningRate = 2.5E+07,
    IndexSpeedReward = 2E+07,
    DropWeight = 0,
    VisualOdds = 7.163323782234957,
    ModelWeight = 9000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    AlbinosColorFullWhite = true,
    WalkSound = table.freeze({
        SoundId = 91021680910561,
        Data = table.freeze({
            Looped = true,
            MaxDistance = 20,
            Speed = 1,
            Volume = 1.5
        })
    }),
    RandomIdleSound = table.freeze({
        SoundId = 109891701674473,
        Data = table.freeze({
            MaxDistance = 20,
            Volume = 1.5
        })
    }),
    Egg = table.freeze({
        DisplayName = "Demon Hound Egg",
        Icon = "rbxassetid://81200150769664",
        ModelName = "Demon Hound",
        GrowthTime = 1200,
        WeightKg = 5
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://71097341870152"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://88651036276589"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.fromRGB(149, 68, 60)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(149, 68, 60),
        80
    }),
    table.freeze({
        Color3.fromRGB(108, 46, 40),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
