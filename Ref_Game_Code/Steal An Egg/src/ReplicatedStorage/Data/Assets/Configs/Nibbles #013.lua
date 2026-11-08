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
    _id = "Nibbles #013",
    DisplayName = "Nibbles #013",
    Icon = "rbxassetid://136256356835239",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 185000,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 0,
    ModelWeight = 8,
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
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Rat Egg",
        ModelName = "Nibbles #013",
        Icon = "rbxassetid://128576060432452",
        GrowthTime = 900,
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
local v1 = "rbxassetid://108174037258974"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://108174037258974 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://114797945842128"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://114797945842128 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.9725490212440491, 0.9725490212440491, 0.9725490212440491)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.9725490212440491, 0.9725490212440491, 0.9725490212440491),
        760
    }),
    table.freeze({
        Color3.new(0.9019607901573181, 0.8235294222831726, 0.6274510025978088),
        120
    })
})

return (freeze(t1))
