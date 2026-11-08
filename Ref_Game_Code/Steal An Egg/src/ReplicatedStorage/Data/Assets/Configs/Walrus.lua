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
    _id = "Walrus",
    DisplayName = "Walrus",
    Icon = "rbxassetid://129141571024477",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 600,
    IndexSpeedReward = 14400,
    DropWeight = 0.5,
    VisualOdds = 4788235.136,
    ModelWeight = 200,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    RandomIdleSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Walrus Egg",
        Icon = "rbxassetid://91972491841412",
        GrowthTime = 60,
        WeightKg = 4,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://98973083016392"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://98973083016392 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://106288976924750"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://106288976924750 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.WalkSound = table.freeze({
    SoundId = 81119519724182,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.46666666865348816, 0.4431372582912445, 0.41960784792900085)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.46666666865348816, 0.4431372582912445, 0.41960784792900085),
        620
    }),
    table.freeze({
        Color3.new(0.4117647111415863, 0.3333333432674408, 0.27450981736183167),
        180
    }),
    table.freeze({
        Color3.new(0.6470588445663452, 0.5490196347236633, 0.47058823704719543),
        140
    }),
    table.freeze({
        Color3.new(0.7450980544090271, 0.6470588445663452, 0.5686274766921997),
        45
    }),
    table.freeze({
        Color3.new(0.27450981736183167, 0.23529411852359772, 0.21568627655506134),
        15
    }),
    table.freeze({
        Color3.new(0.27843138575553894, 0.3686274588108063, 0.615686297416687),
        7
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 110863031812081,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})

return (freeze(t1))
