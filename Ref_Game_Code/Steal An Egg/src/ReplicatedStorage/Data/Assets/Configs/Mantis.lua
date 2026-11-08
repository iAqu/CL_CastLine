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
    _id = "Mantis",
    DisplayName = "Mantaris",
    Icon = "rbxassetid://119413872068696",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1.1E+07,
    IndexSpeedReward = 3435120,
    DropWeight = 0,
    VisualOdds = 2.5E+12,
    ModelWeight = 1500,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    WalkSound = nil,
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
        DisplayName = "Mantaris Egg",
        Icon = "rbxassetid://93443486739123",
        GrowthTime = 1020,
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
local v1 = "rbxassetid://90034148491685"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://90034148491685 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://136861862282952"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://136861862282952 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.8392156958580017, 0.3843137323856354, 0.14901961386203766)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.8392156958580017, 0.3843137323856354, 0.14901961386203766),
        850
    }),
    table.freeze({
        Color3.new(0.6274510025978088, 0.27450981736183167, 0.11764705926179886),
        90
    }),
    table.freeze({
        Color3.new(0.8823529481887817, 0.5882353186607361, 0.3137255012989044),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})

return (freeze(t1))
