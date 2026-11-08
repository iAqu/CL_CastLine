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
    _id = "Imp",
    DisplayName = "Imp",
    Icon = "rbxassetid://80756597804671",
    EarningRate = 1.6E+07,
    IndexSpeedReward = 8E+06,
    DropWeight = 0,
    VisualOdds = 5.9417706476530014,
    ModelWeight = 9000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    AlbinosColorFullWhite = true,
    WalkSound = table.freeze({
        SoundId = 122896507255411,
        Data = table.freeze({
            Looped = true,
            MaxDistance = 20,
            Speed = 1,
            Volume = 1.5
        })
    }),
    RandomIdleSound = table.freeze({
        SoundId = 87783014657179,
        Data = table.freeze({
            MaxDistance = 20,
            Volume = 1.5
        })
    }),
    Egg = table.freeze({
        DisplayName = "Imp Egg",
        Icon = "rbxassetid://86008838296332",
        ModelName = "Imp",
        GrowthTime = 900,
        WeightKg = 5
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://99392172664963"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://72516808870539"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.fromRGB(165, 38, 40)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(165, 38, 40),
        80
    }),
    table.freeze({
        Color3.fromRGB(125, 45, 38),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
