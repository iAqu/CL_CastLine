-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 5
    local Animation = Instance.new("Animation")

    Animation.AnimationId = p1

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "Ringlord",
    DisplayName = "Ringlord",
    Icon = "rbxassetid://91756381949392",
    EarningRate = 8.25E+08,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 1,
    ModelWeight = 80,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    AlbinosColorFullWhite = true,
    DontRoll = true,
    WalkSound = table.freeze({
        SoundId = 118578341930967,
        Data = table.freeze({
            Looped = true,
            MaxDistance = 20,
            Speed = 1,
            Volume = 1.5
        })
    }),
    RandomIdleSound = table.freeze({
        SoundId = 82083136808152,
        Data = table.freeze({
            MaxDistance = 20,
            Volume = 1.5
        })
    }),
    Egg = table.freeze({
        DisplayName = "Ringlord Egg",
        Icon = "rbxassetid://126807681611943",
        ModelName = "Ringlord",
        GrowthTime = 21600,
        WeightKg = 80
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://116695407509351"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://116861024650521"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(90, 87, 83)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(90, 87, 83),
        80
    }),
    table.freeze({
        Color3.fromRGB(110, 98, 78),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
