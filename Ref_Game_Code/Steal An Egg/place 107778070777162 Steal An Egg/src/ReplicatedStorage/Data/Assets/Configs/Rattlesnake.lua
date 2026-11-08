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
    _id = "Rattlesnake",
    DisplayName = "Snake",
    Icon = "rbxassetid://119006769959865",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 3600,
    IndexSpeedReward = 10800,
    DropWeight = 0.25,
    VisualOdds = 21547.05811,
    ModelWeight = 45,
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
        DisplayName = "Snake Egg",
        Icon = "rbxassetid://85648596444101",
        GrowthTime = 150,
        WeightKg = 3,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = 0
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://130705101747406"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://130705101747406 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://130705101747406"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://130705101747406 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(0.6470588445663452, 0.4941176474094391, 0.2823529541492462)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.6470588445663452, 0.4941176474094391, 0.2823529541492462),
        680
    }),
    table.freeze({
        Color3.new(0.7176470756530762, 0.5607843399047852, 0.3450980484485626),
        170
    }),
    table.freeze({
        Color3.new(0.8039215803146362, 0.686274528503418, 0.45098039507865906),
        115
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 120142944253002,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 90201240349836,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
