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
    _id = "Centapede",
    DisplayName = "Centapede",
    Icon = "rbxassetid://137964650556285",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1500,
    IndexSpeedReward = 960000,
    DropWeight = 0,
    VisualOdds = 1.35E+11,
    ModelWeight = 6,
    WalkAnimationReferenceSpeed = 2,
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
        DisplayName = "Centapede Egg",
        Icon = "rbxassetid://131685653579153",
        GrowthTime = 120,
        WeightKg = 7,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://112002125092401"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://112002125092401 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://117870055907973"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://117870055907973 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.9058823585510254, 0.9058823585510254, 0.9254902005195618)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.9058823585510254, 0.9058823585510254, 0.9254902005195618),
        900
    }),
    table.freeze({
        Color3.new(0.20000000298023224, 1, 0.1882352977991104),
        100
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 90676527927085,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})

return (freeze(t1))
