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
    _id = "Ring Guard",
    DisplayName = "Ring Guard",
    Icon = "rbxassetid://97967732679537",
    EarningRate = 1.5E+07,
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
        SoundId = 107135546418104,
        Data = table.freeze({
            Looped = true,
            MaxDistance = 20,
            Speed = 1,
            Volume = 1.5
        })
    }),
    RandomIdleSound = table.freeze({
        SoundId = 108615491098304,
        Data = table.freeze({
            MaxDistance = 20,
            Volume = 1.5
        })
    }),
    Egg = table.freeze({
        DisplayName = "Ring Guard Egg",
        Icon = "rbxassetid://105780316822746",
        ModelName = "Ring Guard",
        GrowthTime = 1140,
        WeightKg = 80
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://105537650706847"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://127903082838058"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.fromRGB(107, 97, 78)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(107, 97, 78),
        80
    }),
    table.freeze({
        Color3.fromRGB(91, 84, 70),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
