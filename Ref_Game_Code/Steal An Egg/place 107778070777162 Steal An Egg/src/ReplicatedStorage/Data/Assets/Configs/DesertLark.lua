-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 7
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 9
        -- upvalues: p1 (copy), Animation (copy)
        Animation.AnimationId = p1
    end

    if not pcall(setAnimationId) then
        warn((("Animation %* is not shared with this experience"):format(p1)))
    end

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "DesertLark",
    DisplayName = "Bird",
    Icon = "rbxassetid://107145283169125",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 8,
    IndexSpeedReward = 500,
    DropWeight = 0.3333333333333333,
    VisualOdds = 3.265923580159354,
    ModelWeight = 5,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Bird Egg",
        Icon = "rbxassetid://131243362633620",
        GrowthTime = 25,
        WeightKg = 1,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://83189168987431"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://83189168987431 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://71642453365136"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://71642453365136 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Uncommon
t1.BaseModelColor = Color3.new(0.6470588445663452, 0.6078431606292725, 0.5058823823928833)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.6470588445663452, 0.6078431606292725, 0.5058823823928833),
        700
    }),
    table.freeze({
        Color3.new(0.7450980544090271, 0.686274528503418, 0.529411792755127),
        180
    }),
    table.freeze({
        Color3.new(0.4901960790157318, 0.4117647111415863, 0.29411765933036804),
        85
    }),
    table.freeze({
        Color3.new(0.843137264251709, 0.7843137383460999, 0.6470588445663452),
        35
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 102991056587805,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 98182435581719,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
