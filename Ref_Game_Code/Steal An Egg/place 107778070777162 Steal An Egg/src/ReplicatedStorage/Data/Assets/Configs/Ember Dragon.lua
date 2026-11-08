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
    _id = "Ember Dragon",
    DisplayName = "Ember Dragon",
    Icon = "rbxassetid://135400297612664",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 6E+08,
    IndexSpeedReward = 80000,
    DropWeight = 0,
    VisualOdds = 50000,
    ModelWeight = 14000,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Dragon Egg",
        Icon = "rbxassetid://124581147164560",
        GrowthTime = 60,
        WeightKg = 5,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://134684952794789"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://134684952794789 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://110166896149574"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://110166896149574 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.new(0.3803921639919281, 0.2823529541492462, 0.23529411852359772)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.3803921639919281, 0.2823529541492462, 0.23529411852359772),
        700
    }),
    table.freeze({
        Color3.new(0.5607843399047852, 0.30980393290519714, 0.16470588743686676),
        180
    }),
    table.freeze({
        Color3.new(0.27450981736183167, 0.1882352977991104, 0.14901961386203766),
        108
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 95640392463828,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 0.9,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 99984406249141,
    Data = table.freeze({
        MaxDistance = 30,
        Volume = 1.5
    })
})

return (freeze(t1))
