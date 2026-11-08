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
    _id = "Swan",
    DisplayName = "Swan",
    Icon = "rbxassetid://125076114591417",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 320,
    IndexSpeedReward = 3500,
    DropWeight = 0.2,
    VisualOdds = 670.5118643718583,
    ModelWeight = 22,
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
        DisplayName = "Swan Egg",
        Icon = "rbxassetid://125884067432601",
        GrowthTime = 120,
        WeightKg = 2,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://113947385873952"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://113947385873952 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://136832792656489"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://136832792656489 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.7921568751335144, 0.7960784435272217, 0.8196078538894653)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.7921568751335144, 0.7960784435272217, 0.8196078538894653),
        200
    }),
    table.freeze({
        Color3.new(0.9607843160629272, 0.9607843160629272, 0.9333333373069763),
        710
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.21568627655506134, 0.21568627655506134),
        70
    }),
    table.freeze({
        Color3.new(0.7450980544090271, 0.686274528503418, 0.6078431606292725),
        20
    })
})
t1.WalkSound = table.freeze({
    SoundId = 99672949453572,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 109415901740965,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
