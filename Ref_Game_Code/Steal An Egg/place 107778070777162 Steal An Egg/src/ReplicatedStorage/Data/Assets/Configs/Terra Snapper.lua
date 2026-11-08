-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 9
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 11
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
    _id = "Terra Snapper",
    DisplayName = "Terra Snapper",
    Icon = "rbxassetid://82250986590981",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 7.5E+08,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 15.38461538,
    ModelWeight = 60000,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Terra Snapper Egg",
        Icon = "rbxassetid://113826857989447",
        ModelName = "Depths Egg",
        GrowthTime = 10,
        WeightKg = 6,
        HideRarity = true,
        IgnoreSizeGrowthMultiplier = true
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://90942455913842"

local function setAnimationId() -- line: 11
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://90942455913842 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://119118916125408"

local function setAnimationId2() -- line: 11
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://119118916125408 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.fromRGB(68, 100, 51)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(68, 100, 51),
        80
    }),
    table.freeze({
        Color3.fromRGB(105, 99, 70),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return (freeze(t1))
