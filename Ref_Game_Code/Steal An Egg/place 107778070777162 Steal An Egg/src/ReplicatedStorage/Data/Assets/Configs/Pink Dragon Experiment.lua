-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local v1 = Color3.fromRGB(255, 255, 255)

local function makeAnimation(p1) -- line: 12
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 14
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
    _id = "Pink Dragon Experiment",
    DisplayName = "Pink Dragon Experiment #010",
    Icon = "rbxassetid://77234078319420",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2.5E+09,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 2.2E+10,
    ModelWeight = 1234,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Pink Dragon Experiment Egg",
        Icon = "rbxassetid://118215270374998",
        ModelName = nil,
        GrowthTime = 900,
        WeightKg = 6,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://107687297888177"

local function setAnimationId() -- line: 14
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://107687297888177 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://77477247327024"

local function setAnimationId2() -- line: 14
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://77477247327024 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })
t1.WalkSound = table.freeze({
    SoundId = 124307245335749,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 75325692136933,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
